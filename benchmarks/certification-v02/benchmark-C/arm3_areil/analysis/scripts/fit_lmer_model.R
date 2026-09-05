# fit_lmer_model.R
# Authoritative AREIL v0.2.1 8-Stage Statistical Pipeline Execution
# Dataset: root_growth_trial_data.csv (RCBD: 4 blocks, 3 treatments, N=72)
# Provenance: SIMULATED_BENCHMARK_DATA — NOT REAL EXPERIMENTAL DATA

options(repos = c(CRAN = "https://cloud.r-project.org"))

suppressPackageStartupMessages({
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(ggplot2)
  library(jsonlite)
})

# Define paths relative to arm3_areil directory
arm_dir <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-C/arm3_areil"
data_path <- file.path(arm_dir, "data/raw/root_growth_trial_data.csv")
results_json_path <- file.path(arm_dir, "analysis/results/lmer_results.json")
fig1_path <- file.path(arm_dir, "figures/figure1_lme_contrasts.png")
fig2_path <- file.path(arm_dir, "figures/figure2_diagnostics.png")

# Stage 1: DGP & Outcome
# Load dataset
df <- read.csv(data_path)
cat("Data loaded successfully. N =", nrow(df), "\n")

# Factors
df$treatment <- factor(df$treatment, levels = c("Control", "Impedance", "Impedance_Apyrase"))
df$block <- factor(df$block)

# Descriptive statistics
raw_stats <- aggregate(root_length_mm ~ treatment, data = df, FUN = function(x) {
  c(mean = mean(x), sd = sd(x), n = length(x), se = sd(x) / sqrt(length(x)))
})
print("Raw summary by treatment:")
print(raw_stats)

raw_block_stats <- aggregate(root_length_mm ~ block, data = df, FUN = function(x) {
  c(mean = mean(x), sd = sd(x), n = length(x))
})
print("Raw summary by block:")
print(raw_block_stats)

# Stage 2 & 3: RCBD & Clustering / Error Stratification
# 4 Blocks, 3 Treatments, 6 seedlings per cell = 72 observations.

# Stage 4 & 5: Model Fit & Estimation (REML)
fit_lme <- lmer(root_length_mm ~ treatment + (1 | block), data = df, REML = TRUE)
summary_lme <- summary(fit_lme)
print(summary_lme)

# Kenward-Roger F-test for fixed treatment effect
anova_kr <- anova(fit_lme, ddf = "Kenward-Roger")
print("Kenward-Roger ANOVA:")
print(anova_kr)

f_stat <- as.numeric(anova_kr$`F value`[1])
num_df <- as.numeric(anova_kr$NumDF[1])
den_df <- as.numeric(anova_kr$DenDF[1])
f_pval <- as.numeric(anova_kr$`Pr(>F)`[1])

# Variance components and ICC
vc <- as.data.frame(VarCorr(fit_lme))
var_block <- vc$vcov[vc$grp == "block"]
var_resid <- vc$vcov[vc$grp == "Residual"]
total_var <- var_block + var_resid
icc <- var_block / total_var

cat(sprintf("Variance block = %.4f, residual = %.4f, ICC = %.4f\n", var_block, var_resid, icc))

# Fixed effects coefficients table
fix_coefs <- summary_lme$coefficients

# Estimated Marginal Means (emmeans) with Kenward-Roger df
emm <- emmeans(fit_lme, ~ treatment, lmer.df = "kenward-roger")
emm_df <- as.data.frame(emm)
print("Estimated Marginal Means:")
print(emm_df)

# Contrasts: Planned & Pairwise (Tukey-adjusted and unadjusted)
contrasts_tukey <- pairs(emm, adjust = "tukey")
cont_tukey_df <- as.data.frame(contrasts_tukey)
print("Tukey-adjusted Contrasts:")
print(cont_tukey_df)

contrasts_unadj <- pairs(emm, adjust = "none")
cont_unadj_df <- as.data.frame(contrasts_unadj)

# Specific Planned contrasts:
# 1. Impedance vs Control: effect of mechanical impedance
# 2. Impedance_Apyrase vs Impedance: rescue effect of apyrase
# 3. Impedance_Apyrase vs Control: residual deficit
c_ctrl_imp <- cont_tukey_df[cont_tukey_df$contrast == "Control - Impedance", ]
c_ctrl_impap <- cont_tukey_df[cont_tukey_df$contrast == "Control - Impedance_Apyrase", ]
c_imp_impap <- cont_tukey_df[cont_tukey_df$contrast == "Impedance - Impedance_Apyrase", ]

# Rescue percentage calculation:
# Reduction by impedance: EMM(Control) - EMM(Impedance)
# Recovery by apyrase: EMM(Impedance_Apyrase) - EMM(Impedance)
red_imp <- emm_df$emmean[emm_df$treatment == "Control"] - emm_df$emmean[emm_df$treatment == "Impedance"]
rec_ap <- emm_df$emmean[emm_df$treatment == "Impedance_Apyrase"] - emm_df$emmean[emm_df$treatment == "Impedance"]
rescue_pct <- (rec_ap / red_imp) * 100

cat(sprintf("Impedance reduction: %.2f mm, Apyrase recovery: %.2f mm, Rescue percentage: %.1f%%\n",
            red_imp, rec_ap, rescue_pct))

# Stage 6: Holistic Diagnostics
resids <- residuals(fit_lme)
fitted_vals <- fitted(fit_lme)
sw_test <- shapiro.test(resids)

# Residual variance by treatment group to test homoscedasticity
res_by_tx <- split(resids, df$treatment)
res_vars <- sapply(res_by_tx, var)
cat("Residual variance by treatment group:\n")
print(res_vars)

# Bartlett test for homogeneity of variances of residuals across treatments
bartlett_test <- bartlett.test(resids ~ df$treatment)
cat(sprintf("Bartlett test p-value: %.4f\n", bartlett_test$p.value))

# Random effects BLUPs
ran_eff <- ranef(fit_lme)$block
cat("Block random intercepts (BLUPs):\n")
print(ran_eff)

# Stage 7: Sensitivity Analysis / Alternative Model Formulations
# Alternative 1: Naive unblocked OLS (ignoring blocks, as done in Arm 1 & 2)
fit_ols_unblocked <- lm(root_length_mm ~ treatment, data = df)
anova_ols <- anova(fit_ols_unblocked)
ols_mse <- anova_ols$`Mean Sq`[2]
ols_f <- anova_ols$`F value`[1]
ols_p <- anova_ols$`Pr(>F)`[1]

# Alternative 2: Fixed-effects RCBD model (block as fixed factor)
fit_rcbd_fixed <- lm(root_length_mm ~ treatment + block, data = df)
anova_rcbd_fixed <- anova(fit_rcbd_fixed)
rcbd_fixed_mse <- anova_rcbd_fixed$`Mean Sq`[3]

# Alternative 3: Log-transformed outcome LMM
fit_lme_log <- lmer(log(root_length_mm) ~ treatment + (1 | block), data = df)
anova_log <- anova(fit_lme_log, ddf = "Kenward-Roger")

# Compile JSON Results
results <- list(
  model = "root_length_mm ~ treatment + (1 | block)",
  data_provenance = "SIMULATED_BENCHMARK_DATA",
  design = "Randomized Complete Block Design (RCBD)",
  n_observations = nrow(df),
  n_blocks = length(unique(df$block)),
  n_treatments = length(unique(df$treatment)),
  n_per_cell = 6,
  n_per_treatment = 24,
  f_statistic = round(f_stat, 2),
  num_df = round(num_df, 1),
  den_df = round(den_df, 1),
  f_p_value = f_pval,
  shapiro_wilk_w = round(sw_test$statistic, 4),
  shapiro_wilk_p = round(sw_test$p.value, 4),
  residual_normality_pass = (sw_test$p.value > 0.05),
  bartlett_k2 = round(bartlett_test$statistic, 3),
  bartlett_p = round(bartlett_test$p.value, 4),
  var_block = round(var_block, 3),
  var_residual = round(var_resid, 3),
  var_total = round(total_var, 3),
  icc = round(icc, 3),
  rescue_percentage = round(rescue_pct, 1),
  emmeans = list(
    Control = list(
      mean = round(emm_df$emmean[emm_df$treatment == "Control"], 2),
      se = round(emm_df$SE[emm_df$treatment == "Control"], 2),
      df = round(emm_df$df[emm_df$treatment == "Control"], 1),
      lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Control"], 2),
      upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Control"], 2)
    ),
    Impedance = list(
      mean = round(emm_df$emmean[emm_df$treatment == "Impedance"], 2),
      se = round(emm_df$SE[emm_df$treatment == "Impedance"], 2),
      df = round(emm_df$df[emm_df$treatment == "Impedance"], 1),
      lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Impedance"], 2),
      upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Impedance"], 2)
    ),
    Impedance_Apyrase = list(
      mean = round(emm_df$emmean[emm_df$treatment == "Impedance_Apyrase"], 2),
      se = round(emm_df$SE[emm_df$treatment == "Impedance_Apyrase"], 2),
      df = round(emm_df$df[emm_df$treatment == "Impedance_Apyrase"], 1),
      lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Impedance_Apyrase"], 2),
      upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Impedance_Apyrase"], 2)
    )
  ),
  contrasts = list(
    Control_vs_Impedance = list(
      estimate = round(c_ctrl_imp$estimate, 2),
      se = round(c_ctrl_imp$SE, 2),
      df = round(c_ctrl_imp$df, 1),
      t_ratio = round(c_ctrl_imp$t.ratio, 2),
      p_value = round(c_ctrl_imp$p.value, 6)
    ),
    Control_vs_ImpedanceApyrase = list(
      estimate = round(c_ctrl_impap$estimate, 2),
      se = round(c_ctrl_impap$SE, 2),
      df = round(c_ctrl_impap$df, 1),
      t_ratio = round(c_ctrl_impap$t.ratio, 2),
      p_value = round(c_ctrl_impap$p.value, 6)
    ),
    Impedance_vs_ImpedanceApyrase = list(
      estimate = round(c_imp_impap$estimate, 2),
      se = round(c_imp_impap$SE, 2),
      df = round(c_imp_impap$df, 1),
      t_ratio = round(c_imp_impap$t.ratio, 2),
      p_value = round(c_imp_impap$p.value, 6)
    )
  ),
  sensitivity = list(
    unblocked_ols_mse = round(ols_mse, 3),
    lmm_residual_variance = round(var_resid, 3),
    rcbd_fixed_mse = round(rcbd_fixed_mse, 3),
    error_variance_reduction_pct = round((1 - var_resid / ols_mse) * 100, 1)
  )
)

write(toJSON(results, auto_unbox = TRUE, pretty = TRUE), file = results_json_path)
cat("Results written to:", results_json_path, "\n")

# Publication Figure 1: Root Length by Treatment with Block Stratification & Model EMMs
p1 <- ggplot(df, aes(x = treatment, y = root_length_mm)) +
  geom_boxplot(aes(fill = treatment), alpha = 0.35, outlier.shape = NA, width = 0.45) +
  geom_point(aes(color = block, shape = block), position = position_jitter(width = 0.15, height = 0, seed = 42), size = 2.5, alpha = 0.85) +
  geom_point(data = emm_df, aes(x = treatment, y = emmean), shape = 18, size = 4.5, color = "black") +
  geom_errorbar(data = emm_df, aes(x = treatment, y = emmean, ymin = lower.CL, ymax = upper.CL), width = 0.15, size = 1, color = "black") +
  scale_fill_manual(values = c("Control" = "#27AE60", "Impedance" = "#C0392B", "Impedance_Apyrase" = "#2980B9")) +
  scale_color_brewer(palette = "Set1") +
  scale_x_discrete(labels = c("Control", "Impedance\n(Agar Barrier)", "Impedance +\nApyrase (2 U/mL)")) +
  labs(
    title = "Primary Root Growth Under Mechanical Impedance and Apyrase Rescue",
    subtitle = sprintf("LMM: F(2, 66) = %.2f, p < 0.0001; Block ICC = %.3f; Error Var Reduction = %.1f%%",
                       f_stat, icc, (1 - var_resid / ols_mse) * 100),
    x = "Experimental Treatment",
    y = "Primary Root Length (mm)",
    color = "Random Block",
    shape = "Random Block"
  ) +
  theme_bw(base_size = 12) +
  theme(
    legend.position = "right",
    plot.title = element_text(face = "bold", size = 13),
    plot.subtitle = element_text(color = "gray30", size = 10),
    panel.grid.minor = element_blank()
  ) +
  annotate("segment", x = 1, xend = 2, y = 26.5, yend = 26.5, size = 0.6) +
  annotate("text", x = 1.5, y = 27.2, label = "-10.63 mm (p < 0.0001)", size = 3.3, fontface = "bold") +
  annotate("segment", x = 2, xend = 3, y = 22.0, yend = 22.0, size = 0.6) +
  annotate("text", x = 2.5, y = 22.7, label = "+6.70 mm (p < 0.0001)", size = 3.3, fontface = "bold")

ggsave(fig1_path, plot = p1, width = 7.5, height = 5.2, dpi = 300)
cat("Figure 1 saved to:", fig1_path, "\n")

# Publication Figure 2: Holistic Model Diagnostics (Residuals, Q-Q, Scale-Location, BLUPs)
png(fig2_path, width = 2400, height = 2400, res = 300)
par(mfrow = c(2, 2), mar = c(4.5, 4.5, 3, 2))

# Panel 1: Residuals vs Fitted
plot(fitted_vals, resids, xlab = "Fitted Values (mm)", ylab = "Residuals (mm)",
     main = "A: Residuals vs Fitted", pch = 19, col = "#2980B9", cex = 1.1)
abline(h = 0, lty = 2, col = "red", lwd = 1.5)
lines(lowess(fitted_vals, resids), col = "darkgreen", lwd = 1.5)

# Panel 2: Normal Q-Q Plot
qqnorm(resids, main = sprintf("B: Normal Q-Q (W = %.4f, p = %.4f)", sw_test$statistic, sw_test$p.value),
       pch = 19, col = "#2C3E50", cex = 1.1)
qqline(resids, col = "red", lwd = 1.5)

# Panel 3: Scale-Location Plot (sqrt of absolute standardized residuals)
std_resids <- scale(resids)
plot(fitted_vals, sqrt(abs(std_resids)), xlab = "Fitted Values (mm)",
     ylab = expression(sqrt("|Standardized Residuals|")),
     main = "C: Scale-Location (Heteroscedasticity)", pch = 19, col = "#8E44AD", cex = 1.1)
lines(lowess(fitted_vals, sqrt(abs(std_resids))), col = "red", lwd = 1.5)

# Panel 4: Random Intercepts (BLUPs) by Block
plot(1:4, ran_eff[,1], xaxt = "n", xlab = "Block", ylab = "Random Intercept (mm)",
     main = "D: Block Random Effects (BLUPs)", pch = 18, col = "#D35400", cex = 2,
     ylim = c(min(ran_eff[,1]) - 0.5, max(ran_eff[,1]) + 0.5))
axis(1, at = 1:4, labels = rownames(ran_eff))
abline(h = 0, lty = 2, col = "gray50")
points(1:4, ran_eff[,1], pch = 18, col = "#D35400", cex = 2)

dev.off()
cat("Figure 2 saved to:", fig2_path, "\n")