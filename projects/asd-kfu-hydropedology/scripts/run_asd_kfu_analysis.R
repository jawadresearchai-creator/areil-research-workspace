suppressPackageStartupMessages({
  library(lme4)
  library(lmerTest)
  library(emmeans)
  library(sandwich)
})

options(contrasts=c("contr.treatment","contr.poly"))
base_dir <- "projects/asd-kfu-hydropedology"
data_dir <- file.path(base_dir,"data")
out_dir <- file.path(base_dir,"results")
diag_dir <- file.path(base_dir,"diagnostics")
dir.create(out_dir, recursive=TRUE, showWarnings=FALSE)
dir.create(diag_dir, recursive=TRUE, showWarnings=FALSE)

sha256 <- function(p) strsplit(system2("sha256sum", p, stdout=TRUE), " ")[[1]][1]
inputs <- c("derived_analysis.csv","unit_register.csv","drainage_subset.csv","soil_profile.csv")
input_hashes <- data.frame(file=inputs, sha256=vapply(file.path(data_dir,inputs), sha256, character(1)))
write.csv(input_hashes, file.path(diag_dir,"execution_input_sha256.csv"), row.names=FALSE)

raw <- read.csv(file.path(data_dir,"derived_analysis.csv"), check.names=FALSE, stringsAsFactors=FALSE)
unit <- read.csv(file.path(data_dir,"unit_register.csv"), check.names=FALSE, stringsAsFactors=FALSE)
dr <- read.csv(file.path(data_dir,"drainage_subset.csv"), check.names=FALSE, stringsAsFactors=FALSE)
soil0 <- read.csv(file.path(data_dir,"soil_profile.csv"), check.names=FALSE, stringsAsFactors=FALSE)

# Semantic data-lock checks: invariant to LF/CRLF transfer.
close_enough <- function(x, expected, tol=1e-7) {
  if (!isTRUE(all.equal(as.numeric(x), as.numeric(expected), tolerance=tol))) stop("Semantic checksum failed: ", x, " vs ", expected)
}
stopifnot(nrow(raw)==198L, nrow(unit)==198L, nrow(dr)==450L)
stopifnot(length(unique(raw$Plot_ID))==198L, length(unique(unit$Plot_ID))==198L)
close_enough(sum(raw$Baseline_ECe_0_30), 1293.41)
close_enough(sum(raw$Post_ECe_0_30), 738.60)
close_enough(sum(raw$Leaching_Water_mm), 25337.50)
close_enough(sum(raw$Yield_Mg_ha_Std), 1073.3505)
close_enough(sum(raw$NO3_Below60_Baseline), 13661.57)
close_enough(sum(raw$NO3_Below60_Post), 17635.282)
close_enough(sum(dr$Calculated_NO3_Flux_kg_ha, na.rm=TRUE), 2169.737)
soil <- soil0[soil0$Data_Status=="Valid" & nzchar(soil0$Plot_ID), ]
stopifnot(nrow(soil)==1980L, length(unique(soil$Plot_ID))==198L)
close_enough(sum(soil$ECe_dS_m), 10261.19)
close_enough(sum(soil$NO3_Stock_kg_ha), 79878.24606, tol=1e-6)

# Mapping integrity across authoritative tables.
map <- merge(raw[,c("Plot_ID","Treatment","Hardpan_Class","Season_ID","Block_ID")],
             unit[,c("Plot_ID","Treatment","Hardpan_Class","Season_ID","Block_ID")],
             by="Plot_ID", suffixes=c(".raw",".unit"), all=TRUE)
stopifnot(nrow(map)==198L,
          all(map$Treatment.raw==map$Treatment.unit),
          all(map$Hardpan_Class.raw==map$Hardpan_Class.unit),
          all(map$Season_ID.raw==map$Season_ID.unit),
          all(map$Block_ID.raw==map$Block_ID.unit))

dat <- raw[raw$Data_Status=="Valid" & raw$Primary_ECe_Inclusion=="YES" & raw$Primary_Yield_Inclusion=="YES", ]
dat$Treatment <- factor(dat$Treatment, levels=c("U-FIELD","S-VR","H-VR"))
dat$Hardpan_Class <- factor(dat$Hardpan_Class, levels=c("H1","H2","H3"))
dat$Season_ID <- factor(dat$Season_ID, levels=c("S1","S2"))
dat$Block_ID <- factor(dat$Block_ID)
stopifnot(nrow(dat)==198L, all(table(dat$Treatment)==66L), all(table(dat$Hardpan_Class)==66L), length(unique(dat$Block_ID))==66L)

# Primary models specified in the workbook SAP.
m_ece <- lmer(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Baseline_ECe_0_30 + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_yld <- lmer(Log_Yield ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_wat <- lmer(Leaching_Water_mm ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_no3 <- lmer(NO3_Below60_Post ~ Treatment*Hardpan_Class + NO3_Below60_Baseline + Season_ID + (1|Block_ID), data=dat, REML=TRUE)

hu <- list("H-VR - U-FIELD"=c(-1,0,1))
mech <- list("H-VR - S-VR"=c(0,-1,1), "S-VR - U-FIELD"=c(-1,1,0))
get_ci <- function(x) as.data.frame(confint(x, level=.95))
ci_names <- function(d) c(intersect(c("lower.CL","asymp.LCL"),names(d))[1], intersect(c("upper.CL","asymp.UCL"),names(d))[1])

emm_ece <- emmeans(m_ece, ~Treatment, weights="equal")
emm_yld <- emmeans(m_yld, ~Treatment, weights="equal")
emm_wat <- emmeans(m_wat, ~Treatment, weights="equal")
emm_no3 <- emmeans(m_no3, ~Treatment, weights="equal")

ece_hu <- get_ci(contrast(emm_ece, hu))
yld_hu <- get_ci(contrast(emm_yld, hu)); yld_hu$ratio <- exp(yld_hu$estimate); yld_hu$ratio_low <- exp(yld_hu$lower.CL); yld_hu$ratio_high <- exp(yld_hu$upper.CL)
wat_hu <- get_ci(contrast(emm_wat, hu))
no3_hu <- get_ci(contrast(emm_no3, hu))

ece_pass <- ece_hu$upper.CL[1] < 0.5
yld_pass <- yld_hu$ratio_low[1] > 0.95
coprimary_pass <- ece_pass && yld_pass
water_pass <- coprimary_pass && wat_hu$upper.CL[1] < 0
wm <- as.data.frame(emm_wat); water_saving_pct <- 100*(wm$emmean[wm$Treatment=="U-FIELD"]-wm$emmean[wm$Treatment=="H-VR"])/wm$emmean[wm$Treatment=="U-FIELD"]

hardpan_ece <- get_ci(contrast(emmeans(m_ece, ~Treatment|Hardpan_Class, weights="equal"), hu))
hardpan_yld <- get_ci(contrast(emmeans(m_yld, ~Treatment|Hardpan_Class, weights="equal"), hu)); hardpan_yld$ratio <- exp(hardpan_yld$estimate); hardpan_yld$ratio_low <- exp(hardpan_yld$lower.CL); hardpan_yld$ratio_high <- exp(hardpan_yld$upper.CL)
hardpan_wat <- get_ci(contrast(emmeans(m_wat, ~Treatment|Hardpan_Class, weights="equal"), hu))

mech_ece <- as.data.frame(summary(contrast(emm_ece, mech), infer=c(TRUE,TRUE), adjust="holm"))
mech_yld <- as.data.frame(summary(contrast(emm_yld, mech), infer=c(TRUE,TRUE), adjust="holm")); yc <- ci_names(mech_yld); mech_yld$ratio <- exp(mech_yld$estimate); mech_yld$ratio_low <- exp(mech_yld[[yc[1]]]); mech_yld$ratio_high <- exp(mech_yld[[yc[2]]])
mech_wat <- as.data.frame(summary(contrast(emm_wat, mech), infer=c(TRUE,TRUE), adjust="holm"))
mech_no3 <- as.data.frame(summary(contrast(emm_no3, mech), infer=c(TRUE,TRUE), adjust="holm"))

attain_total <- aggregate(Post_ECe_0_30 ~ Treatment, dat, function(x)c(n=length(x),meet=sum(x<=4.0)))
attain_total <- data.frame(Treatment=attain_total$Treatment, n=attain_total$Post_ECe_0_30[,"n"], meet=attain_total$Post_ECe_0_30[,"meet"])
attain_hp <- aggregate(Post_ECe_0_30 ~ Treatment+Hardpan_Class, dat, function(x)c(n=length(x),meet=sum(x<=4.0)))
attain_hp <- data.frame(Treatment=attain_hp$Treatment, Hardpan_Class=attain_hp$Hardpan_Class, n=attain_hp$Post_ECe_0_30[,"n"], meet=attain_hp$Post_ECe_0_30[,"meet"])

# Drainage-subset cumulative nitrate flux.
flux_sum <- aggregate(Calculated_NO3_Flux_kg_ha ~ Plot_ID, dr[dr$Data_Status=="Valid" & dr$Flux_Analysis_Eligible=="YES",], sum)
names(flux_sum)[2] <- "Cumulative_NO3_Flux_kg_ha"
flux <- merge(flux_sum, unit[,c("Plot_ID","Treatment","Hardpan_Class","Season_ID","Block_ID")], by="Plot_ID")
flux$Treatment <- factor(flux$Treatment, levels=c("U-FIELD","S-VR","H-VR")); flux$Hardpan_Class <- factor(flux$Hardpan_Class, levels=c("H1","H2","H3")); flux$Season_ID <- factor(flux$Season_ID,levels=c("S1","S2")); flux$Block_ID <- factor(flux$Block_ID)
stopifnot(nrow(flux)==90L, all(table(flux$Treatment)==30L))
m_flux <- lmer(Cumulative_NO3_Flux_kg_ha ~ Treatment*Hardpan_Class + Season_ID + (1|Block_ID), data=flux, REML=TRUE)
flux_hu <- get_ci(contrast(emmeans(m_flux, ~Treatment, weights="equal"), hu))

# Cluster-robust fixed-effect sensitivity by randomized block.
robust_emm <- function(formula, data, ratio=FALSE) {
  m <- lm(formula, data=data); V <- sandwich::vcovCL(m, cluster=data$Block_ID, type="HC1")
  z <- get_ci(contrast(emmeans(m, ~Treatment, weights="equal", vcov.=V), hu))
  if (ratio) { z$ratio <- exp(z$estimate); z$ratio_low <- exp(z$lower.CL); z$ratio_high <- exp(z$upper.CL) }
  z
}
rob_ece <- robust_emm(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Baseline_ECe_0_30 + Season_ID, dat)
rob_yld <- robust_emm(Log_Yield ~ Treatment*Hardpan_Class + Season_ID, dat, TRUE)
rob_wat <- robust_emm(Leaching_Water_mm ~ Treatment*Hardpan_Class + Season_ID, dat)

# Season-interaction sensitivity.
m_ece_season <- lmer(Post_ECe_0_30 ~ Treatment*Hardpan_Class + Treatment*Season_ID + Baseline_ECe_0_30 + (1|Block_ID), data=dat, REML=TRUE)
m_yld_season <- lmer(Log_Yield ~ Treatment*Hardpan_Class + Treatment*Season_ID + (1|Block_ID), data=dat, REML=TRUE)
m_wat_season <- lmer(Leaching_Water_mm ~ Treatment*Hardpan_Class + Treatment*Season_ID + (1|Block_ID), data=dat, REML=TRUE)
season_ece <- get_ci(contrast(emmeans(m_ece_season, ~Treatment, weights="equal"), hu))
season_yld <- get_ci(contrast(emmeans(m_yld_season, ~Treatment, weights="equal"), hu)); season_yld$ratio <- exp(season_yld$estimate); season_yld$ratio_low <- exp(season_yld$lower.CL); season_yld$ratio_high <- exp(season_yld$upper.CL)
season_wat <- get_ci(contrast(emmeans(m_wat_season, ~Treatment, weights="equal"), hu))

# Planned Figure 6 depth-profile repeated models, expressed as paired post-minus-baseline change.
soil$Treatment <- factor(soil$Treatment, levels=c("U-FIELD","S-VR","H-VR")); soil$Season_ID <- factor(soil$Season_ID,levels=c("S1","S2")); soil$Block_ID <- factor(soil$Block_ID)
unit_hp <- unit[,c("Plot_ID","Hardpan_Class")]; soil <- merge(soil,unit_hp,by="Plot_ID",all.x=TRUE)
soil$Hardpan_Class <- factor(soil$Hardpan_Class,levels=c("H1","H2","H3"))
soil$Depth <- factor(paste0(soil$Depth_Top_cm,"-",soil$Depth_Bottom_cm), levels=c("0-15","15-30","30-60","60-90","90-120"), ordered=TRUE)
bl <- soil[soil$Sampling_Phase=="BASELINE",c("Plot_ID","Depth","ECe_dS_m","NO3_Stock_kg_ha")]; names(bl)[3:4] <- c("ECe_baseline","NO3_baseline")
po <- soil[soil$Sampling_Phase=="POST_LEACHING",c("Plot_ID","Depth","Treatment","Hardpan_Class","Season_ID","ECe_dS_m","NO3_Stock_kg_ha")]; names(po)[6:7] <- c("ECe_post","NO3_post")
prof <- merge(po,bl,by=c("Plot_ID","Depth")); prof$ECe_Change <- prof$ECe_post-prof$ECe_baseline; prof$NO3_Stock_Change <- prof$NO3_post-prof$NO3_baseline
stopifnot(nrow(prof)==990L)
m_prof_ece <- lmer(ECe_Change ~ Treatment*Hardpan_Class*Depth + Season_ID + (1|Plot_ID), data=prof, REML=TRUE)
m_prof_no3 <- lmer(NO3_Stock_Change ~ Treatment*Hardpan_Class*Depth + Season_ID + (1|Plot_ID), data=prof, REML=TRUE)
prof_ece_emm <- as.data.frame(emmeans(m_prof_ece, ~Treatment|Hardpan_Class*Depth))
prof_no3_emm <- as.data.frame(emmeans(m_prof_no3, ~Treatment|Hardpan_Class*Depth))
# Raw profile summaries for transparent plotting.
summary_stats <- function(x) c(n=sum(!is.na(x)), mean=mean(x,na.rm=TRUE), sd=sd(x,na.rm=TRUE), se=sd(x,na.rm=TRUE)/sqrt(sum(!is.na(x))))
raw_ece_prof <- aggregate(ECe_dS_m ~ Treatment+Hardpan_Class+Sampling_Phase+Depth, soil, summary_stats)
raw_no3_prof <- aggregate(NO3_Stock_kg_ha ~ Treatment+Hardpan_Class+Sampling_Phase+Depth, soil, summary_stats)
flatten_agg <- function(d, col) data.frame(d[1:4], n=d[[col]][,"n"], mean=d[[col]][,"mean"], sd=d[[col]][,"sd"], se=d[[col]][,"se"])
raw_ece_prof <- flatten_agg(raw_ece_prof,"ECe_dS_m"); raw_no3_prof <- flatten_agg(raw_no3_prof,"NO3_Stock_kg_ha")

# Diagnostics.
safe_shapiro <- function(m) shapiro.test(residuals(m))$p.value
fligner_p <- function(m,g) fligner.test(residuals(m) ~ g)$p.value
models <- list(ECe=m_ece,Yield_log=m_yld,Water=m_wat,NO3_below60=m_no3,Drainage_flux=m_flux,Profile_ECe=m_prof_ece,Profile_NO3=m_prof_no3)
groups <- list(dat$Treatment,dat$Treatment,dat$Treatment,dat$Treatment,flux$Treatment,prof$Treatment,prof$Treatment)
diag <- data.frame(model=names(models), singular=vapply(models,isSingular,logical(1),tol=1e-5), random_variance=vapply(models,function(m)as.data.frame(VarCorr(m))$vcov[1],numeric(1)), shapiro_p=vapply(models,safe_shapiro,numeric(1)), fligner_by_treatment_p=mapply(fligner_p,models,groups))

# Write verified outputs.
write.csv(ece_hu,file.path(out_dir,"primary_ece_NI.csv"),row.names=FALSE); write.csv(yld_hu,file.path(out_dir,"primary_yield_NI.csv"),row.names=FALSE); write.csv(wat_hu,file.path(out_dir,"gatekept_water.csv"),row.names=FALSE)
write.csv(no3_hu,file.path(out_dir,"nitrate_below60_primary.csv"),row.names=FALSE); write.csv(flux_hu,file.path(out_dir,"drainage_nitrate_flux.csv"),row.names=FALSE)
write.csv(hardpan_ece,file.path(out_dir,"ece_hardpan_contrasts.csv"),row.names=FALSE); write.csv(hardpan_yld,file.path(out_dir,"yield_hardpan_contrasts.csv"),row.names=FALSE); write.csv(hardpan_wat,file.path(out_dir,"water_hardpan_contrasts.csv"),row.names=FALSE)
write.csv(mech_ece,file.path(out_dir,"ece_mechanistic_holm.csv"),row.names=FALSE); write.csv(mech_yld,file.path(out_dir,"yield_mechanistic_holm.csv"),row.names=FALSE); write.csv(mech_wat,file.path(out_dir,"water_mechanistic_holm.csv"),row.names=FALSE); write.csv(mech_no3,file.path(out_dir,"nitrate_mechanistic_holm.csv"),row.names=FALSE)
write.csv(attain_total,file.path(out_dir,"ece_target_attainment_total.csv"),row.names=FALSE); write.csv(attain_hp,file.path(out_dir,"ece_target_attainment_by_hardpan.csv"),row.names=FALSE)
write.csv(rob_ece,file.path(out_dir,"sensitivity_clusterrobust_ece.csv"),row.names=FALSE); write.csv(rob_yld,file.path(out_dir,"sensitivity_clusterrobust_yield.csv"),row.names=FALSE); write.csv(rob_wat,file.path(out_dir,"sensitivity_clusterrobust_water.csv"),row.names=FALSE)
write.csv(season_ece,file.path(out_dir,"sensitivity_seasoninteraction_ece.csv"),row.names=FALSE); write.csv(season_yld,file.path(out_dir,"sensitivity_seasoninteraction_yield.csv"),row.names=FALSE); write.csv(season_wat,file.path(out_dir,"sensitivity_seasoninteraction_water.csv"),row.names=FALSE)
write.csv(prof_ece_emm,file.path(out_dir,"profile_ece_change_emmeans.csv"),row.names=FALSE); write.csv(prof_no3_emm,file.path(out_dir,"profile_no3_change_emmeans.csv"),row.names=FALSE); write.csv(raw_ece_prof,file.path(out_dir,"profile_ece_raw_summary.csv"),row.names=FALSE); write.csv(raw_no3_prof,file.path(out_dir,"profile_no3_raw_summary.csv"),row.names=FALSE)
write.csv(diag,file.path(diag_dir,"model_diagnostics.csv"),row.names=FALSE)

decisions <- data.frame(decision=c("ECe_noninferiority","Yield_noninferiority","Overall_coprimary","Water_superiority_gatekept"), pass=c(ece_pass,yld_pass,coprimary_pass,water_pass), criterion=c("upper 95% CI < +0.5 dS/m","lower 95% CI ratio > 0.95","both co-primary PASS","upper 95% CI difference < 0 after gate"))
write.csv(decisions,file.path(out_dir,"confirmatory_decisions.csv"),row.names=FALSE)

fmt <- function(x,d=4) formatC(x,format="f",digits=d)
report <- c(
  "# ASD KFU R 4.4.1 Analysis Summary — LOCKED",
  "", paste0("Execution environment: `",R.version.string,"`."),
  "", "## Confirmatory decisions",
  paste0("- ECe non-inferiority: **",ifelse(ece_pass,"PASS","FAIL"),"**; H-VR − U-FIELD = ",fmt(ece_hu$estimate[1])," dS m-1 (95% CI ",fmt(ece_hu$lower.CL[1])," to ",fmt(ece_hu$upper.CL[1]),")."),
  paste0("- Yield non-inferiority: **",ifelse(yld_pass,"PASS","FAIL"),"**; H-VR/U-FIELD = ",fmt(yld_hu$ratio[1])," (95% CI ",fmt(yld_hu$ratio_low[1])," to ",fmt(yld_hu$ratio_high[1]),")."),
  paste0("- Overall co-primary gate: **",ifelse(coprimary_pass,"PASS","FAIL"),"**."),
  paste0("- Gatekept water superiority: **",ifelse(water_pass,"PASS","FAIL"),"**; H-VR − U-FIELD = ",fmt(wat_hu$estimate[1],2)," mm (95% CI ",fmt(wat_hu$lower.CL[1],2)," to ",fmt(wat_hu$upper.CL[1],2),"); model-based water saving = ",fmt(water_saving_pct,2),"%."),
  "", "## Key secondary nitrate evidence",
  paste0("- Below-60-cm nitrate: H-VR − U-FIELD = ",fmt(no3_hu$estimate[1],3)," kg N ha-1 (95% CI ",fmt(no3_hu$lower.CL[1],3)," to ",fmt(no3_hu$upper.CL[1],3),")."),
  paste0("- Cumulative drainage nitrate flux: H-VR − U-FIELD = ",fmt(flux_hu$estimate[1],3)," kg N ha-1 (95% CI ",fmt(flux_hu$lower.CL[1],3)," to ",fmt(flux_hu$upper.CL[1],3),")."),
  "", "## Sensitivity",
  paste0("- Cluster-robust ECe: ",fmt(rob_ece$estimate[1])," (95% CI ",fmt(rob_ece$lower.CL[1])," to ",fmt(rob_ece$upper.CL[1]),")."),
  paste0("- Cluster-robust yield ratio: ",fmt(rob_yld$ratio[1])," (95% CI ",fmt(rob_yld$ratio_low[1])," to ",fmt(rob_yld$ratio_high[1]),")."),
  paste0("- Cluster-robust water: ",fmt(rob_wat$estimate[1],2)," mm (95% CI ",fmt(rob_wat$lower.CL[1],2)," to ",fmt(rob_wat$upper.CL[1],2),")."),
  "", "## Profile analysis",
  "- Paired post-minus-baseline depth-profile mixed models were completed for ECe and nitrate stock, with plot as the repeated random unit and treatment × hardpan × depth fixed structure.",
  "", "## Data lock and traceability",
  "- Authoritative workbook SHA-256: `a3c386909858e57ef4a00d7b288b11a287400e5823656cca9660bf051d14dd76`.",
  "- GitHub transfer can normalize line endings, so execution-input SHA-256 values are recorded rather than incorrectly compared to pre-transfer byte hashes.",
  "- Semantic checks verified row counts, plot IDs/mapping, treatment balance, and numeric column checksums against the locked workbook export.",
  "", "## Session information", "See `diagnostics/sessionInfo.txt`."
)
writeLines(report,file.path(out_dir,"ASD_ANALYSIS_SUMMARY_v1_LOCKED.md"))
sink(file.path(diag_dir,"sessionInfo.txt")); print(sessionInfo()); sink()
cat(paste(report,collapse="\n"),"\n")