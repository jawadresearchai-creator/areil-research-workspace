# CITRUS-NET frozen paper architecture v1

Status: architecture frozen before primary orchard data lock. This document does not assert results that are not present in the canonical orchard workbook.

## Working title
Natural root grafts as candidate hydraulic links between mature Kinnow trees: stable-isotope tracing, severing causality, and independent citrus molecular triangulation

## Central question
Do naturally occurring inter-tree root grafts in mature citrus permit directional transfer of water under a controlled hydraulic asymmetry, and does physically interrupting the graft eliminate that transfer relative to a sham manipulation?

## Core causal ladder
1. **Biological availability / anatomy** — register orchards, trees and neighbouring pairs; excavate targeted root corridors; physically trace root ownership; score candidate unions without using tracer results.
2. **Functional transfer** — introduce a stable-isotope tracer into an enclosed donor-root segment and test whether receiver xylem water becomes enriched relative to its own baseline and contemporaneous negative controls while soil-water controls remain inconsistent with leakage.
3. **Hydraulic dependence / directionality** — impose predefined Wet–Wet, Wet–Dry and Dry–Wet states and test whether transfer magnitude follows the inter-tree hydraulic gradient.
4. **Causal interruption** — repeat the transfer assay after physical severing of the target graft and compare the pre/post change against a matched sham manipulation.
5. **Independent molecular triangulation** — keep public citrus graft-union and root-aquaporin evidence statistically separate from orchard observations and use it only to contextualize vascular-union organization and root-water transport.

## Experimental-unit rule
- Pair-level causal inference is based on `Pair_ID` / target `Graft_ID`.
- Repeated xylem samples, soil samples, sensor timestamps and injections are repeated measurements, not independent biological replicates.
- If a tree pair contains more than one candidate graft, the pair remains the clustering unit unless exactly one target graft is prespecified before intervention.

## Pre-intervention anatomy rule
Avoid circular classification. A root union's pre-intervention eligibility must be determined solely by physical tracing and morphology/anatomy. Functional isotope transfer must never be used to define the exposure category subsequently tested for transfer.

Operational freeze:
- R0–R4 may be used as pre-intervention anatomical/morphological classes.
- If the existing label `R5 = functionally confirmed` is retained in the database, R5 is a post-outcome descriptor only and must not be used as an independent predictor in primary transfer models.

## G1 — biological availability gate
The existing `>=6 high-quality R4 candidates` rule is retained as a feasibility gate only. It is not an inferential sample-size justification. The confirmatory causal stage requires an explicit pair-level sample-size/power or precision rule before unblinded outcome analysis.

## G2 — functional isotope evidence
Primary transfer endpoint: receiver-xylem tracer enrichment after donor-root dosing.

A positive transfer event requires all of the following:
1. receiver enrichment above its own pre-dose baseline;
2. receiver enrichment above contemporaneous non-grafted/contact controls;
3. magnitude exceeding the analytical/background decision limit defined from method uncertainty and control distribution before treatment-code unblinding;
4. acceptable extraction/run QC;
5. no soil-water isotope pattern consistent with chamber leakage or bulk-soil contamination.

The exact laboratory decision limit is calculated from the validated method uncertainty and negative-control/background distribution and is frozen in the SAP before primary analysis.

## Hydraulic-gradient test
The prespecified mechanistic question is whether transfer magnitude changes with the donor-to-receiver water-potential gradient. `Hydraulic_State` remains a design variable, not a retrospective label. The primary model uses pair/graft as the biological unit with repeated time points modeled within unit.

Where the same pair is tested under more than one hydraulic state, intervention order must be randomized when technically possible and an adequate isotope washout/new baseline must precede the next pulse. Carryover is assessed from pre-dose xylem and soil-water isotope values.

## G3 — severing causality
Primary causal contrast: change in receiver transfer after severing relative to change after sham under a matched hydraulic state and matched tracer dose.

Required protections:
- assignment to severing versus sham documented before outcome analysis;
- matched excavation, handling, elapsed time and measurement schedule;
- root injury outside the target union recorded explicitly;
- pre-manipulation and post-manipulation photographs;
- pre/post physiological measurements to detect nonspecific damage;
- same pair/graft remains the repeated-measure unit.

A severing effect supports necessity of the physical connection only when transfer decreases after severing more than after sham and the result is not explained by leakage, generalized root injury, altered tracer dose or changed hydraulic gradient.

## Primary outcomes
1. Receiver xylem isotope enrichment / derived tracer excess.
2. Severing-versus-sham change in receiver enrichment.

## Secondary mechanistic outcomes
- receiver stem water potential;
- sap flow where methodologically valid;
- soil water content and matric potential;
- synchronized trunk-diameter response;
- anatomy of the target union;
- harvest/water-productivity endpoints only if G2 and G3 are passed.

## External molecular arm
The molecular arm is independent and cannot be treated as measurements from the Sargodha/Kinnow orchard trees.

### GSE263656 graft-union evidence
Use only at the published/deposited evidence level unless rootstock identity of individual raw-count replicates can be resolved without inference. This arm represents vascular/lignification and graft-organization biology in a separate citrus graft system.

### GSE255759 root RNA-seq reanalysis
Use the four prespecified root contrasts independently: ML2x, ML4x, PL2x and PL4x water-deficit versus control. The qPCR-anchored PIP panel remains fixed as PIP1 `Ciclev10012384` and PIP2 `Ciclev10029003`.

### Claim boundary
The public data may support statements such as `independent citrus evidence is consistent with regulated vascular-union formation and root membrane water transport`. They cannot support `PIP2 caused inter-tree water transfer`, `the orchard grafts expressed these genes`, or any claim that the external stem-graft transcriptome directly represents natural inter-tree root grafts.

## Frozen manuscript structure
### Abstract
Background/gap; natural-root-graft question; isotope + severing design; principal orchard findings once data are locked; bounded molecular triangulation; conclusion.

### 1. Introduction
1. Natural root grafts and below-ground integration.
2. Why anatomical contact is not evidence of hydraulic function.
3. Need for directional tracer evidence and causal interruption.
4. Citrus as a perennial orchard system.
5. Independent molecular context for graft vascular organization and root hydraulic regulation.
6. Explicit hypotheses.

### 2. Materials and methods
2.1 Orchard, cultivar/rootstock and permissions
2.2 Tree/pair census and candidate selection
2.3 Root excavation, ownership tracing and anatomical grading
2.4 Root chamber construction, leak testing and tracer preparation
2.5 Stable-isotope sampling, extraction and analytical QC
2.6 Hydraulic-asymmetry treatments
2.7 Severing and sham causal test
2.8 Graft anatomy
2.9 Soil, weather and physiological measurements
2.10 Independent public molecular evidence
2.11 Randomization, blinding, exclusions and data lock
2.12 Statistical analysis

### 3. Results
3.1 Frequency and anatomical classes of inter-tree root unions
3.2 Stable-isotope evidence for functional transfer
3.3 Dependence of transfer on hydraulic asymmetry
3.4 Severing versus sham causal test
3.5 Independent molecular triangulation

### 4. Discussion
4.1 What constitutes evidence of a functional natural root graft
4.2 Directionality and hydraulic context
4.3 Severing evidence and alternative explanations
4.4 Relationship to citrus vascular-union biology and PIP regulation
4.5 Limits: orchard/site generality, natural-graft selection, external molecular datasets
4.6 Ecological and orchard implications without extrapolating beyond measured scale

## Frozen figure plan
- **Figure 1:** study architecture, pair/graft identification, chamber/tracer setup and causal ladder.
- **Figure 2:** root-union morphology/anatomy and distribution of pre-intervention anatomical classes.
- **Figure 3:** receiver isotope time course / transfer effect with matched controls and soil-leakage evidence.
- **Figure 4:** hydraulic-state dependence and synchronized physiological response.
- **Figure 5:** severing-versus-sham causal result.
- **Figure 6:** one compact independent molecular-triangulation figure: external graft-union module + GSE255759 PIP1/PIP2 forest plot + explicit claim boundary.

## Statistical architecture
- Experimental unit: pair/target graft, not sample or time point.
- Repeated measurements: mixed-effects or other repeated-measures model with within-unit correlation represented explicitly.
- Multiple target grafts within one tree pair: nested/clustered or one target prespecified.
- G2: planned contrast of receiver tracer response against baseline and negative controls with effect estimate and 95% CI.
- Hydraulic test: planned effect of hydraulic state/gradient, time and their interaction.
- G3: primary difference-in-differences style contrast: `(post - pre)_severed - (post - pre)_sham` with pair-level repeated measures.
- Molecular contrasts remain separate from orchard models.
- Report effect estimates, uncertainty and exact multiplicity procedure; do not infer biological replication from repeated samples.

## Writing rule
The manuscript will not state any orchard result until the canonical workbook passes QC/provenance review and the data-lock record is complete. The public molecular arm may be described now because its pipeline has been executed independently and archived, but it must remain clearly labeled as external evidence.
