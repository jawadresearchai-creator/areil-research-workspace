# AREIL Scientific Figure Toolchain

## Purpose

AREIL uses a reproducible, data-authoritative figure pipeline. Figure software is a renderer; it must not become an alternative source of numerical truth.

## Installed / integrated engines

### R + ggplot2

GitHub-hosted Windows runners install the current R release and the following figure/data packages:

- ggplot2
- dplyr
- tidyr
- readxl
- openxlsx
- svglite
- ragg
- patchwork
- scales

Use ggplot2 when layered statistical graphics, faceting, distributions, model estimates, uncertainty displays, or grammar-of-graphics composition is advantageous.

### Inkscape

GitHub-hosted Windows runners install Inkscape and verify headless SVG-to-PDF conversion.

Use Inkscape only for vector inspection, format conversion, and non-data-changing finishing. It must never be used to manually alter data positions, error bars, significance annotations, or numerical labels.

### OriginPro

OriginPro is proprietary Windows software. The repository includes:

- the official external-Python integration package `originpro`;
- a PowerShell installer/verification hook;
- an OriginPro automation smoke test;
- a dedicated GitHub Actions job targeting a licensed Windows self-hosted runner.

The OriginLab application and its license are deliberately not committed to this public repository.

Required self-hosted runner labels:

`self-hosted, Windows, X64, originpro`

Preferred setup:

1. Install and activate OriginPro on the Windows runner normally.
2. Register that machine as a GitHub self-hosted runner.
3. Add the custom runner label `originpro`.
4. Run **Scientific Figure Toolchain** manually with **run_originpro_self_hosted = true**.

Optional quiet-install path:

- place the official OriginLab MSI on the runner;
- set the runner environment variable `ORIGIN_MSI_PATH` to that local MSI path;
- the setup script will install it with Windows Installer if Origin is absent.

Licensing remains under OriginLab's normal licensing mechanism and is not bypassed or embedded in CI.

## Engine routing

1. **Python/Matplotlib** — default fully scripted and reproducible publication engine.
2. **R/ggplot2** — statistical graphics, distributions, faceting, model estimates, and layered grammar-of-graphics figures.
3. **OriginPro** — advanced scientific graph templates, specialized engineering/scientific plotting, and Origin-native workflows when the licensed runner is available.
4. **Inkscape** — vector QA, SVG/PDF conversion, and final non-data-changing vector finishing.

## Integrity rules

- The authoritative workbook/CSV and frozen statistical result objects remain the sole numerical authority.
- Significance symbols and annotations must be generated from saved result objects, not manually typed from memory.
- Final figures must be rendered at target print size and checked for clipping, overlaps, unreadable text, malformed superscripts, units, and panel consistency.
- Export at least one true-vector format (SVG or PDF) and the journal-required high-resolution raster format when needed.
- Manual vector editing must not alter the scientific meaning or geometry of plotted observations.
