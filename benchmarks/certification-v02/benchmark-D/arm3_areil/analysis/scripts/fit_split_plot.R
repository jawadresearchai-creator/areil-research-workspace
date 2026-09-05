library(lme4)
library(lmerTest)
library(emmeans)
library(jsonlite)

data <- read.csv("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/yates_oats_1935_trial.csv")

# Proper split-plot model: Variety and nitro as fixed, Block and Block:Variety as random
fit_lme <- lmer(yield ~ Variety * nitro + (1 | Block) + (1 | Block:Variety), data = data)
anv <- anova(fit_lme)
vc <- as.data.frame(VarCorr(fit_lme))

emm_nitro <- emmeans(fit_lme, ~ nitro, at = list(nitro = c(0.0, 0.2, 0.4, 0.6)))
emm_var <- emmeans(fit_lme, ~ Variety)

# Normality check
resids <- residuals(fit_lme)
shapiro <- shapiro.test(resids)

out <- list(
  model = "lmer(yield ~ Variety * nitro + (1 | Block) + (1 | Block:Variety))",
  block_var = vc[vc$grp == "Block", "vcov"],
  block_variety_var = vc[vc$grp == "Block:Variety", "vcov"],
  residual_var = vc[vc$grp == "Residual", "vcov"],
  nitro_F = anv["nitro", "F value"],
  nitro_p = anv["nitro", "Pr(>F)"],
  variety_F = anv["Variety", "F value"],
  variety_p = anv["Variety", "Pr(>F)"],
  shapiro_W = shapiro$statistic,
  shapiro_p = shapiro$p.value
)

out_dir <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/arm3_areil/analysis/results"
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
write(toJSON(out, auto_unbox = TRUE, pretty = TRUE), file.path(out_dir, "lme_results.json"))
cat("AREIL Benchmark D LME model fitted successfully.
")
