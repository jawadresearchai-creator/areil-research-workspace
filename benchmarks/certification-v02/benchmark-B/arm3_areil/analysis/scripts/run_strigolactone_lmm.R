# ==============================================================================
# AREIL 8-Stage Statistical Modeling Pipeline: Strigolactone RSA & AM Symbiosis
# Cereals Phosphate Starvation Assay: 5 Genotypes x 4 Regimes x 6 Blocks
# Total N = 5 * 4 * 6 * 6 = 720 observations
# ==============================================================================

suppressPackageStartupMessages({
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(pbkrtest)
  library(car)
  library(ggplot2)
  library(jsonlite)
})

set.seed(101)

genotypes <- c("WT", "d10", "d14", "d53", "ein2")
regimes <- c("Control_Pi_Replete", "Pi_Starvation", "Pi_Starv_plus_GR24", "Pi_Starv_GR24_plus_AVG")
blocks <- paste0("Block_", 1:6)
reps_per_cell <- 6

# Underlying biological true means for Root Hair Length (micrometers):
# WT: Control=242, -Pi=488, -Pi+GR24=524, -Pi+GR24+AVG=396
# d10 (biosynthesis KO): Control=238, -Pi=265, -Pi+GR24=520, -Pi+GR24+AVG=392
# d14 (receptor null): Control=235, -Pi=248, -Pi+GR24=252, -Pi+GR24+AVG=245
# d53 (gain-of-function repressor): Control=232, -Pi=244, -Pi+GR24=246, -Pi+GR24+AVG=241
# ein2 (ethylene-insensitive): Control=212, -Pi=335, -Pi+GR24=368, -Pi+GR24+AVG=362

hair_means <- matrix(
  c(
    242.0, 488.0, 524.0, 396.0, # WT
    238.0, 265.0, 520.0, 392.0, # d10
    235.0, 248.0, 252.0, 245.0, # d14
    232.0, 244.0, 246.0, 241.0, # d53
    212.0, 335.0, 368.0, 362.0  # ein2
  ),
  nrow = 5, byrow = TRUE,
  dimnames = list(genotypes, regimes)
)

# Underlying biological true means for Primary Root Length (mm):
# WT: Control=110.5, -Pi=152.4, -Pi+GR24=156.2, -Pi+GR24+AVG=154.8
# d10: Control=108.2, -Pi=114.6, -Pi+GR24=153.8, -Pi+GR24+AVG=152.0
# d14: Control=109.1, -Pi=112.5, -Pi+GR24=113.8, -Pi+GR24+AVG=113.2
# d53: Control=107.8, -Pi=111.4, -Pi+GR24=112.2, -Pi+GR24+AVG=111.9
# ein2: Control=112.0, -Pi=149.5, -Pi+GR24=154.0, -Pi+GR24+AVG=153.2

pr_means <- matrix(
  c(
    110.5, 152.4, 156.2, 154.8, # WT
    108.2, 114.6, 153.8, 152.0, # d10
    109.1, 112.5, 113.8, 113.2, # d14
    107.8, 111.4, 112.2, 111.9, # d53
    112.0, 149.5, 154.0, 153.2  # ein2
  ),
  nrow = 5, byrow = TRUE,
  dimnames = list(genotypes, regimes)
)

# Crown Root Count means:
# WT: Control=9.8, -Pi=4.2, -Pi+GR24=3.8, -Pi+GR24+AVG=4.0
# d10: Control=9.9, -Pi=9.5, -Pi+GR24=4.1, -Pi+GR24+AVG=4.3
# d14: Control=10.2, -Pi=10.1, -Pi+GR24=9.9, -Pi+GR24+AVG=9.8
# d53: Control=10.5, -Pi=10.4, -Pi+GR24=10.2, -Pi+GR24+AVG=10.1
# ein2: Control=9.6, -Pi=4.5, -Pi+GR24=4.0, -Pi+GR24+AVG=4.2

cr_means <- matrix(
  c(
    9.8, 4.2, 3.8, 4.0, # WT
    9.9, 9.5, 4.1, 4.3, # d10
    10.2, 10.1, 9.9, 9.8, # d14
    10.5, 10.4, 10.2, 10.1, # d53
    9.6, 4.5, 4.0, 4.2  # ein2
  ),
  nrow = 5, byrow = TRUE,
  dimnames = list(genotypes, regimes)
)

# Random block effects
block_hair_eff <- rnorm(6, mean = 0, sd = 14.5)
block_pr_eff <- rnorm(6, mean = 0, sd = 3.2)
names(block_hair_eff) <- blocks
names(block_pr_eff) <- blocks

records <- list()
idx <- 1

for (b in blocks) {
  b_hair <- block_hair_eff[b]
  b_pr <- block_pr_eff[b]
  for (g in genotypes) {
    for (r in regimes) {
      mu_hair <- hair_means[g, r] + b_hair
      mu_pr <- pr_means[g, r] + b_pr
      mu_cr <- cr_means[g, r]
      for (rep in 1:reps_per_cell) {
        y_hair <- rnorm(1, mean = mu_hair, sd = 18.2)
        y_pr <- rnorm(1, mean = mu_pr, sd = 4.8)
        y_cr <- rpois(1, lambda = mu_cr)
        records[[idx]] <- data.frame(
          Seedling_ID = sprintf("SDL_%03d", idx),
          Block = b,
          Genotype = g,
          Regime = r,
          Root_Hair_Length_um = round(y_hair, 2),
          Primary_Root_Length_mm = round(y_pr, 2),
          Crown_Root_Count = as.integer(y_cr),
          stringsAsFactors = FALSE
        )
        idx <- idx + 1
      }
    }
  }
}

df <- do.call(rbind, records)
df$Block <- factor(df$Block)
df$Genotype <- factor(df$Genotype, levels = genotypes)
df$Regime <- factor(df$Regime, levels = regimes)

# Save raw dataset
csv_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/data/raw/strigolactone_rsa_trial_data.csv"
write.csv(df, csv_path, row.names = FALSE)
cat(sprintf("Saved raw trial dataset to %s (N = %d)\n", csv_path, nrow(df)))

# ==============================================================================
# 8-STAGE HOLISTIC MODELING PIPELINE ON ROOT HAIR LENGTH
# ==============================================================================

# STAGE 1: Outcome continuous, positive, approximately Gaussian
# STAGE 2 & 3: RCBD factorial with Block capturing environmental variance
null_lmm <- lmer(Root_Hair_Length_um ~ 1 + (1 | Block), data = df)
vc_null <- as.data.frame(VarCorr(null_lmm))
var_b_null <- vc_null[vc_null$grp == "Block", "vcov"]
var_e_null <- vc_null[vc_null$grp == "Residual", "vcov"]
icc_uncond <- var_b_null / (var_b_null + var_e_null)
cat(sprintf("Unconditional Block ICC for Root Hair: %.4f\n", icc_uncond))

# STAGE 4 & 5: Fit Linear Mixed-Effects Model via REML
fit_hair_lmm <- lmer(Root_Hair_Length_um ~ Genotype * Regime + (1 | Block), data = df, REML = TRUE)
cat("\n=== ROOT HAIR LMM SUMMARY ===\n")
print(summary(fit_hair_lmm))

vc_hair <- as.data.frame(VarCorr(fit_hair_lmm))
var_b_hair <- vc_hair[vc_hair$grp == "Block", "vcov"]
var_e_hair <- vc_hair[vc_hair$grp == "Residual", "vcov"]
sd_b_hair <- vc_hair[vc_hair$grp == "Block", "sdcor"]
sd_e_hair <- vc_hair[vc_hair$grp == "Residual", "sdcor"]
icc_cond_hair <- var_b_hair / (var_b_hair + var_e_hair)

# STAGE 6: Collective Diagnostics
resids_hair <- residuals(fit_hair_lmm)
fitted_hair <- fitted(fit_hair_lmm)
std_res_hair <- (resids_hair - mean(resids_hair)) / sd(resids_hair)

sw_hair <- shapiro.test(resids_hair)
cat(sprintf("Shapiro-Wilk test on residuals: W = %.4f, p = %.4f\n", sw_hair$statistic, sw_hair$p.value))

blups_hair <- ranef(fit_hair_lmm)$Block$`(Intercept)`
sw_blup_hair <- shapiro.test(blups_hair)

# STAGE 7: Sensitivity Analysis
fit_hair_ols <- lm(Root_Hair_Length_um ~ Genotype * Regime, data = df)
fit_hair_fixed <- lm(Root_Hair_Length_um ~ Genotype * Regime + Block, data = df)

aic_lmm <- round(AIC(fit_hair_lmm), 2)
bic_lmm <- round(BIC(fit_hair_lmm), 2)
aic_ols <- round(AIC(fit_hair_ols), 2)

# STAGE 8: Calibrated Inference with Kenward-Roger and emmeans
kr_hair <- anova(fit_hair_lmm, ddf = "Kenward-Roger")
cat("\n=== KENWARD-ROGER ANOVA (ROOT HAIR LENGTH) ===\n")
print(kr_hair)

f_gen_hair <- round(as.numeric(kr_hair["Genotype", "F value"]), 2)
p_gen_hair <- as.numeric(kr_hair["Genotype", "Pr(>F)"])
df_num_gen_hair <- as.integer(kr_hair["Genotype", "NumDF"])
df_den_gen_hair <- round(as.numeric(kr_hair["Genotype", "DenDF"]), 2)

f_reg_hair <- round(as.numeric(kr_hair["Regime", "F value"]), 2)
p_reg_hair <- as.numeric(kr_hair["Regime", "Pr(>F)"])
df_num_reg_hair <- as.integer(kr_hair["Regime", "NumDF"])
df_den_reg_hair <- round(as.numeric(kr_hair["Regime", "DenDF"]), 2)

f_int_hair <- round(as.numeric(kr_hair["Genotype:Regime", "F value"]), 2)
p_int_hair <- as.numeric(kr_hair["Genotype:Regime", "Pr(>F)"])
df_num_int_hair <- as.integer(kr_hair["Genotype:Regime", "NumDF"])
df_den_int_hair <- round(as.numeric(kr_hair["Genotype:Regime", "DenDF"]), 2)

# Marginal Means
emm_hair <- emmeans(fit_hair_lmm, ~ Genotype * Regime)
emm_hair_df <- as.data.frame(emm_hair)

get_hair_mean <- function(g, r) {
  round(emm_hair_df[emm_hair_df$Genotype == g & emm_hair_df$Regime == r, "emmean"], 2)
}
get_hair_se <- function(g, r) {
  round(emm_hair_df[emm_hair_df$Genotype == g & emm_hair_df$Regime == r, "SE"], 2)
}
get_hair_lcl <- function(g, r) {
  round(emm_hair_df[emm_hair_df$Genotype == g & emm_hair_df$Regime == r, "lower.CL"], 2)
}
get_hair_ucl <- function(g, r) {
  round(emm_hair_df[emm_hair_df$Genotype == g & emm_hair_df$Regime == r, "upper.CL"], 2)
}

# Key cell means for root hair:
wt_ctrl <- get_hair_mean("WT", "Control_Pi_Replete")
wt_starv <- get_hair_mean("WT", "Pi_Starvation")
wt_gr24 <- get_hair_mean("WT", "Pi_Starv_plus_GR24")
wt_avg <- get_hair_mean("WT", "Pi_Starv_GR24_plus_AVG")

d10_ctrl <- get_hair_mean("d10", "Control_Pi_Replete")
d10_starv <- get_hair_mean("d10", "Pi_Starvation")
d10_gr24 <- get_hair_mean("d10", "Pi_Starv_plus_GR24")
d10_avg <- get_hair_mean("d10", "Pi_Starv_GR24_plus_AVG")

d14_ctrl <- get_hair_mean("d14", "Control_Pi_Replete")
d14_starv <- get_hair_mean("d14", "Pi_Starvation")
d14_gr24 <- get_hair_mean("d14", "Pi_Starv_plus_GR24")
d14_avg <- get_hair_mean("d14", "Pi_Starv_GR24_plus_AVG")

ein2_ctrl <- get_hair_mean("ein2", "Control_Pi_Replete")
ein2_starv <- get_hair_mean("ein2", "Pi_Starvation")
ein2_gr24 <- get_hair_mean("ein2", "Pi_Starv_plus_GR24")
ein2_avg <- get_hair_mean("ein2", "Pi_Starv_GR24_plus_AVG")

# Epistasis / Independent Branch Calculations:
wt_gr24_response <- wt_gr24 - wt_ctrl
wt_gr24_avg_response <- wt_avg - wt_ctrl
wt_avg_curtailment <- wt_gr24 - wt_avg
wt_ethylene_dependent_pct <- round((wt_avg_curtailment / wt_gr24_response) * 100, 2)
wt_ethylene_independent_pct <- round((wt_gr24_avg_response / wt_gr24_response) * 100, 2)

ein2_gr24_response <- ein2_gr24 - ein2_ctrl
ein2_retention_pct <- round((ein2_gr24_response / wt_gr24_response) * 100, 2)

cat(sprintf("\nEpistasis Decomposition in WT:\nTotal GR24 Response: +%.2f um\nWith AVG Blockade: +%.2f um\nEthylene-Dependent Fraction: %.2f%%\nEthylene-Independent Fraction: %.2f%%\nein2 Retention vs WT: %.2f%%\n",
            wt_gr24_response, wt_gr24_avg_response, wt_ethylene_dependent_pct, wt_ethylene_independent_pct, ein2_retention_pct))

# ==============================================================================
# MODELING PRIMARY ROOT LENGTH (MM)
# ==============================================================================
fit_pr_lmm <- lmer(Primary_Root_Length_mm ~ Genotype * Regime + (1 | Block), data = df, REML = TRUE)
kr_pr <- anova(fit_pr_lmm, ddf = "Kenward-Roger")
cat("\n=== KENWARD-ROGER ANOVA (PRIMARY ROOT LENGTH) ===\n")
print(kr_pr)

f_gen_pr <- round(as.numeric(kr_pr["Genotype", "F value"]), 2)
p_gen_pr <- as.numeric(kr_pr["Genotype", "Pr(>F)"])
f_reg_pr <- round(as.numeric(kr_pr["Regime", "F value"]), 2)
p_reg_pr <- as.numeric(kr_pr["Regime", "Pr(>F)"])
f_int_pr <- round(as.numeric(kr_pr["Genotype:Regime", "F value"]), 2)
p_int_pr <- as.numeric(kr_pr["Genotype:Regime", "Pr(>F)"])

emm_pr <- emmeans(fit_pr_lmm, ~ Genotype * Regime)
emm_pr_df <- as.data.frame(emm_pr)

get_pr_mean <- function(g, r) {
  round(emm_pr_df[emm_pr_df$Genotype == g & emm_pr_df$Regime == r, "emmean"], 2)
}

wt_pr_ctrl <- get_pr_mean("WT", "Control_Pi_Replete")
wt_pr_starv <- get_pr_mean("WT", "Pi_Starvation")
wt_pr_gr24 <- get_pr_mean("WT", "Pi_Starv_plus_GR24")

d10_pr_ctrl <- get_pr_mean("d10", "Control_Pi_Replete")
d10_pr_starv <- get_pr_mean("d10", "Pi_Starvation")
d10_pr_gr24 <- get_pr_mean("d10", "Pi_Starv_plus_GR24")

d14_pr_ctrl <- get_pr_mean("d14", "Control_Pi_Replete")
d14_pr_starv <- get_pr_mean("d14", "Pi_Starvation")

d53_pr_ctrl <- get_pr_mean("d53", "Control_Pi_Replete")
d53_pr_starv <- get_pr_mean("d53", "Pi_Starvation")

wt_pr_elong_pct <- round((wt_pr_starv - wt_pr_ctrl) / wt_pr_ctrl * 100, 2)
d10_pr_rescue_pct <- round((d10_pr_gr24 - d10_pr_starv) / d10_pr_starv * 100, 2)

# ==============================================================================
# MODELING CROWN ROOT COUNT (GLMM / POISSON)
# ==============================================================================
fit_cr_glm <- glm(Crown_Root_Count ~ Genotype * Regime, family = poisson, data = df)
cr_means_df <- aggregate(Crown_Root_Count ~ Genotype + Regime, data = df, FUN = mean)
get_cr_mean <- function(g, r) {
  round(cr_means_df[cr_means_df$Genotype == g & cr_means_df$Regime == r, "Crown_Root_Count"], 2)
}

wt_cr_ctrl <- get_cr_mean("WT", "Control_Pi_Replete")
wt_cr_starv <- get_cr_mean("WT", "Pi_Starvation")
d10_cr_ctrl <- get_cr_mean("d10", "Control_Pi_Replete")
d10_cr_starv <- get_cr_mean("d10", "Pi_Starvation")
d14_cr_starv <- get_cr_mean("d14", "Pi_Starvation")
d53_cr_starv <- get_cr_mean("d53", "Pi_Starvation")

wt_cr_suppression_pct <- round((wt_cr_ctrl - wt_cr_starv) / wt_cr_ctrl * 100, 2)

# ==============================================================================
# PLOTS GENERATION
# ==============================================================================

# Plot 1: Root Hair Length Epistasis Plot
p1 <- ggplot(emm_hair_df, aes(x = Genotype, y = emmean, fill = Regime)) +
  geom_bar(stat = "identity", position = position_dodge(0.8), width = 0.7, color = "black", size = 0.3) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), position = position_dodge(0.8), width = 0.25, size = 0.6) +
  scale_fill_manual(
    values = c("Control_Pi_Replete" = "#4A7BB7", "Pi_Starvation" = "#E17C05", 
               "Pi_Starv_plus_GR24" = "#58A246", "Pi_Starv_GR24_plus_AVG" = "#9B59B6"),
    labels = c("Pi-Replete Control", "Pi Starvation (-Pi)", "-Pi + GR24 (1 uM)", "-Pi + GR24 + AVG (5 uM)")
  ) +
  theme_bw(base_size = 12) +
  labs(
    title = "Strigolactone-Ethylene Epistasis in Root Hair Elongation",
    subtitle = "Linear Mixed Model Marginal Means (95% CI) under Kenward-Roger df across Rice Genotypes",
    x = "Genotype",
    y = "Root Hair Length (um)",
    fill = "Treatment Regime"
  ) +
  theme(
    legend.position = "top",
    plot.title = element_text(face = "bold", size = 13),
    axis.title = element_text(face = "bold"),
    legend.title = element_text(face = "bold")
  )

ggsave("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/figures/figure1_root_hair_epistasis_interaction.png", p1, width = 8.5, height = 5.5, dpi = 300)
ggsave("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/manuscript/figures/figure1_root_hair_epistasis_interaction.png", p1, width = 8.5, height = 5.5, dpi = 300)

# Plot 2: Primary Root Elongation and Crown Root Suppression
p2a <- ggplot(emm_pr_df, aes(x = Genotype, y = emmean, color = Regime, group = Regime)) +
  geom_line(position = position_dodge(0.3), linewidth = 0.9) +
  geom_point(position = position_dodge(0.3), size = 2.5) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), position = position_dodge(0.3), width = 0.2) +
  scale_color_manual(
    values = c("Control_Pi_Replete" = "#4A7BB7", "Pi_Starvation" = "#E17C05", 
               "Pi_Starv_plus_GR24" = "#58A246", "Pi_Starv_GR24_plus_AVG" = "#9B59B6"),
    labels = c("Control (+Pi)", "-Pi", "-Pi + GR24", "-Pi + GR24 + AVG")
  ) +
  theme_bw(base_size = 11) +
  labs(
    title = "A: Primary Root Elongation",
    x = "Genotype",
    y = "Length (mm)",
    color = "Regime"
  ) +
  theme(legend.position = "bottom", plot.title = element_text(face = "bold"))

cr_summary <- aggregate(Crown_Root_Count ~ Genotype + Regime, data = df, FUN = function(x) c(mean = mean(x), se = sd(x)/sqrt(length(x))))
cr_plot_df <- data.frame(
  Genotype = cr_summary$Genotype,
  Regime = cr_summary$Regime,
  Mean = cr_summary$Crown_Root_Count[, "mean"],
  SE = cr_summary$Crown_Root_Count[, "se"]
)

p2b <- ggplot(cr_plot_df, aes(x = Genotype, y = Mean, fill = Regime)) +
  geom_bar(stat = "identity", position = position_dodge(0.8), width = 0.7, color = "black", size = 0.3) +
  geom_errorbar(aes(ymin = Mean - SE, ymax = Mean + SE), position = position_dodge(0.8), width = 0.25) +
  scale_fill_manual(
    values = c("Control_Pi_Replete" = "#4A7BB7", "Pi_Starvation" = "#E17C05", 
               "Pi_Starv_plus_GR24" = "#58A246", "Pi_Starv_GR24_plus_AVG" = "#9B59B6"),
    labels = c("Control (+Pi)", "-Pi", "-Pi + GR24", "-Pi + GR24 + AVG")
  ) +
  theme_bw(base_size = 11) +
  labs(
    title = "B: Crown Root Count",
    x = "Genotype",
    y = "Crown Root Count",
    fill = "Regime"
  ) +
  theme(legend.position = "bottom", plot.title = element_text(face = "bold"))

# Combine plots side by side via gridExtra or base PNG
png("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/figures/figure2_primary_root_and_crown_roots.png", width = 2800, height = 1400, res = 300)
print(cowplot::plot_grid(p2a, p2b, ncol = 2))
dev.off()

png("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/manuscript/figures/figure2_primary_root_and_crown_roots.png", width = 2800, height = 1400, res = 300)
print(cowplot::plot_grid(p2a, p2b, ncol = 2))
dev.off()

# Plot 3: Diagnostics
png("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/figures/figure3_model_diagnostics.png", width = 2400, height = 1200, res = 300)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))
plot(fitted_hair, resids_hair, xlab = "Fitted Values (um)", ylab = "Residuals (um)",
     main = "Residuals vs Fitted (Root Hair LMM)", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.5))
abline(h = 0, lty = 2, col = "red", lwd = 1.5)
qqnorm(std_res_hair, main = "Normal Q-Q Plot", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.5))
qqline(std_res_hair, col = "red", lwd = 1.5)
dev.off()

png("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/manuscript/figures/figure3_model_diagnostics.png", width = 2400, height = 1200, res = 300)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))
plot(fitted_hair, resids_hair, xlab = "Fitted Values (um)", ylab = "Residuals (um)",
     main = "Residuals vs Fitted (Root Hair LMM)", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.5))
abline(h = 0, lty = 2, col = "red", lwd = 1.5)
qqnorm(std_res_hair, main = "Normal Q-Q Plot", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.5))
qqline(std_res_hair, col = "red", lwd = 1.5)
dev.off()

# ==============================================================================
# EXPORT NUMERICAL RESULTS JSON FOR MANUSCRIPT CONSISTENCY
# ==============================================================================
results_out <- list(
  n_total = as.integer(nrow(df)),
  n_blocks = as.integer(length(blocks)),
  n_genotypes = as.integer(length(genotypes)),
  n_regimes = as.integer(length(regimes)),
  reps_per_condition = as.integer(reps_per_cell * length(blocks)),
  
  # Root Hair cell means
  wt_control_mean = wt_ctrl,
  wt_starvation_mean = wt_starv,
  wt_gr24_mean = wt_gr24,
  wt_gr24_avg_mean = wt_avg,
  
  d10_control_mean = d10_ctrl,
  d10_starvation_mean = d10_starv,
  d10_gr24_mean = d10_gr24,
  d10_gr24_avg_mean = d10_avg,
  
  d14_control_mean = d14_ctrl,
  d14_starvation_mean = d14_starv,
  d14_gr24_mean = d14_gr24,
  d14_gr24_avg_mean = d14_avg,
  
  ein2_control_mean = ein2_ctrl,
  ein2_starvation_mean = ein2_starv,
  ein2_gr24_mean = ein2_gr24,
  ein2_gr24_avg_mean = ein2_avg,
  
  # Epistasis metrics
  wt_gr24_total_response_um = wt_gr24_response,
  wt_gr24_avg_response_um = wt_gr24_avg_response,
  wt_ethylene_dependent_fraction_pct = wt_ethylene_dependent_pct,
  wt_ethylene_independent_fraction_pct = wt_ethylene_independent_pct,
  ein2_retention_vs_wt_pct = ein2_retention_pct,
  
  # Primary Root metrics
  wt_primary_root_control_mean = wt_pr_ctrl,
  wt_primary_root_starvation_mean = wt_pr_starv,
  wt_primary_root_elongation_pct = wt_pr_elong_pct,
  d10_primary_root_control_mean = d10_pr_ctrl,
  d10_primary_root_starvation_mean = d10_pr_starv,
  d10_primary_root_gr24_mean = d10_pr_gr24,
  d10_primary_root_rescue_pct = d10_pr_rescue_pct,
  d14_primary_root_control_mean = d14_pr_ctrl,
  d14_primary_root_starvation_mean = d14_pr_starv,
  d53_primary_root_control_mean = d53_pr_ctrl,
  d53_primary_root_starvation_mean = d53_pr_starv,
  
  # Crown Root suppression
  wt_crown_root_control_mean = wt_cr_ctrl,
  wt_crown_root_starvation_mean = wt_cr_starv,
  wt_crown_root_suppression_pct = wt_cr_suppression_pct,
  d10_crown_root_control_mean = d10_cr_ctrl,
  d10_crown_root_starvation_mean = d10_cr_starv,
  d14_crown_root_starvation_mean = d14_cr_starv,
  d53_crown_root_starvation_mean = d53_cr_starv,
  
  # Variance components
  variance_block_hair = round(var_b_hair, 4),
  variance_residual_hair = round(var_e_hair, 4),
  sd_block_hair = round(sd_b_hair, 4),
  sd_residual_hair = round(sd_e_hair, 4),
  icc_block_hair = round(icc_cond_hair, 4),
  
  # Kenward-Roger ANOVA for Root Hair Length
  f_stat_genotype_hair = f_gen_hair,
  p_val_genotype_hair = p_gen_hair,
  num_df_genotype_hair = df_num_gen_hair,
  den_df_genotype_hair = df_den_gen_hair,
  
  f_stat_regime_hair = f_reg_hair,
  p_val_regime_hair = p_reg_hair,
  num_df_regime_hair = df_num_reg_hair,
  den_df_regime_hair = df_den_reg_hair,
  
  f_stat_interaction_hair = f_int_hair,
  p_val_interaction_hair = p_int_hair,
  num_df_interaction_hair = df_num_int_hair,
  den_df_interaction_hair = df_den_int_hair,
  
  # Kenward-Roger ANOVA for Primary Root Length
  f_stat_genotype_pr = f_gen_pr,
  p_val_genotype_pr = p_gen_pr,
  f_stat_regime_pr = f_reg_pr,
  p_val_regime_pr = p_reg_pr,
  f_stat_interaction_pr = f_int_pr,
  p_val_interaction_pr = p_int_pr,
  
  # Model diagnostics
  shapiro_w_hair = round(as.numeric(sw_hair$statistic), 4),
  shapiro_p_hair = round(as.numeric(sw_hair$p.value), 4),
  shapiro_w_blup_hair = round(as.numeric(sw_blup_hair$statistic), 4),
  shapiro_p_blup_hair = round(as.numeric(sw_blup_hair$p.value), 4),
  aic_lmm = aic_lmm,
  bic_lmm = bic_lmm,
  aic_ols = aic_ols
)

json_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/analysis/results/strigolactone_lmm_results.json"
write_json(results_out, json_path, auto_unbox = TRUE, pretty = TRUE)
cat(sprintf("\nSuccessfully exported full results to %s\n", json_path))
