data <- read.csv("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/yates_oats_1935_trial.csv")
fit_lm <- lm(yield ~ Variety + nitro, data = data)
print(summary(fit_lm))
res <- list(
  variety_p = anova(fit_lm)$`Pr(>F)`[1],
  nitro_p = anova(fit_lm)$`Pr(>F)`[2],
  r_squared = summary(fit_lm)$r.squared
)
write(jsonlite::toJSON(res, auto_unbox=TRUE), "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/arm2_tools/lm_results.json")
