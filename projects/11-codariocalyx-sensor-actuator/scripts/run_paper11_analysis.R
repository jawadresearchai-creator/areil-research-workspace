#!/usr/bin/env Rscript

options(stringsAsFactors = FALSE, contrasts = c("contr.treatment", "contr.poly"), warn = 1)

suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(ggplot2)
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(fixest)
  library(nlme)
  library(jsonlite)
  library(readr)
})

project_dir <- normalizePath(file.path(getwd(), "projects/11-codariocalyx-sensor-actuator"), mustWork = TRUE)
workbook <- file.path(project_dir, "data/raw/Codariocalyx_motorius_Sensor_Actuator_Master_Workbook_2023_2024_FINAL.xlsx")
out_dir <- file.path(project_dir, "results")
diag_dir <- file.path(project_dir, "diagnostics")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(diag_dir, recursive = TRUE, showWarnings = FALSE)

expected_sha256 <- "1a1aab770a41502174830546b9642534556e0b536aab6efb0e3da6c0d52aa277"
sha_line <- system2("sha256sum", shQuote(workbook), stdout = TRUE)
actual_sha256 <- strsplit(sha_line, "\\s+")[[1]][1]
if (!identical(tolower(actual_sha256), expected_sha256)) {
  stop(sprintf("AUTHORITATIVE WORKBOOK HASH MISMATCH: expected %s, got %s", expected_sha256, actual_sha256))
}
cat("Authoritative workbook SHA-256 verified:", actual_sha256, "\n")

read_sheet <- function(name) {
  x <- read_excel(workbook, sheet = name, .name_repair = "unique")
  as.data.frame(x)
}

# ---------------- helpers ----------------
result_rows <- list()
model_meta <- list()
qa <- list()

append_result <- function(experiment, role, endpoint, label, estimate = NA_real_, SE = NA_real_,
                          df = NA_real_, statistic = NA_real_, p = NA_real_, low = NA_real_, high = NA_real_,
                          method = NA_character_, extra = list()) {
  row <- tibble(
    experiment = experiment, role = role, endpoint = endpoint, label = label,
    estimate = estimate, SE = SE, df = df, statistic = statistic, p = p,
    CI95_low = low, CI95_high = high, method = method
  )
  if (length(extra)) {
    for (nm in names(extra)) row[[nm]] <- extra[[nm]]
  }
  result_rows[[length(result_rows) + 1]] <<- row
  invisible(row)
}

is_good_lmer <- function(fit) {
  if (inherits(fit, "try-error") || is.null(fit)) return(FALSE)
  if (!isTRUE(is.null(fit@optinfo$conv$lme4$messages))) return(FALSE)
  !lme4::isSingular(fit, tol = 1e-6)
}

safe_lmer <- function(formula, data, REML = FALSE) {
  fit <- try(
    lmerTest::lmer(
      formula, data = data, REML = REML,
      control = lme4::lmerControl(
        optimizer = "bobyqa",
        optCtrl = list(maxfun = 200000),
        check.conv.singular = "ignore"
      )
    ), silent = TRUE
  )
  if (is_good_lmer(fit)) fit else NULL
}

lmer_term <- function(fit, term) {
  ct <- coef(summary(fit))
  if (!term %in% rownames(ct)) stop("Term not found: ", term)
  est <- ct[term, "Estimate"]
  se <- ct[term, "Std. Error"]
  df <- ct[term, "df"]
  stat <- ct[term, "t value"]
  p <- ct[term, "Pr(>|t|)"]
  crit <- qt(0.975, df)
  c(estimate = est, SE = se, df = df, statistic = stat, p = p,
    low = est - crit * se, high = est + crit * se)
}

fixest_term <- function(fit, term) {
  ct <- coeftable(fit)
  if (!term %in% rownames(ct)) stop("Term not found: ", term)
  est <- ct[term, 1]
  se <- ct[term, 2]
  stat <- ct[term, 3]
  p <- ct[term, 4]
  ci <- confint(fit, parm = term, level = 0.95)
  c(estimate = est, SE = se, df = NA_real_, statistic = stat, p = p,
    low = ci[1, 1], high = ci[1, 2])
}

save_text <- function(path, ...) {
  capture.output(..., file = path)
}

holm <- function(x) p.adjust(x, method = "holm")

# ---------------- read design-control sheets ----------------
rand <- read_sheet("08_RANDOMIZATION")
# Recording metadata contains intentionally mixed blank/file-ID columns; read as text to prevent type-guess warnings.
recordings <- as.data.frame(read_excel(workbook, sheet = "13_RECORDINGS", col_types = "text", .name_repair = "unique"))

# ---------------- E1 ----------------
e1 <- read_sheet("14_E1_SENSOR_RESPONSE") %>%
  mutate(
    PPFD10 = as.numeric(Treatment_PPFD_umol_m2_s) / 10,
    Treatment_Period_min = as.numeric(Treatment_Period_min),
    Baseline_Period_min = as.numeric(Baseline_Period_min),
    Stimulated_Side = factor(Stimulated_Side),
    Plant_ID = factor(Plant_ID)
  )

m1 <- safe_lmer(Treatment_Period_min ~ Baseline_Period_min + PPFD10 + Stimulated_Side + (1 | Plant_ID), e1)
if (!is.null(m1)) {
  r <- lmer_term(m1, "PPFD10")
  method1 <- "LMM random intercept Plant_ID; Satterthwaite df"
  save_text(file.path(diag_dir, "E1_primary_model.txt"), summary(m1))
  singular1 <- FALSE
} else {
  m1 <- fixest::feols(Treatment_Period_min ~ Baseline_Period_min + PPFD10 + Stimulated_Side | Plant_ID,
                      data = e1, cluster = ~Plant_ID)
  r <- fixest_term(m1, "PPFD10")
  method1 <- "Plant fixed effects with Plant_ID-clustered SE (pre-specified singular-fit fallback)"
  save_text(file.path(diag_dir, "E1_primary_model.txt"), summary(m1))
  singular1 <- TRUE
}
append_result("E1", "PRIMARY", "Treatment_Period_min",
              "Period change per +10 µmol m^-2 s^-1 measured lateral PPFD, baseline-adjusted",
              r["estimate"], r["SE"], r["df"], r["statistic"], r["p"], r["low"], r["high"], method1)
model_meta$E1 <- list(method = method1, lmer_boundary_fallback = singular1, n = nrow(e1), plants = n_distinct(e1$Plant_ID))

# E1 design-control sensitivity: plant FE + order/day/rig where linkable
rand_e1 <- rand %>%
  filter(Experiment == "E1") %>%
  mutate(Rand_PPFD = as.numeric(sub("^PPFD_", "", as.character(Condition)))) %>%
  select(Plant_ID, Rand_PPFD, Session_Order, Treatment_Order, Experimental_Day, Time_Block, Block)
e1s <- e1 %>%
  mutate(Plant_ID_chr = as.character(Plant_ID)) %>%
  left_join(rand_e1 %>% mutate(Plant_ID_chr = as.character(Plant_ID)) %>% select(-Plant_ID),
            by = c("Plant_ID_chr", "Treatment_PPFD_umol_m2_s" = "Rand_PPFD"))
qa$E1_design_control_join_rows <- sum(complete.cases(e1s$Session_Order))
if (qa$E1_design_control_join_rows != nrow(e1)) stop("E1 design-control join did not resolve all sessions")
# Pre-specified sensitivity: retain the PPFD estimand while adjusting for order/day/time-block/rig-block.
e1sens <- fixest::feols(
  Treatment_Period_min ~ Baseline_Period_min + PPFD10 + Stimulated_Side +
    factor(Session_Order) + factor(Experimental_Day) + factor(Time_Block) + factor(Block) | Plant_ID_chr,
  data = e1s, cluster = ~Plant_ID_chr
)
rs1 <- fixest_term(e1sens, "PPFD10")
append_result("E1", "SENSITIVITY", "Treatment_Period_min",
              "PPFD trend adjusted for session order, experimental day, time block and rig/block",
              rs1["estimate"], rs1["SE"], rs1["df"], rs1["statistic"], rs1["p"], rs1["low"], rs1["high"],
              "Plant fixed effects + design-control covariates + Plant_ID-clustered SE")
save_text(file.path(diag_dir, "E1_design_control_sensitivity.txt"), summary(e1sens))

# ---------------- E2 ----------------
e2 <- read_sheet("15_E2_INTERORGAN_COUPLING") %>%
  mutate(
    Condition = factor(Condition, levels = c("LL", "HL", "LH", "HH")),
    Rotation = factor(as.numeric(Plant_Rotation_deg), levels = c(0, 180)),
    Plant_ID = factor(Plant_ID),
    Delta_Terminal_Azimuth_deg = as.numeric(Delta_Terminal_Azimuth_deg)
  )

m2 <- safe_lmer(Delta_Terminal_Azimuth_deg ~ Condition * Rotation + (1 | Plant_ID), e2)
if (!is.null(m2)) {
  method2 <- "LMM Condition × Rotation + random intercept Plant_ID"
  emm2 <- emmeans(m2, ~ Condition)
} else {
  m2 <- lm(Delta_Terminal_Azimuth_deg ~ Condition * Rotation + factor(Plant_ID), data = e2)
  method2 <- "Plant fixed-effect linear model fallback"
  emm2 <- emmeans(m2, ~ Condition)
}
contr2 <- contrast(emm2, method = list(
  directional_half_difference = c(LL = 0, HL = 0.5, LH = -0.5, HH = 0),
  HL_minus_LL = c(LL = -1, HL = 1, LH = 0, HH = 0),
  LH_minus_LL = c(LL = -1, HL = 0, LH = 1, HH = 0),
  HH_minus_LL = c(LL = -1, HL = 0, LH = 0, HH = 1)
), adjust = "none") %>% as.data.frame()
for (i in seq_len(nrow(contr2))) {
  rr <- contr2[i, ]
  role <- ifelse(rr$contrast == "directional_half_difference", "PRIMARY", "SUPPORTING")
  append_result("E2", role, "Delta_Terminal_Azimuth_deg", rr$contrast,
                rr$estimate, rr$SE, rr$df, rr$t.ratio, rr$p.value,
                rr$estimate - qt(.975, rr$df) * rr$SE,
                rr$estimate + qt(.975, rr$df) * rr$SE, method2)
}
save_text(file.path(diag_dir, "E2_primary_model.txt"), summary(m2), emm2, contr2)
model_meta$E2 <- list(method = method2, n = nrow(e2), plants = n_distinct(e2$Plant_ID))

# rotation-control contrasts explicitly within HL and LH
emm2_rot <- emmeans(m2, ~ Rotation | Condition)
rot_con <- pairs(emm2_rot, adjust = "holm") %>% as.data.frame()
write_csv(rot_con, file.path(out_dir, "E2_rotation_control_contrasts.csv"))

# ---------------- E3 ----------------
e3 <- read_sheet("16_E3_BILATERAL_CONTRAST") %>%
  mutate(
    Plant_ID = factor(Plant_ID),
    C = as.numeric(Light_Contrast_C),
    TotalPPFD100 = as.numeric(Total_Lateral_PPFD) / 100,
    y = as.numeric(Delta_Terminal_Azimuth_deg),
    C_thresh = sign(C) * pmax(abs(C) - 0.15, 0)
  )

# Use identical plant-FE likelihood family for valid AIC comparison.
lin3 <- lm(y ~ C + TotalPPFD100 + Plant_ID, data = e3)
thr3 <- lm(y ~ C + C_thresh + TotalPPFD100 + Plant_ID, data = e3)
fit_sat_k <- function(k) {
  d <- e3 %>% mutate(SatC = tanh(k * C))
  lm(y ~ SatC + TotalPPFD100 + Plant_ID, data = d)
}
obj3 <- function(logk) -as.numeric(logLik(fit_sat_k(exp(logk))))
opt3 <- optimize(obj3, interval = log(c(0.05, 20)), tol = 1e-8)
khat <- exp(opt3$minimum)
sat3 <- fit_sat_k(khat)
aics <- c(linear = AIC(lin3), threshold = AIC(thr3), saturating = AIC(sat3) + 2) # +1 estimated external k
best3 <- names(which.min(aics))
delta3 <- aics - min(aics)

# profile-likelihood CI for k: 2*(LLmax-LL)<=3.841459
loglik_max <- as.numeric(logLik(sat3))
ks <- exp(seq(log(0.05), log(20), length.out = 4000))
lls <- vapply(ks, function(k) as.numeric(logLik(fit_sat_k(k))), numeric(1))
inside <- 2 * (loglik_max - lls) <= qchisq(.95, 1)
k_low <- min(ks[inside]); k_high <- max(ks[inside])
profile3 <- tibble(k = ks, logLik = lls, in_95 = inside)
write_csv(profile3, file.path(out_dir, "E3_k_profile_curve_R.csv"))

cmp3 <- tibble(model = names(aics), AIC = as.numeric(aics), deltaAIC = as.numeric(delta3))
write_csv(cmp3, file.path(out_dir, "E3_model_comparison_R.csv"))

if (best3 == "saturating") {
  d3 <- e3 %>% mutate(SatC = tanh(khat * C))
  sel3 <- lm(y ~ SatC + TotalPPFD100 + Plant_ID, data = d3)
  beta <- coef(sel3)["SatC"]
  vc <- vcov(sel3)["SatC", "SatC"]
  cpos <- tanh(khat * .5); cneg <- tanh(khat * -.5)
  scale <- (cpos - cneg) / 2
  est3 <- beta * scale
  se3 <- sqrt(vc) * abs(scale)
  df3 <- df.residual(sel3)
  t3 <- est3 / se3; p3 <- 2 * pt(abs(t3), df3, lower.tail = FALSE)
  cr <- qt(.975, df3)
  low3 <- est3 - cr * se3; high3 <- est3 + cr * se3
  tot <- summary(sel3)$coefficients["TotalPPFD100", ]
} else if (best3 == "threshold") {
  sel3 <- thr3
  # model-based prediction contrast using model.matrix
  nd <- data.frame(C = c(.5, -.5), C_thresh = c(.35, -.35), TotalPPFD100 = 2,
                   Plant_ID = factor(rep(levels(e3$Plant_ID)[1], 2), levels = levels(e3$Plant_ID)))
  X <- model.matrix(delete.response(terms(sel3)), nd)
  L <- (X[1, ] - X[2, ]) / 2
  est3 <- sum(L * coef(sel3)); se3 <- sqrt(drop(L %*% vcov(sel3) %*% L)); df3 <- df.residual(sel3)
  t3 <- est3 / se3; p3 <- 2 * pt(abs(t3), df3, lower.tail = FALSE); cr <- qt(.975, df3)
  low3 <- est3 - cr * se3; high3 <- est3 + cr * se3
  tot <- summary(sel3)$coefficients["TotalPPFD100", ]
} else {
  sel3 <- lin3
  est3 <- coef(sel3)["C"] * 0.5
  se3 <- sqrt(vcov(sel3)["C", "C"]) * 0.5
  df3 <- df.residual(sel3); t3 <- est3 / se3; p3 <- 2 * pt(abs(t3), df3, lower.tail = FALSE); cr <- qt(.975, df3)
  low3 <- est3 - cr * se3; high3 <- est3 + cr * se3
  tot <- summary(sel3)$coefficients["TotalPPFD100", ]
}
append_result("E3", "PRIMARY", "Delta_Terminal_Azimuth_deg",
              "Directional half-difference between C=+0.5 and C=-0.5 at total lateral PPFD=200",
              est3, se3, df3, t3, p3, low3, high3,
              "Plant fixed-effect likelihood comparison; selected model inference",
              extra = list(selected_model = best3, k_hat = khat, k_CI95_low = k_low, k_CI95_high = k_high))
append_result("E3", "SUPPORTING", "Total_Lateral_PPFD",
              "Total lateral PPFD coefficient in selected contrast-response model (per 100 PPFD)",
              tot["Estimate"], tot["Std. Error"], df.residual(sel3), tot["t value"], tot["Pr(>|t|)"],
              tot["Estimate"] - qt(.975, df.residual(sel3)) * tot["Std. Error"],
              tot["Estimate"] + qt(.975, df.residual(sel3)) * tot["Std. Error"],
              "Selected E3 plant fixed-effect model")
save_text(file.path(diag_dir, "E3_selected_model.txt"), summary(sel3), cmp3,
          paste("k_hat", khat, "CI", k_low, k_high))
model_meta$E3 <- list(selected = best3, k_hat = khat, k_CI95 = c(k_low, k_high), AIC = as.list(aics), deltaAIC = as.list(delta3), n = nrow(e3), plants = n_distinct(e3$Plant_ID))

# ---------------- E4 ----------------
e4 <- read_sheet("17_E4_SCANNING_RESTRICTION") %>%
  mutate(
    Restriction_Condition = factor(Restriction_Condition, levels = c("Free", "Sham", "Moderate", "Strong")),
    Plant_ID = factor(Plant_ID),
    Median_Tracking_Error_deg = as.numeric(Median_Tracking_Error_deg),
    Percent_Natural_Amplitude = as.numeric(Percent_Natural_Amplitude)
  )
m4 <- safe_lmer(Median_Tracking_Error_deg ~ Restriction_Condition + (1 | Plant_ID), e4)
if (!is.null(m4)) {
  method4 <- "LMM random intercept Plant_ID"
  emm4 <- emmeans(m4, ~ Restriction_Condition)
} else {
  m4 <- lm(Median_Tracking_Error_deg ~ Restriction_Condition + Plant_ID, data = e4)
  method4 <- "Plant fixed-effect linear model fallback"
  emm4 <- emmeans(m4, ~ Restriction_Condition)
}
con4 <- contrast(emm4, method = list(
  Strong_minus_Free = c(Free = -1, Sham = 0, Moderate = 0, Strong = 1),
  Sham_minus_Free = c(Free = -1, Sham = 1, Moderate = 0, Strong = 0),
  Moderate_minus_Free = c(Free = -1, Sham = 0, Moderate = 1, Strong = 0)
), adjust = "none") %>% as.data.frame()
con4$p_holm_secondary <- NA_real_
sec_idx4 <- which(con4$contrast %in% c("Sham_minus_Free", "Moderate_minus_Free"))
con4$p_holm_secondary[sec_idx4] <- holm(con4$p.value[sec_idx4])
for (i in seq_len(nrow(con4))) {
  rr <- con4[i, ]; role <- ifelse(rr$contrast == "Strong_minus_Free", "PRIMARY", "SUPPORTING")
  append_result("E4", role, "Median_Tracking_Error_deg", rr$contrast,
                rr$estimate, rr$SE, rr$df, rr$t.ratio, rr$p.value,
                rr$estimate - qt(.975, rr$df) * rr$SE,
                rr$estimate + qt(.975, rr$df) * rr$SE, method4,
                extra = list(p_Holm_secondary = rr$p_holm_secondary))
}
# Mechanistic achieved-amplitude model, plant-clustered
m4amp <- fixest::feols(Median_Tracking_Error_deg ~ Percent_Natural_Amplitude | Plant_ID,
                       data = e4, cluster = ~Plant_ID)
ra <- fixest_term(m4amp, "Percent_Natural_Amplitude")
append_result("E4", "SUPPORTING", "Median_Tracking_Error_deg",
              "Tracking error per +1 percentage point achieved natural amplitude",
              ra["estimate"], ra["SE"], ra["df"], ra["statistic"], ra["p"], ra["low"], ra["high"],
              "Plant fixed effects + Plant_ID-clustered SE")
save_text(file.path(diag_dir, "E4_primary_model.txt"), summary(m4), con4, summary(m4amp))
model_meta$E4 <- list(method = method4, n = nrow(e4), plants = n_distinct(e4$Plant_ID))

# ---------------- E5 ----------------
e5 <- read_sheet("18_E5_SPATIOTEMPORAL_STRUCTURE") %>%
  mutate(
    Condition = factor(Condition, levels = c("Static_balanced", "Structured_antiphase", "Scrambled_matched", "CommonMode_matched")),
    Plant_ID = factor(Plant_ID),
    Terminal_Orientation_Change_deg = as.numeric(Terminal_Orientation_Change_deg)
  )
m5 <- safe_lmer(Terminal_Orientation_Change_deg ~ Condition + (1 | Plant_ID), e5)
if (!is.null(m5)) {
  method5 <- "LMM random intercept Plant_ID"
  emm5 <- emmeans(m5, ~ Condition)
} else {
  m5 <- lm(Terminal_Orientation_Change_deg ~ Condition + Plant_ID, data = e5)
  method5 <- "Plant fixed-effect linear model fallback"
  emm5 <- emmeans(m5, ~ Condition)
}
con5 <- contrast(emm5, method = list(
  Structured_minus_Static = c(Static_balanced = -1, Structured_antiphase = 1, Scrambled_matched = 0, CommonMode_matched = 0),
  Structured_minus_Scrambled = c(Static_balanced = 0, Structured_antiphase = 1, Scrambled_matched = -1, CommonMode_matched = 0),
  Common_minus_Static = c(Static_balanced = -1, Structured_antiphase = 0, Scrambled_matched = 0, CommonMode_matched = 1),
  Structured_minus_Common = c(Static_balanced = 0, Structured_antiphase = 1, Scrambled_matched = 0, CommonMode_matched = -1)
), adjust = "none") %>% as.data.frame()
sec_idx5 <- which(con5$contrast != "Structured_minus_Static")
con5$p_holm_secondary <- NA_real_
con5$p_holm_secondary[sec_idx5] <- holm(con5$p.value[sec_idx5])
for (i in seq_len(nrow(con5))) {
  rr <- con5[i, ]; role <- ifelse(rr$contrast == "Structured_minus_Static", "PRIMARY", "SUPPORTING")
  append_result("E5", role, "Terminal_Orientation_Change_deg", rr$contrast,
                rr$estimate, rr$SE, rr$df, rr$t.ratio, rr$p.value,
                rr$estimate - qt(.975, rr$df) * rr$SE,
                rr$estimate + qt(.975, rr$df) * rr$SE, method5,
                extra = list(p_Holm_secondary = rr$p_holm_secondary))
}

# E5 dose stage-gate: summary values AND full 23_LIGHT_TIMESERIES terminal cumulative integrals.
lt <- read_sheet("23_LIGHT_TIMESERIES")
rec_key <- recordings %>% select(Trial_ID, Experiment, Treatment) %>% distinct()
lt_e5 <- lt %>% left_join(rec_key, by = "Trial_ID") %>% filter(Experiment == "E5")
lt_terminal <- lt_e5 %>% group_by(Trial_ID, Treatment) %>%
  summarise(
    n_points = n(), min_time = min(as.numeric(Time_s), na.rm = TRUE), max_time = max(as.numeric(Time_s), na.rm = TRUE),
    terminal_integrated_total = max(as.numeric(Integrated_Total_Photons), na.rm = TRUE),
    .groups = "drop"
  )
e5_dose_check <- e5 %>% select(Trial_ID, Condition, Integrated_Photon_Dose_Total, Dose_Difference_vs_Matched_Condition_pct) %>%
  left_join(lt_terminal, by = "Trial_ID") %>%
  mutate(abs_pct_difference_timeseries_vs_summary = 100 * abs(terminal_integrated_total - as.numeric(Integrated_Photon_Dose_Total)) / as.numeric(Integrated_Photon_Dose_Total))
write_csv(e5_dose_check, file.path(out_dir, "E5_dose_validation_R.csv"))
qa$E5_all_summary_dose_within_1pct <- all(abs(as.numeric(e5$Dose_Difference_vs_Matched_Condition_pct)) <= 1 + 1e-12, na.rm = TRUE)
qa$E5_timeseries_matches_summary_within_1pct <- all(e5_dose_check$abs_pct_difference_timeseries_vs_summary <= 1 + 1e-12, na.rm = TRUE)
if (!qa$E5_all_summary_dose_within_1pct || !qa$E5_timeseries_matches_summary_within_1pct) stop("E5 dose stage-gate failed")
save_text(file.path(diag_dir, "E5_primary_model.txt"), summary(m5), con5)
model_meta$E5 <- list(method = method5, n = nrow(e5), plants = n_distinct(e5$Plant_ID))

# ---------------- E6 ----------------
e6 <- read_sheet("19_E6_ELECTROPHYSIOLOGY") %>%
  mutate(
    Plant_ID = factor(Plant_ID),
    is_stim = Stimulated_Side %in% c("Left", "Right"),
    Ayes = tolower(as.character(A_Event_Detected)) == "yes",
    Byes = tolower(as.character(B_Event_Detected)) == "yes",
    Cyes = tolower(as.character(C_Event_Detected)) == "yes",
    A_C_Propagation_mm_s = ifelse(as.numeric(A_C_Lag_s) > 0, as.numeric(Distance_A_C_mm) / as.numeric(A_C_Lag_s), NA_real_),
    ordered_event = as.integer(Ayes & Byes & Cyes & as.numeric(A_Onset_s) < as.numeric(B_Onset_s) & as.numeric(B_Onset_s) < as.numeric(C_Onset_s))
  )
pp <- e6 %>% group_by(Plant_ID) %>% summarise(
  n = n(), stim_n = sum(is_stim), stim_events = sum(ordered_event[is_stim]), sham_events = sum(ordered_event[!is_stim]),
  diff = mean(ordered_event[is_stim]) - mean(ordered_event[!is_stim]), .groups = "drop")
obs6 <- mean(pp$diff)
n6 <- nrow(pp)
x <- 0:n6
rand_stat <- 1.5 * x / n6 - 0.5
rand_prob <- dbinom(x, size = n6, prob = 1/3)
p_exact6 <- sum(rand_prob[abs(rand_stat) >= abs(obs6) - 1e-12])
append_result("E6", "PRIMARY", "ordered A->B->C event occurrence",
              "Stimulated minus sham ordered-event occurrence difference",
              obs6, p = p_exact6, method = "Exact blocked within-plant randomization, 2 stimulated:1 sham",
              extra = list(
                stim_sessions_events = sprintf("%d/%d", sum(e6$ordered_event[e6$is_stim]), sum(e6$is_stim)),
                sham_sessions_events = sprintf("%d/%d", sum(e6$ordered_event[!e6$is_stim]), sum(!e6$is_stim)),
                plants_consistent = sum(pp$stim_events == 2 & pp$sham_events == 0)
              ))
# Secondary timing estimates from plant means, stimulated detected sessions only.
stim6 <- e6 %>% filter(is_stim, ordered_event == 1)
vars6 <- c("A_B_Lag_s", "B_C_Lag_s", "A_C_Lag_s", "A_B_Propagation_mm_s", "B_C_Propagation_mm_s", "A_C_Propagation_mm_s", "C_to_Movement_Lag_s")
for (v in vars6) {
  pm <- stim6 %>% group_by(Plant_ID) %>% summarise(value = mean(as.numeric(.data[[v]]), na.rm = TRUE), .groups = "drop") %>% filter(is.finite(value))
  est <- mean(pm$value); se <- sd(pm$value) / sqrt(nrow(pm)); df <- nrow(pm) - 1; cr <- qt(.975, df)
  append_result("E6", "SECONDARY_DESCRIPTIVE", v, paste("Plant-mean", v, "among stimulated detected sessions"),
                est, se, df, NA_real_, NA_real_, est - cr * se, est + cr * se,
                "Plant-mean t interval; descriptive secondary timing/propagation")
}
write_csv(pp, file.path(out_dir, "E6_plant_event_pattern_R.csv"))
qa$E6_all_plants_2stim_1sham <- all(pp$n == 3 & pp$stim_n == 2)
qa$E6_complete_pattern_40of40_vs_0of20 <- all(pp$stim_events == 2 & pp$sham_events == 0)
if (!qa$E6_all_plants_2stim_1sham) stop("E6 design block structure failed")
model_meta$E6 <- list(method = "Exact blocked randomization", n_plants = n6, p_exact = p_exact6)

# ---------------- E7 ----------------
e7 <- read_sheet("20_E7_PHYSIOLOGICAL_VALUE") %>%
  mutate(Scanning_Condition = factor(Scanning_Condition, levels = c("Free", "Sham", "Strong")), Plant_ID = factor(Plant_ID))
m7 <- safe_lmer(Integrated_Photosynthetic_Performance ~ Scanning_Condition + (1 | Plant_ID), e7)
if (!is.null(m7)) {
  method7 <- "LMM random intercept Plant_ID"
  emm7 <- emmeans(m7, ~ Scanning_Condition)
} else {
  m7 <- fixest::feols(Integrated_Photosynthetic_Performance ~ Scanning_Condition | Plant_ID, data = e7, cluster = ~Plant_ID)
  method7 <- "Plant fixed effects with Plant_ID-clustered SE (pre-specified singular-fit fallback)"
  # use direct fixest coefficients for contrasts
  for (cond in c("Strong", "Sham")) {
    term <- paste0("Scanning_Condition", cond)
    rr <- fixest_term(m7, term)
    append_result("E7", ifelse(cond == "Strong", "PRIMARY", "SUPPORTING"), "Integrated_Photosynthetic_Performance",
                  paste0(cond, " minus Free integrated photosynthetic performance"),
                  rr["estimate"], rr["SE"], rr["df"], rr["statistic"], rr["p"], rr["low"], rr["high"], method7)
  }
  emm7 <- NULL
}
if (!is.null(emm7)) {
  con7 <- contrast(emm7, method = list(
    Strong_minus_Free = c(Free = -1, Sham = 0, Strong = 1),
    Sham_minus_Free = c(Free = -1, Sham = 1, Strong = 0)
  ), adjust = "none") %>% as.data.frame()
  for (i in seq_len(nrow(con7))) {
    rr <- con7[i, ]; append_result("E7", ifelse(rr$contrast == "Strong_minus_Free", "PRIMARY", "SUPPORTING"),
      "Integrated_Photosynthetic_Performance", rr$contrast, rr$estimate, rr$SE, rr$df, rr$t.ratio, rr$p.value,
      rr$estimate - qt(.975, rr$df) * rr$SE, rr$estimate + qt(.975, rr$df) * rr$SE, method7)
  }
}

# E7 secondary condition endpoints with Holm across Strong-Free family.
sec7_vars <- c("Integrated_Terminal_PPFD", "PhiPSII", "ETR_umol_e_m2_s", "Leaf_Temperature_C",
               "Assimilation_umol_CO2_m2_s", "gs_mol_H2O_m2_s", "Transpiration_mmol_H2O_m2_s", "Intercellular_CO2_umol_mol")
sec7 <- list()
for (v in sec7_vars) {
  f <- as.formula(paste(v, "~ Scanning_Condition + (1|Plant_ID)"))
  mm <- safe_lmer(f, e7)
  if (!is.null(mm)) {
    ee <- emmeans(mm, ~ Scanning_Condition)
    cc <- contrast(ee, method = list(Strong_minus_Free = c(Free=-1, Sham=0, Strong=1)), adjust="none") %>% as.data.frame()
    sec7[[v]] <- tibble(endpoint=v, estimate=cc$estimate, SE=cc$SE, df=cc$df, statistic=cc$t.ratio, p=cc$p.value,
                        low=cc$estimate-qt(.975,cc$df)*cc$SE, high=cc$estimate+qt(.975,cc$df)*cc$SE,
                        method="LMM random intercept Plant_ID")
  } else {
    ff <- as.formula(paste0(v, " ~ Scanning_Condition | Plant_ID"))
    fm <- feols(ff, data=e7, cluster=~Plant_ID)
    rr <- fixest_term(fm, "Scanning_ConditionStrong")
    sec7[[v]] <- tibble(endpoint=v, estimate=rr["estimate"], SE=rr["SE"], df=NA_real_, statistic=rr["statistic"], p=rr["p"], low=rr["low"], high=rr["high"], method="Plant FE + clustered SE")
  }
}
sec7df <- bind_rows(sec7) %>% mutate(p_Holm = holm(p))
write_csv(sec7df, file.path(out_dir, "E7_secondary_condition_results_R.csv"))
for (i in seq_len(nrow(sec7df))) {
  rr <- sec7df[i,]
  append_result("E7", "SECONDARY", rr$endpoint, "Strong minus Free", rr$estimate, rr$SE, rr$df, rr$statistic, rr$p, rr$low, rr$high, rr$method, extra=list(p_Holm_secondary=rr$p_Holm))
}

# E7 time-resolved analysis from detailed sheet.
d7 <- read_sheet("24_FLUORESCENCE_GAS_EXCHANGE") %>%
  mutate(
    Condition = factor(Condition, levels = c("Free", "Sham", "Strong")),
    Plant_ID = factor(Plant_ID), Trial_ID = factor(Trial_ID), Relative_Time_min = as.numeric(Relative_Time_min)
  )
# Baseline Fv/Fm at -25 min.
b7 <- d7 %>% filter(Relative_Time_min == -25, !is.na(FvFm))
mb <- safe_lmer(as.numeric(FvFm) ~ Condition + (1 | Plant_ID), b7)
if (!is.null(mb)) {
  eb <- emmeans(mb, ~ Condition)
  cb <- contrast(eb, method=list(Sham_minus_Free=c(Free=-1,Sham=1,Strong=0), Strong_minus_Free=c(Free=-1,Sham=0,Strong=1)), adjust="holm") %>% as.data.frame()
} else {
  mb <- lm(as.numeric(FvFm) ~ Condition + Plant_ID, data=b7)
  eb <- emmeans(mb, ~ Condition)
  cb <- contrast(eb, method=list(Sham_minus_Free=c(Free=-1,Sham=1,Strong=0), Strong_minus_Free=c(Free=-1,Sham=0,Strong=1)), adjust="holm") %>% as.data.frame()
}
write_csv(cb, file.path(out_dir, "E7_FvFm_baseline_R.csv"))

# Dynamic 0-60 min AR(1) models. Store omnibus condition/time/interaction tests.
time_endpoints <- c("Terminal_PPFD", "PhiPSII", "ETR", "Leaf_Temperature_C")
time_tests <- list()
for (v in time_endpoints) {
  td <- d7 %>% filter(Relative_Time_min %in% c(0,15,30,45,60), !is.na(.data[[v]])) %>% mutate(TimeF=factor(Relative_Time_min))
  ff <- as.formula(paste(v, "~ Condition * TimeF"))
  fit <- try(nlme::lme(
    fixed = ff,
    random = ~1 | Plant_ID/Trial_ID,
    correlation = nlme::corAR1(form = ~ Relative_Time_min | Plant_ID/Trial_ID),
    data = td, method = "REML", na.action = na.omit,
    control = nlme::lmeControl(opt = "optim", maxIter = 200, msMaxIter = 200, returnObject = TRUE)
  ), silent=TRUE)
  if (inherits(fit,"try-error")) {
    # fallback without AR1, still session-nested repeated random structure
    fit <- nlme::lme(fixed=ff, random=~1|Plant_ID/Trial_ID, data=td, method="REML", na.action=na.omit,
                     control=nlme::lmeControl(opt="optim", maxIter=200, msMaxIter=200, returnObject=TRUE))
    corr_method <- "nested random intercepts; AR1 failed"
  } else corr_method <- "nested random intercepts + AR(1) within session"
  av <- anova(fit)
  av$term <- rownames(av)
  rownames(av) <- NULL
  out <- as_tibble(av) %>% mutate(endpoint=v, correlation_structure=corr_method)
  time_tests[[v]] <- out
  save_text(file.path(diag_dir, paste0("E7_time_",v,".txt")), summary(fit), av)
}
write_csv(bind_rows(time_tests), file.path(out_dir, "E7_time_resolved_omnibus_R.csv"))

# Gas exchange at 110 min, explicitly post-tracking.
gas_vars <- c("Assimilation_umol_CO2_m2_s", "gs_mol_H2O_m2_s", "Transpiration_mmol_H2O_m2_s", "Ci_umol_mol")
gas110 <- d7 %>% filter(Relative_Time_min == 110)
gas_results <- list()
for (v in gas_vars) {
  gd <- gas110 %>% filter(!is.na(.data[[v]]))
  ff <- as.formula(paste(v, "~ Condition + (1|Plant_ID)"))
  gm <- safe_lmer(ff, gd)
  if (!is.null(gm)) {
    ge <- emmeans(gm,~Condition)
    gc <- contrast(ge, method=list(Strong_minus_Free=c(Free=-1,Sham=0,Strong=1), Sham_minus_Free=c(Free=-1,Sham=1,Strong=0)), adjust="holm") %>% as.data.frame()
    gc$method <- "post-tracking LMM"
  } else {
    lm_g <- lm(as.formula(paste(v,"~ Condition + Plant_ID")),data=gd)
    ge <- emmeans(lm_g,~Condition)
    gc <- contrast(ge, method=list(Strong_minus_Free=c(Free=-1,Sham=0,Strong=1), Sham_minus_Free=c(Free=-1,Sham=1,Strong=0)), adjust="holm") %>% as.data.frame()
    gc$method <- "post-tracking plant fixed-effect model fallback"
  }
  gc$endpoint <- v; gas_results[[v]] <- gc
}
write_csv(bind_rows(gas_results), file.path(out_dir,"E7_gas_exchange_110min_R.csv"))

save_text(file.path(diag_dir, "E7_primary_model.txt"), summary(m7))
model_meta$E7 <- list(method = method7, n = nrow(e7), plants = n_distinct(e7$Plant_ID))

# ---------------- global QA / outputs ----------------
# Confirm expected design counts.
qa$E1 <- list(rows=nrow(e1), plants=n_distinct(e1$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e1$Plant_ID)))))
qa$E2 <- list(rows=nrow(e2), plants=n_distinct(e2$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e2$Plant_ID)))))
qa$E3 <- list(rows=nrow(e3), plants=n_distinct(e3$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e3$Plant_ID)))))
qa$E4 <- list(rows=nrow(e4), plants=n_distinct(e4$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e4$Plant_ID)))))
qa$E5 <- list(rows=nrow(e5), plants=n_distinct(e5$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e5$Plant_ID)))))
qa$E6 <- list(rows=nrow(e6), plants=n_distinct(e6$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e6$Plant_ID)))))
qa$E7 <- list(rows=nrow(e7), plants=n_distinct(e7$Plant_ID), sessions_per_plant=sort(unique(as.integer(table(e7$Plant_ID)))))
qa$workbook_sha256 <- actual_sha256

all_results <- bind_rows(result_rows)
write_csv(all_results, file.path(out_dir, "R_PRIMARY_AND_SUPPORTING_RESULTS.csv"), na = "")
write_json(model_meta, file.path(out_dir, "R_MODEL_METADATA.json"), pretty=TRUE, auto_unbox=TRUE, na="null")
write_json(qa, file.path(out_dir, "R_QA_REPORT.json"), pretty=TRUE, auto_unbox=TRUE, na="null")

session <- capture.output(sessionInfo())
writeLines(session, file.path(out_dir, "R_SESSION_INFO.txt"))

# Compact markdown report for human inspection.
primary <- all_results %>% filter(role == "PRIMARY")
lines <- c(
  "# Paper 11 R Statistical Reconciliation",
  "",
  paste0("Workbook SHA-256: `", actual_sha256, "`"),
  "",
  "## Primary results",
  ""
)
for (i in seq_len(nrow(primary))) {
  rr <- primary[i,]
  lines <- c(lines, sprintf("- **%s** — %s: estimate = %s; 95%% CI [%s, %s]; P = %s; method: %s",
                            rr$experiment, rr$label,
                            format(rr$estimate, digits=7), format(rr$CI95_low, digits=7), format(rr$CI95_high, digits=7),
                            format(rr$p, digits=7), rr$method))
}
lines <- c(lines, "", "## E3 model comparison", "")
for (i in seq_len(nrow(cmp3))) lines <- c(lines, sprintf("- %s: AIC %.3f; ΔAIC %.3f", cmp3$model[i], cmp3$AIC[i], cmp3$deltaAIC[i]))
lines <- c(lines, sprintf("- estimated saturation k = %.6f; profile-likelihood 95%% CI %.6f–%.6f", khat, k_low, k_high))
lines <- c(lines, "", "## Hard QA gates", "", paste0("- E5 summary dose ≤1%: ", qa$E5_all_summary_dose_within_1pct), paste0("- E5 time-series integration matches summaries ≤1%: ", qa$E5_timeseries_matches_summary_within_1pct), paste0("- E6 complete 40/40 stimulated vs 0/20 sham pattern: ", qa$E6_complete_pattern_40of40_vs_0of20))
writeLines(lines, file.path(out_dir, "R_RECONCILIATION_REPORT.md"))

cat("Paper 11 R analysis completed successfully.\n")
print(primary)
