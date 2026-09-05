library(lme4)
library(lmerTest)
library(emmeans)
library(jsonlite)

data_path <- "E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-D/yates_oats_1935_trial.csv"
data <- read.csv(data_path)

cat("--- DATA SUMMARY ---\n")
print(str(data))
print(summary(data))

cat("\n--- MODEL 1: NITRO CONTINUOUS ---\n")
m_cont <- lmer(yield ~ Variety * nitro + (1 | Block) + (1 | Block:Variety), data = data)
print(summary(m_cont))
cat("\nANOVA Kenward-Roger (Continuous):\n")
print(anova(m_cont, ddf = "Kenward-Roger"))

cat("\n--- MODEL 2: NITRO FACTOR ---\n")
data$nitro_fac <- factor(data$nitro)
m_fac <- lmer(yield ~ Variety * nitro_fac + (1 | Block) + (1 | Block:Variety), data = data)
print(summary(m_fac))
cat("\nANOVA Kenward-Roger (Factor):\n")
print(anova(m_fac, ddf = "Kenward-Roger"))

cat("\n--- VARIANCE COMPONENTS ---\n")
print(VarCorr(m_cont))
print(VarCorr(m_fac))
