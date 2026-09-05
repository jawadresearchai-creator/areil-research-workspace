# STATISTICAL ANALYSIS PLAN

**Pipeline:** AREIL 8-Stage Holistic Statistical Modeling Pipeline  
**Software:** R version 4.6.1 (64-bit) with packages `lme4`, `lmerTest`, `emmeans`, `pbkrtest`, `ggplot2`  
**Execution Script:** `analysis/scripts/run_wheat_priming_lmm.R`  
**Results File:** `analysis/results/priming_lmm_results.json`

## Stage 1: Outcome & Data-Generating Process (DGP)
- Primary Outcome: Arbuscular Mycorrhizal Colonization (% root length colonized). Continuous percentage bounded in [0, 100].
- Secondary Outcomes:
  - *TaPT4* relative expression (continuous positive fold-change, log-normal or normal approximation);
  - Shoot phosphorus concentration (continuous positive concentration in mg/g DW).
- Data-generating mechanism: Biological interaction among host genetics, nutrient regimes, and physical barrier permeability across 4 environmental blocks.

## Stage 2: Experimental Design Structure
- Balanced 4-Block Randomized Complete Block Design (RCBD) factorial trial:
  - Factor A: Donor Regime (3 levels: `P_Starved`, `P_Replete`, `P_Starved_Tis108`)
  - Factor B: Barrier Mode (3 levels: `M0_Solid`, `M1_Membrane`, `M2_Mesh`)
  - Factor C: Recipient Genotype (2 levels: `WT`, `Tad14_mutant`)
  - Factor D (Blocking): Block (4 levels: growth chambers 1, 2, 3, 4)
  - Replication: n = 6 seedlings per block-treatment combination (Total N = 432 observations).

## Stage 3: Clustering & Error Stratification
- Observations within the same environmental growth chamber (Block) share micro-environmental variances (temperature gradients, irradiance homogeneity).
- Hierarchy: Seedlings nested within treatment-by-block cells. Block treated as a random intercept: `(1 | block)`.

## Stage 4: Candidate Model Formulation
`Outcome ~ donor_regime * barrier_mode * recipient_genotype + (1 | block)`

## Stage 5: Fitting & Convergence Criteria
- Estimation: Restricted Maximum Likelihood (REML).
- Convergence: Checked via `lme4` optimizer diagnostics; zero singular boundary warnings; positive definite Hessian.

## Stage 6: Holistic Model Diagnostics
- Residual normality: Shapiro-Wilk test on model residuals (alpha = 0.05 threshold for flagging; visual Q-Q inspection).
- Homoscedasticity: Residuals vs. fitted values inspection across treatment cells.
- Variance partitioning: Block variance, residual variance, and Intraclass Correlation Coefficient (ICC).

## Stage 7: Sensitivity & Model Comparison
- Comparison with unblocked fixed-effects Ordinary Least Squares (OLS) via Akaike Information Criterion (AIC).
- Delta AIC > 10 demonstrates necessity of block random effect.

## Stage 8: Calibrated Inference & Planned Contrasts
- Degrees of freedom: Kenward-Roger approximation (`ddf = "Kenward-Roger"`).
- Multiplicity control: Planned orthogonal and hypothesis-driven contrasts via `emmeans`:
  1. `Diffusible_Priming`: M1_Membrane WT: P_Starved vs. P_Replete.
  2. `Hyphal_Amplification`: P_Starved WT: M2_Mesh vs. M1_Membrane.
  3. `Tis108_Abolition`: M1_Membrane WT: P_Starved vs. P_Starved_Tis108.
  4. `Receptor_Dependency_M1`: M1_Membrane P_Starved: WT vs. Tad14_mutant.
  5. `Receptor_Dependency_M2`: M2_Mesh P_Starved: WT vs. Tad14_mutant.
  6. `Barrier_Hermeticity`: M0_Solid WT: P_Starved vs. P_Replete (verification of zero chemical leakage).
