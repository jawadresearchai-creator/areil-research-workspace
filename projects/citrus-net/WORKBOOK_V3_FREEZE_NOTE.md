# CITRUS-NET workbook v3 freeze note

Date: 2026-09-16

The canonical workbook was revised from `CITRUS_NET_Exhaustive_Master_Data_Workbook_v2.xlsx` to `CITRUS_NET_Exhaustive_Master_Data_Workbook_v3_FROZEN.xlsx` before primary orchard data lock.

## Corrections frozen in v3
- Fixed `04_Graft_Assessment!P2:P301`: prospective isotope-pilot eligibility now requires both root ownership traces = Yes and `R_Grade = R4` only.
- Removed the prior fill-down defect that incremented text labels (`R5/R6`, `R6/R7`, etc.) in eligibility formulas.
- Reframed `R5` as a post-outcome functional descriptor only; it must not be used to select grafts prospectively or as a primary exposure predictor.
- Froze `Pair_ID / prespecified target Graft_ID` as the biological experimental unit; samples/time points/sensors are repeated measures.
- Clarified G1 as a feasibility gate rather than a power calculation.
- Strengthened G2 to require a frozen transfer decision rule plus valid chamber/soil leakage QC.
- Strengthened G3 to use a prespecified severing-versus-sham pre/post contrast under matched hydraulic conditions.
- Added `50_SAP_Primary_Analysis` with the primary endpoint/contrast, carryover, leakage, multiplicity, missingness and external-molecular separation rules.
- Added `51_PreData_Audit` with critical/major review threats and explicit PASS/OPEN/NOT READY/BLOCKED states.
- Added SAP/audit requirements to `41_Required_By_Phase` and updated README/dashboard wording.

## Remaining pre-unblinding items
1. Enter an explicit pair-level confirmatory sample-size or precision target (`SAP-05`).
2. Freeze the exact numerical G2 transfer decision limit from validated method uncertainty and contemporaneous negative-control/background data (`SAP-08`).
3. Populate orchard/tree/pair/graft/intervention/isotope and provenance records.
4. Complete exclusions/missingness review and `48_Data_Lock` before drafting orchard Results.

No primary orchard outcome was generated, inferred or simulated during this revision.
