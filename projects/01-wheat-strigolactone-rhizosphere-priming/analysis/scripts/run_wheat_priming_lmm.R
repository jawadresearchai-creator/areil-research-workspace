#!/usr/bin/env Rscript
# run_wheat_priming_lmm.R: AREIL 8-Stage Holistic Statistical Modeling Pipeline
# Evaluates AM colonization, TaPT4 expression, and shoot P across factorial rhizobox microcosms.

suppressPackageStartupMessages({
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(pbkrtest)
  library(ggplot2)
  library(jsonlite)
})

cat("=== AREIL 8-STAGE STATISTICAL MODELING PIPELINE ===\n")
cat("Stage 1: Outcome & DGP Identification\n")
cat("Stage 2: Design Structure: 4-Block Factorial RCBD\n")
cat("Stage 3: Clustering & Error Stratification\n")
cat("Stage 4: Model Formulation\n\n")

data_path <- "E:/Agriculture/Antigravity Research/projects/01-wheat-strigolactone-rhizosphere-priming/raw/wheat_strigolactone_priming_trial.csv"
results_dir <- "E:/Agriculture/Antigravity Research/projects/01-wheat-strigolactone-rhizosphere-priming/analysis/results"
figures_dir <- "E:/Agriculture/Antigravity Research/projects/01-wheat-strigolactone-rhizosphere-priming/manuscript/figures"
tables_dir  <- "E:/Agriculture/Antigravity Research/projects/01-wheat-strigolactone-rhizosphere-priming/manuscript/tables"

dir.create(results_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(figures_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(tables_dir, recursive = TRUE, showWarnings = FALSE)

# Read data (skipping comment lines)
df <- read.csv(data_path, comment.char = "#")
cat(sprintf("Loaded %d observations across %d experimental blocks.\n", nrow(df), length(unique(df$block))))

# Convert factors
df$block <- factor(df$block)
df$donor_regime <- factor(df$donor_regime, levels = c("P_Replete", "P_Starved", "P_Starved_Tis108"))
df$barrier_mode <- factor(df$barrier_mode, levels = c("M0_Solid", "M1_Membrane", "M2_Mesh"))
df$recipient_genotype <- factor(df$recipient_genotype, levels = c("WT", "Tad14_mutant"))

# Stage 5: Fit Linear Mixed Models via REML
cat("\nStage 5: Fitting Linear Mixed-Effects Models via REML...\n")

# Model 1: AM Colonization %
lmm_am <- lmer(am_colonization_pct ~ donor_regime * barrier_mode * recipient_genotype + (1 | block), data = df, REML = TRUE)
anova_am <- anova(lmm_am, type = 3, ddf = "Kenward-Roger")
cat("\n--- Type III ANOVA (Kenward-Roger): AM Colonization % ---\n")
print(anova_am)

# Model 2: TaPT4 Relative Expression
lmm_pt4 <- lmer(tapt4_relative_expression ~ donor_regime * barrier_mode * recipient_genotype + (1 | block), data = df, REML = TRUE)
anova_pt4 <- anova(lmm_pt4, type = 3, ddf = "Kenward-Roger")
cat("\n--- Type III ANOVA (Kenward-Roger): TaPT4 Relative Expression ---\n")
print(anova_pt4)

# Model 3: Shoot Phosphorus (mg/g)
lmm_p <- lmer(shoot_phosphorus_mg_g ~ donor_regime * barrier_mode * recipient_genotype + (1 | block), data = df, REML = TRUE)
anova_p <- anova(lmm_p, type = 3, ddf = "Kenward-Roger")
cat("\n--- Type III ANOVA (Kenward-Roger): Shoot Phosphorus Concentration ---\n")
print(anova_p)

# Stage 6: Holistic Model Diagnostics
cat("\nStage 6: Holistic Diagnostics...\n")
res_am <- residuals(lmm_am)
shapiro_am <- shapiro.test(res_am)
cat(sprintf("AM Colonization Model Residuals Shapiro-Wilk: W = %.4f, p = %.4f\n", shapiro_am$statistic, shapiro_am$p.value))

var_comp <- as.data.frame(VarCorr(lmm_am))
block_var <- var_comp$vcov[var_comp$grp == "block"]
resid_var <- var_comp$vcov[var_comp$grp == "Residual"]
icc <- block_var / (block_var + resid_var)
cat(sprintf("Variance components: Block = %.4f, Residual = %.4f, ICC = %.4f\n", block_var, resid_var, icc))

# Stage 7: Sensitivity & Model Comparison (Blocked LMM vs Unblocked OLS)
cat("\nStage 7: Sensitivity & Model Comparison...\n")
ols_am <- lm(am_colonization_pct ~ donor_regime * barrier_mode * recipient_genotype, data = df)
aic_lmm <- AIC(lmm_am)
aic_ols <- AIC(ols_am)
cat(sprintf("Model Selection: LMM AIC = %.2f vs OLS AIC = %.2f (Delta AIC = %.2f)\n", aic_lmm, aic_ols, aic_ols - aic_lmm))

# Stage 8: Calibrated Inference & Planned Contrasts
cat("\nStage 8: Calibrated Inference with Planned Contrasts (emmeans)...\n")
emm_am <- emmeans(lmm_am, ~ donor_regime * barrier_mode * recipient_genotype)
emm_df <- as.data.frame(emm_am)

# Get specific contrast estimates and tests
c_diffusible <- contrast(emm_am, list("Diffusible_Priming" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Replete" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", -1, 0)
)))
c_hyphal <- contrast(emm_am, list("Hyphal_Amplification" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M2_Mesh" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", -1, 0)
)))
c_tis108 <- contrast(emm_am, list("Tis108_Abolition" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Starved_Tis108" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", -1, 0)
)))
c_receptor_m1 <- contrast(emm_am, list("Receptor_Dependency_M1" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "Tad14_mutant", -1, 0)
)))
c_receptor_m2 <- contrast(emm_am, list("Receptor_Dependency_M2" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M2_Mesh" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M2_Mesh" & emm_df$recipient_genotype == "Tad14_mutant", -1, 0)
)))
c_hermetic <- contrast(emm_am, list("Barrier_Hermeticity" = ifelse(
  emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M0_Solid" & emm_df$recipient_genotype == "WT", 1,
  ifelse(emm_df$donor_regime == "P_Replete" & emm_df$barrier_mode == "M0_Solid" & emm_df$recipient_genotype == "WT", -1, 0)
)))

planned_contrasts_res <- rbind(
  as.data.frame(c_diffusible),
  as.data.frame(c_hyphal),
  as.data.frame(c_tis108),
  as.data.frame(c_receptor_m1),
  as.data.frame(c_receptor_m2),
  as.data.frame(c_hermetic)
)
cat("\n--- Planned Contrasts Table ---\n")
print(planned_contrasts_res)

# Similar contrasts for TaPT4 and Shoot P
emm_pt4 <- emmeans(lmm_pt4, ~ donor_regime * barrier_mode * recipient_genotype)
emm_pt4_df <- as.data.frame(emm_pt4)
c_pt4_diff <- contrast(emm_pt4, list("TaPT4_Diffusible_Priming" = ifelse(
  emm_pt4_df$donor_regime == "P_Starved" & emm_pt4_df$barrier_mode == "M1_Membrane" & emm_pt4_df$recipient_genotype == "WT", 1,
  ifelse(emm_pt4_df$donor_regime == "P_Replete" & emm_pt4_df$barrier_mode == "M1_Membrane" & emm_pt4_df$recipient_genotype == "WT", -1, 0)
)))
c_pt4_hyph <- contrast(emm_pt4, list("TaPT4_Hyphal_Amplification" = ifelse(
  emm_pt4_df$donor_regime == "P_Starved" & emm_pt4_df$barrier_mode == "M2_Mesh" & emm_pt4_df$recipient_genotype == "WT", 1,
  ifelse(emm_pt4_df$donor_regime == "P_Starved" & emm_pt4_df$barrier_mode == "M1_Membrane" & emm_pt4_df$recipient_genotype == "WT", -1, 0)
)))

emm_p <- emmeans(lmm_p, ~ donor_regime * barrier_mode * recipient_genotype)
emm_p_df <- as.data.frame(emm_p)
c_p_diff <- contrast(emm_p, list("ShootP_Diffusible_Priming" = ifelse(
  emm_p_df$donor_regime == "P_Starved" & emm_p_df$barrier_mode == "M1_Membrane" & emm_p_df$recipient_genotype == "WT", 1,
  ifelse(emm_p_df$donor_regime == "P_Replete" & emm_p_df$barrier_mode == "M1_Membrane" & emm_p_df$recipient_genotype == "WT", -1, 0)
)))

# Package results into clean structured JSON
results_json <- list(
  metadata = list(
    pipeline = "AREIL 8-Stage Holistic Statistical Modeling Pipeline",
    version = "AREIL v0.2.3",
    timestamp = as.character(Sys.time()),
    r_version = R.version.string,
    total_observations = nrow(df),
    blocks = 4,
    replicates_per_cell = 6
  ),
  diagnostics = list(
    shapiro_wilk_w = round(as.numeric(shapiro_am$statistic), 4),
    shapiro_wilk_p = round(as.numeric(shapiro_am$p.value), 4),
    normality_status = ifelse(shapiro_am$p.value > 0.05, "PASS", "DEVIATION_NOTED"),
    block_variance = round(block_var, 4),
    residual_variance = round(resid_var, 4),
    icc = round(icc, 4),
    aic_lmm = round(aic_lmm, 2),
    aic_ols = round(aic_ols, 2),
    delta_aic = round(aic_ols - aic_lmm, 2)
  ),
  anova_am_colonization = list(
    donor_f = round(anova_am["donor_regime", "F value"], 2),
    donor_p = anova_am["donor_regime", "Pr(>F)"],
    barrier_f = round(anova_am["barrier_mode", "F value"], 2),
    barrier_p = anova_am["barrier_mode", "Pr(>F)"],
    genotype_f = round(anova_am["recipient_genotype", "F value"], 2),
    genotype_p = anova_am["recipient_genotype", "Pr(>F)"],
    three_way_interaction_f = round(anova_am["donor_regime:barrier_mode:recipient_genotype", "F value"], 2),
    three_way_interaction_p = anova_am["donor_regime:barrier_mode:recipient_genotype", "Pr(>F)"]
  ),
  anova_tapt4_expression = list(
    donor_f = round(anova_pt4["donor_regime", "F value"], 2),
    donor_p = anova_pt4["donor_regime", "Pr(>F)"],
    barrier_f = round(anova_pt4["barrier_mode", "F value"], 2),
    barrier_p = anova_pt4["barrier_mode", "Pr(>F)"],
    genotype_f = round(anova_pt4["recipient_genotype", "F value"], 2),
    genotype_p = anova_pt4["recipient_genotype", "Pr(>F)"],
    three_way_interaction_f = round(anova_pt4["donor_regime:barrier_mode:recipient_genotype", "F value"], 2),
    three_way_interaction_p = anova_pt4["donor_regime:barrier_mode:recipient_genotype", "Pr(>F)"]
  ),
  anova_shoot_phosphorus = list(
    donor_f = round(anova_p["donor_regime", "F value"], 2),
    donor_p = anova_p["donor_regime", "Pr(>F)"],
    barrier_f = round(anova_p["barrier_mode", "F value"], 2),
    barrier_p = anova_p["barrier_mode", "Pr(>F)"],
    genotype_f = round(anova_p["recipient_genotype", "F value"], 2),
    genotype_p = anova_p["recipient_genotype", "Pr(>F)"],
    three_way_interaction_f = round(anova_p["donor_regime:barrier_mode:recipient_genotype", "F value"], 2),
    three_way_interaction_p = anova_p["donor_regime:barrier_mode:recipient_genotype", "Pr(>F)"]
  ),
  planned_contrasts_am = list(
    diffusible_priming_effect = round(planned_contrasts_res[planned_contrasts_res$contrast == "Diffusible_Priming", "estimate"], 2),
    diffusible_priming_se = round(planned_contrasts_res[planned_contrasts_res$contrast == "Diffusible_Priming", "SE"], 2),
    diffusible_priming_t = round(planned_contrasts_res[planned_contrasts_res$contrast == "Diffusible_Priming", "t.ratio"], 2),
    diffusible_priming_p = planned_contrasts_res[planned_contrasts_res$contrast == "Diffusible_Priming", "p.value"],
    
    hyphal_amplification_effect = round(planned_contrasts_res[planned_contrasts_res$contrast == "Hyphal_Amplification", "estimate"], 2),
    hyphal_amplification_se = round(planned_contrasts_res[planned_contrasts_res$contrast == "Hyphal_Amplification", "SE"], 2),
    hyphal_amplification_t = round(planned_contrasts_res[planned_contrasts_res$contrast == "Hyphal_Amplification", "t.ratio"], 2),
    hyphal_amplification_p = planned_contrasts_res[planned_contrasts_res$contrast == "Hyphal_Amplification", "p.value"],
    
    tis108_abolition_effect = round(planned_contrasts_res[planned_contrasts_res$contrast == "Tis108_Abolition", "estimate"], 2),
    tis108_abolition_se = round(planned_contrasts_res[planned_contrasts_res$contrast == "Tis108_Abolition", "SE"], 2),
    tis108_abolition_t = round(planned_contrasts_res[planned_contrasts_res$contrast == "Tis108_Abolition", "t.ratio"], 2),
    tis108_abolition_p = planned_contrasts_res[planned_contrasts_res$contrast == "Tis108_Abolition", "p.value"],
    
    receptor_dependency_m1_effect = round(planned_contrasts_res[planned_contrasts_res$contrast == "Receptor_Dependency_M1", "estimate"], 2),
    receptor_dependency_m1_se = round(planned_contrasts_res[planned_contrasts_res$contrast == "Receptor_Dependency_M1", "SE"], 2),
    receptor_dependency_m1_t = round(planned_contrasts_res[planned_contrasts_res$contrast == "Receptor_Dependency_M1", "t.ratio"], 2),
    receptor_dependency_m1_p = planned_contrasts_res[planned_contrasts_res$contrast == "Receptor_Dependency_M1", "p.value"],
    
    barrier_hermeticity_effect = round(planned_contrasts_res[planned_contrasts_res$contrast == "Barrier_Hermeticity", "estimate"], 2),
    barrier_hermeticity_se = round(planned_contrasts_res[planned_contrasts_res$contrast == "Barrier_Hermeticity", "SE"], 2),
    barrier_hermeticity_t = round(planned_contrasts_res[planned_contrasts_res$contrast == "Barrier_Hermeticity", "t.ratio"], 2),
    barrier_hermeticity_p = planned_contrasts_res[planned_contrasts_res$contrast == "Barrier_Hermeticity", "p.value"]
  ),
  planned_contrasts_tapt4 = list(
    diffusible_induction_fold = round(as.data.frame(c_pt4_diff)$estimate, 2),
    diffusible_induction_se = round(as.data.frame(c_pt4_diff)$SE, 2),
    diffusible_induction_p = as.data.frame(c_pt4_diff)$p.value,
    hyphal_amplification_fold = round(as.data.frame(c_pt4_hyph)$estimate, 2),
    hyphal_amplification_se = round(as.data.frame(c_pt4_hyph)$SE, 2),
    hyphal_amplification_p = as.data.frame(c_pt4_hyph)$p.value
  ),
  planned_contrasts_shoot_p = list(
    diffusible_p_gain_effect = round(as.data.frame(c_p_diff)$estimate, 2),
    diffusible_p_gain_se = round(as.data.frame(c_p_diff)$SE, 2),
    diffusible_p_gain_p = as.data.frame(c_p_diff)$p.value
  ),
  key_cell_means = list(
    wt_m0_pstarved_am = round(emm_df[emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M0_Solid" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    wt_m0_preplete_am = round(emm_df[emm_df$donor_regime == "P_Replete" & emm_df$barrier_mode == "M0_Solid" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    wt_m1_preplete_am = round(emm_df[emm_df$donor_regime == "P_Replete" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    wt_m1_pstarved_am = round(emm_df[emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    wt_m1_tis108_am   = round(emm_df[emm_df$donor_regime == "P_Starved_Tis108" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    wt_m2_pstarved_am = round(emm_df[emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M2_Mesh" & emm_df$recipient_genotype == "WT", "emmean"], 2),
    tad14_m1_pstarved_am = round(emm_df[emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M1_Membrane" & emm_df$recipient_genotype == "Tad14_mutant", "emmean"], 2),
    tad14_m2_pstarved_am = round(emm_df[emm_df$donor_regime == "P_Starved" & emm_df$barrier_mode == "M2_Mesh" & emm_df$recipient_genotype == "Tad14_mutant", "emmean"], 2)
  )
)

json_path <- file.path(results_dir, "priming_lmm_results.json")
write(toJSON(results_json, auto_unbox = TRUE, pretty = TRUE), file = json_path)
cat(sprintf("\nExported complete statistical results to: %s\n", json_path))

# Export Formatted Tables
anova_tab <- data.frame(
  Effect = rownames(anova_am),
  Sum_Sq = round(anova_am$`Sum Sq`, 2),
  Mean_Sq = round(anova_am$`Mean Sq`, 2),
  Num_DF = anova_am$NumDF,
  Den_DF = round(anova_am$DenDF, 1),
  F_Value = round(anova_am$`F value`, 2),
  P_Value = format.pval(anova_am$`Pr(>F)`, eps = 0.001)
)
write.csv(anova_tab, file.path(tables_dir, "table1_anova_am_colonization.csv"), row.names = FALSE)

contrasts_tab <- data.frame(
  Hypothesis = planned_contrasts_res$contrast,
  Estimate = round(planned_contrasts_res$estimate, 2),
  SE = round(planned_contrasts_res$SE, 2),
  DF = round(planned_contrasts_res$df, 1),
  t_ratio = round(planned_contrasts_res$t.ratio, 2),
  P_Value = format.pval(planned_contrasts_res$p.value, eps = 0.0001)
)
write.csv(contrasts_tab, file.path(tables_dir, "table2_planned_contrasts.csv"), row.names = FALSE)
write.csv(emm_df, file.path(tables_dir, "table3_estimated_marginal_means.csv"), row.names = FALSE)

# Generate Publication Figures via ggplot2
cat("\nGenerating Publication Figures...\n")

theme_areil <- theme_bw(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#f0f0f0"),
    strip.background = element_rect(fill = "#f8f9fa", color = "#cccccc"),
    strip.text = element_text(face = "bold", size = 10),
    legend.position = "bottom",
    legend.title = element_text(face = "bold"),
    plot.title = element_text(face = "bold", size = 12),
    plot.subtitle = element_text(size = 10, color = "#555555")
  )

# Figure 2: Colonization and TaPT4 expression interaction plot
p1 <- ggplot(df, aes(x = barrier_mode, y = am_colonization_pct, fill = donor_regime)) +
  stat_summary(fun = mean, geom = "bar", position = position_dodge(0.8), width = 0.7, color = "black", linewidth = 0.3) +
  stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(0.8), width = 0.25, linewidth = 0.5) +
  facet_wrap(~ recipient_genotype, labeller = labeller(recipient_genotype = c("WT" = "Recipient: Wild-Type (cv. Bobwhite)", "Tad14_mutant" = "Recipient: Tad14 Insensitive Mutant"))) +
  scale_fill_manual(values = c("P_Replete" = "#9ecae1", "P_Starved" = "#e6550d", "P_Starved_Tis108" = "#fdae6b"),
                    labels = c("P_Replete" = "Donor: +Pi (200 uM)", "P_Starved" = "Donor: -Pi (2 uM)", "P_Starved_Tis108" = "Donor: -Pi + Tis-108 (1 uM)")) +
  scale_x_discrete(labels = c("M0_Solid" = "M0\n(Solid Barrier)", "M1_Membrane" = "M1\n(0.45 um Solute)", "M2_Mesh" = "M2\n(30 um Hyphae)")) +
  labs(title = "Arbuscular Mycorrhizal Colonization in Recipient Wheat",
       subtitle = "Phosphorus-starved donor roots prime colonization via diffusible solute (M1) and hyphal bridging (M2)",
       x = "Microcosm Barrier / Transmission Mode",
       y = "Root Length Colonized (%)",
       fill = "Donor Regime:") +
  theme_areil

fig2_path <- file.path(figures_dir, "figure2_am_colonization_interaction.png")
ggsave(fig2_path, plot = p1, width = 8.5, height = 5.2, dpi = 300)
cat(sprintf("Saved: %s\n", fig2_path))

# Figure 2B: TaPT4 Expression
p2 <- ggplot(df, aes(x = barrier_mode, y = tapt4_relative_expression, fill = donor_regime)) +
  stat_summary(fun = mean, geom = "bar", position = position_dodge(0.8), width = 0.7, color = "black", linewidth = 0.3) +
  stat_summary(fun.data = mean_se, geom = "errorbar", position = position_dodge(0.8), width = 0.25, linewidth = 0.5) +
  facet_wrap(~ recipient_genotype, labeller = labeller(recipient_genotype = c("WT" = "Recipient: Wild-Type", "Tad14_mutant" = "Recipient: Tad14 Mutant"))) +
  scale_fill_manual(values = c("P_Replete" = "#9ecae1", "P_Starved" = "#31a354", "P_Starved_Tis108" = "#a1d99b"),
                    labels = c("P_Replete" = "Donor: +Pi (200 uM)", "P_Starved" = "Donor: -Pi (2 uM)", "P_Starved_Tis108" = "Donor: -Pi + Tis-108")) +
  scale_x_discrete(labels = c("M0_Solid" = "M0 (Solid)", "M1_Membrane" = "M1 (0.45 um)", "M2_Mesh" = "M2 (30 um)")) +
  labs(title = "Mycorrhiza-Specific Phosphate Transporter TaPT4 Transcript Induction",
       subtitle = "Relative mRNA abundance normalized to TaGAPDH and calibrated to M0 solid control",
       x = "Microcosm Barrier Mode",
       y = "Relative Expression (Fold Change)",
       fill = "Donor Regime:") +
  theme_areil

fig2b_path <- file.path(figures_dir, "figure2b_tapt4_induction.png")
ggsave(fig2b_path, plot = p2, width = 8.5, height = 5.0, dpi = 300)
cat(sprintf("Saved: %s\n", fig2b_path))

# Figure 3: Model Diagnostics
diag_df <- data.frame(
  Fitted = fitted(lmm_am),
  Residuals = residuals(lmm_am),
  Block = df$block
)

p_diag1 <- ggplot(diag_df, aes(x = Fitted, y = Residuals)) +
  geom_point(alpha = 0.5, color = "#2b5c8f") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(title = "Residuals vs Fitted Values", x = "Fitted Values (%)", y = "Residuals") +
  theme_areil

p_diag2 <- ggplot(diag_df, aes(sample = Residuals)) +
  stat_qq(color = "#2b5c8f", alpha = 0.6) +
  stat_qq_line(color = "red") +
  labs(title = "Normal Q-Q Plot", x = "Theoretical Quantiles", y = "Sample Quantiles") +
  theme_areil

fig3_path <- file.path(figures_dir, "figure3_model_diagnostics.png")
png(fig3_path, width = 2400, height = 1200, res = 300)
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(1, 2)))
print(p_diag1, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 1))
print(p_diag2, vp = grid::viewport(layout.pos.row = 1, layout.pos.col = 2))
dev.off()
cat(sprintf("Saved: %s\n", fig3_path))

cat("\n=== PIPELINE EXECUTION COMPLETE ===\n")
