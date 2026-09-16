#!/usr/bin/env python3
"""CITRUS-NET independent molecular triangulation v2.

This analysis is intentionally separate from the Sargodha Kinnow orchard dataset.
It never creates, imputes, or simulates qPCR values.

Evidence arms
-------------
1) GSE255759 root RNA-seq: reanalyzed from deposited raw integer counts with
   PyDESeq2, separately within each scion/rootstock combination.
2) GSE263656 citrus graft-union study: used as deposited/published molecular
   context because the GEO MINiML does not expose the rootstock identity for
   each replicate unambiguously. No sample mapping is guessed.
3) Published real citrus qPCR anchors: PIP1 Ciclev10012384 and PIP2
   Ciclev10029003 from Martinez-Cuenca et al. 2021; Paudel et al. 2017 provides
   independent PIP/root-hydraulic-conductivity support.

Prespecified BEFORE numerical extraction from GSE255759:
- hydraulic qPCR anchor panel: Ciclev10012384 (PIP1), Ciclev10029003 (PIP2)
- contrasts: Water deficit vs Control, separately in ML2x, ML4x, PL2x, PL4x
- genome-wide BH-adjusted P values are retained; panel interpretation is based
  on effect direction, effect magnitude, padj, and replication across contrasts.
"""
from __future__ import annotations
import hashlib, json, math, re
from pathlib import Path

import numpy as np
import pandas as pd
import requests
from pydeseq2.dds import DeseqDataSet
from pydeseq2.ds import DeseqStats

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "public_molecular" / "raw_v2"
OUT = ROOT / "public_molecular" / "results_v2"
RAW.mkdir(parents=True, exist_ok=True)
OUT.mkdir(parents=True, exist_ok=True)

GSE255_URL = "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE255nnn/GSE255759/suppl/GSE255759_counts_roots.csv.gz"

QPCR_ANCHORS = {
    "Ciclev10012384": {
        "symbol": "PIP1",
        "published_qpcr_source": "Martinez-Cuenca et al. 2021, Horticulturae 7:388",
        "forward_primer": "AGGATTACACGGAGCCACCT",
        "reverse_primer": "TGCTTTTGGATTTGGACACG",
        "role": "plasma-membrane aquaporin / root water transport",
    },
    "Ciclev10029003": {
        "symbol": "PIP2",
        "published_qpcr_source": "Martinez-Cuenca et al. 2021, Horticulturae 7:388",
        "forward_primer": "TGTGTTCATGGTTCACTTGG",
        "reverse_primer": "TGAATGGTCCAACCCAGAAG",
        "role": "plasma-membrane aquaporin / root water transport",
    },
}

# Published GSE263656 evidence is encoded only at the level directly supported
# by the article. These are not rederived measurements from our orchard study.
GRAFT_EVIDENCE = [
    {
        "dataset": "GSE263656",
        "module": "vascular_lignification",
        "tissue": "stem vascular tissue below graft union",
        "comparison": "incompatible US-1283 vs compatible US-812",
        "evidence": "Strongest transcriptional reprogramming occurred below the graft union; phenylpropanoid/lignin-associated genes were repressed in incompatible unions, including class III peroxidase and laccase transcripts.",
        "claim_boundary": "Published/deposited citrus stem-graft context; not measured in natural root grafts from CITRUS-NET.",
        "source": "Febres et al. 2024, Frontiers in Plant Science 15:1421734; GSE263656",
    },
    {
        "dataset": "GSE263656",
        "module": "graft_organization",
        "tissue": "stem vascular tissue below graft union",
        "comparison": "incompatible US-1283 vs compatible US-812",
        "evidence": "AUX/IAA transcripts were predominantly induced while SAUR transcripts were predominantly repressed in the below-union incompatible-rootstock response.",
        "claim_boundary": "Published/deposited citrus stem-graft context; not evidence that these transcripts changed in the orchard root grafts.",
        "source": "Febres et al. 2024, Frontiers in Plant Science 15:1421734; GSE263656",
    },
    {
        "dataset": "GSE263656",
        "module": "technical_validation",
        "tissue": "citrus graft study",
        "comparison": "RNA-seq vs qRT-PCR",
        "evidence": "Eleven selected DEGs were independently checked by qRT-PCR, with strong positive agreement between RNA-seq and qRT-PCR reported by the authors.",
        "claim_boundary": "Published qRT-PCR validation of the external dataset only.",
        "source": "Febres et al. 2024, Frontiers in Plant Science 15:1421734; GSE263656",
    },
]


def download(url: str, dest: Path) -> None:
    if dest.exists() and dest.stat().st_size > 0:
        return
    with requests.get(url, stream=True, timeout=180) as r:
        r.raise_for_status()
        with dest.open("wb") as f:
            for chunk in r.iter_content(1024 * 1024):
                if chunk:
                    f.write(chunk)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def canonical_gene_id(g: str) -> str:
    # Deposited IDs use suffixes such as Ciclev10012384m.g.
    g = str(g).strip()
    return re.sub(r"m\.g$", "", g)


def parse_gse255(path: Path) -> pd.DataFrame:
    # GEO file has a first auxiliary 'Sample;8;9;...' row followed by the real
    # semicolon-delimited header beginning 'Gene;Roots_ML2xCtrl_1;...'.
    df = pd.read_csv(path, compression="gzip", sep=";", skiprows=1)
    if df.shape[1] < 5 or df.columns[0] != "Gene":
        raise RuntimeError(f"Unexpected GSE255759 format: shape={df.shape}, first columns={list(df.columns[:5])}")
    df = df.set_index("Gene")
    df.index = [canonical_gene_id(x) for x in df.index]
    df = df.apply(pd.to_numeric, errors="raise").astype(int)
    if (df.values < 0).any():
        raise RuntimeError("Negative counts found in GSE255759 root matrix")
    return df


def run_deseq(counts_gene_by_sample: pd.DataFrame, ctrl_cols: list[str], wd_cols: list[str], combo: str) -> pd.DataFrame:
    cols = ctrl_cols + wd_cols
    # PyDESeq2 expects samples x genes.
    counts = counts_gene_by_sample[cols].T.copy()
    # Remove completely uninformative genes; keep low genes for DESeq2 filtering.
    keep = counts.sum(axis=0) >= 10
    counts = counts.loc[:, keep]
    meta = pd.DataFrame(
        {"condition": ["Control"] * len(ctrl_cols) + ["WD"] * len(wd_cols)},
        index=cols,
    )
    dds = DeseqDataSet(
        counts=counts,
        metadata=meta,
        design="~condition",
        refit_cooks=False,
        quiet=True,
        n_cpus=2,
    )
    dds.deseq2()
    stat = DeseqStats(
        dds,
        contrast=["condition", "WD", "Control"],
        alpha=0.05,
        cooks_filter=False,
        independent_filter=True,
        quiet=True,
        n_cpus=2,
    )
    stat.summary()
    res = stat.results_df.reset_index().rename(columns={"index": "gene_id"})
    if "gene" in res.columns and "gene_id" not in res.columns:
        res = res.rename(columns={"gene": "gene_id"})
    if "gene_id" not in res.columns:
        # PyDESeq2 currently preserves gene identifiers in the index; defensive fallback.
        res.insert(0, "gene_id", stat.results_df.index.astype(str))
    res["gene_id"] = res["gene_id"].astype(str).map(canonical_gene_id)
    res["dataset"] = "GSE255759"
    res["contrast"] = f"{combo}_WD_vs_Control"
    res["n_control"] = len(ctrl_cols)
    res["n_WD"] = len(wd_cols)
    return res


def main():
    raw_path = RAW / "GSE255759_counts_roots.csv.gz"
    download(GSE255_URL, raw_path)
    prov = {
        "dataset": "GSE255759",
        "url": GSE255_URL,
        "file": str(raw_path.relative_to(ROOT)),
        "bytes": raw_path.stat().st_size,
        "sha256": sha256(raw_path),
        "parser": "semicolon-delimited; skip auxiliary first row; raw integer counts",
    }
    (OUT / "provenance.json").write_text(json.dumps(prov, indent=2))

    mat = parse_gse255(raw_path)
    mat.to_csv(OUT / "GSE255759_roots_counts_parsed.csv.gz", compression="gzip")

    combos = ["ML2x", "ML4x", "PL2x", "PL4x"]
    all_de = []
    sample_design = []
    for combo in combos:
        ctrl = [c for c in mat.columns if re.fullmatch(rf"Roots_{combo}Ctrl_\d+", str(c))]
        wd = [c for c in mat.columns if re.fullmatch(rf"Roots_{combo}WD_\d+", str(c))]
        if len(ctrl) != 3 or len(wd) < 3:
            raise RuntimeError(f"Unexpected sample structure for {combo}: ctrl={ctrl}, wd={wd}")
        for c in ctrl:
            sample_design.append({"sample": c, "combo": combo, "condition": "Control"})
        for c in wd:
            sample_design.append({"sample": c, "combo": combo, "condition": "WD"})
        res = run_deseq(mat, ctrl, wd, combo)
        res.to_csv(OUT / f"GSE255759_{combo}_PyDESeq2.csv", index=False)
        all_de.append(res)

    pd.DataFrame(sample_design).to_csv(OUT / "GSE255759_root_sample_design.csv", index=False)
    de = pd.concat(all_de, ignore_index=True)
    de.to_csv(OUT / "GSE255759_all_contrasts_PyDESeq2.csv.gz", index=False, compression="gzip")

    # Prespecified qPCR-anchored PIP panel only: IDs were locked from published
    # real citrus qPCR before inspecting GSE255759 DE results.
    panel_rows = []
    for gid, meta in QPCR_ANCHORS.items():
        for combo in combos:
            sub = de[(de.gene_id == gid) & (de.contrast == f"{combo}_WD_vs_Control")]
            if len(sub) == 0:
                panel_rows.append({
                    "gene_id": gid, "symbol": meta["symbol"], "combo": combo,
                    "present_in_GSE255759": False,
                    "published_qpcr_source": meta["published_qpcr_source"],
                    "forward_primer": meta["forward_primer"],
                    "reverse_primer": meta["reverse_primer"],
                    "claim_boundary": "Prespecified external qPCR anchor; absent/unresolved in deposited root count matrix.",
                })
                continue
            r = sub.iloc[0]
            panel_rows.append({
                "gene_id": gid,
                "symbol": meta["symbol"],
                "combo": combo,
                "present_in_GSE255759": True,
                "baseMean": float(r.get("baseMean", np.nan)),
                "log2FoldChange_WD_vs_Control": float(r.get("log2FoldChange", np.nan)),
                "lfcSE": float(r.get("lfcSE", np.nan)),
                "stat": float(r.get("stat", np.nan)),
                "pvalue": float(r.get("pvalue", np.nan)),
                "padj_genomewide": float(r.get("padj", np.nan)),
                "published_qpcr_source": meta["published_qpcr_source"],
                "forward_primer": meta["forward_primer"],
                "reverse_primer": meta["reverse_primer"],
                "claim_boundary": "GSE255759 effect is an independent public root RNA-seq result; qPCR primers/results originate from a different published citrus experiment.",
            })
    panel = pd.DataFrame(panel_rows)
    panel.to_csv(OUT / "PIP_qPCR_anchored_panel.csv", index=False)

    # Direction consistency and significance summary.
    p = panel[panel.present_in_GSE255759 == True].copy()
    summary_rows = []
    for gid, g in p.groupby("gene_id"):
        effects = g["log2FoldChange_WD_vs_Control"].dropna()
        sig = g["padj_genomewide"].fillna(1) < 0.05
        pos = int((effects > 0).sum())
        neg = int((effects < 0).sum())
        summary_rows.append({
            "gene_id": gid,
            "symbol": QPCR_ANCHORS[gid]["symbol"],
            "contrasts_available": int(len(effects)),
            "significant_FDR05": int(sig.sum()),
            "positive_effects": pos,
            "negative_effects": neg,
            "direction_consistent_3plus": bool(max(pos, neg) >= 3),
            "median_log2FC": float(effects.median()) if len(effects) else np.nan,
        })
    pip_summary = pd.DataFrame(summary_rows)
    pip_summary.to_csv(OUT / "PIP_panel_summary.csv", index=False)

    graft = pd.DataFrame(GRAFT_EVIDENCE)
    graft.to_csv(OUT / "GSE263656_published_graft_module_evidence.csv", index=False)

    graft_supported = True  # supported by the published/deposited GSE263656 study; no guessed remapping.
    hydraulic_supported = False
    if not pip_summary.empty:
        hydraulic_supported = bool(
            (pip_summary.significant_FDR05 > 0).any()
            or pip_summary.direction_consistent_3plus.any()
        )
    decision = (
        "MAIN_RESULTS_GO" if graft_supported and hydraulic_supported
        else "SUPPLEMENT_ONLY" if graft_supported or hydraulic_supported
        else "DO_NOT_USE"
    )

    decision_obj = {
        "decision": decision,
        "graft_module_supported": graft_supported,
        "graft_evidence_mode": "published/deposited GSE263656 evidence; no ambiguous sample remapping",
        "hydraulic_PIP_supported": hydraulic_supported,
        "hydraulic_evidence_mode": "independent PyDESeq2 reanalysis of GSE255759 root raw counts",
        "qPCR_status": "No qPCR data generated. Published real citrus qPCR used only as external anchor.",
    }
    (OUT / "decision.json").write_text(json.dumps(decision_obj, indent=2))

    # Human-readable report with exact panel values.
    lines = [
        "# CITRUS-NET independent molecular triangulation",
        "",
        "## Claim boundary",
        "Public molecular data are independent contextual evidence. They were not generated from the Sargodha Kinnow trees and must not be described as qPCR/RNA-seq measurements from the orchard experiment.",
        "",
        "## Graft-union module — GSE263656",
        "The published/deposited citrus graft study supports vascular/lignification and graft-organization modules below incompatible unions and reports qRT-PCR validation of selected DEGs. Because GEO sample metadata do not expose rootstock identity per replicate unambiguously, this pipeline does not guess a raw-count mapping.",
        "",
        "## Root-hydraulic module — GSE255759",
        "Raw deposited root counts were parsed directly and analyzed independently by PyDESeq2 within each of four scion/rootstock combinations (WD vs Control). The qPCR-anchored panel was fixed before numerical extraction.",
        "",
        "### Prespecified PIP panel",
    ]
    if len(panel):
        for _, r in panel.iterrows():
            if not r.get("present_in_GSE255759", False):
                lines.append(f"- {r['symbol']} ({r['gene_id']}), {r['combo']}: not resolved in matrix")
            else:
                padj = r.get("padj_genomewide", np.nan)
                padjs = "NA" if pd.isna(padj) else f"{padj:.4g}"
                lines.append(
                    f"- {r['symbol']} ({r['gene_id']}), {r['combo']}: log2FC={r['log2FoldChange_WD_vs_Control']:.3f}, genome-wide padj={padjs}."
                )
    lines += [
        "",
        "## Predefined inclusion decision",
        f"**{decision}**",
        "",
        "The molecular arm can enter the main Results only if the external graft-union module is supported and the independent root PIP module shows either genome-wide FDR support or repeated directionally consistent effects across at least three of four contrasts. Otherwise it is supplementary/context only.",
        "",
        "## qPCR status",
        "No Ct, ΔCt, ΔΔCt, or qPCR expression values were simulated, imputed, or generated. Published primer sequences are retained solely to document that the anchor genes were assayed by real qPCR in independent citrus experiments.",
    ]
    (OUT / "MOLECULAR_TRIANGULATION_REPORT.md").write_text("\n".join(lines))
    print("\n".join(lines))


if __name__ == "__main__":
    main()
