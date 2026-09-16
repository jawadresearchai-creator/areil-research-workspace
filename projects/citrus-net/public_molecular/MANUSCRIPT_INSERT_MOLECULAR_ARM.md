# Manuscript insert — independent molecular triangulation

## Recommended subsection title
Independent citrus molecular evidence links graft-union organization with root hydraulic transport

## Methods text
Public gene-expression data were analysed as an independent molecular-context arm and were not appended to, pooled with, or used to redefine observations from the mature Kinnow root-graft experiment. Before numerical extraction, the molecular analysis was restricted to two biological modules: (i) vascular-union organization, represented by lignification/secondary-wall and auxin-responsive programs, and (ii) root hydraulic transport, represented by plasma-membrane intrinsic protein (PIP) aquaporins. For graft-union context, GSE263656 was used at the level supported by the deposited study and publication because GEO sample metadata did not identify rootstock assignment for each replicate unambiguously; no replicate identity was inferred. That study compared compatible US-812 and incompatible US-1283 citrus graft combinations in vascular tissue above and below the graft union and independently checked selected RNA-seq targets by qRT-PCR. For root hydraulic context, the deposited GSE255759 root raw-count matrix was parsed directly and analysed with PyDESeq2 separately within four scion/rootstock combinations (ML2x, ML4x, PL2x and PL4x), contrasting nine-day water deficit with the corresponding irrigated control. Genome-wide Benjamini–Hochberg-adjusted P values were retained. Two PIP transcripts were fixed before inspecting GSE255759 differential-expression results because they had previously been quantified by real citrus-root qPCR: PIP1 (Ciclev10012384) and PIP2 (Ciclev10029003). Public molecular effects were interpreted only as independent mechanistic context and not as gene-expression measurements from the orchard root grafts.

## Results text
Independent citrus molecular evidence converged on two processes relevant to the physiological phenotype observed in the orchard. In GSE263656, the strongest transcriptional reprogramming associated with graft incompatibility occurred below the graft union on the rootstock side. The published/deposited analysis identified repression of phenylpropanoid/lignin-associated programs in incompatible unions, including class III peroxidase and laccase transcripts, while AUX/IAA transcripts were predominantly induced and SAUR transcripts predominantly repressed. Selected RNA-seq targets from that study were independently checked by qRT-PCR and showed strong positive agreement with the transcriptomic measurements. These external observations support the biological plausibility that successful citrus vascular integration depends on coordinated secondary-wall and graft-organization programs, but they do not establish that those transcripts differed in the natural root grafts examined here.

A separate reanalysis of GSE255759 provided root-hydraulic context. The prespecified PIP1 transcript Ciclev10012384 showed no genome-wide significant water-deficit response in any of the four scion/rootstock combinations (log2 fold changes: ML2x, -0.435, adjusted P = 0.375; ML4x, 0.001, adjusted P = 0.999; PL2x, -0.101, adjusted P = 0.863; PL4x, -0.015, adjusted P = 0.988). In contrast, PIP2 Ciclev10029003 decreased under water deficit in all four combinations: -1.946 log2-fold in ML2x (adjusted P = 1.36 × 10^-5), -0.667 in ML4x (adjusted P = 0.0944), -1.277 in PL2x (adjusted P = 0.00312), and -0.842 in PL4x (adjusted P = 0.194). Thus, the direction of the PIP2 response was reproduced across all four independent citrus scion/rootstock combinations, with genome-wide FDR significance in two. Because these effects came from an external water-deficit experiment rather than the root-graft orchard, they are used only to place the observed inter-tree water transfer within an independently demonstrated citrus root-water-transport framework.

## Discussion bridge
The public molecular evidence does not identify a molecular cause of inter-tree water transfer in the present trees, but it narrows the mechanistic context in two useful ways. First, independent citrus graft-union transcriptomics links successful versus disrupted vascular integration to secondary-wall/lignification and auxin-responsive programs, complementing the anatomical distinction observed here between fully continuous R5 unions and incompletely continuous, tracer-negative R4 unions. Second, the repeated water-deficit response of a qPCR-anchored PIP2 aquaporin across independent citrus rootstock/scion combinations is consistent with dynamic regulation of root membrane water transport. These molecular observations therefore triangulate, rather than replace, the direct evidence supplied by anatomy, stable-isotope transfer, receiver hydraulic recovery and loss of transfer after graft severing.

## Claim boundaries that must remain in the manuscript
- Do not write that PIP1/PIP2 were measured in the Sargodha Kinnow trees.
- Do not write that PIP2 caused inter-tree transfer.
- Do not write that the GSE263656 stem-graft transcriptome reproduces natural root-graft biology.
- Do state that the external datasets provide independent citrus molecular context for vascular-union organization and hydraulic regulation.
- Do state that no qPCR values were generated or simulated for the present experiment.
- Keep the causal conclusion based on isotope transfer plus graft severing/sham, not on public expression data.

## Recommended molecular figure
One compact figure only:
A. Evidence architecture: orchard causal experiment kept separate from public molecular evidence.
B. Published GSE263656 graft-union module: vascular/lignification and AUX/IAA–SAUR response below incompatible unions; explicitly label as external stem-graft evidence.
C. Forest plot of GSE255759 PIP1/PIP2 log2 fold changes with 95% intervals across ML2x, ML4x, PL2x and PL4x.
D. Triangulation diagram: vascular continuity ↔ external graft-union biology; inter-tree water transfer ↔ external PIP root-hydraulic biology.

The figure caption should state: 'Public molecular datasets were analysed or summarized independently and were not combined statistically with observations from the Kinnow root-graft experiment.'
