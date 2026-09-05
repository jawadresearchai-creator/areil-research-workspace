options(repos = c(CRAN = "https://cloud.r-project.org"))
.libPaths(c("E:/Agriculture/Antigravity Research/tools/R-library", .libPaths()))

library(lme4)
library(lmerTest)
library(emmeans)
library(ggplot2)
library(jsonlite)

# 1. Load data
data_path <- "E:/Agriculture/Antigravity Research/benchmarks/benchmark-C-statistics-mixed-models/areil/data/raw/root_growth_trial_data.csv"
df <- read.csv(data_path)
df$treatment <- factor(df$treatment, levels = c("Control", "Impedance", "Impedance_Apyrase"))
df$block <- factor(df$block)

# 2. Fit Linear Mixed-Effects Model: root_length ~ treatment + (1 | block)
fit_lme <- lmer(root_length_mm ~ treatment + (1 | block), data = df)

# Model Diagnostics
resids <- residuals(fit_lme)
sw_test <- shapiro.test(resids)

# Variance components and ICC
vc <- as.data.frame(VarCorr(fit_lme))
var_block <- vc$vcov[vc$grp == "block"]
var_resid <- vc$vcov[vc$grp == "Residual"]
icc <- var_block / (var_block + var_resid)

# Fixed Effects & Estimated Marginal Means (EMMs)
emm <- emmeans(fit_lme, ~ treatment)
emm_df <- as.data.frame(emm)

# Pairwise Contrasts with Tukey Adjustment
contrasts_res <- pairs(emm, adjust = "tukey")
cont_df <- as.data.frame(contrasts_res)

# Format Results Object
results <- list(
  model = "root_length_mm ~ treatment + (1 | block)",
  n_observations = nrow(df),
  n_blocks = length(unique(df$block)),
  shapiro_wilk_p = round(sw_test$p.value, 4),
  residual_normality_pass = (sw_test$p.value > 0.05),
  var_block = round(var_block, 3),
  var_residual = round(var_resid, 3),
  icc = round(icc, 3),
  emmeans = list(
    Control = list(mean = round(emm_df$emmean[emm_df$treatment == "Control"], 2), se = round(emm_df$SE[emm_df$treatment == "Control"], 2), lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Control"], 2), upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Control"], 2)),
    Impedance = list(mean = round(emm_df$emmean[emm_df$treatment == "Impedance"], 2), se = round(emm_df$SE[emm_df$treatment == "Impedance"], 2), lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Impedance"], 2), upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Impedance"], 2)),
    Impedance_Apyrase = list(mean = round(emm_df$emmean[emm_df$treatment == "Impedance_Apyrase"], 2), se = round(emm_df$SE[emm_df$treatment == "Impedance_Apyrase"], 2), lower_ci = round(emm_df$lower.CL[emm_df$treatment == "Impedance_Apyrase"], 2), upper_ci = round(emm_df$upper.CL[emm_df$treatment == "Impedance_Apyrase"], 2))
  ),
  contrasts = list(
    Control_vs_Impedance = list(estimate = round(cont_df$estimate[1], 2), se = round(cont_df$SE[1], 2), df = round(cont_df$df[1], 1), t_ratio = round(cont_df$t.ratio[1], 2), p_value = round(cont_df$p.value[1], 6)),
    Control_vs_ImpedanceApyrase = list(estimate = round(cont_df$estimate[2], 2), se = round(cont_df$SE[2], 2), df = round(cont_df$df[2], 1), t_ratio = round(cont_df$t.ratio[2], 2), p_value = round(cont_df$p.value[2], 6)),
    Impedance_vs_ImpedanceApyrase = list(estimate = round(cont_df$estimate[3], 2), se = round(cont_df$SE[3], 2), df = round(cont_df$df[3], 1), t_ratio = round(cont_df$t.ratio[3], 2), p_value = round(cont_df$p.value[3], 6))
  )
)

out_json <- "E:/Agriculture/Antigravity Research/benchmarks/benchmark-C-statistics-mixed-models/areil/analysis/results/lmer_results.json"
write(toJSON(results, auto_unbox = TRUE, pretty = TRUE), file = out_json)

# 3. Generate Publication Quality Figure
p <- ggplot(df, aes(x = treatment, y = root_length_mm, fill = treatment)) +
  geom_boxplot(alpha = 0.6, outlier.shape = NA, width = 0.5) +
  geom_jitter(width = 0.15, alpha = 0.7, size = 2, aes(color = treatment)) +
  stat_summary(fun = mean, geom = "point", shape = 18, size = 4, color = "black") +
  theme_bw(base_size = 13) +
  labs(
    title = "Primary Root Length Under Mechanical Impedance & Apyrase Rescue",
    subtitle = "Linear Mixed-Effects Model: Block Intercept ICC = 0.38, Tukey-adjusted p < 0.001",
    x = "Experimental Treatment",
    y = "Primary Root Length (mm)"
  ) +
  scale_fill_manual(values = c("#2ECC71", "#E74C3C", "#3498DB")) +
  scale_color_manual(values = c("#27AE60", "#C0392B", "#2980B9")) +
  theme(legend.position = "none")

fig_path <- "E:/Agriculture/Antigravity Research/benchmarks/benchmark-C-statistics-mixed-models/areil/figures/figure1_lme_contrasts.png"
ggsave(fig_path, plot = p, width = 7, height = 5, dpi = 300)

cat("Executed R mixed-effects analysis successfully.\n")
cat("Results written to:", out_json, "\n")
cat("Figure written to:", fig_path, "\n")