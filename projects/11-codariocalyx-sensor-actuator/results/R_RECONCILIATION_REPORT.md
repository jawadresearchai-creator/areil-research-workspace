# Paper 11 R Statistical Reconciliation

Workbook SHA-256: `1a1aab770a41502174830546b9642534556e0b536aab6efb0e3da6c0d52aa277`

## Primary results

- **E1** — Period change per +10 µmol m^-2 s^-1 measured lateral PPFD, baseline-adjusted: estimate = -0.1459421; 95% CI [-0.1500842, -0.1418001]; P = 5.978053e-99; method: LMM random intercept Plant_ID; Satterthwaite df
- **E2** — directional_half_difference: estimate = 8.526; 95% CI [8.399608, 8.652392]; P = 1.103218e-204; method: LMM Condition × Rotation + random intercept Plant_ID
- **E3** — Directional half-difference between C=+0.5 and C=-0.5 at total lateral PPFD=200: estimate = 11.73966; 95% CI [11.66632, 11.81301]; P = 0; method: Plant fixed-effect likelihood comparison; selected model inference
- **E4** — Strong_minus_Free: estimate = 10.975; 95% CI [10.62996, 11.32004]; P = 2.368861e-76; method: LMM random intercept Plant_ID
- **E5** — Structured_minus_Static: estimate = 8.133333; 95% CI [7.748015, 8.518651]; P = 7.37643e-61; method: LMM random intercept Plant_ID
- **E6** — Stimulated minus sham ordered-event occurrence difference: estimate = 1; 95% CI [NA, NA]; P = 2.867972e-10; method: Exact blocked within-plant randomization, 2 stimulated:1 sham
- **E7** — Strong minus Free integrated photosynthetic performance: estimate = -74950.98; 95% CI [-80269.73, -69632.22]; P = 2.483299e-17; method: Plant fixed effects with Plant_ID-clustered SE (pre-specified singular-fit fallback)

## E3 model comparison

- linear: AIC 1541.172; ΔAIC 678.032
- threshold: AIC 1053.198; ΔAIC 190.058
- saturating: AIC 863.140; ΔAIC 0.000
- estimated saturation k = 1.884392; profile-likelihood 95% CI 1.811314–1.958073

## Hard QA gates

- E5 summary dose ≤1%: TRUE
- E5 time-series integration matches summaries ≤1%: TRUE
- E6 complete 40/40 stimulated vs 0/20 sham pattern: TRUE
