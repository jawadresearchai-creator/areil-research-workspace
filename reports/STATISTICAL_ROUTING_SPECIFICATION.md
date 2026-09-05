# AREIL Statistical Modeling & Routing Specification

**Version:** 2.2.0  
**Status:** Canonical Requirement  

---

## 1. Universal Statistical Decision Pipeline

Statistical models must never be selected by a single arbitrary hypothesis test threshold (such as Shapiro-Wilk W > 0.95), nor by automatic default to random effects regardless of design. Instead, every analysis must proceed through the following rigorous 8-stage pipeline:

```
1. OUTCOME / DATA-GENERATING PROCESS
         │
         ▼
2. EXPERIMENTAL DESIGN & RANDOMIZATION
         │
         ▼
3. DEPENDENCE / HIERARCHY / MEASUREMENT STRUCTURE
         │
         ▼
4. CANDIDATE MODEL FAMILY (LM/GLS vs LMM vs GLM/GLMM)
         │
         ▼
5. MODEL FIT & ESTIMATION
         │
         ▼
6. HOLISTIC DIAGNOSTICS (COLLECTIVE EVALUATION)
         │
         ▼
7. SENSITIVITY / ALTERNATIVE SPECIFICATIONS
         │
         ▼
8. INFERENCE & UNCERTAINTY REPORTING
```

---

## 2. Stage Breakdown

### Stage 1: Outcome / Data-Generating Process
* Identify the response variable type and physical/biological bounds:
  * **Continuous, approximately symmetric:** e.g., root length (mm), shoot biomass (mg), enzyme velocity.
  * **Counts / Discrete Non-negative:** e.g., lateral root count, lesion count, insect visits. Candidate families: Poisson, Quasi-Poisson, or Negative Binomial.
  * **Binary / Proportions / Binomial:** e.g., germination success (0/1), survival rate (k/n). Candidate family: Binomial / Logistic.
  * **Zero-Inflated:** e.g., pathogen spore counts with excess true zeros. Candidate families: Zero-Inflated Poisson (ZIP) or Hurdle models.
  * **Censored / Time-to-Event:** e.g., days to germination or flowering. Candidate families: Cox proportional hazards or parametric survival models.
  * **Bounded Continuous / Proportions (0, 1):** e.g., percentage canopy cover. Candidate families: Beta regression or logit-transformed linear models.

### Stage 2: Experimental Design & Randomization
* Identify the randomization unit, treatment allocation structure, and physical layout:
  * **Completely Randomized Design (CRD):** Single error stratum, no physical grouping of experimental units.
  * **Randomized Complete Block Design (RCBD):** Blocking factor captures nuisance spatial or temporal variation.
  * **Split-Plot / Strip-Plot Design:** Multi-stratum error structure (whole-plots randomized to whole-plot factors; sub-plots nested within whole-plots randomized to sub-plot factors).
  * **Repeated Measures / Longitudinal Tracking:** Multiple observations on the same subject or plot over time.

### Stage 3: Dependence, Hierarchy & Measurement Structure
* Establish the dependence structure from physical design, not merely data post-hoc:
  * **Authority of Design:** The actual experimental design, randomization structure, sampling hierarchy, measurement structure, and estimand are authoritative.
  * **Role of ICC:** The Intraclass Correlation Coefficient (ICC) provides descriptive diagnostic information about variance partitioning across clusters. However, ICC does **NOT** determine whether random effects exist; design structure governs model formulation.
  * **Distinguish Strata:** Distinguish crossed vs. nested error structures (e.g., `(1 | Block) + (1 | Block:Variety)` in split-plot designs).

### Stage 4: Candidate Model Family Formulation
Model selection reflects both outcome distribution (Stage 1) and dependency structure (Stages 2 & 3):

* **Continuous Gaussian Outcome + Independent Observations / No Hierarchy:**
  * Route to **Ordinary Least Squares (LM)**: `stats::lm(y ~ treatment, data = df)`.
  * If heteroscedasticity across treatment groups is present without clustering, route to **Generalized Least Squares (GLS)**: `nlme::gls(y ~ treatment, weights = varIdent(form = ~ 1 | treatment))`.
  * *Never default automatically to `lmer` when observations are independent and unclustered.*

* **Continuous Gaussian Outcome + Blocking / Clustering / Hierarchy / Repeated Structure:**
  * Route to **Linear Mixed-Effects Model (LMM)**: `lme4::lmer(y ~ treatment + (1 | cluster), data = df)`.
  * For split-plot designs: `lme4::lmer(yield ~ Variety * nitro + (1 | Block) + (1 | Block:Variety))`.
  * Evaluate fixed effects using **Kenward-Roger** or **Satterthwaite** adjusted degrees of freedom (`lmerTest::anova(model, ddf = "Kenward-Roger")`) to prevent whole-plot test statistic inflation.

* **Non-Gaussian Outcomes (Counts, Binomial, Bounded):**
  * Independent: **GLM** (`stats::glm`).
  * Clustered / Hierarchical: **GLMM** (`lme4::glmer` or `glmmTMB`).

### Stage 5: Model Fit & Estimation
* Fit LMMs using REML (Restricted Maximum Likelihood) for unbiased variance component estimation; use ML when comparing models with differing fixed effects via likelihood ratio tests.
* Inspect optimizer convergence, singular fit warnings (`isSingular()`), and boundary estimates.

### Stage 6: Holistic Diagnostics (Collective Evaluation)
Do NOT rely on Shapiro-Wilk p-values as a universal selection gate. Evaluate model adequacy collectively:
1. **Residual vs. Fitted Plot:** Inspect for non-linearity, curvature, and heteroscedasticity (funneling).
2. **Quantile-Quantile (Q-Q) Plot:** Evaluate heavy tails, skewness, and extreme departures from the theoretical distribution.
3. **Random-Effects Distribution:** Check Q-Q plots of Best Linear Unbiased Predictors (BLUPs / random intercepts and slopes).
4. **Influential Observations:** Inspect Cook's distance, leverage, and dfbetas.
5. **Shapiro-Wilk Test:** May be reported as one descriptive diagnostic, but:
   * It is **never** a universal gate.
   * `W > 0.95` is **not** an automatic validity threshold.
   * p-values are sample-size dependent (overly sensitive at large N, underpowered at small N).
   * GLMM selection is **never** triggered solely by Shapiro-Wilk rejection.

### Stage 7: Sensitivity & Alternative Specifications
* Compare candidate specifications:
  * Heteroscedastic weighting (`nlme::gls` or `nlme::lme` with `varIdent()`).
  * Transformation (log, Box-Cox) vs. Generalized Linear Mixed Model (GLMM).
  * Robust standard errors (cluster-robust sandwich estimators via `clubSandwich`).

### Stage 8: Inference & Uncertainty Reporting
* Report:
  * Effect sizes with exact 95% confidence intervals.
  * Adjusted degrees of freedom (Satterthwaite or Kenward-Roger).
  * Multiple comparison adjustments (Tukey HSD, Dunnett) via `emmeans`.
  * Random effect variance components ($\sigma^2_{\text{cluster}}$, $\sigma^2_{\text{residual}}$) and design-based standard errors of differences (SED).
