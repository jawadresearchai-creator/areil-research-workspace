# ==============================================================================
# AREIL 8-Stage Statistical Modeling Pipeline: Root Impedance Phenotyping Assay
# Response: Primary Root Elongation (mm) across 5 Genotypes x 2 Mechanical Regimes
# Design: Randomized Complete Block Design (RCBD) across 6 Experimental Blocks
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

set.seed(42)

# --- STAGE 1: Data-Generating Process & Outcome Simulation ---
# 5 Genotypes: Col-0 (WT), dorn1-1 (P2K1-KO), fer-4 (FERONIA-KO), rbohD (ROS-KO), APY2-OE (Apyrase-OE)
# 2 Treatments: Control (0.8% agar), Impedance (2.0% high-density agar)
# 6 Blocks (independent plates/batches), 6 replicate seedlings per cell
# Total N = 5 * 2 * 6 * 6 = 360 observations

genotypes <- c("Col-0", "dorn1-1", "fer-4", "rbohD", "APY2-OE")
treatments <- c("Control", "Impedance")
blocks <- paste0("Block_", 1:6)
reps_per_cell <- 6

# Underlying biological true effects (mm):
# Base means under Control:
base_means <- c(
  "Col-0" = 28.50,
  "dorn1-1" = 27.80,
  "fer-4" = 22.40,
  "rbohD" = 26.90,
  "APY2-OE" = 29.10
)

# Mechanical impedance effects (reduction in mm):
# Col-0 suffers strong inhibition due to eATP release, FERONIA/P2K1 signaling, and RBOHD ROS burst (-14.3 mm)
# dorn1-1 is partially insensitive to eATP (-8.0 mm)
# fer-4 is insensitive to mechanical scaffolding (-5.9 mm)
# rbohD lacks the ROS wave for cell wall stiffening (-5.8 mm)
# APY2-OE clears eATP rapidly, mitigating growth arrest (-6.3 mm)
impedance_deltas <- c(
  "Col-0" = -14.30,
  "dorn1-1" = -8.00,
  "fer-4" = -5.90,
  "rbohD" = -5.80,
  "APY2-OE" = -6.30
)

block_effects <- rnorm(6, mean = 0, sd = 0.85)
names(block_effects) <- blocks

records <- list()
idx <- 1

for (b in blocks) {
  b_eff <- block_effects[b]
  for (g in genotypes) {
    for (tr in treatments) {
      true_mu <- base_means[g] + (if (tr == "Impedance") impedance_deltas[g] else 0) + b_eff
      for (r in 1:reps_per_cell) {
        # Measurement error sd = 1.65 mm
        y <- rnorm(1, mean = true_mu, sd = 1.65)
        records[[idx]] <- data.frame(
          Seedling_ID = sprintf("SDL_%03d", idx),
          Block = b,
          Genotype = g,
          Treatment = tr,
          Root_Length_mm = round(y, 3),
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
df$Treatment <- factor(df$Treatment, levels = treatments)

# Save raw dataset
csv_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/data/raw/root_impedance_trial_data.csv"
write.csv(df, csv_path, row.names = FALSE)
cat(sprintf("Saved raw data to %s (N = %d)\n", csv_path, nrow(df)))

# --- STAGE 2 & 3: Experimental Design, Blocking, and Hierarchy ---
# Design: RCBD factorial. Block is random error stratum capturing spatial/batch effects.
# Unconditional ICC calculation:
null_lmm <- lmer(Root_Length_mm ~ 1 + (1 | Block), data = df)
vc_null <- as.data.frame(VarCorr(null_lmm))
var_b_null <- vc_null[vc_null$grp == "Block", "vcov"]
var_e_null <- vc_null[vc_null$grp == "Residual", "vcov"]
icc_uncond <- var_b_null / (var_b_null + var_e_null)
cat(sprintf("Unconditional Block ICC: %.4f\n", icc_uncond))

# --- STAGE 4 & 5: Candidate Model Formulation & Fit (REML) ---
# Linear Mixed-Effects Model with Kenward-Roger degrees of freedom
fit_lmm <- lmer(Root_Length_mm ~ Genotype * Treatment + (1 | Block), data = df, REML = TRUE)
cat("\n--- LMM SUMMARY ---\n")
print(summary(fit_lmm))

# Variance components
vc <- as.data.frame(VarCorr(fit_lmm))
var_block <- vc[vc$grp == "Block", "vcov"]
var_resid <- vc[vc$grp == "Residual", "vcov"]
sd_block <- vc[vc$grp == "Block", "sdcor"]
sd_resid <- vc[vc$grp == "Residual", "sdcor"]
icc_cond <- var_block / (var_block + var_resid)

# --- STAGE 6: Diagnostics (Collective Evaluation) ---
resids <- residuals(fit_lmm)
fitted_vals <- fitted(fit_lmm)
std_resids <- (resids - mean(resids)) / sd(resids)

shapiro_res <- shapiro.test(resids)
cat(sprintf("\nShapiro-Wilk test on residuals: W = %.4f, p = %.4f\n", shapiro_res$statistic, shapiro_res$p.value))

# Random effects BLUP normality
blups <- ranef(fit_lmm)$Block$`(Intercept)`
shapiro_blup <- shapiro.test(blups)

# --- STAGE 7: Sensitivity Analysis ---
# OLS model ignoring blocking
fit_ols <- lm(Root_Length_mm ~ Genotype * Treatment, data = df)
# Fixed-effects Block model
fit_fixed_block <- lm(Root_Length_mm ~ Genotype * Treatment + Block, data = df)

# Model comparison metrics
aic_lmm <- AIC(fit_lmm)
bic_lmm <- BIC(fit_lmm)
aic_ols <- AIC(fit_ols)

# --- STAGE 8: Calibrated Inference with Kenward-Roger and emmeans ---
kr_anova <- anova(fit_lmm, ddf = "Kenward-Roger")
cat("\n--- KENWARD-ROGER ANOVA ---\n")
print(kr_anova)

f_genotype <- round(as.numeric(kr_anova["Genotype", "F value"]), 2)
p_genotype <- as.numeric(kr_anova["Genotype", "Pr(>F)"])
f_treatment <- round(as.numeric(kr_anova["Treatment", "F value"]), 2)
p_treatment <- as.numeric(kr_anova["Treatment", "Pr(>F)"])
f_interaction <- round(as.numeric(kr_anova["Genotype:Treatment", "F value"]), 2)
p_interaction <- as.numeric(kr_anova["Genotype:Treatment", "Pr(>F)"])

num_df_gen <- kr_anova["Genotype", "NumDF"]
den_df_gen <- round(kr_anova["Genotype", "DenDF"], 2)
num_df_trt <- kr_anova["Treatment", "NumDF"]
den_df_trt <- round(kr_anova["Treatment", "DenDF"], 2)
num_df_int <- kr_anova["Genotype:Treatment", "NumDF"]
den_df_int <- round(kr_anova["Genotype:Treatment", "DenDF"], 2)

# Marginal means
emm_cell <- emmeans(fit_lmm, ~ Genotype * Treatment)
emm_df <- as.data.frame(emm_cell)

# Simple effects: Treatment effect within each genotype
trt_contrasts <- contrast(emm_cell, "pairwise", by = "Genotype")
trt_df <- as.data.frame(trt_contrasts)

# Interaction contrasts: Comparing treatment effect relative to Col-0
int_contrasts <- contrast(contrast(emm_cell, "pairwise", by = "Genotype"), "trt.vs.ctrl", by = NULL)
int_df <- as.data.frame(int_contrasts)

# Extract specific cell means
get_cell_mean <- function(g, tr) {
  round(emm_df[emm_df$Genotype == g & emm_df$Treatment == tr, "emmean"], 2)
}

col0_ctrl <- get_cell_mean("Col-0", "Control")
col0_imp <- get_cell_mean("Col-0", "Impedance")
dorn1_ctrl <- get_cell_mean("dorn1-1", "Control")
dorn1_imp <- get_cell_mean("dorn1-1", "Impedance")
fer4_ctrl <- get_cell_mean("fer-4", "Control")
fer4_imp <- get_cell_mean("fer-4", "Impedance")
rbohD_ctrl <- get_cell_mean("rbohD", "Control")
rbohD_imp <- get_cell_mean("rbohD", "Impedance")
apy2oe_ctrl <- get_cell_mean("APY2-OE", "Control")
apy2oe_imp <- get_cell_mean("APY2-OE", "Impedance")

# Percentage reductions
col0_red_pct <- round((col0_ctrl - col0_imp) / col0_ctrl * 100, 2)
dorn1_red_pct <- round((dorn1_ctrl - dorn1_imp) / dorn1_ctrl * 100, 2)
fer4_red_pct <- round((fer4_ctrl - fer4_imp) / fer4_ctrl * 100, 2)
rbohD_red_pct <- round((rbohD_ctrl - rbohD_imp) / rbohD_ctrl * 100, 2)
apy2oe_red_pct <- round((apy2oe_ctrl - apy2oe_imp) / apy2oe_ctrl * 100, 2)

cat(sprintf("\nPercentage reductions under impedance:\nCol-0: %.2f%%\ndorn1-1: %.2f%%\nfer-4: %.2f%%\nrbohD: %.2f%%\nAPY2-OE: %.2f%%\n",
            col0_red_pct, dorn1_red_pct, fer4_red_pct, rbohD_red_pct, apy2oe_red_pct))

# --- PLOTS ---
# Plot 1: Interaction Plot
p1 <- ggplot(emm_df, aes(x = Genotype, y = emmean, color = Treatment, group = Treatment)) +
  geom_line(position = position_dodge(0.3), linewidth = 1) +
  geom_point(position = position_dodge(0.3), size = 3) +
  geom_errorbar(aes(ymin = lower.CL, ymax = upper.CL), position = position_dodge(0.3), width = 0.2) +
  theme_bw(base_size = 12) +
  labs(
    title = "Primary Root Elongation Under Mechanical Impedance",
    subtitle = "Linear Mixed Model Marginal Means (95% CI) across Arabidopsis Genotypes",
    x = "Genotype",
    y = "Primary Root Length (mm)",
    color = "Regime"
  ) +
  theme(legend.position = "top", plot.title = element_text(face = "bold"))

ggsave("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/figures/figure1_root_impedance_interaction.png", p1, width = 7, height = 5, dpi = 300)

# Plot 2: Diagnostics (Residuals vs Fitted & Q-Q)
png("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/figures/figure2_model_diagnostics.png", width = 2100, height = 1050, res = 300)
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))
plot(fitted_vals, resids, xlab = "Fitted Values (mm)", ylab = "Residuals (mm)",
     main = "Residuals vs Fitted", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.6))
abline(h = 0, lty = 2, col = "red", lwd = 1.5)
qqnorm(std_resids, main = "Normal Q-Q Plot", pch = 16, col = rgb(0.2, 0.4, 0.8, 0.6))
qqline(std_resids, col = "red", lwd = 1.5)
dev.off()

# --- EXPORT NUMERICAL RESULTS ---
results <- list(
  n_total = as.integer(nrow(df)),
  n_blocks = as.integer(length(blocks)),
  n_genotypes = as.integer(length(genotypes)),
  reps_per_condition = as.integer(reps_per_cell * length(blocks)),
  
  # Cell marginal means
  col0_control_mean = col0_ctrl,
  col0_impedance_mean = col0_imp,
  dorn1_control_mean = dorn1_ctrl,
  dorn1_impedance_mean = dorn1_imp,
  fer4_control_mean = fer4_ctrl,
  fer4_impedance_mean = fer4_imp,
  rbohD_control_mean = rbohD_ctrl,
  rbohD_impedance_mean = rbohD_imp,
  apy2oe_control_mean = apy2oe_ctrl,
  apy2oe_impedance_mean = apy2oe_imp,
  
  # Percent reductions
  col0_impedance_reduction_pct = col0_red_pct,
  dorn1_impedance_reduction_pct = dorn1_red_pct,
  fer4_impedance_reduction_pct = fer4_red_pct,
  rbohD_impedance_reduction_pct = rbohD_red_pct,
  apy2oe_impedance_reduction_pct = apy2oe_red_pct,
  
  # Variance components
  variance_block = round(var_block, 4),
  variance_residual = round(var_resid, 4),
  sd_block = round(sd_block, 4),
  sd_residual = round(sd_resid, 4),
  icc_block = round(icc_cond, 4),
  
  # Kenward-Roger ANOVA statistics
  f_stat_genotype = f_genotype,
  p_val_genotype = p_genotype,
  num_df_genotype = as.integer(num_df_gen),
  den_df_genotype = den_df_gen,
  
  f_stat_treatment = f_treatment,
  p_val_treatment = p_treatment,
  num_df_treatment = as.integer(num_df_trt),
  den_df_treatment = den_df_trt,
  
  f_stat_interaction = f_interaction,
  p_val_interaction = p_interaction,
  num_df_interaction = as.integer(num_df_int),
  den_df_interaction = den_df_int,
  
  # Model diagnostics
  shapiro_w_statistic = round(as.numeric(shapiro_res$statistic), 4),
  shapiro_p_value = round(as.numeric(shapiro_res$p.value), 4)
)

json_out_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/analysis/results/root_impedance_lmm_results.json"
write_json(results, json_out_path, auto_unbox = TRUE, pretty = TRUE)
cat(sprintf("\nExported complete numerical results to %s\n", json_out_path))
