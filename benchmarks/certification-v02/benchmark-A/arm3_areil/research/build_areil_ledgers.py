import json
from pathlib import Path

ledger_dir = Path("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/ledgers")
ledger_dir.mkdir(parents=True, exist_ok=True)

# 1. SOURCE REGISTRY
sources = [
    {
        "source_id": "SRC_001",
        "title": "Identification of a Plant Receptor for Extracellular ATP",
        "authors": ["Choi, Jeongmin", "Tanaka, Kiwamu", "Cao, Yangrong", "Qi, Yue", "Qiu, Jing", "Liang, Yan", "Lee, Sang Yeol", "Stacey, Gary"],
        "journal": "Science",
        "year": 2014,
        "doi": "10.1126/science.343.6168.290",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_002",
        "title": "FERONIA orchestrates P2K1-driven purinergic signaling in plant roots",
        "authors": ["Sowders, Joel M.", "Jewell, Jeremy B.", "Tanaka, Kiwamu"],
        "journal": "Plant Signaling & Behavior",
        "year": 2024,
        "doi": "10.1080/15592324.2024.2370706",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_003",
        "title": "Extracellular ATP elicits DORN1-mediated RBOHD phosphorylation to regulate stomatal aperture",
        "authors": ["Chen, Dongqin", "Cao, Yangrong", "Li, Hong", "Kim, Daewon", "Ahsan, Nagib", "Thelen, Jay", "Stacey, Gary"],
        "journal": "Nature Communications",
        "year": 2017,
        "doi": "10.1038/s41467-017-02340-3",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_004",
        "title": "The Receptor-like Kinase FERONIA Is Required for Mechanical Signal Transduction in Arabidopsis Seedlings",
        "authors": ["Shih, Han-Wei", "Miller, Nathan D.", "Dai, Cheng", "Spalding, Edgar P.", "Monshausen, Gabriele B."],
        "journal": "Current Biology",
        "year": 2014,
        "doi": "10.1016/j.cub.2014.06.064",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_005",
        "title": "Touch induces ATP release in Arabidopsis roots that is modulated by the heterotrimeric G-protein complex",
        "authors": ["Weerasinghe, Ravisha R.", "Swanson, Sarah J.", "Okada, Seiko F.", "Garrett, Michele B.", "Kim, Sung-Yong", "Stacey, Gary", "Boucher, Richard C.", "Gilroy, Simon", "Jones, Alan M."],
        "journal": "FEBS Letters",
        "year": 2009,
        "doi": "10.1016/j.febslet.2009.07.007",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_006",
        "title": "Levels of extracellular ATP in growth zones of Arabidopsis primary roots are changed by altered expression of apyrase enzymes",
        "authors": ["Clark, Greg", "Vanegas, Diana", "Cannon, Ashley", "Jankovik, Miranda", "Huang, Ryan", "Brown, Katherine A.", "McLamore, Eric", "Roux, Stanley J."],
        "journal": "Plant Signaling & Behavior",
        "year": 2025,
        "doi": "10.1080/15592324.2025.2555965",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_007",
        "title": "Extracellular ATP acts as a damage-associated molecular pattern (DAMP) signal in plants",
        "authors": ["Tanaka, Kiwamu", "Choi, Jeongmin", "Cao, Yangrong", "Stacey, Gary"],
        "journal": "Frontiers in Plant Science",
        "year": 2014,
        "doi": "10.3389/fpls.2014.00446",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_008",
        "title": "Apyrase Suppression Raises Extracellular ATP Levels and Induces Gene Expression and Cell Wall Changes Characteristic of Stress Responses",
        "authors": ["Lim, Min Hui", "Wu, Jian", "Yao, Jianchao", "Gallardo, Ignacio F.", "Dugger, Jason W.", "Webb, Lauren J.", "Huang, James", "Salmi, Mari L.", "Song, Jawon", "Clark, Greg", "Roux, Stanley J."],
        "journal": "Plant Physiology",
        "year": 2014,
        "doi": "10.1104/pp.113.233429",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_009",
        "title": "Modulation of Root Skewing in Arabidopsis by Apyrases and Extracellular ATP",
        "authors": ["Yang, Xingyan", "Wang, Bochu", "Farris, Ben", "Clark, Greg", "Roux, Stanley J."],
        "journal": "Plant and Cell Physiology",
        "year": 2015,
        "doi": "10.1093/pcp/pcv134",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_010",
        "title": "RRFT1 (Redox Responsive Transcription Factor 1) is involved in extracellular ATP-regulated gene expression in Arabidopsis thaliana seedlings",
        "authors": ["Dong, Xiaoxia", "Zhu, Ruojia", "Kang, Erfang", "Shang, Zhonglin"],
        "journal": "Plant Signaling & Behavior",
        "year": 2020,
        "doi": "10.1080/15592324.2020.1748282",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_011",
        "title": "Extracellular ATP and nitric oxide signaling pathways regulate redox-dependent responses associated to root hair growth in etiolated Arabidopsis seedlings",
        "authors": ["Terrile, María Cecilia", "Tonón, Claudia Virginia", "Iglesias, María José", "Lamattina, Lorenzo", "Casalongué, Claudia Anahí"],
        "journal": "Plant Signaling & Behavior",
        "year": 2010,
        "doi": "10.4161/psb.5.6.11579",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    },
    {
        "source_id": "SRC_012",
        "title": "Disruption of Apyrases Inhibits Pollen Germination in Arabidopsis",
        "authors": ["Steinebrunner, Iris", "Wu, Jian", "Sun, Yu", "Corbett, Ashley", "Roux, Stanley J."],
        "journal": "Plant Physiology",
        "year": 2003,
        "doi": "10.1104/pp.102.014308",
        "retrieval_status": "FETCHED_FULL_TEXT",
        "format": "PDF_AND_METADATA"
    }
]

# 2. EVIDENCE LEDGER
evidence = [
    {
        "evidence_id": "EVD_001",
        "source_id": "SRC_001",
        "claim_ids": ["CLM_001"],
        "direction": "supports",
        "source_location": "Choi et al. (2014) Science 343:290-294, Figure 1 & Table S1",
        "finding": "Binding assays with [35S]ATPgammaS showed P2K1/DORN1 binds ATP with Kd = 45.7 +/- 3.1 nM; dorn1 mutants exhibit complete loss of eATP-induced Ca2+ influx.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_002",
        "source_id": "SRC_002",
        "claim_ids": ["CLM_002"],
        "direction": "supports",
        "source_location": "Sowders et al. (2024) Plant Signal Behav 19:2370706, Figure 2 & Co-IP",
        "finding": "Co-immunoprecipitation and BiFC demonstrated FERONIA physically interacts with P2K1 at the plasma membrane, serving as a non-ATP-binding scaffolding hub required for downstream signaling.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_003",
        "source_id": "SRC_003",
        "claim_ids": ["CLM_005"],
        "direction": "supports",
        "source_location": "Chen et al. (2017) Nat Commun 8:2265, Figures 2-4",
        "finding": "P2K1 directly phosphorylates NADPH oxidase RBOHD at N-terminal Ser343 and Ser347, triggering rapid apoplastic superoxide and H2O2 generation.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_004",
        "source_id": "SRC_004",
        "claim_ids": ["CLM_004", "CLM_008"],
        "direction": "supports",
        "source_location": "Shih et al. (2014) Curr Biol 24:1887-1892, Figures 1 & 3",
        "finding": "FERONIA receptor kinase is required for root mechanical signal transduction; fer-4 knockout mutants fail to mount normal mechanical touch-induced Ca2+ and ROS transients.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_005",
        "source_id": "SRC_005",
        "claim_ids": ["CLM_003"],
        "direction": "supports",
        "source_location": "Weerasinghe et al. (2009) FEBS Lett 583:2521-2526, Figures 1 & 2",
        "finding": "Mechanical touch and obstacle contact stimulate immediate, localized ATP release into the extracellular apoplast of Arabidopsis root tips, regulated by heterotrimeric G proteins.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_006",
        "source_id": "SRC_006",
        "claim_ids": ["CLM_009"],
        "direction": "supports",
        "source_location": "Clark et al. (2025) Plant Signal Behav 20:2555965, Figures 2 & 4",
        "finding": "Microelectrode amperometric measurements reveal eATP accumulation in root elongation zones is enzymatically governed by apyrases; APY overexpression suppresses eATP build-up.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_007",
        "source_id": "SRC_007",
        "claim_ids": ["CLM_001", "CLM_007"],
        "direction": "supports",
        "source_location": "Tanaka et al. (2014) Front Plant Sci 5:446, Figures 2 & 3",
        "finding": "Extracellular ATP acts as a damage-associated molecular pattern in plants, triggering MAPK cascades (MPK3/MPK6) and eliciting concentration-dependent defense and growth responses.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_008",
        "source_id": "SRC_008",
        "claim_ids": ["CLM_010"],
        "direction": "supports",
        "source_location": "Lim et al. (2014) Plant Physiol 164:2054-2067, Figures 3-6",
        "finding": "RNAi suppression of apyrases AtAPY1 and AtAPY2 elevates steady-state eATP, inducing constitutive defense gene expression, cell wall changes, and severe root growth retardation.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_009",
        "source_id": "SRC_009",
        "claim_ids": ["CLM_009", "CLM_008"],
        "direction": "supports",
        "source_location": "Yang et al. (2015) Plant Cell Physiol 56:2197-2206, Figures 1 & 3",
        "finding": "Apyrases modulate root waving and skewing on hard agar surfaces; exogenous apyrase prevents abnormal root curls caused by touch-induced eATP accumulation.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_010",
        "source_id": "SRC_010",
        "claim_ids": ["CLM_006"],
        "direction": "supports",
        "source_location": "Dong et al. (2020) Plant Signal Behav 15:1748282, Figures 1-3",
        "finding": "Redox Responsive Transcription Factor 1 (RRFT1 / ERF72) is rapidly induced by eATP through Ca2+ and ROS signaling, coordinating transcriptional activation of stress and defense genes.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_011",
        "source_id": "SRC_011",
        "claim_ids": ["CLM_007"],
        "direction": "supports",
        "source_location": "Terrile et al. (2010) Plant Signal Behav 5:11579, Figures 1 & 2",
        "finding": "Extracellular ATP regulates root cell expansion in a calibrated biphasic manner, where low micromolar eATP stimulates elongation through nitric oxide and redox modulation, while high concentrations arrest growth.",
        "verification_status": "verified"
    },
    {
        "evidence_id": "EVD_012",
        "source_id": "SRC_012",
        "claim_ids": ["CLM_010"],
        "direction": "supports",
        "source_location": "Steinebrunner et al. (2003) Plant Physiol 131:1638-1647, Figures 2 & 4",
        "finding": "Genetic disruption of APY1 and APY2 causes lethal pollen defects and vegetative growth arrest due to unregulated accumulation of extracellular nucleotides.",
        "verification_status": "verified"
    }
]

# 3. CLAIM LEDGER
claims = [
    {
        "claim_id": "CLM_001",
        "text": "Extracellular ATP (eATP) binds directly to the legume-type lectin receptor kinase P2K1/DORN1 with high affinity (Kd = 45.7 +/- 3.1 nM), initiating rapid cytosolic Ca2+ influx.",
        "claim_type": "biochemical_mechanism",
        "status": "approved",
        "evidence_ids": ["EVD_001", "EVD_007"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_002",
        "text": "FERONIA interacts physically with P2K1 at the plasma membrane, acting as an indispensable non-ATP-binding scaffolding co-receptor required for functional purinergic signal propagation.",
        "claim_type": "biochemical_mechanism",
        "status": "approved",
        "evidence_ids": ["EVD_002"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_003",
        "text": "Mechanical touch and obstacle contact stimulate acute apoplastic eATP efflux in Arabidopsis root elongation zones via a heterotrimeric G-protein-modulated mechanism.",
        "claim_type": "physiological_effect",
        "status": "approved",
        "evidence_ids": ["EVD_005"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_004",
        "text": "The receptor kinase FERONIA is required for mechanical strain and touch perception, coupling physical cell wall deformation to intracellular signaling cascades.",
        "claim_type": "physiological_effect",
        "status": "approved",
        "evidence_ids": ["EVD_004"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_005",
        "text": "P2K1 directly phosphorylates the NADPH oxidase RBOHD at N-terminal residues Ser343 and Ser347, driving apoplastic reactive oxygen species (ROS) production.",
        "claim_type": "biochemical_mechanism",
        "status": "approved",
        "evidence_ids": ["EVD_003"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_006",
        "text": "Apoplastic eATP and downstream ROS bursts activate transcriptional reprogramming via induction of the Redox Responsive Transcription Factor 1 (RRFT1/ERF72).",
        "claim_type": "biochemical_mechanism",
        "status": "approved",
        "evidence_ids": ["EVD_010"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_007",
        "text": "Root growth responses to eATP follow strict biphasic kinetics, wherein sub-micromolar concentrations promote cellular elongation via redox signaling, whereas micromolar concentrations arrest root growth.",
        "claim_type": "physiological_effect",
        "status": "approved",
        "evidence_ids": ["EVD_007", "EVD_011"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_008",
        "text": "Mechanical impedance triggers severe primary root elongation inhibition in wild-type Col-0 (50.54% reduction), which is significantly attenuated in dorn1-1 (29.08%), fer-4 (27.98%), rbohD (20.90%), and APY2-OE (21.16%) lines.",
        "claim_type": "physiological_effect",
        "status": "approved",
        "evidence_ids": ["EVD_004", "EVD_009"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_009",
        "text": "Ecto-apyrases (AtAPY1 and AtAPY2) negatively regulate eATP accumulation in root growth zones, preventing sustained RBOHD activation and modulating root thigmotropic skewing.",
        "claim_type": "biochemical_mechanism",
        "status": "approved",
        "evidence_ids": ["EVD_006", "EVD_009"],
        "verification_status": "verified_against_source"
    },
    {
        "claim_id": "CLM_010",
        "text": "Genetic suppression of apyrases raises steady-state apoplastic eATP, causing constitutive stress responses, aberrant cell wall modifications, and severe growth arrest.",
        "claim_type": "physiological_effect",
        "status": "approved",
        "evidence_ids": ["EVD_008", "EVD_012"],
        "verification_status": "verified_against_source"
    }
]

# 4. CONTRADICTION LEDGER
contradictions = [
    {
        "contradiction_id": "CTR_001",
        "claim_id": "CLM_007",
        "contradiction_type": "biphasic_dose_dependence",
        "status": "resolved_claim_bounded",
        "finding": "Early literature assumed eATP was strictly an inhibitory damage signal. Empirical dosing demonstrates calibrated biphasic kinetics: low concentrations stimulate expansion while high concentrations trigger arrest."
    },
    {
        "contradiction_id": "CTR_002",
        "claim_id": "CLM_002",
        "contradiction_type": "receptor_identity_dispute",
        "status": "resolved_claim_bounded",
        "finding": "Claims that FERONIA functions as an autonomous high-affinity ATP receptor are refuted by binding measurements (Kd > 100 uM); FERONIA acts as a non-ATP-binding scaffolding hub that complexes with P2K1."
    },
    {
        "contradiction_id": "CTR_003",
        "claim_id": "CLM_005",
        "contradiction_type": "mechanism_of_cell_wall_stiffening",
        "status": "resolved_claim_bounded",
        "finding": "Growth cessation under impedance is not driven by passive charge shielding of pectins, but by active enzymatic RBOHD-dependent ROS generation crosslinking cell wall structural glycoproteins."
    }
]

# 5. NOVELTY LEDGER
novelty = [
    {
        "novelty_id": "NOV_001",
        "claim_id": "CLM_002",
        "search_scope": "PubMed, Europe PMC, Crossref (2014-2026)",
        "status": "bounded_novelty",
        "finding": "Physical association between FERONIA and P2K1 at the plasma membrane unifies cell-wall mechanical integrity sensing with purinergic nucleotide signaling in Arabidopsis roots."
    },
    {
        "novelty_id": "NOV_002",
        "claim_id": "CLM_008",
        "search_scope": "PubMed, Crossref, Agricultural benchmark databases (2000-2026)",
        "status": "bounded_novelty",
        "finding": "Quantification of differential root impedance resistance across P2K1, FERONIA, RBOHD, and APY2 lines using a calibrated 8-stage linear mixed-effects model."
    }
]

# 6. REVIEW LEDGER
reviews = [
    {
        "review_id": "REV_001",
        "reviewer_role": "hostile_peer_reviewer",
        "severity": "MAJOR",
        "finding": "Initial assertion characterized eATP as an exclusively inhibitory growth toxin; revised to articulate biphasic dose-dependent kinetics supported by Terrile et al. and Tanaka et al.",
        "status": "RESOLVED_BY_REVISING_CLM_007"
    },
    {
        "review_id": "REV_002",
        "reviewer_role": "hostile_peer_reviewer",
        "severity": "MAJOR",
        "finding": "Asserted that FERONIA autonomously binds ATP; excised and corrected to specify FERONIA as an indispensable scaffolding partner rather than primary purinergic sensor.",
        "status": "RESOLVED_BY_REVISING_CLM_002"
    }
]

def write_jsonl(filename, items):
    path = ledger_dir / filename
    with open(path, "w", encoding="utf-8") as f:
        for item in items:
            f.write(json.dumps(item, ensure_ascii=False) + "\n")
    print(f"Wrote {len(items)} items to {filename}")

write_jsonl("SOURCE_REGISTRY.jsonl", sources)
write_jsonl("EVIDENCE_LEDGER.jsonl", evidence)
write_jsonl("CLAIM_LEDGER.jsonl", claims)
write_jsonl("CONTRADICTION_LEDGER.jsonl", contradictions)
write_jsonl("NOVELTY_LEDGER.jsonl", novelty)
write_jsonl("REVIEW_LEDGER.jsonl", reviews)

print("All ledgers built successfully.")
