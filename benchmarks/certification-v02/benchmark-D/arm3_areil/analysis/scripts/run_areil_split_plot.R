library(lme4)
library(lmerTest)
library(emmeans)
library(jsonlite)

data_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/yates_oats_1935_trial.csv"
data <- read.csv(data_path)
data$nitro_fac <- factor(data$nitro)
data$Block <- factor(data$Block)
data$Variety <- factor(data$Variety)

fit_sp <- lmer(yield ~ Variety * nitro_fac + (1 | Block) + (1 | Block:Variety), data = data)
anv <- anova(fit_sp, ddf = "Kenward-Roger")
vc <- as.data.frame(VarCorr(fit_sp))
emm_n <- as.data.frame(emmeans(fit_sp, ~ nitro_fac))
emm_v <- as.data.frame(emmeans(fit_sp, ~ Variety))

res <- list(
  anova_table = list(
    variety_f = anv["Variety", "F value"],
    variety_p = anv["Variety", "Pr(>F)"],
    variety_numdf = anv["Variety", "NumDF"],
    variety_dendf = anv["Variety", "DenDF"],
    nitro_f = anv["nitro_fac", "F value"],
    nitro_p = anv["nitro_fac", "Pr(>F)"],
    nitro_numdf = anv["nitro_fac", "NumDF"],
    nitro_dendf = anv["nitro_fac", "DenDF"],
    interaction_f = anv["Variety:nitro_fac", "F value"],
    interaction_p = anv["Variety:nitro_fac", "Pr(>F)"]
  ),
  variance_components = list(
    var_block = vc[vc$grp == "Block", "vcov"],
    var_whole_plot = vc[vc$grp == "Block:Variety", "vcov"],
    var_residual = vc[vc$grp == "Residual", "vcov"]
  ),
  means_nitrogen = emm_n,
  means_variety = emm_v,
  shapiro_wilk_residuals = list(
    w = shapiro.test(residuals(fit_sp))$statistic,
    p = shapiro.test(residuals(fit_sp))$p.value
  )
)

out_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/arm3_areil/analysis/split_plot_results.json"
write(jsonlite::toJSON(res, auto_unbox = TRUE, pretty = TRUE), out_path)
cat("R analysis executed and results saved.
")
