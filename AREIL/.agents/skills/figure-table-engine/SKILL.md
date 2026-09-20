---
name: figure-table-engine
description: Designs figures/tables from scientific questions and authoritative result objects using reproducible Python, R/ggplot2, OriginPro, and Inkscape routes.
---
# Figure & Table Engine

Choose display by question/design. Prefer raw distributions + estimates/uncertainty where useful. Avoid redundant table/figure messages. Generate annotations from authoritative result objects, never from memory or manual transcription.

## Engine routing

- **Python/Matplotlib**: default fully scripted publication engine and fallback for all supported figures.
- **R/ggplot2**: use for grammar-of-graphics composition, faceting, distributions, model estimates, uncertainty displays, and statistical graphics where it is clearer or more efficient.
- **OriginPro**: use for Origin-native advanced scientific graph templates or specialized plotting when a licensed Windows self-hosted runner is available. Do not make the proprietary application or its license a repository dependency for numerical authority.
- **Inkscape**: use for SVG/PDF vector QA, format conversion, and non-data-changing finishing only. Never manually reposition observations, error bars, significance symbols, or numerical labels.

## Output contract

Render at final print size and inspect overlap, clipping, labels, units, fonts, superscripts, legends, panel consistency, and accessibility. Export at least one true-vector format (SVG or PDF) plus the journal-required high-resolution raster format when needed.

The authoritative workbook/CSV and frozen statistical result objects remain the sole numerical authority regardless of rendering engine.
