# Paper 11 — Codariocalyx motorius sensor–actuator manuscript

This project contains the authoritative workbook and reproducible statistical code for the Plant Signaling & Behavior manuscript provisionally framed around active spatial light sensing and sensor–actuator coupling in *Codariocalyx motorius*.

## Numerical authority

`data/raw/Codariocalyx_motorius_Sensor_Actuator_Master_Workbook_2023_2024_FINAL.xlsx`

Expected SHA-256:

`1a1aab770a41502174830546b9642534556e0b536aab6efb0e3da6c0d52aa277`

The R workflow aborts before analysis if the workbook hash differs.

## Analysis rules

- Plant is the biological unit.
- E1–E7 follow the locked SAP stored with the project.
- Mixed models are primary where identifiable.
- Pre-specified plant-fixed-effect/clustered fallbacks are used for singular random-effect fits.
- E3 compares linear, threshold, and saturating contrast-response models on identical observations and likelihood family; saturation `k` is estimated.
- E5 photon-dose matching is a hard stage gate and is rechecked against the full light time series.
- E6 ordered-event inference uses exact blocked randomization rather than inheriting legacy workbook statistics.
- E7 time-resolved fluorescence/thermal analyses preserve within-session dependence and attempt AR(1) correlation.

Generated statistical outputs are uploaded as GitHub Actions artifacts and are not manually edited.
