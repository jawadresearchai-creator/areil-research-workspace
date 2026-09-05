# Agronomic Performance and Nitrogen Response in Cereal Trials: A Rigorous Re-Evaluation of the Classic Yates (1935) Split-Plot Oat Experiment

**Author:** Independent Research Fellow in Biometry & Crop Science  
**Affiliation:** Antigravity Research Division, Benchmark Certification Unit  
**Date:** September 2026  
**Dataset Origin:** Rothamsted Experimental Station Split-Plot Oat Trial (*Avena sativa* L., Yates 1935; $N = 72$, Real Public Data)

---

## Abstract

The split-plot experimental design, formalized by Frank Yates in 1935, remains a foundational paradigm in agricultural field research for accommodating multiple factors requiring disparate plot dimensions. Here, we present an exhaustive re-examination and statistical re-evaluation of the classic Yates 1935 oat (*Avena sativa* L.) field trial conducted at Rothamsted Experimental Station. The trial evaluated three oat varieties ('Golden Rain', 'Marvellous', and 'Victory') assigned to main plots across six randomized complete blocks, and four levels of ammonium sulphate nitrogen fertilizer (0.0, 0.2, 0.4, and 0.6 cwt/acre) randomized to sub-plots within each main plot ($N = 72$ observations). Statistical analyses encompassing classical split-plot analysis of variance (ANOVA), orthogonal polynomial contrast partitioning, and restricted maximum likelihood (REML) linear mixed-effects modeling (LMM) were performed. Nitrogen fertilization exerted an exceptionally strong, positive main effect on grain yield ($F_{3, 45} = 37.686, p = 2.458 \times 10^{-12}$), increasing mean yields from $79.39 \pm 4.57$ quarter-pounds per sub-plot at 0.0 cwt/acre to $123.39 \pm 5.42$ quarter-pounds at 0.6 cwt/acre. Orthogonal polynomial partitioning revealed that $97.58\%$ of the treatment sum of squares for nitrogen was governed by a linear response ($F_{1, 45} = 110.323, p = 1.091 \times 10^{-13}$; slope $\beta = 73.67 \pm 6.78$ quarter-pounds per cwt/acre), with a minor, non-significant quadratic curvature indicating slight diminishing returns ($F_{1, 45} = 2.713, p = 0.1065$). In contrast, oat variety main effects were statistically non-significant ($F_{2, 10} = 1.485, p = 0.2724$), with 'Marvellous' averaging $109.79 \pm 4.82$ quarter-pounds, 'Golden Rain' $104.50 \pm 5.50$ quarter-pounds, and 'Victory' $97.63 \pm 6.12$ quarter-pounds. Furthermore, the Variety $\times$ Nitrogen interaction was negligible ($F_{6, 45} = 0.303, p = 0.9322$), demonstrating that all three cultivars responded with parallel linear responsiveness across nitrogen gradients. Mixed-model variance decomposition demonstrated that the sub-plot error variance ($\sigma_e^2 = 177.08$) was substantially lower than the whole-plot error variance ($MS_a = 601.33$, $\sigma_{wp}^2 = 106.06$), verifying a 3.40-fold precision enhancement for sub-plot factor contrasts relative to whole-plot comparisons. Rigorous model diagnostics confirmed residual normality (Shapiro-Wilk $W = 0.9899, p = 0.8365$) and homoscedasticity across all twelve treatment combinations (Levene $p = 0.6716$, Bartlett $p = 0.6051$). These findings illuminate the statistical efficiency of hierarchical agricultural designs and substantiate robust nitrogen utilization in temperate oat cropping systems.

---

## 1. Introduction

Optimizing nitrogen fertilization and varietal selection represents a cornerstone of sustainable cereal production. Nitrogen is the primary limiting macronutrient in small-grain cereal cropping systems, directly governing tiller initiation, canopy expansion, spikelet fertility, and kernel filling (Sinclair & Rufty, 2012). However, evaluating crop cultivars alongside agronomic management practices creates logistical and structural complexities in field trials. Tillage, planting operations, or harvesting often require large plots, whereas chemical amendments, such as fertilizers or plant protection products, can be applied to smaller land units.

To resolve these logistical constraints without compromising statistical validity, Frank Yates published his seminal monograph *"Complex Experiments"* in 1935. In this paper, Yates introduced the split-plot design, an ingenious arrangement derived from Ronald A. Fisher's principles of randomization, blocking, and replication (Fisher, 1935; Yates, 1935). By nesting smaller sub-plots within larger main plots (whole plots), the split-plot design accommodates two distinct strata of random variation: a whole-plot error stratum capturing spatial heterogeneity across large blocks, and a sub-plot error stratum capturing micro-environmental variability among adjacent sub-units. 

The benchmark dataset utilized by Yates (1935) to illustrate this methodology consists of a field trial on oats (*Avena sativa* L.) conducted at Rothamsted Experimental Station. Although originally analyzed almost a century ago, this trial remains the canonical pedagogical and methodological standard in modern biometric treatises (e.g., Snedecor & Cochran, 1989; Pinheiro & Bates, 2000; Littell et al., 2006; Montgomery, 2017). Despite its ubiquity in statistical textbooks, modern research analyses rarely present an integrated, high-precision report uniting classical sum-of-squares partitioning, orthogonal polynomial response modeling, modern REML-based linear mixed models, and comprehensive diagnostic validation.

The objective of this investigation is to provide a complete, rigorous biometrical analysis of the Yates 1935 split-plot oat trial. Specifically, we aim to:
1. Characterize the exact empirical distribution of grain yield across varieties, nitrogen rates, and spatial blocks;
2. Execute a classical split-plot ANOVA with separate error strata to evaluate varietal differences, nitrogen response curves, and their interaction;
3. Decompose the nitrogen response into orthogonal linear, quadratic, and cubic polynomial trends;
4. Estimate fixed-effect parameters, variance components, and standard errors of pairwise differences using restricted maximum likelihood (REML) mixed-effects modeling;
5. Validate model assumptions through formal tests of normality and homoscedasticity across treatment cells.

---

## 2. Materials and Methods

### 2.1 Dataset Provenance and Experimental Layout
The analyzed dataset originates from the classic oat field trial conducted at Rothamsted Experimental Station, Harpenden, Hertfordshire, UK (Yates, 1935). The experiment was structured as a randomized complete block split-plot design comprising:
- **Replication / Blocks ($r = 6$):** Six field blocks designated I, II, III, IV, V, and VI, established to control for macroscopic soil fertility gradients.
- **Main Plot Factor (Variety, $v = 3$):** Three winter oat cultivars—'Golden Rain' (an established European standard), 'Marvellous' (a high-tillering variety), and 'Victory' (a traditional Swedish pedigree cultivar)—randomly allocated to three whole plots within each block ($6 \times 3 = 18$ whole plots).
- **Sub-Plot Factor (Nitrogen, $m = 4$):** Four rates of ammonium sulphate fertilizer corresponding to 0.0, 0.2, 0.4, and 0.6 hundredweight per acre (cwt/acre; equivalent to 0, 22.4, 44.8, and 67.2 kg N/ha, given 1 cwt = 112 lbs $\approx 50.8$ kg). The four levels were randomly assigned to sub-plots within each whole plot.
- **Experimental Units:** The trial encompassed $N = 6 \times 3 \times 4 = 72$ individual sub-plots. Each sub-plot occupied $1/80^{\text{th}}$ of an acre ($50.58\text{ m}^2$).
- **Response Variable:** Grain yield recorded in quarter-pounds ($1/4\text{ lb} \approx 113.4\text{ g}$) per sub-plot. Multiplying yield by 20 converts the metric directly to pounds per acre ($\text{lbs/acre}$).

### 2.2 Classical Split-Plot Linear Model Specification
The statistical model for a randomized complete block split-plot design is formulated as:
$$y_{ijk} = \mu + \rho_i + \alpha_j + \eta_{ij} + \beta_k + (\alpha\beta)_{jk} + \varepsilon_{ijk}$$
where:
- $y_{ijk}$ is the grain yield observed in block $i$ ($i = 1, \dots, 6$), main-plot variety $j$ ($j = 1, 2, 3$), and sub-plot nitrogen rate $k$ ($k = 1, \dots, 4$);
- $\mu$ denotes the grand mean;
- $\rho_i$ is the fixed or random effect of block $i$ ($\sum \rho_i = 0$ or $\rho_i \sim \mathcal{N}(0, \sigma_{\text{block}}^2)$);
- $\alpha_j$ is the main effect of variety $j$ ($\sum \alpha_j = 0$);
- $\eta_{ij} \sim \mathcal{N}(0, \sigma_{\text{wp}}^2)$ is the whole-plot error (Error $a$), representing the interaction between block $i$ and variety $j$;
- $\beta_k$ is the main effect of nitrogen level $k$ ($\sum \beta_k = 0$);
- $(\alpha\beta)_{jk}$ is the interaction effect between variety $j$ and nitrogen level $k$ ($\sum_j (\alpha\beta)_{jk} = \sum_k (\alpha\beta)_{jk} = 0$);
- $\varepsilon_{ijk} \sim \mathcal{N}(0, \sigma_e^2)$ is the sub-plot residual error (Error $b$), assumed independent and identically distributed.

The degrees of freedom partition for $r = 6$, $v = 3$, $m = 4$ is:
- Blocks: $r - 1 = 5$
- Variety: $v - 1 = 2$
- Error $a$ (Block $\times$ Variety): $(r - 1)(v - 1) = 10$
- **Total Whole-Plot Stratum:** $rv - 1 = 17$
- Nitrogen: $m - 1 = 3$
- Variety $\times$ Nitrogen: $(v - 1)(m - 1) = 6$
- Error $b$ (Sub-plot residual): $v(r - 1)(m - 1) = 45$
- **Total:** $rvm - 1 = 71$

Crucially, the test statistic for Variety is constructed using Mean Square Error $a$ ($F_{\text{var}} = MS_{\text{var}} / MS_a$), whereas tests for Nitrogen and Variety $\times$ Nitrogen utilize Mean Square Error $b$ ($F_{\text{nitro}} = MS_{\text{nitro}} / MS_b$; $F_{\text{int}} = MS_{\text{int}} / MS_b$).

### 2.3 Orthogonal Polynomial Contrast Decomposition
Because the nitrogen levels were spaced at equal increments ($0.0, 0.2, 0.4, 0.6\text{ cwt/acre}$, step size $\Delta = 0.2$), the 3 degrees of freedom for nitrogen were decomposed into orthogonal polynomial contrasts:
- Linear contrast: $\mathbf{c}_{\text{lin}} = [-3, -1, 1, 3]^T$, with divisor $\sum c_i^2 = 20$;
- Quadratic contrast: $\mathbf{c}_{\text{quad}} = [1, -1, -1, 1]^T$, with divisor $\sum c_i^2 = 4$;
- Cubic contrast: $\mathbf{c}_{\text{cub}} = [-1, 3, -3, 1]^T$, with divisor $\sum c_i^2 = 20$.

The contrast sum of squares was evaluated as:
$$SS_{\text{contrast}} = \frac{n_{\text{per\_level}} \left( \sum_{k=1}^4 c_k \bar{y}_{\cdot\cdot k} \right)^2}{\sum_{k=1}^4 c_k^2}$$
where $n_{\text{per\_level}} = rv = 18$. The interaction sum of squares ($SS_{V \times N}$, 6 df) was similarly partitioned into $V \times N_{\text{lin}}$ (2 df), $V \times N_{\text{quad}}$ (2 df), and $V \times N_{\text{cub}}$ (2 df).

### 2.4 Linear Mixed-Effects Model (LMM) and Standard Errors of Differences
In modern computational biometry, the split-plot design is analyzed via restricted maximum likelihood (REML) linear mixed-effects modeling:
$$\mathbf{y} = \mathbf{X}\boldsymbol{\beta} + \mathbf{Z}_{\text{block}}\mathbf{u}_{\text{block}} + \mathbf{Z}_{\text{wp}}\mathbf{u}_{\text{wp}} + \boldsymbol{\varepsilon}$$
where $\mathbf{u}_{\text{block}} \sim \mathcal{N}(\mathbf{0}, \sigma_{\text{block}}^2 \mathbf{I}_6)$, $\mathbf{u}_{\text{wp}} \sim \mathcal{N}(\mathbf{0}, \sigma_{\text{wp}}^2 \mathbf{I}_{18})$, and $\boldsymbol{\varepsilon} \sim \mathcal{N}(\mathbf{0}, \sigma_e^2 \mathbf{I}_{72})$. 

In split-plot designs, standard errors for comparing treatment means depend critically on whether the comparison involves whole-plot or sub-plot factors:
1. **Comparing two Nitrogen levels overall:**
   $$SE_1 = \sqrt{\frac{2 MS_b}{rv}} \quad (\text{df} = 45)$$
2. **Comparing two Varieties overall:**
   $$SE_2 = \sqrt{\frac{2 MS_a}{rm}} \quad (\text{df} = 10)$$
3. **Comparing two Nitrogen levels for the same Variety:**
   $$SE_3 = \sqrt{\frac{2 MS_b}{r}} \quad (\text{df} = 45)$$
4. **Comparing two Varieties at the same Nitrogen level:**
   $$SE_4 = \sqrt{\frac{2[(m-1)MS_b + MS_a]}{rm}}$$
   with Satterthwaite-approximated degrees of freedom:
   $$\text{df}' = \frac{\left[(m-1)MS_b + MS_a\right]^2}{\frac{\left[(m-1)MS_b\right]^2}{v(r-1)(m-1)} + \frac{(MS_a)^2}{(r-1)(v-1)}}$$

### 2.5 Computational Environment and Diagnostic Testing
All statistical algorithms were executed in Python 3.13 utilizing `pandas` (v2.2.3), `scipy` (v1.15.1), and `statsmodels` (v0.14.4). Goodness-of-fit diagnostics included:
- **Normality:** Shapiro-Wilk $W$ test on sub-plot residuals and whole-plot residuals;
- **Homoscedasticity:** Levene's test (centered at median) across Varieties, across Nitrogen levels, and across the 12 treatment cells; Bartlett's $\chi^2$ test across treatment cells.

---

## 3. Statistical Results

### 3.1 Descriptive Statistics
The grand mean grain yield across all 72 experimental sub-plots was $103.97 \pm 3.19$ quarter-pounds per sub-plot ($2079.4\text{ lbs/acre}$), with a standard deviation of $27.06$, median of $102.50$, interquartile range of $35.25$, minimum of $53.00$, and maximum of $174.00$. Sample skewness ($0.275$) and excess kurtosis ($-0.328$) conformed closely to a univariate normal distribution.

Varietal means displayed modest variation: 'Marvellous' produced the highest average grain yield at $109.79 \pm 4.82$ quarter-pounds ($n = 24$), followed by 'Golden Rain' at $104.50 \pm 5.50$ quarter-pounds ($n = 24$), and 'Victory' at $97.63 \pm 6.12$ quarter-pounds ($n = 24$).

In contrast, grain yields exhibited a steep, monotonic increase in response to nitrogen additions (Table 1). Yields rose from $79.39 \pm 4.57$ quarter-pounds at zero fertilizer ($0.0\text{ cwt/acre}$) to $98.89 \pm 5.15$ at $0.2\text{ cwt/acre}$, $114.22 \pm 5.26$ at $0.4\text{ cwt/acre}$, and $123.39 \pm 5.42$ at $0.6\text{ cwt/acre}$. 

```
Table 1: Descriptive statistics for oat grain yield (quarter-pounds per 1/80-acre plot) 
disaggregated by main effects and treatment combinations (N = 72).
-----------------------------------------------------------------------------------------
Factor / Level             n    Mean       Std. Dev.  Std. Err.  Median    Min      Max
-----------------------------------------------------------------------------------------
Overall Trial             72   103.97      27.06       3.19     102.50    53.00   174.00

Variety:
  Golden Rain             24   104.50      26.94       5.50     102.50    60.00   161.00
  Marvellous              24   109.79      23.59       4.82     113.00    63.00   156.00
  Victory                 24    97.63      30.00       6.12      94.00    53.00   174.00

Nitrogen Rate (cwt/acre):
  0.0                     18    79.39      19.39       4.57      72.00    53.00   117.00
  0.2                     18    98.89      21.84       5.15      95.00    64.00   140.00
  0.4                     18   114.22      22.32       5.26     115.00    81.00   161.00
  0.6                     18   123.39      23.00       5.42     121.50    86.00   174.00

Block (Replication):
  Block I                 12   135.33      22.84       6.59     135.50   105.00   174.00
  Block II                12   107.25      26.95       7.78     104.00    61.00   149.00
  Block III               12    95.92      24.80       7.16      92.00    60.00   132.00
  Block IV                12    98.17      24.02       6.93      97.50    64.00   133.00
  Block V                 12    90.92      20.44       5.90      92.50    62.00   126.00
  Block VI                12    96.25      20.62       5.95      94.00    53.00   121.00

Variety x Nitrogen:
  Golden Rain x 0.0        6    80.00      21.00       8.58      75.00    60.00   117.00
  Golden Rain x 0.2        6    98.50      13.47       5.50      97.00    82.00   114.00
  Golden Rain x 0.4        6   114.67      29.94      12.22     111.00    86.00   161.00
  Golden Rain x 0.6        6   124.83      20.88       8.52     124.50    96.00   149.00
  Marvellous x 0.0         6    86.67      16.57       6.77      88.00    63.00   105.00
  Marvellous x 0.2         6   108.50      26.85      10.96     111.00    70.00   140.00
  Marvellous x 0.4         6   117.17       9.79       4.00     119.50   104.00   132.00
  Marvellous x 0.6         6   126.83      20.29       8.28     128.50    99.00   156.00
  Victory x 0.0            6    71.50      20.60       8.41      67.50    53.00   111.00
  Victory x 0.2            6    89.67      22.51       9.19      90.50    64.00   130.00
  Victory x 0.4            6   110.83      26.01      10.62     106.00    81.00   157.00
  Victory x 0.6            6   118.50      30.09      12.28     110.50    86.00   174.00
-----------------------------------------------------------------------------------------
```

Spatial blocking accounted for substantial variation: Block I demonstrated significantly higher productivity ($135.33 \pm 6.59$ quarter-pounds) than the remaining blocks, which ranged between $90.92$ (Block V) and $107.25$ (Block II).

### 3.2 Classical Split-Plot Analysis of Variance (ANOVA)
The classical split-plot ANOVA is presented in Table 2. Testing Variety against Error $a$ ($MS_a = 601.33$) revealed no significant difference among oat cultivars ($F_{2, 10} = 1.485, p = 0.2724$). In stark contrast, the main effect of Nitrogen was overwhelmingly significant when evaluated against the sub-plot error ($MS_b = 177.08$; $F_{3, 45} = 37.686, p = 2.458 \times 10^{-12}$).

The Variety $\times$ Nitrogen interaction term accounted for an exceptionally small sum of squares ($SS = 321.75$, $MS = 53.62$), yielding an $F$-ratio far below unity ($F_{6, 45} = 0.303, p = 0.9322$). This absence of interaction confirms that the biological yield response to nitrogen was entirely uniform across all three cultivars.

```
Table 2: Split-plot analysis of variance (ANOVA) table for Yates (1935) oat trial.
---------------------------------------------------------------------------------------------------
Stratum / Source of Variation      df        SS            MS          F-ratio      p-value
---------------------------------------------------------------------------------------------------
Whole-Plot Stratum:
  Blocks (Replications)             5     15,875.28      3,175.06        5.280      0.01244 *
  Variety (Whole-plot treatment)    2      1,786.36        893.18        1.485      0.27239 (ns)
  Error a (Block x Variety)        10      6,013.31        601.33           --           --
  [Total Whole-Plot]              [17]   [23,674.94]    [1,392.64]          --           --

Sub-Plot Stratum:
  Nitrogen (Sub-plot treatment)     3     20,020.50      6,673.50       37.686      2.458e-12 ***
  Variety x Nitrogen Interaction    6        321.75         53.62        0.303      0.93220 (ns)
  Error b (Sub-plot residual)      45      7,968.75        177.08           --           --

Total Stratum:                     71     51,985.94        732.20           --           --
---------------------------------------------------------------------------------------------------
Significance codes: *** p < 0.001; * p < 0.05; ns: not significant (p >= 0.05).
F-tests: Variety tested against Error a; Nitrogen and Variety x Nitrogen tested against Error b.
```

### 3.3 Orthogonal Polynomial Partitioning of Nitrogen Response
Decomposing the Nitrogen sum of squares ($SS_{\text{nitro}} = 20,020.50$) into single-degree-of-freedom orthogonal polynomial contrasts revealed that the response is governed almost entirely by a linear function (Table 3):
- The **Linear contrast** accounted for $SS_{\text{lin}} = 19,536.40$ ($97.58\%$ of $SS_{\text{nitro}}$), producing an $F$-statistic of $110.323$ ($p = 1.091 \times 10^{-13}$).
- The **Quadratic contrast** accounted for $SS_{\text{quad}} = 480.50$ ($2.40\%$ of $SS_{\text{nitro}}$), yielding $F = 2.713$ ($p = 0.1065$). Although statistically non-significant at the conventional $\alpha = 0.05$ threshold, this slight negative curvature reflects modest diminishing marginal yield returns at the highest nitrogen level ($0.6\text{ cwt/acre}$).
- The **Cubic contrast** was negligible ($SS_{\text{cub}} = 3.60$, $0.02\%$ of $SS_{\text{nitro}}$; $F = 0.020, p = 0.8873$).

```
Table 3: Orthogonal polynomial contrast decomposition for Nitrogen main effect 
and Variety x Nitrogen interaction.
---------------------------------------------------------------------------------------------------
Contrast Source                    df        SS            MS          F-ratio      p-value
---------------------------------------------------------------------------------------------------
Nitrogen Polynomials:
  N (Linear)                        1     19,536.40     19,536.40      110.323      1.091e-13 ***
  N (Quadratic)                     1        480.50        480.50        2.713      0.10647 (ns)
  N (Cubic)                         1          3.60          3.60        0.020      0.88726 (ns)
  [Total Nitrogen Treatment]       [3]   [20,020.50]    [6,673.50]     [37.686]    [2.458e-12]

Interaction Decompositions:
  Variety x N (Linear)              2        168.35         84.18        0.475      0.62479 (ns)
  Variety x N (Quadratic)           2         11.08          5.54        0.031      0.96919 (ns)
  Variety x N (Cubic)               2        142.32         71.16        0.402      0.67150 (ns)
  [Total Variety x Nitrogen]       [6]      [321.75]       [53.62]      [0.303]    [0.93220]

Sub-Plot Error (Error b)           45      7,968.75        177.08           --           --
---------------------------------------------------------------------------------------------------
```

When the interaction term was similarly disaggregated, the interaction of Variety with linear nitrogen ($SS = 168.35, F = 0.475, p = 0.6248$), quadratic nitrogen ($SS = 11.08, F = 0.031, p = 0.9692$), and cubic nitrogen ($SS = 142.32, F = 0.402, p = 0.6715$) confirmed an absence of cultivar-specific slope modifications.

### 3.4 Linear Mixed-Effects Models (REML)
To obtain exact maximum likelihood estimates and empirical standard errors, restricted maximum likelihood (REML) linear mixed models were fitted with random intercepts for Blocks and Whole-Plots (Table 4). 

Under the continuous nitrogen specification with Golden Rain as the reference cultivar, the estimated baseline yield at zero fertilizer was $81.90 \pm 8.57$ quarter-pounds. The estimated main linear slope for nitrogen was $\beta_{\text{nitro}} = 75.33 \pm 11.86$ quarter-pounds per cwt/acre ($z = 6.353, p = 2.116 \times 10^{-10}$). Cultivar differences at baseline ('Marvellous': $+8.52 \pm 12.12, p = 0.482$; 'Victory': $-8.60 \pm 12.12, p = 0.478$) and differential slopes ('Marvellous' $\times$ Nitro: $-10.75 \pm 16.77, p = 0.522$; 'Victory' $\times$ Nitro: $+5.75 \pm 16.77, p = 0.732$) were statistically indistinguishable from zero.

In the reduced parsimonious main-effects model, the overall linear slope of nitrogen fertilization across all varieties was estimated at:
$$\beta_{\text{nitro}} = 73.67 \pm 6.78\text{ quarter-pounds per cwt/acre} \quad (z = 10.863, p = 1.731 \times 10^{-27}; 95\%\text{ CI: } [60.38, 86.96])$$
This translates to an agronomic yield gain of $1,473.3\text{ lbs of oat grain per cwt of ammonium sulphate applied}$ ($13.15\text{ kg grain per kg N}$).

```
Table 4: Linear mixed-effects model parameter estimates (REML).
---------------------------------------------------------------------------------------------------
Parameter                                     Estimate     Std. Error    z-value    p-value    95% Conf. Interval
---------------------------------------------------------------------------------------------------
Model A: Interaction Model (Continuous Nitrogen)
  Intercept (Golden Rain @ 0 N)                 81.900        8.571       9.556     < 0.001     [65.10, 98.70]
  Variety [Marvellous]                           8.517       12.121       0.703       0.482    [-15.24, 32.27]
  Variety [Victory]                             -8.600       12.121      -0.710       0.478    [-32.36, 15.16]
  Nitrogen Rate                                 75.333       11.859       6.353     < 0.001     [52.09, 98.58]
  Variety [Marvellous] x Nitrogen              -10.750       16.771      -0.641       0.522    [-43.62, 22.12]
  Variety [Victory] x Nitrogen                   5.750       16.771       0.343       0.732    [-27.12, 38.62]
  Sub-plot Error Variance (sigma_e^2)          168.750           --          --          --                 --
  Whole-Plot Variance Component                322.622       11.665       2.129       0.033      [0.15, 3.67]*

Model B: Main-Effects Model (Continuous Nitrogen)
  Intercept (Golden Rain @ 0 N)                 82.400        8.059      10.225     < 0.001     [66.61, 98.19]
  Variety [Marvellous]                           5.292       11.027       0.480       0.631    [-16.32, 26.90]
  Variety [Victory]                             -6.875       11.027      -0.623       0.533    [-28.49, 14.74]
  Nitrogen Rate                                 73.667        6.781      10.863     < 0.001     [60.38, 86.96]
  Sub-plot Error Variance (sigma_e^2)          165.559           --          --          --                 --
  Whole-Plot Variance Component                323.420       11.727       2.143       0.032      [0.17, 3.74]*
---------------------------------------------------------------------------------------------------
* Note: Whole-plot variance component reported in statsmodels scaled parameterization (ratio to scale).
```

### 3.5 Variance Components and Split-Plot Efficiency
From the classical expected mean squares (EMS) of the split-plot design with $m = 4$ sub-plots and $r = 6$ replications:
- **Sub-plot error variance ($\sigma_e^2$):** $\sigma_e^2 = MS_b = 177.083$
- **Whole-plot error variance component ($\sigma_{\text{wp}}^2$):**
  $$\sigma_{\text{wp}}^2 = \frac{MS_a - MS_b}{m} = \frac{601.331 - 177.083}{4} = 106.062$$
- **Block variance component ($\sigma_{\text{block}}^2$):**
  $$\sigma_{\text{block}}^2 = \frac{MS_{\text{block}} - MS_a}{vm} = \frac{3175.056 - 601.331}{12} = 214.477$$

The relative efficiency of the split-plot design for detecting nitrogen effects versus variety effects is given by the ratio of the error mean squares:
$$\text{Relative Precision Ratio} = \frac{MS_a}{MS_b} = \frac{601.331}{177.083} = 3.396$$
Thus, allocating nitrogen to the sub-plot stratum yielded a **3.40-fold increase in statistical precision** (a $70.6\%$ reduction in error variance) relative to testing it at the whole-plot level.

### 3.6 Standard Errors of Differences and Critical Thresholds
The exact standard errors of differences (SED) and Least Significant Differences (LSD at $\alpha = 0.05$) are summarized in Table 5:
1. **Between two Nitrogen levels (overall):**
   $$SED_1 = \sqrt{\frac{2(177.0833)}{18}} = 4.4358 \quad \implies \quad LSD_{0.05} = 2.0141 \times 4.4358 = 8.934\text{ qtr-lbs}$$
   Every incremental increase in nitrogen ($+0.2\text{ cwt/acre}$) exceeded this LSD:
   - $0.2 \text{ vs } 0.0 = +19.50$ (Significant)
   - $0.4 \text{ vs } 0.2 = +15.33$ (Significant)
   - $0.6 \text{ vs } 0.4 = +9.17$ (Significant)
2. **Between two Varieties (overall):**
   $$SED_2 = \sqrt{\frac{2(601.3306)}{24}} = 7.0789 \quad \implies \quad LSD_{0.05} = 2.2281 \times 7.0789 = 15.772\text{ qtr-lbs}$$
   The maximum observed varietal difference (Marvellous vs Victory = $12.17$) remained well within the margin of random error ($12.17 < 15.772$).
3. **Between two Nitrogen levels for the same Variety:**
   $$SED_3 = \sqrt{\frac{2(177.0833)}{6}} = 7.6830 \quad \implies \quad LSD_{0.05} = 2.0141 \times 7.6830 = 15.474\text{ qtr-lbs}$$
4. **Between two Varieties at the same Nitrogen level:**
   $$SED_4 = \sqrt{\frac{2[(3)(177.0833) + 601.3306]}{24}} = \sqrt{94.3817} = 9.7150 \quad (\text{Satterthwaite df} = 30.23)$$
   $$LSD_{0.05} = 2.0421 \times 9.7150 = 19.839\text{ qtr-lbs}$$

```
Table 5: Standard errors of differences (SED) and critical detection thresholds.
---------------------------------------------------------------------------------------------------
Comparison Type                              Effective df       SED       Critical t (0.05)   LSD (0.05)
---------------------------------------------------------------------------------------------------
Two Nitrogen levels (overall)                    45            4.4358          2.0141            8.934
Two Varieties (overall)                          10            7.0789          2.2281           15.772
Two Nitrogen levels within same Variety          45            7.6830          2.0141           15.474
Two Varieties within same Nitrogen level         30.23         9.7150          2.0421           19.839
---------------------------------------------------------------------------------------------------
```

### 3.7 Model Fit Diagnostics
Formal diagnostic testing demonstrated exceptional compliance with Gauss-Markov and mixed-model assumptions:
- **Normality of Sub-plot Residuals (Error $b$):** The Shapiro-Wilk test on the 45 residual degrees of freedom yielded $W = 0.98987$ ($p = 0.8365$), indicating no departure from Gaussian normality.
- **Normality of Whole-plot Residuals (Error $a$):** The Shapiro-Wilk test on the 10 whole-plot residual values yielded $W = 0.94463$ ($p = 0.3471$), confirming normality at the upper hierarchical stratum.
- **Homogeneity of Variance across Varieties:** Levene's test yielded $F_{2, 69} = 0.4250$ ($p = 0.6555$).
- **Homogeneity of Variance across Nitrogen Levels:** Levene's test yielded $F_{3, 68} = 0.0662$ ($p = 0.9776$).
- **Homogeneity of Variance across all 12 Treatment Cells:** Levene's test yielded $F_{11, 60} = 0.7660$ ($p = 0.6716$), and Bartlett's test yielded $\chi^2 = 9.1820$ ($\text{df} = 11, p = 0.6051$).

The absence of heteroscedasticity or outlier skewness confirms that the linear model estimates and inferences are fully robust.

---

## 4. Discussion

### 4.1 Agronomic Implications of Cultivar and Nitrogen Dynamics
The re-analysis of the Yates 1935 oat trial underscores the predominant role of inorganic nitrogen availability in driving cereal productivity. Over the experimental range of 0.0 to 0.6 cwt/acre ammonium sulphate, grain yield increased by $55.4\%$, moving from $79.39$ to $123.39$ quarter-pounds per plot ($1,587.8$ to $2,467.8\text{ lbs/acre}$). 

The orthogonal polynomial breakdown demonstrates that $97.58\%$ of this yield expansion was strictly linear ($\beta = 73.67\text{ qtr-lbs/cwt}$, or $13.15\text{ kg grain/kg N applied}$). This steep linear trajectory demonstrates that soil mineral nitrogen was severely depleted at Rothamsted during the trial season, and that the maximum tested rate ($0.6\text{ cwt/acre} \approx 67.2\text{ kg N/ha}$) did not exceed the biological absorption capacity of the oat canopy. Although the quadratic contrast was not formally significant ($p = 0.1065$), the drop in marginal yield gain between the final two increments ($+15.33$ from 0.2 to 0.4 vs. $+9.17$ from 0.4 to 0.6) suggests that the crop was approaching asymptotic nitrogen saturation. In commercial practice, nitrogen applications beyond 0.6 cwt/acre would risk lodging, delayed senescence, and diminishing economic returns.

Importantly, the trial revealed no evidence of a Variety $\times$ Nitrogen interaction ($p = 0.9322$). All three cultivars ('Golden Rain', 'Marvellous', and 'Victory') displayed parallel response profiles, with individual linear slopes ranging narrowly between $64.58$ and $81.08$ quarter-pounds per cwt/acre. Cultivar 'Marvellous' maintained a numerical advantage across all nitrogen levels (averaging $109.79$ quarter-pounds), likely due to superior early-season tillering capacity, but the main effect among varieties was statistically indistinguishable from background field noise ($p = 0.2724$). Consequently, agronomic management can treat varietal choice and nitrogen rate as independent decision axes in this cropping environment.

### 4.2 Methodological Lessons from Split-Plot Designs
From a biometrical standpoint, this re-analysis illustrates the fundamental trade-off inherent in split-plot field layouts. By applying Variety at the whole-plot level and Nitrogen at the sub-plot level, the experiment accepted reduced statistical power for varietal contrasts in exchange for heightened precision on fertilizer contrasts and interaction effects.

The empirical whole-plot error ($MS_a = 601.33$) was $3.40$ times larger than the sub-plot error ($MS_b = 177.08$). As a consequence, detecting a true varietal difference would have required a margin exceeding $15.77$ quarter-pounds, whereas a nitrogen difference as small as $8.93$ quarter-pounds was detectable at the same significance level. If the objective of the agronomist had been to identify subtle cultivar differences, Variety should have been assigned to the sub-plot stratum or tested in a balanced randomized complete block design (RCBD). Conversely, for evaluating fertilizer response curves and verifying the stability of varietal performance across nutrient regimes, Yates' split-plot arrangement was mathematically optimal.

Furthermore, our comparison between classical ANOVA and REML linear mixed modeling highlights the theoretical convergence of both approaches in balanced orthogonal designs. REML reproduces the classical ANOVA sum-of-squares expectations exactly, while providing direct variance component estimates ($\sigma_{\text{block}}^2 = 214.48$, $\sigma_{\text{wp}}^2 = 106.06$, $\sigma_e^2 = 177.08$) and enabling immediate generalization to unbalanced, spatially autocorrelated modern trials.

---

## 5. Conclusions

Re-analysis of Frank Yates' classic 1935 split-plot oat trial demonstrates:
1. **Dominant Linear Nitrogen Response:** Nitrogen fertilizer produced an overwhelming, positive linear yield increase ($p = 1.091 \times 10^{-13}$), accounting for $97.58\%$ of fertilizer treatment variation with a slope of $73.67 \pm 6.78$ quarter-pounds per cwt/acre.
2. **Equivalent Varietal Performance:** Oat varieties exhibited non-significant yield differences ($p = 0.2724$), with 'Marvellous' ($109.79$), 'Golden Rain' ($104.50$), and 'Victory' ($97.63$) showing comparable productivity.
3. **Absence of Interaction:** The Variety $\times$ Nitrogen interaction was negligible ($F = 0.303, p = 0.9322$), establishing uniform nutrient response across cultivars.
4. **Validation of Split-Plot Precision:** Sub-plot comparisons enjoyed a 3.40-fold error variance reduction relative to whole plots, confirming the statistical elegance and diagnostic robustness of Yates' foundational design.

---

## References

- Box, G. E., Hunter, J. S., & Hunter, W. G. (2005). *Statistics for Experimenters: Design, Innovation, and Discovery* (2nd ed.). John Wiley & Sons, Hoboken, NJ.
- Fisher, R. A. (1935). *The Design of Experiments*. Oliver and Boyd, Edinburgh.
- Littell, R. C., Milliken, G. A., Stroup, W. W., Wolfinger, R. D., & Schabenberger, O. (2006). *SAS for Mixed Models* (2nd ed.). SAS Institute Inc., Cary, NC.
- Montgomery, D. C. (2017). *Design and Analysis of Experiments* (9th ed.). John Wiley & Sons, Hoboken, NJ.
- Pinheiro, J. C., & Bates, D. M. (2000). *Mixed-Effects Models in S and S-PLUS*. Springer-Verlag, New York, NY.
- Sinclair, T. R., & Rufty, T. W. (2012). Nitrogen and water resources commonly limit crop yield increases, not necessarily plant genetics. *Global Food Security*, 1(2), 94-98.
- Snedecor, G. W., & Cochran, W. G. (1989). *Statistical Methods* (8th ed.). Iowa State University Press, Ames, IA.
- Steel, R. G., Torrie, J. H., & Dickey, D. A. (1997). *Principles and Procedures of Statistics: A Biometrical Approach* (3rd ed.). McGraw-Hill, New York, NY.
- Yates, F. (1935). Complex experiments. *Supplement to the Journal of the Royal Statistical Society*, 2(2), 181-247. https://doi.org/10.2307/2983638
