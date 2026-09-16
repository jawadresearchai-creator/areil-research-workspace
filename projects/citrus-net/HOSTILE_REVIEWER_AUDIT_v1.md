# CITRUS-NET hostile-reviewer audit v1

Audit scope: study architecture, canonical workbook schema, independent molecular pipeline, causal claims and PS&B positioning. This audit does **not** certify orchard results because the current master workbook has not yet been populated with primary field/laboratory records.

## Executive finding
The study concept is publishable in principle only if the causal claim is built on the orchard experiment: anatomically traced natural inter-tree root union -> receiver isotope enrichment under controlled hydraulic asymmetry -> exclusion of soil/chamber leakage -> loss of transfer after severing relative to sham. The public molecular arm can strengthen interpretation but cannot rescue a weak orchard causal design.

Current status is therefore **DESIGN ACCEPTABLE WITH CRITICAL PRE-DATA-LOCK FIXES; PRIMARY RESULTS NOT YET AUDITABLE**.

## Critical issue 1 — no primary orchard dataset is presently auditable
The canonical workbook structure is extensive, but the current dashboard remains at zero registered orchards, trees, pairs, R4/R5 candidates, interventions, samples and isotope results. Therefore no factual statement about orchard transfer, anatomy, severing or hydraulic recovery should yet be written as a study result.

**Required action:** populate the canonical workbook, preserve raw records, complete provenance links, and create a signed data-lock record before manuscript Results are drafted.

## Critical issue 2 — circularity in `R5 = functionally confirmed`
The codebook currently defines R5 as `functionally confirmed`. If isotope transfer is then compared across R grades, using R5 as an exposure class would be circular because function would already be part of the class definition.

**Resolution frozen:** pre-intervention eligibility is based on traced ownership and morphology/anatomy only. R0–R4 may be used prospectively. R5, if retained, is post-outcome metadata and is not an independent predictor in the primary transfer analysis.

## Critical issue 3 — experimental unit and pseudoreplication
A hostile reviewer will reject analyses that count repeated xylem samples, time points, injections or sensors as biological replicates. The natural biological unit is the inter-tree pair/target graft.

**Resolution frozen:** `Pair_ID` / prespecified target `Graft_ID` is the biological unit. Samples and time points are repeated measurements. Multiple grafts in the same pair must be clustered/nested or only one target graft chosen prospectively.

## Critical issue 4 — G1 is a feasibility threshold, not a sample-size justification
The workbook uses `>=6 high-quality R4 candidates` as the G1 gate. Six candidate unions may establish feasibility but do not by themselves justify confirmatory inference.

**Required action:** before unblinded primary analysis, add an SAP entry specifying either (a) a pair-level power/precision target based on an independently estimated variance, or (b) an explicitly bounded exploratory/rare-event inference strategy using all eligible grafts with exact effect estimates and uncertainty. Do not present `n >= 6` as a power calculation.

## Critical issue 5 — G2 transfer decision must be prespecified quantitatively
`Receiver enrichment exceeds background/QC criteria` is scientifically sensible but too vague for confirmatory inference if the threshold is selected after seeing outcomes.

**Resolution frozen:** define the transfer decision limit before treatment-code unblinding from validated analytical uncertainty plus the contemporaneous negative-control/background distribution. A positive event additionally requires valid extraction/run QC and absence of a soil-water enrichment pattern compatible with leakage.

## Critical issue 6 — soil/chamber leakage is the dominant alternative explanation
A reviewer can argue that enriched water reached the receiver through soil rather than through the graft.

The workbook already contains the correct evidence infrastructure: chamber leak tests, post-run residual volume, visible-leak records, soil water content/matric potential, soil-water isotope results, irrigation-water isotope chemistry, tracer-preparation records, chain of custody, run blanks/standards and raw-file checksums.

**Required action:** make the leakage-control fields mandatory for every primary G2/G3 assay. A transfer claim is invalid for a run with failed chamber QC or unexplained soil-water enrichment.

## Critical issue 7 — severing itself can damage hydraulics
Loss of receiver enrichment after severing could be attributed to nonspecific injury, excavation or altered hydraulic state rather than interruption of the graft.

**Resolution frozen:** severing must be evaluated relative to a matched sham with matched excavation/handling/time. Record root injury outside the target, soil disturbance, wound treatment, photographs, hydraulic state and synchronized receiver physiology. The primary causal contrast is the pre/post change in severed pairs minus the pre/post change in sham pairs.

## Critical issue 8 — irreversible severing creates order/time confounding
Severing cannot be crossed over within the same graft. Seasonal drift, weather and carryover can therefore mimic treatment effects.

**Required action:** randomize eligible pairs to severing versus sham where sample availability permits; synchronize measurement windows; include weather/hydraulic state; retain pair-level pre-manipulation baselines. If all pairs undergo sham first and severing later, the manuscript must explicitly model/order-match time and acknowledge the weaker causal structure.

## Critical issue 9 — isotope carryover between repeated interventions
Repeated tracer pulses can create false receiver enrichment if baseline isotope values have not returned to an acceptable range.

**Required action:** require a new pre-dose baseline before each intervention. A repeated pulse is analyzable only when baseline/carryover criteria are passed. Randomize state order where feasible and document washout duration. Consider the second isotope channel only if analytically validated; do not add it simply to increase apparent complexity.

## Major issue 10 — anatomy must be assessed independently of transfer status
Photographs/anatomy can be unconsciously scored more favorably after a positive transfer result.

**Required action:** blind anatomy/microscopy assessors to isotope outcome and manipulation status where feasible, and record blinded assessment in the anatomy table. Root ownership must be physically traced before dosing.

## Major issue 11 — donor/receiver direction must not be selected post hoc
If the donor is defined as whichever tree later yields the strongest transfer, directionality becomes circular.

**Resolution frozen:** donor/receiver roles and hydraulic state are specified before tracer application. Where feasible, donor/receiver assignment or Wet–Dry/Dry–Wet sequence is randomized and stored in the randomization register.

## Major issue 12 — physiology is mechanistic support, not the causal endpoint
Stem water potential, sap flow and trunk diameter can respond to weather, irrigation and root damage.

**Resolution frozen:** isotope transfer and severing-versus-sham attenuation are the primary outcomes. Physiology is secondary and synchronized to the same intervention, with weather/VPD/PAR and soil-water context retained.

## Major issue 13 — candidate-selection bias must be visible
Excavating only visually promising pairs can inflate apparent graft prevalence and exaggerate generality.

**Required action:** keep the pair-screening census as the denominator, preserve reasons for selection/non-selection, and distinguish `frequency among screened neighboring pairs` from `response among experimentally eligible grafts`. Do not generalize prevalence from the selected R4 cohort.

## Major issue 14 — site generality
One orchard or one cultivar/rootstock context cannot establish a universal citrus-network phenomenon.

**Required action:** report orchard/site, cultivar/rootstock, tree age/spacing/management and soil context precisely. If only one orchard is studied, write conclusions at that scale. Multi-orchard replication is preferable but not required for the mechanistic claim if the causal test is strong and generality is bounded.

## Major issue 15 — public molecular evidence can easily be overinterpreted
### GSE255759
This is a separate water-deficit experiment in four citrus scion/rootstock combinations. The independent reanalysis shows the prespecified PIP2 transcript `Ciclev10029003` decreases in all four contrasts, with genome-wide FDR significance in two. That supports regulated citrus root-water-transport biology under water deficit, not natural root-graft transfer.

### GSE263656
This is an external stem graft compatibility/incompatibility study. It supports vascular/lignification and auxin-responsive graft-organization biology, but it is not a natural inter-tree root-graft dataset. Because replicate-level rootstock mapping in GEO metadata was ambiguous, the current pipeline correctly avoids guessing raw-count assignments.

### Published qPCR anchors
Published citrus studies used real qPCR for PIP1 `Ciclev10012384` and PIP2 `Ciclev10029003`. These validate the biological identity of the external aquaporin anchors; they do not provide qPCR measurements from the orchard study.

**Resolution frozen:** one clearly labeled external molecular subsection/figure only. No wording such as `molecular mechanism of our grafts` or `PIP2 caused transfer`.

## Major issue 16 — confirmatory versus exploratory separation
The isotope pilot is allowed to establish feasibility, variance and practical sampling windows, but its use in final confirmatory inference must be declared prospectively.

**Preferred design:** retain pilot results as exploratory and use a later confirmatory set of eligible grafts for the primary causal test. If scarcity forces reuse of all grafts, state this transparently and use estimation-focused inference rather than treating pilot-tuned decisions as fully confirmatory.

## Major issue 17 — missing prespecified statistical model details
The workbook can store analysis derivations, exclusions and data lock, but the final SAP still needs exact models before unblinded analysis.

Minimum SAP items:
- primary derived tracer-enrichment variable;
- transformation, if any;
- G2 contrast and decision rule;
- repeated-measures covariance/random effects;
- treatment × time / hydraulic-state contrasts;
- G3 difference-in-differences contrast;
- multiplicity method;
- exclusion/QC rules;
- missing-data handling;
- sensitivity analyses for chamber leakage, nonspecific injury and multiple grafts per pair.

## Major issue 18 — PS&B framing
The study should be written as whole-plant/interplant integration and communication through a naturally formed vascular connection, not as an irrigation-engineering paper. The paper's biological center is acquisition and movement of water through a physical inter-tree connection, dependence on hydraulic state, and loss of communication after connection interruption. The external molecular arm supplies bounded vascular/hydraulic context.

## Strengths that should survive review
- Physical root ownership is traced rather than inferred.
- Anatomy and function are separated conceptually.
- Stable isotope provides direct movement evidence.
- Soil/chamber leakage controls are built into the workbook.
- Severing plus sham creates a genuine intervention-based causal test.
- Repeated physiological measurements can connect tracer movement with functional water status.
- The workbook has unusually strong provenance: instruments, calibrations, certificates, methods, materials, custody, QC, raw files, deviations, exclusions and data lock.
- Public molecular data are kept external rather than used as pseudo-replication.
- PIP1 provides a useful negative/weak external result while PIP2 gives a directionally reproduced external signal, reducing the appearance of cherry-picking.

## Claims permitted if the full causal pattern is observed
Permitted wording:
- `naturally occurring inter-tree root grafts can form functional hydraulic connections in mature Kinnow under the tested orchard conditions`;
- `receiver enrichment depended on the imposed hydraulic context`;
- `physical interruption of the target graft reduced transfer relative to sham`;
- `independent citrus molecular evidence is consistent with regulated vascular-union formation and root membrane water transport`.

Do not claim:
- community-wide resource sharing beyond tested pairs;
- adaptive cooperation/altruism;
- PIP2 involvement in the orchard grafts without orchard molecular measurements;
- universal behavior across citrus orchards/rootstocks;
- transfer when soil/chamber leakage cannot be excluded.

## Manuscript go/no-go gates
### Gate A — data readiness
GO only after orchard/tree/pair/graft IDs, intervention records, isotope QC/provenance and manipulation logs are complete.

### Gate B — G2 functional evidence
GO to a causal-transfer manuscript only if receiver enrichment meets the prespecified transfer rule in eligible grafts and leakage/negative controls are clean.

### Gate C — G3 causal interruption
GO to the strongest paper only if severing reduces transfer beyond sham under matched hydraulic conditions. If G2 is positive but G3 is not, the manuscript must be downgraded to observational/functional association.

### Gate D — molecular evidence
Already satisfied for bounded contextual use. It never substitutes for Gates B or C.

## Immediate next actions before field data lock
1. Freeze the revised R-grade interpretation and remove functional transfer from any pre-intervention exposure definition.
2. Add exact G2 detection-limit formula and G3 primary contrast to the SAP/analysis-derivation records.
3. Define pair-level sample-size/precision strategy separately from the `>=6 R4` feasibility gate.
4. Make leak/soil-water controls mandatory for every primary transfer run.
5. Freeze randomization/blinding and manipulation-order rules.
6. Populate the canonical workbook; do not draft orchard Results from hypothetical values.
7. Run QC/provenance audit, exclusions review and data lock.
8. Only then generate the full PS&B manuscript from the locked dataset plus the already-completed independent molecular arm.
