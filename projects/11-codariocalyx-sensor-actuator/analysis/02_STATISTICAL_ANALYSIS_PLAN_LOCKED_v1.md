# Paper 11 — Statistical Analysis Plan (Locked v1)

Lock date: 2026-09-21
Scope: E1–E7 confirmatory analysis. E0 is validation/stage-gate evidence and is excluded from E1–E7 confirmatory inference.

## 1. General analysis principles

- Biological unit: plant.
- Primary statistics: R in a reproducible GitHub workflow.
- Independent verification: Python.
- OriginPro: selective nonlinear/signal/visual cross-check, never an independent source of manuscript numbers.
- Raw numerical authority: authoritative workbook identified by SHA-256 in project control.
- Repeated observations are linked by `Plant_ID`; frames, events and time points are not independent biological replicates.
- Two-sided alpha = 0.05 unless a design-exact permutation test is defined.
- Effect estimates and 95% CIs are emphasized; P values are supporting evidence.
- Primary tests are not pooled across experiments for multiplicity adjustment.
- Secondary/supportive inferential families use Holm adjustment within experiment.
- No observation is removed solely because it weakens an effect. Any exclusion must satisfy a pre-existing measurement/QC rule and be reported.

## 2. Model hierarchy and diagnostics

### Linear/repeated-measures outcomes
Primary hierarchy:
1. random-intercept mixed model with `Plant_ID`;
2. add random slope only when scientifically justified, sufficiently replicated and non-singular;
3. if random-effect variance is on a boundary/singular, use the pre-defined plant-adjusted fixed-effect formulation as a documented fallback/sensitivity model.

Degrees of freedom for linear mixed models: Satterthwaite or Kenward–Roger implementation where available.

Diagnostics before result lock:
- residual Q–Q and residual-vs-fitted;
- heteroscedasticity by condition/PPFD;
- convergence and singularity;
- random-effect variance/boundary behavior;
- influence at plant and session level;
- order/day/rig sensitivity;
- alternative variance structure when needed;
- cluster/bootstrap sensitivity for key estimates where model assumptions remain questionable.

### Order/day/rig terms
`Treatment_Order`, `Experimental_Day`, `Time_Block` and rig/block are design-control variables. They are inspected and reported in sensitivity models. They are not added/removed from the primary model by stepwise P-value selection.

## 3. E1 — isolated lateral sensor response

### Primary question
Does measured lateral PPFD alter lateral-leaflet oscillation period?

### Primary endpoint
`Treatment_Period_min`, baseline-adjusted.

### Primary model
`Treatment_Period_min ~ Baseline_Period_min + PPFD10 + Stimulated_Side + (1|Plant_ID)`
where `PPFD10 = measured Treatment_PPFD / 10`.

Primary estimand: change in treatment-period minutes per +10 µmol m−2 s−1 PPFD, with 95% CI.

### Nonlinearity sensitivity
Because five ordered PPFD levels are available, compare the primary linear trend with a restricted nonlinear/spline or monotonic dose-response representation. This is a sensitivity/visualization analysis; the primary estimand remains the pre-defined linear dose trend unless the linear form is diagnostically untenable.

### Secondary family
- treatment amplitude adjusted for baseline amplitude;
- maximum angular velocity adjusted for baseline velocity;
- response latency;
- cycle-to-cycle CV;
- recovery period/phase descriptors when inferentially appropriate.
Holm adjustment across inferential secondary endpoints.

### Figure destination
Figure 2: raw within-plant dose trajectories + model curve/CI + phase/velocity representation + estimation panel.

### Table destination
Table 2.

## 4. E2 — inter-organ coupling and rotation control

### Primary question
Does lateral-only illumination cause a signed terminal-leaflet orientation response in plant-centric coordinates?

### Primary endpoint
`Delta_Terminal_Azimuth_deg`.

### Primary model
`Delta_Terminal_Azimuth_deg ~ Condition * Rotation + (1|Plant_ID)`
with `Condition={LL,HL,LH,HH}` and indexed rotation 0°/180°.

### Single primary estimand
Directional lateral coupling = `(EMM_HL − EMM_LH)/2`, averaged across rotations.
This gives one signed effect representing terminal deflection toward the brighter lateral side and avoids treating two directional contrasts as independent co-primary tests.

### Planned supporting contrasts
- HL − LL;
- LH − LL;
- HH − LL;
- Condition × Rotation contrasts for HL and LH as apparatus-bias controls.

### Control criterion
Terminal-light constancy is reported descriptively from `Terminal_Light_Change_pct`; no non-significant test is used as evidence of equality.

### Secondary family
Latency, peak displacement, peak angular velocity, time-to-peak, 50% recovery.

### Figure destination
Figure 3: geometry + polar/vector displacement + paired plant trajectories + rotation-control estimation + timing distributions.

### Table destination
Table 2.

## 5. E3 — bilateral contrast integration

### Primary question
Does terminal orientation encode normalized bilateral contrast independently of total lateral irradiance?

### Primary endpoint
`Delta_Terminal_Azimuth_deg`.

### Predictor
Measured `C=(L−R)/(L+R)`; measured total lateral PPFD retained as a covariate in every candidate model.

### Candidate models on identical observations
1. **Linear:** `DeltaAz = β0 + β1*C + βT*TotalPPFD100 + plant effect + error`.
2. **Threshold:** signed threshold function using the pre-specified |C|=0.15 threshold plus `TotalPPFD100` and plant effect.
3. **Saturating:** nonlinear mixed model `DeltaAz = β0 + A*tanh(k*C) + βT*TotalPPFD100 + uPlant + error`, with saturation parameter `k` estimated from the data rather than hard-coded from legacy results.

### Model selection
Compare AIC on identical observations. If the best model has ΔAIC <2 versus a simpler model, prefer the simpler model and show both as sensitivity. Otherwise select the lower-AIC model. Total-PPFD validation strata remain part of interpretation regardless of selected form.

### Primary estimand
Selected model’s contrast-response effect/curve with 95% CI and the total-PPFD coefficient.

### Secondary/exploratory
Mutual information `I(C;Terminal_Response)` only if observation density and stability criteria are met; it will be omitted rather than forced if it adds little beyond the model-based evidence.

### Figure destination
Figure 4: contrast design plane + response curve + total-PPFD validation facets + response surface + model-comparison panel.

### Table destination
Table 2.

## 6. E4 — causal value of scanning

### Primary question
Does strong restriction of oscillatory scanning increase dynamic-light tracking error relative to Free movement?

### Primary endpoint
`Median_Tracking_Error_deg`.

### Primary model
`Median_Tracking_Error_deg ~ Restriction_Condition + (1|Plant_ID)`.

### Primary contrast
Strong − Free.

### Secondary planned contrasts
- Sham − Free;
- Moderate − Free.
Holm adjustment across the secondary contrasts/endpoints within E4.

### Secondary endpoints
Tracking-error AUC, lag, path length, mean/max error, transition success, terminal angular velocity.

### Mechanistic supportive model
Tracking performance as a continuous function of achieved `Percent_Natural_Amplitude`, clustered by plant. This analysis supports a dose-response interpretation of scanning restriction but does not replace the randomized-condition primary comparison.

### Time-resolved supportive model
For the dynamic trajectory, use a session-nested repeated/time model or GAMM/spline model of tracking error over time with condition interaction. It is used for time-course inference/visualization without treating time points as biological replicates.

### Figure destination
Figure 5 panels A–D.

### Table destination
Table 2.

## 7. E5 — information structure beyond photon dose

### Primary question
Does structured anti-phase illumination produce a greater terminal response than static balanced illumination when photon dose is matched?

### Primary endpoint
`Terminal_Orientation_Change_deg`.

### Primary model
`Terminal_Orientation_Change_deg ~ Condition + (1|Plant_ID)`.

### Primary contrast
Structured anti-phase − Static balanced.

### Essential planned secondary contrasts
- Structured anti-phase − Scrambled matched;
- Common-mode matched − Static balanced;
- Structured anti-phase − Common-mode matched if needed for mechanistic separation.
Holm adjustment across the E5 secondary inferential family.

### Dose-matching validation
Use the pre-specified ≤1% integrated-dose tolerance as a stage-gate/control criterion. Do not infer equivalence from a non-significant difference test. Verify experiment-level summaries against `23_LIGHT_TIMESERIES` integration before lock.

### Secondary endpoints
Mean tracking error, AUC, latency, terminal path length and response variability.

### Figure destination
Figure 5 panels E–H: light-pattern trajectories and integrated-dose overlay plus raw/model-based response distributions.

### Table destination
Table 2.

## 8. E6 — electrophysiological bridge

### Primary question
Are ordered A→B→C events specifically associated with lateral stimulation rather than sham onset?

### Primary endpoint
Session-level ordered-event occurrence defined as A, B and C events all detected with `A_Onset < B_Onset < C_Onset` under the locked event rule.

### Primary inference
Because each plant has two stimulated sessions and one sham session and the raw data show complete separation, standard logistic mixed models are not the primary test.

Use an **exact within-plant randomization/permutation test** respecting the 2-stimulus:1-sham block structure. Test statistic: mean within-plant difference between stimulated-session ordered-event occurrence and sham occurrence. Report raw occurrence counts/proportions and the exact/randomization P value.

### Primary effect size
Stimulus-minus-sham occurrence difference, with a conservative plant-level confidence interval/descriptive consistency statement. Do not report the legacy 0.75 estimate.

### Secondary timing/propagation analyses
Among stimulated sessions with detected events:
- A→B lag;
- B→C lag;
- A→C lag;
- C→movement lag;
- apparent A→B/B→C/A→C propagation velocity;
- channel amplitude and AUC.
Use plant-clustered/mixed models for repeated left/right stimulus sessions; left-vs-right side is a symmetry/control term rather than a required effect.

### Important restriction
Sham latency is **missing/undefined when no event occurs**, not zero. No direct latency-vs-sham arithmetic comparison is permitted.

### Figure destination
Figure 6 panels A–D: electrode map + event raster/timeline + lag/propagation estimation.

### Table destination
Table 3.

## 9. E7 — physiological value of active scanning

### Primary question
Does strong restriction reduce integrated light-use performance relative to Free movement?

### Primary endpoint
`Integrated_Photosynthetic_Performance` = trapezoidal integral of realized terminal PPFD(t) × ΦPSII(t).

### Primary model
`Integrated_Photosynthetic_Performance ~ Scanning_Condition + (1|Plant_ID)`.

### Primary contrast
Strong − Free.

### Planned secondary condition contrast
Sham − Free.

### Secondary endpoint family
- integrated/realized terminal PPFD;
- dynamic ΦPSII;
- ETR;
- leaf temperature;
- post-tracking assimilation A;
- gs;
- transpiration E;
- Ci.
Holm adjustment within the declared E7 secondary family.

### Time-resolved fluorescence/thermal analysis
Dynamic times 0, 15, 30, 45 and 60 min are analyzed with condition × time repeated-measures structure, with plant and session dependence retained. An AR(1) or other defensible within-session correlation structure may be used if supported diagnostically. The −25 min Fv/Fm record is a separate dark-adapted baseline measure, not part of illuminated ΦPSII time-course inference.

### Gas exchange
Gas exchange at 110 min is analyzed as a post-tracking outcome using condition + plant repeated-measures structure. It must not be described as simultaneous free-motion measurement.

### Figure destination
Figure 6 panels E–H: dynamic PPFD/ΦPSII/light-use trajectory + integrated-performance estimation + selected gas-exchange outcomes.

### Table destination
Table 3.

## 10. Multiplicity map

- E1 primary PPFD trend: no cross-experiment adjustment; secondary E1 family Holm.
- E2 one primary directional-coupling estimand; secondary/timing/rotation-control family Holm where inferential.
- E3 primary model/curve; model comparison by AIC, not P-value shopping; supportive coefficients reported with CIs.
- E4 Strong-Free primary; secondary E4 contrasts/endpoints Holm.
- E5 Structured-Static primary; remaining planned contrasts/endpoints Holm.
- E6 ordered-event primary exact test; timing/amplitude/propagation secondary family Holm when multiple tests are used.
- E7 Strong-Free integrated-performance primary; secondary physiology family Holm.

## 11. Independent verification requirements

Python must independently verify at minimum:
- C=(L−R)/(L+R);
- signed/absolute angle wrapping;
- tracking error and AUC;
- photon-dose integration;
- E5 ≤1% dose rule;
- E6 event-order and lag calculations;
- apparent velocity calculations;
- E7 integrated PPFD×ΦPSII;
- all headline model estimates exported to the master-results file.

OriginPro cross-check targets:
- E1 dose-response visualization;
- E3 nonlinear contrast-response form;
- selected E6 signal/latency visualizations;
- response-surface and curve sanity checks.

## 12. Statistical output freeze

No manuscript Results prose is permitted until:
1. all primary models have passed diagnostics;
2. sensitivity models are reconciled;
3. Python verification agrees within numerical tolerance;
4. master results are generated from code;
5. Figure 2–6 source tables are regenerated from the verified analysis state.
