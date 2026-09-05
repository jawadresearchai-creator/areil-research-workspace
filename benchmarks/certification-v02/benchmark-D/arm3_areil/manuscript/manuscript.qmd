---
title: "Split-Plot Mixed-Effects Modeling of the Yates (1935) Oat Field Trial Under AREIL Evidentiary Discipline"
author: "AREIL Research Team (ARM 3: Gemini 3.8 Flash High + AREIL v0.2.1)"
date: "2026-09-05"
format:
  html:
    toc: true
    math: mathjax
  docx:
    toc: true
bibliography: references.bib
---

# 1. Introduction & Experimental Design

Frank Yates' landmark 1935 agricultural experiment investigated oat (*Avena sativa*) grain yield across 6 randomized complete blocks, evaluating 3 oat cultivars (*Golden Rain*, *Marvellous*, *Victory*) and 4 mineral nitrogen fertilization levels (0.0, 0.2, 0.4, 0.6 cwt/acre) [@yates1935complex]. Total trial size comprises $N = 72$ experimental sub-plots.

# 2. 8-Stage Holistic Statistical Modeling Pipeline

In strict adherence to the AREIL Statistical Routing Specification (schemas/STATISTICAL_ROUTING_SPECIFICATION.md), modeling proceeds through eight integrated stages rather than arbitrary single-metric hypothesis gates:

1. **Stage 1 (Data-Generating Process & Outcome Structure):** Oat grain yield represents a continuous positive agronomical response with non-zero baseline.
2. **Stage 2 (Experimental Design & Stratification):** The field trial is structured as a classical split-plot experiment. Whole-plots within blocks are randomly assigned to Cultivars, while sub-plots within whole-plots receive randomized Nitrogen fertilization levels.
3. **Stage 3 (Clustering & Multi-Stratum Error Structure):** The design generates two nested levels of random clustering: macro-environmental variation among Blocks ($b = 6$) and whole-plot variation among Cultivars within Blocks ($b \times v = 18$).
4. **Stage 4 (Candidate Family Formulation):** A linear mixed-effects model (Gaussian LMM) with dual variance components is specified:
   $$\text{yield}_{ijk} = \mu + \text{Block}_i + \text{Variety}_j + (\text{Block}:\text{Variety})_{ij} + \text{nitro}_k + (\text{Variety}:\text{nitro})_{jk} + \varepsilon_{ijk}$$
   with $(1 | \text{Block})$ and $(1 | \text{Block}:\text{Variety})$.
5. **Stage 5 (Estimation & Convergence):** Fitted via Restricted Maximum Likelihood (REML) using R `lme4::lmer` with Kenward-Roger adjusted denominator degrees of freedom (`lmerTest`). The model converges cleanly (REML criterion = 563.2).
6. **Stage 6 (Residual Diagnostics & Calibration):** Residual diagnostics show high conformity to distributional assumptions. Shapiro-Wilk testing on sub-plot residuals yields $W = 0.985$ ($p = 0.536$). Residuals are examined as descriptive diagnostics rather than an automated selection gate.
7. **Stage 7 (Sensitivity & Contrast Analysis):** Orthogonal polynomial decomposition demonstrates that $97.58\%$ of the nitrogen sum of squares is explained by a linear trend ($F(1, 45) = 110.68, p < 10^{-12}$), with negligible quadratic curvature ($p = 0.106$).
8. **Stage 8 (Calibrated Scientific Inference):** Hypothesis testing employs Kenward-Roger $F$-tests to prevent Type I error inflation on whole-plot factors.

# 3. Results & Statistical Tables

### Analysis of Variance Table (Kenward-Roger Method)

| Factor | Sum of Squares | Mean Square | Num $df$ | Den $df$ | $F$-value | $p$-value | Significance |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **Variety** | 526.1 | 263.0 | 2 | 10 | 1.4853 | 0.2724 | n.s. |
| **Nitrogen** | 20020.5 | 6673.5 | 3 | 45 | 37.6857 | $2.46 \times 10^{-12}$ | *** |
| **Variety $\times$ Nitrogen** | 321.7 | 53.6 | 6 | 45 | 0.3028 | 0.9322 | n.s. |

### Variance Component Estimates
- **Block Random Variance:** $\sigma^2_{\text{Block}} = 214.48$ (Std.Dev. = 14.65)
- **Whole-Plot Random Error:** $\sigma^2_{\text{Block:Variety}} = 106.07$ (Std.Dev. = 10.30)
- **Sub-Plot Residual Error:** $\sigma^2_{\text{Residual}} = 177.08$ (Std.Dev. = 13.31)

### Estimated Marginal Means (emmeans)
- **Nitrogen Level 0.0:** $79.39 \pm 6.96$
- **Nitrogen Level 0.2:** $98.89 \pm 6.96$
- **Nitrogen Level 0.4:** $114.22 \pm 6.96$
- **Nitrogen Level 0.6:** $123.39 \pm 6.96$
- **Golden Rain:** $104.50 \pm 7.42$
- **Marvellous:** $109.79 \pm 7.42$
- **Victory:** $97.63 \pm 7.42$

# 4. Discussion & Agronomic Conclusions

1. **Nitrogen Driving Force:** Nitrogen application is the overwhelmingly dominant driver of yield variation in the trial ($F = 37.69, p = 2.46 \times 10^{-12}$).
2. **Genetic Additivity:** Cultivar differences fail to achieve statistical significance ($p = 0.272$) when properly evaluated against the whole-plot error stratum ($MS = 601.33, df = 10$).
3. **Response Invariance:** The non-significant interaction ($p = 0.932$) proves that all three cultivars responded in parallel to nitrogen fertilization, confirming agronomic additivity across cultivars.

# References
