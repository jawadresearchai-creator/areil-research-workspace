suppressPackageStartupMessages({
  library(readr); library(dplyr); library(lme4); library(lmerTest)
  library(emmeans); library(sandwich); library(broom.mixed)
})

options(contrasts=c("contr.treatment","contr.poly"))
base_dir <- "projects/asd-kfu-hydropedology"
data_dir <- file.path(base_dir,"data")
out_dir <- file.path(base_dir,"results")
diag_dir <- file.path(base_dir,"diagnostics")
dir.create(out_dir, recursive=TRUE, showWarnings=FALSE)
dir.create(diag_dir, recursive=TRUE, showWarnings=FALSE)

expected <- c(
  derived_analysis.csv="abc718ddc800a1b4466cf7a502ecb3a65550bde37c2c025f0da2c123ec96db0a",
  unit_register.csv="94eb442c3b9d9f98cfc90fa296f43833689cf5fb71dac8b937cc15464547e1e5",
  drainage_subset.csv="a7d8bfa3bfcbd8742460819c550104e9dcd72ba2125e7ebb2472742507761dcb"
)
sha <- function(p) unname(tools::md5sum(p))
# sha256 via system utility on GitHub runner
sha256 <- function(p) strsplit(system2("sha256sum", p, stdout=TRUE), " ")[[1]][1]
for (nm in names(expected)) {
  got <- sha256(file.path(data_dir,nm))
  if (!identical(got, expected[[nm]])) stop("SHA-256 mismatch for ", nm, ": ", got)
}

raw <- read_csv(file.path(data_dir,"derived_analysis.csv"), show_col_types=FALSE)
unit <- read_csv(file.path(data_dir,"unit_register.csv"), show_col_types=FALSE)
dr <- read_csv(file.path(data_dir,"drainage_subset.csv"), show_col_types=FALSE)

dat <- raw %>%
  filter(Data_Status=="Valid", Primary_ECe_Inclusion=="YES", Primary_Yield_Inclusion=="YES") %>%
  mutate(
    Treatment=factor(Treatment, levels=c("U-FIELD","S-VR","H-VR")),
    Hardpan_Class=factor(Hardpan_Class, levels=c("H1","H2","H3")),
    Season_ID=factor(Season_ID, levels=c("S1","S2")),
    Block_ID=factor(Block_ID)
  )
stopifnot(nrow(dat)==198L)
stopifnot(all(table(dat$Treatment)==66L), all(table(dat$Hardpan_Class)==66L))
stopifnot(length(unique(dat$Plot_ID))==198L, length(unique(dat$Block_ID))==66L)

# Workbook-prespecified primary models
m_ece <- lmer(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Baseline_ECe_0_30 + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_yld <- lmer(Log_Yield ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_wat <- lmer(Leaching_Water_mm ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_no3 <- lmer(NO3_Below60_Post ~ Treatment*Hardpan_Class + NO3_Below60_Baseline + Season_ID + (1|Block_ID), data=dat, REML=TRUE)

# Marginal means and prespecified contrasts
emm_ece <- emmeans(m_ece, ~Treatment, weights="equal")
emm_yld <- emmeans(m_yld, ~Treatment, weights="equal")
emm_wat <- emmeans(m_wat, ~Treatment, weights="equal")
emm_no3 <- emmeans(m_no3, ~Treatment, weights="equal")

hu <- list("H-VR - U-FIELD"=c(-1,0,1))
mech <- list("H-VR - S-VR"=c(0,-1,1), "S-VR - U-FIELD"=c(-1,1,0))

get_ci <- function(x) as.data.frame(confint(x, level=.95))
ece_hu <- get_ci(contrast(emm_ece, hu))
yld_hu_log <- get_ci(contrast(emm_yld, hu))
yld_hu <- yld_hu_log %>% mutate(ratio=exp(estimate), ratio_low=exp(lower.CL), ratio_high=exp(upper.CL))
wat_hu <- get_ci(contrast(emm_wat, hu))
no3_hu <- get_ci(contrast(emm_no3, hu))

ece_pass <- ece_hu$upper.CL[1] < 0.5
yld_pass <- yld_hu$ratio_low[1] > 0.95
coprimary_pass <- ece_pass && yld_pass
water_pass <- coprimary_pass && wat_hu$upper.CL[1] < 0

wat_means <- as.data.frame(emm_wat)
u_mm <- wat_means$emmean[wat_means$Treatment=="U-FIELD"]
h_mm <- wat_means$emmean[wat_means$Treatment=="H-VR"]
water_saving_pct <- 100*(u_mm-h_mm)/u_mm

# Treatment x hardpan results
hardpan_ece <- get_ci(contrast(emmeans(m_ece, ~Treatment|Hardpan_Class, weights="equal"), hu))
hardpan_yld <- get_ci(contrast(emmeans(m_yld, ~Treatment|Hardpan_Class, weights="equal"), hu)) %>%
  mutate(ratio=exp(estimate), ratio_low=exp(lower.CL), ratio_high=exp(upper.CL))
hardpan_wat <- get_ci(contrast(emmeans(m_wat, ~Treatment|Hardpan_Class, weights="equal"), hu))

# Mechanistic contrast families with Holm adjustment
mech_ece <- as.data.frame(summary(contrast(emm_ece, mech), infer=c(TRUE,TRUE), adjust="holm"))
mech_wat <- as.data.frame(summary(contrast(emm_wat, mech), infer=c(TRUE,TRUE), adjust="holm"))
mech_no3 <- as.data.frame(summary(contrast(emm_no3, mech), infer=c(TRUE,TRUE), adjust="holm"))

# Helper because emmeans column names differ by df method
ci_cols <- function(df) {
  lo <- intersect(c("lower.CL","asymp.LCL"), names(df))[1]
  hi <- intersect(c("upper.CL","asymp.UCL"), names(df))[1]
  c(lo,hi)
}
# Rebuild yield mechanistic ratio safely
mech_yld <- as.data.frame(summary(contrast(emm_yld, mech), infer=c(TRUE,TRUE), adjust="holm"))
yc <- ci_cols(mech_yld)
mech_yld$ratio <- exp(mech_yld$estimate)
mech_yld$ratio_low <- exp(mech_yld[[yc[1]]])
mech_yld$ratio_high <- exp(mech_yld[[yc[2]]])

# Absolute ECe target attainment
attain <- dat %>% mutate(Target=Post_ECe_0_30 <= 4.0) %>%
  count(Treatment, Hardpan_Class, Target, name="n")
attain_total <- dat %>% group_by(Treatment) %>% summarise(n=n(), meet=sum(Post_ECe_0_30<=4.0), .groups="drop")

# Instrumented drainage subset cumulative nitrate flux
flux <- dr %>%
  filter(Data_Status=="Valid", Flux_Analysis_Eligible=="YES") %>%
  group_by(Plot_ID) %>%
  summarise(Cumulative_NO3_Flux_kg_ha=sum(Calculated_NO3_Flux_kg_ha, na.rm=TRUE), .groups="drop") %>%
  left_join(unit %>% select(Plot_ID,Treatment,Hardpan_Class,Season_ID,Block_ID), by="Plot_ID") %>%
  mutate(Treatment=factor(Treatment, levels=c("U-FIELD","S-VR","H-VR")),
         Hardpan_Class=factor(Hardpan_Class, levels=c("H1","H2","H3")),
         Season_ID=factor(Season_ID, levels=c("S1","S2")), Block_ID=factor(Block_ID))
stopifnot(nrow(flux)==90L)
m_flux <- lmer(Cumulative_NO3_Flux_kg_ha ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=flux, REML=TRUE)
flux_hu <- get_ci(contrast(emmeans(m_flux, ~Treatment, weights="equal"), hu))

# Cluster-robust sensitivity using the same fixed structures and block-cluster sandwich covariance
robust_emm <- function(formula, data, response_scale="identity") {
  mod <- lm(formula, data=data)
  V <- sandwich::vcovCL(mod, cluster=~Block_ID, type="HC1")
  em <- emmeans(mod, ~Treatment, weights="equal", vcov.=V)
  cc <- get_ci(contrast(em, hu))
  if (response_scale=="ratio") cc <- cc %>% mutate(ratio=exp(estimate), ratio_low=exp(lower.CL), ratio_high=exp(upper.CL))
  cc
}
rob_ece <- robust_emm(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Baseline_ECe_0_30 + Season_ID, dat)
rob_yld <- robust_emm(Log_Yield ~ Treatment*Hardpan_Class + Season_ID, dat, "ratio")
rob_wat <- robust_emm(Leaching_Water_mm ~ Treatment*Hardpan_Class + Season_ID, dat)

# Season-interaction sensitivity
m_ece_season <- lmer(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Treatment*Season_ID + Baseline_ECe_0_30 + (1|Block_ID), data=dat, REML=TRUE)
m_yld_season <- lmer(Log_Yield ~ Treatment*Hardpan_Class + Treatment*Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_wat_season <- lmer(Leaching_Water_mm ~ Treatment*Hardpan_Class + Treatment*Season_ID + (1|Block_ID), data=dat, REML=TRUE)
season_ece <- get_ci(contrast(emmeans(m_ece_season, ~Treatment, weights="equal"), hu))
season_yld <- get_ci(contrast(emmeans(m_yld_season, ~Treatment, weights="equal"), hu)) %>% mutate(ratio=exp(estimate), ratio_low=exp(lower.CL), ratio_high=exp(upper.CL))
season_wat <- get_ci(contrast(emmeans(m_wat_season, ~Treatment, weights="equal"), hu))

# Diagnostics
safe_shapiro <- function(x) unname(shapiro.test(residuals(x))$p.value)
fligner_p <- function(x, group) unname(fligner.test(x ~ group)$p.value)
diag <- tibble(
  model=c("ECe","Yield_log","Water","NO3_below60","Drainage_flux"),
  singular=c(isSingular(m_ece,tol=1e-5),isSingular(m_yld,tol=1e-5),isSingular(m_wat,tol=1e-5),isSingular(m_no3,tol=1e-5),isSingular(m_flux,tol=1e-5)),
  random_block_variance=c(as.data.frame(VarCorr(m_ece))$vcov[1],as.data.frame(VarCorr(m_yld))$vcov[1],as.data.frame(VarCorr(m_wat))$vcov[1],as.data.frame(VarCorr(m_no3))$vcov[1],as.data.frame(VarCorr(m_flux))$vcov[1]),
  shapiro_p=c(safe_shapiro(m_ece),safe_shapiro(m_yld),safe_shapiro(m_wat),safe_shapiro(m_no3),safe_shapiro(m_flux)),
  fligner_by_treatment_p=c(fligner_p(residuals(m_ece),dat$Treatment),fligner_p(residuals(m_yld),dat$Treatment),fligner_p(residuals(m_wat),dat$Treatment),fligner_p(residuals(m_no3),dat$Treatment),fligner_p(residuals(m_flux),flux$Treatment))
)

# Write outputs
write_csv(ece_hu, file.path(out_dir,"primary_ece_NI.csv"))
write_csv(yld_hu, file.path(out_dir,"primary_yield_NI.csv"))
write_csv(wat_hu, file.path(out_dir,"gatekept_water.csv"))
write_csv(no3_hu, file.path(out_dir,"nitrate_below60_primary.csv"))
write_csv(flux_hu, file.path(out_dir,"drainage_nitrate_flux.csv"))
write_csv(hardpan_ece, file.path(out_dir,"ece_hardpan_contrasts.csv"))
write_csv(hardpan_yld, file.path(out_dir,"yield_hardpan_contrasts.csv"))
write_csv(hardpan_wat, file.path(out_dir,"water_hardpan_contrasts.csv"))
write_csv(mech_ece, file.path(out_dir,"ece_mechanistic_holm.csv"))
write_csv(mech_yld, file.path(out_dir,"yield_mechanistic_holm.csv"))
write_csv(mech_wat, file.path(out_dir,"water_mechanistic_holm.csv"))
write_csv(mech_no3, file.path(out_dir,"nitrate_mechanistic_holm.csv"))
write_csv(attain, file.path(out_dir,"ece_target_attainment_by_hardpan.csv"))
write_csv(attain_total, file.path(out_dir,"ece_target_attainment_total.csv"))
write_csv(rob_ece, file.path(out_dir,"sensitivity_clusterrobust_ece.csv"))
write_csv(rob_yld, file.path(out_dir,"sensitivity_clusterrobust_yield.csv"))
write_csv(rob_wat, file.path(out_dir,"sensitivity_clusterrobust_water.csv"))
write_csv(season_ece, file.path(out_dir,"sensitivity_seasoninteraction_ece.csv"))
write_csv(season_yld, file.path(out_dir,"sensitivity_seasoninteraction_yield.csv"))
write_csv(season_wat, file.path(out_dir,"sensitivity_seasoninteraction_water.csv"))
write_csv(diag, file.path(diag_dir,"model_diagnostics.csv"))

decisions <- tibble(
  decision=c("ECe_noninferiority","Yield_noninferiority","Overall_coprimary","Water_superiority_gatekept"),
  pass=c(ece_pass,yld_pass,coprimary_pass,water_pass),
  criterion=c("upper 95% CI < +0.5 dS/m","lower 95% CI ratio > 0.95","both co-primary PASS","upper 95% CI difference < 0 after gate")
)
write_csv(decisions, file.path(out_dir,"confirmatory_decisions.csv"))

fmt <- function(x,d=4) formatC(x,format="f",digits=d)
report <- c(
  "# ASD KFU R 4.4.1 Confirmatory Analysis",
  "",
  paste0("R version: `", R.version.string, "`"),
  "",
  "## Confirmatory decisions",
  paste0("- ECe NI: **", ifelse(ece_pass,"PASS","FAIL"), "**; H-VR − U-FIELD = ",fmt(ece_hu$estimate[1])," dS m-1 (95% CI ",fmt(ece_hu$lower.CL[1])," to ",fmt(ece_hu$upper.CL[1]),")."),
  paste0("- Yield NI: **", ifelse(yld_pass,"PASS","FAIL"), "**; H-VR/U-FIELD = ",fmt(yld_hu$ratio[1])," (95% CI ",fmt(yld_hu$ratio_low[1])," to ",fmt(yld_hu$ratio_high[1]),")."),
  paste0("- Overall co-primary gate: **", ifelse(coprimary_pass,"PASS","FAIL"), "**."),
  paste0("- Gatekept water superiority: **", ifelse(water_pass,"PASS","FAIL"), "**; H-VR − U-FIELD = ",fmt(wat_hu$estimate[1],2)," mm (95% CI ",fmt(wat_hu$lower.CL[1],2)," to ",fmt(wat_hu$upper.CL[1],2),"); water saving = ",fmt(water_saving_pct,2),"%."),
  "",
  "## Key secondary nitrate",
  paste0("- Below-60-cm nitrate: H-VR − U-FIELD = ",fmt(no3_hu$estimate[1],3)," kg N ha-1 (95% CI ",fmt(no3_hu$lower.CL[1],3)," to ",fmt(no3_hu$upper.CL[1],3),")."),
  paste0("- Cumulative drainage nitrate flux: H-VR − U-FIELD = ",fmt(flux_hu$estimate[1],3)," kg N ha-1 (95% CI ",fmt(flux_hu$lower.CL[1],3)," to ",fmt(flux_hu$upper.CL[1],3),")."),
  "",
  "## Sensitivity",
  paste0("- Cluster-robust ECe estimate: ",fmt(rob_ece$estimate[1])," (95% CI ",fmt(rob_ece$lower.CL[1])," to ",fmt(rob_ece$upper.CL[1]),")."),
  paste0("- Cluster-robust yield ratio: ",fmt(rob_yld$ratio[1])," (95% CI ",fmt(rob_yld$ratio_low[1])," to ",fmt(rob_yld$ratio_high[1]),")."),
  paste0("- Cluster-robust water estimate: ",fmt(rob_wat$estimate[1],2)," mm (95% CI ",fmt(rob_wat$lower.CL[1],2)," to ",fmt(rob_wat$upper.CL[1],2),")."),
  "",
  "## Data lock",
  "- Source workbook SHA-256 (external authoritative file): `a3c386909858e57ef4a00d7b288b11a287400e5823656cca9660bf051d14dd76`.",
  "- Analysis CSV SHA-256 values were verified before model execution.",
  "",
  "## Session information",
  "See `diagnostics/sessionInfo.txt`."
)
writeLines(report, file.path(out_dir,"ASD_ANALYSIS_SUMMARY_v1_LOCKED.md"))

sink(file.path(diag_dir,"sessionInfo.txt")); print(sessionInfo()); sink()

cat(paste(report, collapse="\n"),"\n")