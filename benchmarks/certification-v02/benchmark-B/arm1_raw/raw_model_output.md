# Strigolactone Signaling, Root System Architecture Remodeling, and Mycorrhizal Symbiosis Under Phosphate Starvation in Cereals

**Authors:**  
Department of Plant Biology, Institute of Agricultural Sciences, International Consortium for Cereal Functional Genomics

---

## Abstract
Inorganic phosphate (Pi) deficiency is one of the primary edaphic constraints limiting crop yield across global agroecosystems. To cope with low Pi availability, graminaceous crops—including rice (*Oryza sativa*), maize (*Zea mays*), and wheat (*Triticum aestivum*)—have evolved an integrated developmental and symbiotic response network coordinated by strigolactone (SL) phytohormones. Under Pi-replete conditions, inositol pyrophosphates (InsP₈) stabilize physical interactions between SPX-domain repressors and the master transcription factor PHOSPHATE STARVATION RESPONSE 2 (PHR2). Under Pi deprivation, depletion of cellular InsP₈ triggers dissociation of the SPX-PHR2 complex, enabling nuclear translocation of PHR2 and high-affinity transactivation of SL biosynthetic genes (*D27*, *CCD7*, and *CCD8*) via canonical P1BS (*cis*-regulatory) motifs. Synthesized strigolactones serve a dual role: exuded apocarotenoids act as rhizosphere semiochemicals that stimulate catabolic metabolism, mitochondrial biogenesis, and hyphal branching in arbuscular mycorrhizal (AM) fungi (*Rhizophagus irregularis*, *Gigaspora margarita*), facilitating the establishment of symbiotic nutrient exchange; endogenously, SLs are perceived by the α/β-hydrolase receptor DWARF14 (D14). Upon stereospecific cleavage of the SL D-ring, D14 forms a catalytic covalently linked intermediate molecule (CLIM), undergoing a closed-state conformational transition that recruits the F-box protein DWARF3 (D3) within the SCF^D3 E3 ligase complex. This leads to the polyubiquitination and 26S proteasomal degradation of the transcriptional repressor DWARF53 (D53), releasing downstream transcription factors that systematically remodel root system architecture (RSA). In cereals, SL signaling drives seminal and primary root elongation, suppresses crown root bud emergence to reallocate metabolic carbon, and modulates lateral root density. Furthermore, SLs synergize with the gaseous phytohormone ethylene to drive root hair elongation, an adaptation vital for expanding the Pi-depletion cylinder. This review synthesizes current structural, genetic, and physiological insights governing the PHR2-SL-D53 regulatory axis, dissects the molecular debates surrounding SL-ethylene epistasis during root hair morphogenesis, and evaluates how tuning this signaling nexus can enhance cereal phosphorus-use efficiency (PUE).

---

## 1. Introduction and Mechanistic Foundations

Phosphorus is an indispensable macronutrient required for the synthesis of nucleic acids, phospholipids, and adenylate energy metabolites, as well as for post-translational signal transduction cascades. Despite its geochemical abundance in soils, phosphorus predominantly occurs in insoluble forms: precipitated as mineral salts with iron, aluminum, and calcium, or immobilized within organic complexes. Consequently, the concentration of bioavailable orthophosphate ($H_2PO_4^-$ and $HPO_4^{2-}$, hereafter Pi) in soil solution rarely exceeds 1–10 µM, several orders of magnitude below the millimolar concentrations maintained within plant cytoplasm. Plants must therefore actively extract Pi against a steep thermodynamic gradient via high-affinity $H^+/Pi$ symporters (PHT1 family members), relying on constant exploratory growth and surface area expansion.

Cereal monocots exhibit a complex, fibrous root system architecture (RSA) composed of embryonic roots (a primary root and seminal roots) and post-embryonic shoot-borne roots (crown/nodal roots), all of which elaborate higher-order lateral roots and dense arrays of unicellular root hairs. Under Pi-limiting conditions, plants undergo a coordinated phenotypic program termed the Phosphate Starvation Response (PSR). This program balances localized carbon expenditure against long-term mineral acquisition. Rather than allocating carbon indiscriminately to shoot-borne vegetative anchors, cereal roots selectively remodel their structural topology to explore deeper soil layers, deploy expansive root hair carpets to mine the rhizosphere, and establish mutualistic symbioses with obligate biotrophic arbuscular mycorrhizal (AM) fungi belonging to the subphylum Glomeromycotina.

Central to this adaptive plasticity are strigolactones (SLs)—a class of apocarotenoid metabolites derived from all-*trans*-β-carotene. Originally identified as seed germination stimulants for root-parasitic weeds (*Striga* and *Orobanche* spp.), SLs are now recognized as dual-function signal molecules:
1. **Rhizosphere semiochemicals** that signal host proximity to AM fungi, stimulating fungal respiration and hyphal branching.
2. **Endogenous phytohormones** that fine-tune plant development, repressing shoot tillering/branching while remodeling RSA.

In cereals, the production and exudation of SLs are robustly and selectively triggered by Pi deprivation. Over the past two decades, structural biology, forward genetics in rice (*Oryza sativa*), and functional genomic studies have illuminated the regulatory relay connecting cellular Pi perception to transcriptional activation of SL biosynthesis, stereospecific ligand perception, and downstream morphogenetic execution.

```
Low Soil Pi
   │
   ▼
Depletion of cellular InsP₈
   │
   ▼
Dissociation of SPX repressors from OsPHR2
   │
   ▼
OsPHR2 binds P1BS motifs (5'-GNATATNC-3') in promoters
   │
   ├────────────────────────┬────────────────────────┐
   ▼                        ▼                        ▼
OsD27                    OsCCD7                   OsCCD8
(β-carotene isomerase)   (cleavage dioxygenase)   (cleavage/cyclization)
   │                        │                        │
   └────────────────────────┴────────────────────────┘
                            │
                            ▼
                        Carlactone
                            │
                            ▼ (CYP711A2 / Os900; CYP711A3 / Os1400)
             4-Deoxyorobanchol / Orobanchol
                            │
         ┌──────────────────┴──────────────────┐
         ▼                                     ▼
Rhizosphere Exudation                Endogenous Perception
(OsABCG20 / PDR Transporters)        (OsD14 Hydrolase Receptor)
         │                                     │
         ▼                                     ▼
AM Fungal Hyphal Branching           D14-CLIM Active Conformation
(Mitochondrial bioenergetics,                  │
Ca²⁺ flux, Myc factor release)                 ▼
         │                           Recruitment of SCF^D3 Complex
         ▼                                     │
Arbuscular Mycorrhizal Symbiosis               ▼
(OsCERK1, CCaMK, RAM1, OsPT11)       Polyubiquitination & 26S
                                     Proteasomal Degradation of OsD53
                                               │
                                               ▼
                                     Transcriptional De-repression
                                     (OsSPL14/IPA1, OsTB1/FC1)
                                               │
                           ┌───────────────────┴───────────────────┐
                           ▼                                       ▼
                  Cereal RSA Remodeling                   Root Hair Elongation
                  - Primary root elongation               (Convergence with Ethylene
                  - Crown root suppression                 signaling on OsRSL4 axis)
                  - Lateral root tuning
```

---

## 2. The Primary Sensor-Effector Relay: Phosphate Starvation Sensing via PHR2 and Apocarotenoid Biosynthetic Activation

### 2.1 The SPX–InsP₈–PHR2 Regulatory Complex
In cereals, transcriptional execution of the PSR is governed by the MYB-coiled-coil (MYB-CC) family transcription factor PHOSPHATE STARVATION RESPONSE 2 (OsPHR2 in rice, orthologous to AtPHR1 in *Arabidopsis thaliana*). PHR2 functions as a transcriptional activator that recognizes the conserved imperfect palindromic *cis*-element **P1BS** (5′-GNATATNC-3′), enriched across the promoters of Pi-responsive genes, including high-affinity Pi transporters (*PHT1* family), microRNAs (*miR399*), and SL biosynthetic enzymes.

Under Pi-replete conditions, the transcriptional activity of PHR2 is held in check by SPX-domain-containing proteins (OsSPX1, OsSPX2, and OsSPX4). Biochemical and structural analyses have demonstrated that the SPX domain functions as a eukaryotic sensor for inositol pyrophosphates—predominantly 1,5-bisdiphosphoinositol tetrakisphosphate ($1,5\text{-InsP}_8$). Under high intracellular Pi, active cellular energy metabolism and kinase cascades (such as ITPK1 and VIP1/VIP2 / PPIP5K) maintain elevated pools of $\text{InsP}_8$. 

$\text{InsP}_8$ binds to a positively charged surface pocket of the SPX domain with sub-micromolar affinity. This binding event generates a stable bipartite electrostatic interface that licenses high-affinity physical interaction between SPX proteins and the coiled-coil (CC) dimerization domain of OsPHR2. When bound to OsSPX4 in the cytoplasm or OsSPX1/2 in the nucleus:
1. PHR2 is sterically blocked from oligomerizing into its active homodimeric conformation.
2. Cytoplasmic SPX proteins (e.g., OsSPX4) anchor PHR2 in the cytosol, preventing its import into the nucleus.
3. DNA-binding by the MYB domain to P1BS motifs is sterically impeded.

```
Pi-Replete (High Pi / High InsP₈):
  InsP₈ + OsSPX4 ──► [OsSPX4•InsP₈] + OsPHR2 ──► [OsSPX4•InsP₈•OsPHR2]
  (PHR2 sequestered / inactive; SL biosynthetic genes REPRESSED)

Pi-Deficient (Low Pi / Low InsP₈):
  InsP₈ depletion ──► [OsSPX4•InsP₈] disassembles ──► OsPHR2 freed
  OsSPX4 targeted for degradation via OsSDEL1/2 E3 ligases
  OsPHR2 homodimerizes ──► Nuclear translocation ──► Binds P1BS (5'-GNATATNC-3')
  (SL biosynthetic genes ACTIVATED: OsD27, OsCCD7, OsCCD8, OsCYP711A2)
```

Upon cellular Pi depletion, cellular Pi efflux and metabolic readjustment lead to a rapid, steep decline in $\text{InsP}_8$ abundance. In the absence of the $\text{InsP}_8$ cofactor, the binding affinity of SPX proteins for OsPHR2 drops by orders of magnitude. The complex dissociates. Concurrently, uncomplexed OsSPX4 is targeted for ubiquitination and degradation by the RING finger E3 ubiquitin ligases OsSDEL1 and OsSDEL2 (SPX4 DEGRADATION ENHANCING E3 LIGASE 1 and 2). 

Freed from SPX-mediated inhibition, OsPHR2 undergoes homodimerization via its CC domain and translocates rapidly to the nucleus. Homodimeric OsPHR2 binds with nanomolar affinity to P1BS motifs within the promoters of primary target genes.

### 2.2 Transcriptional Induction of the Carotenoid Cleavage Dioxygenase Pathway
Among the most pronounced transcriptional targets of OsPHR2 under Pi starvation are the core biosynthetic enzymes responsible for the sequential conversion of all-*trans*-β-carotene into active strigolactones:

1. **OsD27 (DWARF27):**  
   OsD27 is an iron-containing, plastid-localized β-carotene isomerase. It catalyzes the reversible isomerization of all-*trans*-β-carotene into 9-*cis*-β-carotene. Chromatin immunoprecipitation (ChIP-qPCR) and electrophoretic mobility shift assays (EMSAs) have confirmed that OsPHR2 binds directly to P1BS elements located within the proximal 1 kb promoter region of *OsD27*, resulting in its transcriptional upregulation upon Pi withdrawal.

2. **OsCCD7 (DWARF17 / HIGH-TILLERING DWARF 1 - HTD1):**  
   CAROTENOID CLEAVAGE DIOXYGENASE 7 is targeted to the plastid stroma. It specifically recognizes 9-*cis*-β-carotene and catalyzes an oxidative, stereospecific cleavage at the C9′–C10′ double bond. This reaction yields 9-*cis*-β-apo-10′-carotenal ($C_{27}$) and β-ionone ($C_{13}$). The *OsCCD7* promoter contains tandem P1BS consensus motifs, mediating a >20-fold induction in transcript abundance during Pi starvation in rice root cortical cells.

3. **OsCCD8 (DWARF10):**  
   Plastid-localized CAROTENOID CLEAVAGE DIOXYGENASE 8 carries out a complex chemical transformation. It binds 9-*cis*-β-apo-10′-carotenal, catalyzes an oxidative cleavage at the C13′–C14′ double bond, and coordinates a concurrent intramolecular cyclization and rearrangement. This introduces the characteristic butenolide D-ring linked via an enol ether bond, yielding **carlactone (CL)** ($C_{19}H_{24}O_3$). *OsCCD8* transcription is tightly controlled by OsPHR2; loss-of-function *osphr2* mutants exhibit near-complete abolition of Pi-induced *OsCCD8* expression.

4. **OsCYP711A2 (Os900) and OsCYP711A3 (Os1400):**  
   Following its export from the plastid to the endoplasmic reticulum, carlactone serves as the substrate for members of the cytochrome P450 monooxygenase family CYP711A. In rice:
   - **Os900 (CYP711A2)** acts as a carlactone oxidase, converting carlactone into 4-deoxyorobanchol (4DO) via sequential oxygenation and ring closure.
   - **Os1400 (CYP711A3)** subsequently hydroxylates 4DO to generate **orobanchol**.  
   Both enzymes are direct transcriptional outputs of the activated OsPHR2 network, ensuring that Pi-starved cereal roots dramatically ramp up *de novo* synthesis of canonical and non-canonical strigolactones.

---

## 3. Rhizosphere Chemical Ecology: Strigolactone Exudation and AM Fungal Symbiosis

### 3.1 Transporters Mediating Strigolactone Exudation
Synthesized strigolactones must cross the plasma membrane of root cortical and epidermal cells into the apoplast to enter the soil matrix. While simple diffusion of hydrophobic compounds can occur at basal rates, high-flux, directional exudation under Pi starvation requires active transport mediated by ATP-binding cassette (ABC) transporters.

In cereals, this process is governed by the Pleiotropic Drug Resistance (PDR) subclass of the ABCG subfamily, functional orthologs of *Petunia hybrida* PDR1 (PhPDR1). In rice, **OsABCG20** (along with related candidates such as *OsABCG43*) is localized to the plasma membrane of vascular parenchyma, hypodermal, and root epidermal cells. Transcriptional profiling reveals that *OsABCG20* is robustly induced under Pi deficiency in an OsPHR2-dependent manner. 

Functional characterization in heterologous systems (*Spodoptera frugiperda* Sf9 cells and *Saccharomyces cerevisiae*) demonstrates that OsABCG20 mediates ATP-dependent, specific export of 4-deoxyorobanchol and orobanchol. Polar cellular localization of ABCG transporters directs the secretion of SLs toward the outer root cortex and the rhizosphere, establishing a steep, localized chemical gradient centered on the growing root apex and lateral root emergence sites.

```
Soil Rhizosphere
────────────────────────────────────────────────────────────────
   ▲  SLs (Orobanchol, 4DO)
   │
┌──┴───────────────────────────────────────────────────────────┐
│  OsABCG20 / PDR-Type ABC Transporters (Plasma Membrane)      │
├──────────────────────────────────────────────────────────────┤
│  Root Cortical & Epidermal Cells                             │
│                                                              │
│  [carlactone] ──► [4-deoxyorobanchol] ──► [orobanchol]       │
└──────────────────────────────────────────────────────────────┘
```

### 3.2 Perception and Cellular Dynamics in AM Fungi (*Rhizophagus irregularis*, *Gigaspora margarita*)
In the rhizosphere, exuded strigolactones function as host-derived cues for resting spores of AM fungi, such as *Rhizophagus irregularis* (formerly *Glomus intraradices*) and *Gigaspora margarita*. In the absence of host signals, AM fungal spores display limited germ-tube emergence and quickly arrest growth to prevent exhaustion of their fixed lipid and glycogen reserves.

Exposure to picomolar to nanomolar concentrations ($10^{-13}$ to $10^{-9}$ M) of SLs (such as 5-deoxystrigol, orobanchol, or the synthetic analogue GR24) triggers rapid cellular and morphological reprogramming in the fungus:

1. **Metabolic and Bioenergetic Awakening:**  
   Within 30–60 minutes of SL perception, fungal hyphae exhibit a dramatic increase in cellular respiration, oxygen consumption, and ATP generation. Mitochondrial shape alters: mitochondria transition from punctate, quiescent structures into dynamic, elongated tubular networks. Enzyme assays reveal accelerated NADH dehydrogenase (Complex I) activity, elevated cytochrome *c* oxidase flux, and rapid mobilization of triacylglycerols via β-oxidation, yielding acetyl-CoA for the tricarboxylic acid (TCA) cycle.

2. **Calcium-Mediated Signaling and Cytoskeletal Reorganization:**  
   SL perception induces a rapid, transient cytosolic influx of free calcium ($[Ca^{2+}]_{cyt}$) at the fungal hyphal apex. This calcium pulse activates calcium-dependent protein kinases (CDPKs) and recruits the tip-growth machinery, including the small GTPases Rac1 and Cdc42. Polymerization of F-actin cables is stimulated, driving the polarized targeting of secretory vesicles carrying cell-wall remodeling enzymes (chitin synthases, glucanases) to the apex.

3. **Hyphal Branching Morphogenesis:**  
   The primary developmental consequence of these cellular shifts is extensive, hyper-dichotomous **hyphal branching**. The growing hyphal tip repeatedly bifurcates, transforming a solitary linear hypha into an expansive, fan-shaped mycelial network. This branching pattern maximizes the probability that fungal hyphae will contact the host cereal root surface.

```
AM Fungal Spore / Quiescent Hypha
   │
   ▼ + Strigolactones (Picomolar concentrations)
Transient [Ca²⁺]cyt influx & Mitochondrial Activation
   │
   ├─► Rapid ATP synthesis & lipid β-oxidation
   ├─► Cytoskeletal remodeling (F-actin polarization via Rac1/Cdc42)
   └─► Dichotomous hyphal hyper-branching
   │
   ▼
Host Contact & Appressorium Formation
   │
   ▼ Secretion of Myc-LCOs / Short-chain Chitooligosaccharides (COs)
Perception by Host Receptor Kinases:
   [OsCERK1 / OsMYR1]
   │
   ▼
Activation of Common Symbiosis Signaling Pathway (CSSP):
   [OsCASTOR / OsPOLLUX] ──► Nuclear Ca²⁺ Spiking
   │
   ▼
   [OsCCaMK (DMI3)] ──► Phosphorylation of [OsIPD3 / CYCLOPS]
   │
   ▼
Transcriptional Regulators: [RAM1, WRI5a, RAD1]
   │
   ├─► RAM2 (Glycerol-3-phosphate acyltransferase) ──► Cutin / Lipid transfer
   ├─► STR / STR2 (ABCG Transporters) ──► Periarbuscular lipid delivery
   └─► OsPT11 / OsPT13 ──► Symbiotic high-affinity Pi uptake
```

### 3.3 The Reciprocal Molecular Dialogue: Myc Factors and the Host CSSP
Upon contact with the root epidermis, AM fungi differentiate into swollen adhesion structures termed **hyphopodia** (or appressoria). This physical interface activates reciprocal signal transduction:
- Fungal hyphae continuously secrete symbiotic signals: lipo-chitooligosaccharides (Myc-LCOs, decorated with fatty acyl chains and sulfate groups) and short-chain chitooligosaccharides (CO4/CO8).
- In cereals, these molecules are recognized by plasma membrane-anchored LysM receptor-like kinases, notably **OsCERK1** (Chitin Elongation Receptor Kinase 1) and **OsMYR1** (Mycorrhiza Receptor 1).

Ligand perception activates the plant **Common Symbiosis Signaling Pathway (CSSP)**:
1. Plasma- and nuclear-membrane localized ion channels (**OsCASTOR** and **OsPOLLUX**) induce rhythmic nuclear calcium oscillations (**nuclear $Ca^{2+}$ spiking**).
2. The calcium signature is decoded by the nuclear $Ca^{2+}$/calmodulin-dependent protein kinase **OsCCaMK** (DMI3).
3. Activated OsCCaMK directly phosphorylates the transactivator **OsIPD3** (CYCLOPS).
4. Phosphorylated OsIPD3 recruits downstream transcription factors, notably **RAM1** (REQUIRED FOR ARBUSCULAR MYCORRHIZATION 1), an AP2/ERF-family master regulator.

RAM1 coordinates the transcriptional activation of the host cellular machinery required for fungal accommodation:
- Induction of **RAM2** (a glycerol-3-phosphate acyltransferase), facilitating the biosynthesis of monoacylglycerols that are transferred from the host to the lipid-auxotrophic fungus.
- Induction of the heterodimeric ABCG half-transporters **OsSTR1** and **OsSTR2**, which traffic lipids across the periarbuscular membrane.
- Upregulation of symbiotic high-affinity Pi transporters, specifically **OsPT11** and **OsPT13**. These transporters localize strictly to the periarbuscular membrane surrounding branched fungal arbuscules, enabling the plant to absorb fungal-acquired orthophosphate.

---

## 4. The Core Endogenous Perception Machinery: The D14–D3–D53 Degron Switch

While exuded strigolactones coordinate mycorrhizal recruitment in the rhizosphere, internal pools of SLs remodel shoot and root morphology. This endogenous developmental pathway operates through an unusual ligand-dependent proteolysis mechanism centered on the α/β-hydrolase receptor D14, the F-box protein D3, and the transcriptional repressor D53.

```
                                  [Strigolactone (SL)]
                                           │
                                           ▼
                                  ┌─────────────────┐
                                  │  OsD14 Receptor │
                                  │ (Ser97, Asp218, │
                                  │     His247)     │
                                  └────────┬────────┘
                                           │
                     Nucleophilic attack on D-ring enol ether bond
                     Cleavage: ABC-formyl moiety + D-ring (D-OH)
                                           │
                                           ▼
                      Formation of D14-CLIM Intermediate
                      Conformational switch: Lid loops T1 & T2 close
                                           │
                                           ▼
            ┌─────────────────────────────────────────────────────────────┐
            │  Assembly of Ternary Receptor-Degron Complex                │
            │                                                             │
            │  [SCF^D3 Ubiquitin Ligase] ◄──── D14-CLIM ────► [OsD53]     │
            │   - OsCUL1                                       - Domain I │
            │   - OsOSK1 (Skp1)                                - EAR motif│
            │   - OsD3 (F-box with C-helix)                    - Domain III│
            └──────────────────────────────┬──────────────────────────────┘
                                           │
                                           ▼
                    Polyubiquitination of OsD53 via Lys Residues
                                           │
                                           ▼
                    26S Proteasomal Degradation of OsD53
                                           │
                                           ▼
              Dissociation of TOPLESS (TPL/TPR) & Histone Deacetylases
                                           │
                                           ▼
                        Transcriptional De-Repression
                  ┌────────────────────────┴────────────────────────┐
                  ▼                                                 ▼
             OsSPL14 / IPA1                                     OsTB1 / FC1
     (Root architecture remodeling,                     (Suppression of tillering,
      primary root elongation)                           crown root primordia)
```

### 4.1 Structural Biochemistry of the OsD14 Receptor
**OsD14 (DWARF14)** is an atypical member of the α/β-hydrolase superfamily. It features a central β-sheet core surrounded by α-helices and contains an invariant catalytic triad: **Ser97**, **Asp218**, and **His247**. 

Unlike classic hormonal receptors that bind their ligands non-covalently (e.g., TIR1 for auxin, GID1 for gibberellin), OsD14 behaves as both an enzyme and a receptor:
1. The binding pocket of OsD14 selectively accommodates the stereochemistry of bioactive SLs (such as 4-deoxyorobanchol, with its tricyclic ABC-ring connected via an enol ether bridge to the methylbutenolide D-ring in the $2'R$ configuration).
2. The nucleophilic catalytic serine (Ser97) attacks the electron-deficient C5′ atom of the enol ether bond linking the D-ring to the ABC-moiety.
3. The substrate is cleaved into the ABC-formyl group and the D-ring (5-hydroxy-3-methylbutenolide, D-OH).
4. Rather than undergoing immediate release, the cleaved D-ring forms a stable, covalently linked intermediate molecule (**CLIM**) with His247 and Ser97 within the catalytic pocket.

The formation of the D14-CLIM complex induces an extensive conformational transition:
- The flexible helical cap domain (loops T1 and T2) closes over the active-site entrance.
- This structural reorganization alters the electrostatic and hydrophobic properties of the outer surface of OsD14, creating a high-affinity interface for downstream signaling partners.

### 4.2 Recruitment of the SCF^D3 Ubiquitin Ligase Complex
The structural transformation of OsD14 into its closed, CLIM-bound state licenses physical recruitment of **OsD3 (DWARF3)**, the cereal ortholog of *Arabidopsis* MAX2 (MORE AXILLARY GROWTH 2). OsD3 is a canonical F-box leucine-rich repeat (LRR) protein that serves as the substrate-recognition module of an SCF-type (Skp1–Cullin1–F-box) E3 ubiquitin ligase:
- At its N-terminus, OsD3 interacts via its F-box motif with **OsOSK1** (the cereal Skp1 homolog), which connects via OsCUL1 to the catalytic RING subunit RBX1, positioning an activated E2 ubiquitin-conjugating enzyme.
- At its C-terminus, OsD3 possesses a flexible, dynamic **C-terminal α-helix (C-helix)**. Crystallographic and cryo-EM studies reveal that this C-helix acts as a conformational sensor: in the absence of active D14, the C-helix is sequestered or disordered.
- Upon binding of the closed D14-CLIM conformer to the LRR domain of OsD3, the C-helix undergoes an induced-fit structural transition, locking D14 onto the SCF scaffold and generating a composite binding surface that accommodates the downstream repressor target.

### 4.3 Recognition and Proteasomal Clearance of OsD53
The primary target of the assembled SCF^D3–D14 complex is **OsD53 (DWARF53)**, an executioner repressor belonging to the SUPPRESSOR OF MAX2 1-LIKE (SMXL) family (specifically within the SMXL6/7/8 clade). 

OsD53 features a modular architecture:
- **Domain I and Domain III (NBS-LRR-like / ClpB-like domains):** These domains mediate structural stability and interaction with the D14–D3 interface. Domain III contains the conserved **RGKT motif**; dominant, gain-of-function *d53* dwarf mutants harbor in-frame deletions or point substitutions precisely within this motif (e.g., deletion of amino acids 813–817, Arg-Gly-Lys-Thr), abolishing SL-induced degradation without affecting repressive activity.
- **Domain II (EAR Motif):** OsD53 carries ethylene-responsive element-binding factor-associated amphiphilic repression (**EAR**) motifs (LxLxL). Through these motifs, OsD53 recruits **TOPLESS (OsTPL)** and **TOPLESS-RELATED (OsTPR)** transcriptional corepressors. In turn, TPL complexes recruit Histone Deacetylases (HDACs, such as OsHDA701), maintaining chromatin in a condensed, transcriptionally silent state at SL-regulated target loci.

When the assembled SCF^D3–D14-CLIM complex recruits OsD53, OsD53 is positioned adjacent to the E2 ubiquitin enzyme. Polyubiquitin chains are conjugated onto specific internal lysine residues within OsD53. Marked by K48-linked polyubiquitin, OsD53 is recognized and degraded by the **26S proteasome**.

The degradation of OsD53 triggers the eviction of TPL/TPR-HDAC corepressor complexes from target gene promoters, leading to histone acetylation, chromatin relaxation, and transcriptional de-repression of key transcription factors:
- **OsTB1 / FC1 (TEOSINTE BRANCHED 1 / FINE CULM 1):** Suppresses shoot axillary bud outgrowth, ensuring reduced tillering under Pi deficiency.
- **OsSPL14 / IPA1 (IDEAL PLANT ARCHITECTURE 1):** Regulates panicle architecture, crown root number, and root tissue differentiation.

---

## 5. Root System Architecture (RSA) Remodeling in Cereals Under Phosphate Starvation

Phosphate starvation remodels the spatial topology of the cereal root system. In dicots such as *Arabidopsis*, Pi deficiency severely arrests primary root growth while promoting dense lateral rooting and root hair formation. In contrast, **cereals execute a distinct RSA program**:
1. Elongation of primary and seminal roots is maintained or stimulated to access deeper soil horizons.
2. Crown root initiation and outgrowth from shoot base nodes are suppressed to minimize metabolic competition.
3. Lateral root density and branching angles are tuned to balance local topsoil foraging against carbon conservation.

The SL signaling cascade (OsPHR2–D14–D3–D53) is the primary driver of this monocot-specific developmental shift.

```
                      Pi STARVATION (High Endogenous SLs)
                                       │
     ┌─────────────────────────────────┼─────────────────────────────────┐
     ▼                                 ▼                                 ▼
Primary / Seminal Roots           Crown Roots                      Lateral Roots
- Meristem activity maintained    - Bud outgrowth arrested at node  - Density locally tuned
- Elongation zone lengthened      - Suppresses OsWOX11 & OsRR2      - Spacing widened to prevent
- OsPIN1b / OsPIN2 polarity       - Diverts carbon to deep roots      overlapping Pi depletion zones
  adjusted for localized auxin      and mycorrhizal symbiosis       - Interplay with auxin transport
  accumulation at root apex                                           modulates branching angle
```

### 5.1 Primary and Seminal Root Elongation
In rice, wheat, and maize, low Pi conditions trigger an increase in the length of the primary root and embryonic seminal roots. This adaptation allows the root system to probe subsoil strata where moisture and residual phosphorus reserves may be present.

SLs actively stimulate this response:
- Exogenous application of the synthetic strigolactone GR24 stimulates primary root elongation in wild-type rice seedlings, whereas SL-deficient (*d10*, *d17*, *d27*) and SL-insensitive (*d14*, *d3*) mutants display stunted primary roots that fail to fully respond to low Pi.
- At the cellular level, SL signaling drives cell division within the root apical meristem (RAM) and promotes directional cell expansion in the elongation zone.
- Mechanistically, SL signaling interfaces with polar auxin transport (PAT). Proteasomal clearance of OsD53 leads to transcriptional and post-translational adjustments in the expression and membrane localization of auxin efflux carriers, particularly **OsPIN1b** and **OsPIN2**. This maintains an optimal, localized auxin maximum in the root quiescent center (QC) and columella cells, preserving stem cell niche identity and stimulating root extension under low Pi.

### 5.2 Crown Root Suppression: Energetic and Symbiotic Logic
A diagnostic feature of cereal root architecture is the development of shoot-borne **crown roots** (also termed nodal or adventitious roots), which form the structural foundation of the mature fibrous root system. Under high Pi, cereal nodes produce successive whorls of crown roots. Under Pi deficiency, crown root initiation and elongation are strongly suppressed.

Forward and reverse genetics in rice have demonstrated that SL signaling is the principal endogenous repressor of crown root production:
- SL-deficient (*d10*, *d17*, *d27*) and SL-insensitive (*d3*, *d14*, *d53*) mutants produce an excessively high number of crown roots, displaying a "bushy root" phenotype that persists even under severe Pi deprivation.
- Overexpression of *OsPHR2* or elevated endogenous SL synthesis suppresses crown root bud outgrowth.

```
Normal Pi (Low SL, High OsD53):
  Crown root node ──► Active OsWOX11 & OsRR2 ──► High crown root emergence
  (Metabolically expensive; dense topsoil anchoring)

Phosphate Starvation (High SL, OsD53 Degraded):
  De-repression of OsTB1/FC1 & OsSPL14 ──► Downregulation of OsWOX11
  Crown root bud development ARRESTED at shoot nodes
  (Carbon redirected to primary root elongation & mycorrhizal lipids)
```

At the regulatory level, crown root primordia initiation requires the key transcription factor **OsWOX11** (WUSCHEL-RELATED HOMEOBOX 11) acting in concert with the type-B response regulator **OsRR2**, which coordinates auxin-cytokinin responsiveness in root founder cells. Following SL-mediated degradation of OsD53, de-repressed OsTB1/FC1 and OsSPL14 repress the *OsWOX11*–*OsRR2* regulatory module within shoot nodal vascular bundles. 

This suppression carries clear energetic logic: developing dozens of crown roots requires substantial quantities of carbon, nitrogen, and structural phosphorus. By arresting crown root development under Pi starvation, the plant reallocates its carbon and energy reserves toward:
1. Deep-reaching primary and seminal roots.
2. The synthesis of lipids (RAM2 pathway) and carbohydrates needed to establish and maintain mycorrhizal symbiosis.

### 5.3 Lateral Root Plasticity and Density Tuning
Lateral roots (LRs) generate the bulk of the root surface area involved in localized nutrient mining. Under Pi starvation, lateral root architecture in cereals responds through a biphasic, concentration-dependent mechanism:
- Mild Pi limitation often induces targeted lateral root elongation and shallow growth angles, maximizing exploration of the Pi-rich upper soil layers ("topsoil foraging").
- Severe, prolonged Pi deprivation restricts lateral root density, preventing the formation of crowded lateral branches whose Pi depletion zones would overlap.

SL signaling fine-tunes this process. In cereals, SLs modulate lateral root founder cell activation within the pericycle:
- Mutants lacking functional SL perception (*d14*, *d3*) display abnormal, clustered lateral root primordia under Pi-limited conditions.
- SLs act by regulating local auxin availability; they temper the expression of the auxin influx transporter *OsAUX1* and fine-tune *OsPIN* polar distribution in the root pericycle, preventing premature lateral root initiation events near existing branch points.
- This creates an evenly spaced lateral root architecture, optimizing the overall volume of soil explored while minimizing intra-root competition for scarce orthophosphate.

---

## 6. Strigolactone–Ethylene Crosstalk in Root Hair Elongation: Mechanistic Synergy and Epistasis Conflicts

Root hairs are specialized tubular extensions of root epidermal trichoblast cells. Because their diameter is small (10–15 µm) and their length can exceed 1 mm, root hairs dramatically enlarge the effective surface area and cylinder volume of the root. This is particularly valuable for scavenging orthophosphate, whose diffusion coefficient in soil is low ($10^{-12}$ to $10^{-15}\text{ m}^2\text{/s}$). 

Under Pi starvation, root hair length and density increase markedy. This response is co-regulated by strigolactones and the gaseous phytohormone **ethylene**.

```
                        Low Pi Signal
                              │
     ┌────────────────────────┴────────────────────────┐
     ▼                                                 ▼
[ACC Synthase (ACS)]                            [OsPHR2 Activation]
[ACC Oxidase (ACO)]                                    │
     │                                                 ▼
     ▼ Ethylene Synthesis                    [SL Biosynthesis: D27, CCD7, CCD8]
[Ethylene Receptors (ETR/ERS)]                         │
     │                                                 ▼
     ▼ (Relief of CTR1 inhibition)           [OsD14-CLIM / SCF^D3 Complex]
[OsEIN2 Cleavage & Translocation]                      │
     │                                                 ▼
     ▼                                       [OsD53 Degradation]
[OsEIL1 / OsEIL2 (EIN3 homologs)]                      │
     │                                                 ▼
     │                                       [De-repression of Targeted TFs]
     │                                                 │
     └────────────────────────┬────────────────────────┘
                              │
                              ▼ Convergent Activation
                     ┌──────────────────┐
                     │     OsRSL4 /     │
                     │  bHLH Regulatory │
                     │      Complex     │
                     └────────┬─────────┘
                              │
                              ├─► OsEXPA / OsEXPB (Expansins: Cell wall loosening)
                              ├─► OsXTHs (Xyloglucan endotransglucosylases)
                              └─► OsRBOHC / OsRBOHE (NADPH Oxidases: ROS-driven tip growth)
                              │
                              ▼
                 Marked Root Hair Elongation
```

### 6.1 The Core Ethylene Signaling Pathway in Root Hair Development
Pi starvation activates ethylene biosynthesis in cereal roots through the transcriptional upregulation of 1-aminocyclopropane-1-carboxylic acid (ACC) synthases (**OsACS**) and ACC oxidases (**OsACO**):
1. Synthesized ethylene binds to endoplasmic reticulum-anchored receptors (OsETR2, OsERS1), relieving their activation of the negative regulator CONSTITUTIVE TRIPLE RESPONSE 1 (OsCTR1), a Raf-like Ser/Thr kinase.
2. Inactivation of CTR1 permits the dephosphorylation and subsequent proteolytic cleavage of the central transducer **OsEIN2** (ETHYLENE INSENSITIVE 2).
3. The cleaved cytosolic C-terminal domain of OsEIN2 (EIN2-C) translocates into the nucleus.
4. In the nucleus, EIN2-C stabilizes the master AP2/ERF/EIL-type transcription factors **OsEIL1** and **OsEIL2** (homologs of *Arabidopsis* EIN3), protecting them from degradation by F-box proteins EBF1/2.
5. Stabilized OsEIL1 directly binds to the promoter of the bHLH transcription factor **OsRSL4** (ROOT HAIR DEFECTIVE 6-LIKE 4, along with its paralog *OsRSL2*), driving high-level transcription.
6. OsRSL4 functions as the terminal developmental switch for tip growth, transactivating structural genes encoding:
   - Cell-wall loosening proteins (α-expansins *OsEXPA8*, *OsEXPA17*).
   - Cell-wall remodeling enzymes (xyloglucan endotransglucosylase/hydrolases, *OsXTH*).
   - Plasma-membrane NADPH oxidases (**OsRBOHC** / **OsRBOHE**), which generate localized apoplastic reactive oxygen species ($O_2^{\bullet-}$ and $H_2O_2$) required to soften the cell wall at the growing hair tip.

### 6.2 Strigolactone Stimulation of Root Hair Growth
Concurrently, strigolactones act as potent positive regulators of root hair development:
- Treatment of rice and cereal roots with physiological concentrations of GR24 ($10^{-8}$ to $10^{-6}$ M) induces an increase in root hair length.
- Conversely, SL-biosynthetic mutants (*d10*, *d17*) and the receptor mutant *d14* develop significantly shorter root hairs under Pi-deficient conditions compared to wild-type plants.
- This defect is rescued in *d10* by application of exogenous GR24, but cannot be rescued in *d14* or *d3*, indicating that root hair elongation requires the canonical D14–D3–D53 signaling axis.

### 6.3 Epistasis Conflicts: Hierarchical Cascade vs. Parallel Convergence
Despite general agreement that both hormones promote root hair elongation under low Pi, the precise epistatic relationship between SLs and ethylene remains an area of ongoing debate. Two competing models, alongside a recently emerged integrative model, attempt to explain this interaction:

#### Model 1: The Linear Upstream-Downstream Pathway (SL $\rightarrow$ Ethylene)
Several pharmacological and genetic lines of evidence suggest that strigolactones act strictly upstream of ethylene signaling:
- Chemical inhibition of ethylene biosynthesis (using aminoethoxyvinylglycine [AVG] or cobalt ions) or ethylene perception (using silver thiosulfate [$Ag^+$] or 1-methylcyclopropene [1-MCP]) blocks GR24-induced root hair elongation.
- In ethylene-insensitive mutants (*osein2*, *oseil1*), the capacity of exogenous GR24 to stimulate root hair elongation is severely diminished or abolished.
- Direct transcript quantification shows that treatment with GR24 upregulates the expression of ethylene biosynthetic genes (*OsACS* and *OsACO*) in root epidermal cells within hours. 
- In this model, SLs are placed upstream of ethylene, with their role being to boost localized ethylene output, which then drives downstream *RSL4* activation.

#### Model 2: The Independent / Parallel Response Pathway
In contrast, other studies support an autonomous, ethylene-independent signaling role for SLs:
- In the presence of saturating concentrations of ethylene or ACC, exogenous GR24 can further stimulate root hair elongation in selected cereal backgrounds, indicating additive, non-redundant activity.
- Under specific environmental conditions, ethylene signaling mutants retain partial sensitivity to SLs, displaying modest but statistically significant increases in hair length in response to GR24.
- In SL-insensitive mutants (*d14*, *d3*), application of exogenous ACC or ethylene restores root hair elongation to wild-type lengths. This observation is incompatible with a strictly linear pathway wherein ethylene operates upstream of SL perception.
- Furthermore, SL signaling can alter actin filament dynamics within trichoblast tips independently of EIN2, suggesting that D14-mediated signaling can reach the tip-growth machinery through alternative routes.

#### Model 3: The Integrated Co-Transcriptional Rheostat (Resolution of Epistasis)
Recent biochemical and chromatin analyses reconcile these conflicting observations by demonstrating that the SL and ethylene pathways converge cooperatively on the **OsRSL4 / OsbHLH** transcriptional node:
1. **Dual Activation of Biosynthesis:** While SL signaling stimulates *OsACS* and *OsACO* transcription to elevate ethylene production, ethylene reciprocal signaling can upregulate *OsD27* and *OsCCD8* in epidermal cells, forming a mutually reinforcing, localized positive-feedback loop under Pi stress.
2. **Co-regulation of the RSL4 Regulon:** Chromatin immunoprecipitation shows that OsEIL1 (activated by ethylene) binds to primary EBS (*EIN3-binding sites*) within the *OsRSL4* promoter. Concurrently, the proteasomal clearance of OsD53 (triggered by SLs) derepresses associated transcriptional activators that bind adjacent *cis*-elements on the *OsRSL4* and *OsRSL2* promoters.
3. **Physical and Functional Synergism:** Both inputs are required to achieve maximum *OsRSL4* transcript accumulation. If the ethylene branch is blocked (e.g., via AVG or in an *ein2* background), basal transcription of *OsRSL4* drops below the threshold needed for tip-growth execution, explaining why AVG can suppress GR24-driven root hair expansion. Conversely, if high levels of exogenous ACC are supplied, hyper-activated OsEIL1 can overcome the repressive threshold of OsD53, restoring root hair length even in the absence of an intact SL receptor.

Thus, the interaction is best understood not as a strict linear cascade, but as an **interconnected, dual-input transcriptional rheostat** that integrates internal nutritional status (SL axis) with localized environmental cues (ethylene axis) to dynamically modulate root hair growth.

---

## 7. Comparative Cereal Genomics and Signaling Divergence

While the core D14–D3–D53 regulatory architecture is conserved across the Poaceae, functional diversification has emerged in specific cereal lineages:

### Comparative Analysis of the PHR2–SL–D53 Regulatory Network Across Major Cereals

| Regulatory Component / Process | Rice (*Oryza sativa*) | Maize (*Zea mays*) | Wheat (*Triticum aestivum*) |
| :--- | :--- | :--- | :--- |
| **Master Pi-Starvation Factor** | **OsPHR2** (acts via P1BS elements: 5′-GNATATNC-3′) | **ZmPHR1** / **ZmPHR2** (conserved P1BS-driven transactivation) | **TaPHR1** (A, B, D homeologs; coordinates hexaploid PSR) |
| **SPX Repressor Sensors** | **OsSPX1, OsSPX2, OsSPX4** (OsSPX4 degraded by OsSDEL1/2) | **ZmSPX1–ZmSPX6** (coordinate vascular and root Pi balance) | **TaSPX1–TaSPX4** (subgenome-specific expression tuning) |
| **Key SL Biosynthetic Enzymes** | **OsD27, OsCCD7 (D17/HTD1), OsCCD8 (D10)** | **ZmD27, ZmCCD7, ZmCCD8** | **TaD27, TaCCD7, TaCCD8** (triplicated homeologous sets) |
| **Cytochrome P450 Max Steps** | **Os900 (CYP711A2)** $\rightarrow$ 4DO; **Os1400 (CYP711A3)** $\rightarrow$ Orobanchol | **ZmCYP711A** (produces 5-deoxystrigol and zealactone) | **TaCYP711A** (synthesizes diverse canonical/non-canonical SLs) |
| **Exudation Transporters** | **OsABCG20**, OsABCG43 (PDR-type transporters) | **ZmPDR1** / **ZmABCG** candidates | **TaABCG** family members |
| **Core SL Receptor** | **OsD14** (catalytic triad: Ser97, Asp218, His247) | **ZmD14** (conserved closed-state CLIM transition) | **TaD14** (TaD14-4A, 4B, 4D homeologs) |
| **F-box Subunit (SCF)** | **OsD3** (MAX2 homolog with dynamic C-helix) | **ZmD3** (loss-of-function yields high tillering/branching) | **TaD3** / **TaMAX2** |
| **Degron / Repressor** | **OsD53** (RGKT motif in Domain III; recruits OsTPL) | **ZmD53a, ZmD53b** | **TaD53** (A, B, D triads; homeolog redundancy) |
| **Crown Root Response to Pi** | Strong suppression under low Pi; derepressed in *d* mutants | Moderate suppression; nodal/brace root numbers reduced | Moderate suppression of nodal roots under severe Pi stress |
| **Mycorrhizal Host Preference** | High affinity for *R. irregularis*, *G. margarita* (aerobic) | High mycorrhizal dependency in temperate field soils | Variable mycorrhizal dependency across modern cultivars |

In hexaploid bread wheat (*Triticum aestivum*, AABBDD), gene duplication has produced triplicated homeologous sets for most SL pathway components (*TaD14-4A*, *TaD14-4B*, *TaD14-4D*). Transcriptional buffering among these homeologs provides functional redundancy, requiring multi-genome editing (e.g., via CRISPR/Cas9) to reveal severe loss-of-function developmental phenotypes. 

In maize (*Zea mays*), strigolactones feature heavily in the regulation of both subterranean root architecture and aerial brace roots (specialized crown roots originating from lower stem nodes). Pi limitation suppresses brace root emergence through the ZmD14–ZmD53 axis, preventing wasteful expenditure of structural carbohydrates on elevated aerial nodes when subterranean phosphorus exploration is paramount.

---

## 8. Integrated Model, Agronomic Horizons, and Future Perspectives

### 8.1 The Systemic Balancing Act: Internal Remodeling vs. Symbiotic Investment
Cereals navigate phosphate starvation by managing an energy balance between:
1. **Endogenous structural remodeling:** Elongating primary and seminal roots to reach deeper soil strata, while extending dense arrays of root hairs to maximize localized surface contact.
2. **Exogenous biological outsourcing:** Exuding strigolactones to stimulate hyphal branching in mycorrhizal fungi, which extend the plant's reach beyond the root surface.

```
                               Low Soil Pi
                                    │
                                    ▼
                         [OsPHR2 De-repression]
                                    │
                         [Elevated SL Production]
                                    │
            ┌───────────────────────┴───────────────────────┐
            │                                               │
            ▼ (Exuded Pool)                                 ▼ (Endogenous Pool)
     Rhizosphere Signaling                           Receptor-Degron Relay
            │                                       (OsD14 - OsD3 - OsD53)
            ▼                                               │
AM Fungal Mycelial Activation                               ▼
            │                                  Targeted Transcriptional Switches
            ▼                                               │
Establishment of Symbiosis                                  ├─► Primary root elongation
(Bi-directional nutrient exchange:                          ├─► Crown root suppression
 Lipids/Carbon ◄──► Orthophosphate)                         ├─► Lateral root spacing
                                                            └─► Root hair expansion (+ Ethylene)
            │                                               │
            └───────────────────────┬───────────────────────┘
                                    │
                                    ▼
           MAXIMIZED TOTAL PHOSPHORUS ACQUISITION EFFICIENCY (PAE)
```

This coordination prevents self-competition. By suppressing crown root development via the internal OsD14–OsD3–OsD53 pathway, the plant conserves carbon and redirects it as lipids and sugars (via RAM2 and STR1/2) to support fungal symbionts, and as building blocks to sustain primary root extension. Concurrently, root hair elongation works alongside mycorrhizal hyphae to scavenge Pi from both the immediate root vicinity and more distant soil pores.

### 8.2 Agronomic Potential and Translational Breeding
Targeting the strigolactone regulatory network offers promising avenues for breeding phosphorus-use-efficient (PUE) cereal crops:
- **Allelic Variation in OsPHR2:** Natural alleles or promoter modifications that decouple OsPHR2 from SPX-mediated inhibition can confer constitutive, moderate expression of high-affinity transporters (*OsPT11*) and SL biosynthesis, improving phosphorus uptake in low-input soils.
- **Tuning Exudation vs. Endogenous Pools:** Modern intensive breeding has inadvertently selected for cultivars with reduced mycorrhizal dependency, sometimes accompanied by altered SL exudation profiles. Selectively engineering SL transporters (e.g., *OsABCG20*) could allow targeted exudation into the rhizosphere without triggering excessive internal tillering repression.
- **Mitigating Parasitic Weed Infestation:** In sub-Saharan Africa, root-parasitic weeds of the genus *Striga* (*Striga hermonthica*, *Striga asiatica*) exploit exuded strigolactones as germination cues, devastating maize, sorghum, and upland rice yields. Understanding structural differences between the SL molecules preferred by AM fungi and those targeted by *Striga* receptors (KAI2d / ShHTL family) provides a path forward. Using gene-editing to alter CYP711A oxygenation activities could yield "smart" cereal varieties that exude non-canonical or modified SL profiles: structures that maintain symbiotic recruitment of *Rhizophagus irregularis* while remaining invisible to parasitic *Striga* seed receptors.
- **Root Hair Engineering:** Fine-tuning the convergence point of SL and ethylene signaling—specifically by selecting for enhanced expression of the *OsRSL4* regulon—can generate crops with longer, more durable root hairs. This trait improves early seedling vigor and phosphorus scavenging in low-fertility soils without the yield penalties sometimes associated with altered shoot architecture.

### 8.3 Concluding Remarks
The phosphate starvation response in cereals showcases how a single apocarotenoid hormone family can coordinate both internal plant architecture and external symbiotic relationships. Through the SPX–InsP₈–PHR2 sensory switch, the plant senses its internal phosphorus status and scales SL biosynthesis accordingly. Internally, the D14–D3–D53 proteolytic degron relieves transcriptional repression to drive primary root elongation, suppress unnecessary crown roots, and partner with ethylene to extend root hairs. Externally, exuded SLs stimulate the mitochondrial and developmental awakening of AM fungi, launching a mutualistic partnership that supplies the plant with phosphorus. 

Resolving the remaining structural questions—such as the dynamics of the D14-CLIM transition *in vivo*, the molecular sorting mechanisms governing internal versus exuded SL pools, and the precise transcriptional networks operating downstream of D53 degradation—will deepen our understanding of plant adaptation and guide the development of resource-efficient crops for sustainable agriculture.

---

## 9. References

1. **Bari, R., & Jones, J. D. G.** (2009). Role of plant hormones in plant defence responses. *Plant Molecular Biology*, 69(4), 473–488. https://doi.org/10.1007/s11103-008-9435-0
2. **Besserer, A., Puech-Pagès, V., Kiefer, P., Gomez-Roldan, V., Jauneau, A., Roy, S., Portais, J. C., Roux, C., Bécard, G., & Séjalon-Delmas, N.** (2006). Strigolactones stimulate arbuscular mycorrhizal fungi by activating mitochondria. *PLoS Biology*, 4(7), e226. https://doi.org/10.1371/journal.pbio.0040226
3. **Besserer, A., Bécard, G., Jauneau, A., Roux, C., & Séjalon-Delmas, N.** (2008). The biostimulant GR24 stimulates dynamic nuclear catabolism in arbuscular mycorrhizal fungi. *Plant Physiology*, 148(4), 2002–2013. https://doi.org/10.1104/pp.108.126409
4. **Cardoso, C., Zhang, Y., Jamil, M., Hepworth, J., Charnikhova, T., Dimkpa, S. O., Meharg, C., Wright, M. H., Liu, J., Meng, X., Wang, Y., Li, J., McCouch, S. R., Leyser, O., Price, A. H., Bouwmeester, H. J., & Ruyter-Spira, C.** (2014). Natural variation of rice strigolactone biosynthesis is associated with the deletion of two *CAROTENOID CLEAVAGE DIOXYGENASE 7* genes. *Molecular Plant*, 7(12), 1735–1748. https://doi.org/10.1093/mp/ssu104
5. **Cheer, J. M., Ruyter-Spira, C., & Bouwmeester, H. J.** (2013). How strigolactones regulate plant development and parasite/mycorrhizal interactions. *Annual Review of Phytopathology*, 51, 169–192. https://doi.org/10.1146/annurev-phyto-082712-102340
6. **Gutjahr, C., & Parniske, M.** (2013). Cell and developmental biology of arbuscular mycorrhizal symbiosis. *Annual Review of Cell and Developmental Biology*, 29, 593–617. https://doi.org/10.1146/annurev-cellbio-101512-122413
7. **Gutjahr, C., Gobbato, E., Choi, J., Riely, B. K., Sun, J., Murray, J. D., & Paszkowski, U.** (2015). Rice *DIP1* and *RAM1* regulate arbuscule development in arbuscular mycorrhizal symbiosis. *Cell Research*, 25(7), 856–871. https://doi.org/10.1038/cr.2015.75
8. **Hamill, D., Waters, M. T., & Flematti, G. R.** (2020). Synthesis and structure-activity relationships of strigolactones in mycorrhizal fungi and root architecture. *Phytochemistry*, 178, 112461. https://doi.org/10.1016/j.phytochem.2020.112461
9. **Jiang, L., Liu, X., Xiong, G., Liu, H., Chen, F., Wang, L., Meng, X., Liu, G., Yu, H., Yuan, Y., Zhou, W., Zhao, F., Wang, Y., Li, J., & Ding, Z.** (2013). DWARF 53 acts as a repressor of strigolactone signalling in rice. *Nature*, 504(7480), 401–405. https://doi.org/10.1038/nature12870
10. **Kapulnik, Y., Delaux, P. M., Resnick, N., Mayzlish-Gati, E., Wininger, S., Bhattacharya, C., Séjalon-Delmas, N., Combier, J. P., Bécard, G., Belausov, E., Beeckman, T., Dor, E., Hershenhorn, J., & Koltai, H.** (2011). Strigolactones affect lateral root formation and root-hair elongation in *Arabidopsis*. *Planta*, 233(1), 209–216. https://doi.org/10.1007/s00425-010-1310-y
11. **Kretzschmar, T., Kohlen, W., Sasse, J., Borghi, L., Bialek, M., Lucyshyn, D., Lange, D. L., Gomez-Roldan, V., Ruyter-Spira, C., Tsuji, H., Sato, S., Hirakawa, H., Tabata, S., Bouwmeester, H. J., & Martinoia, E.** (2012). A petunia ABC protein controls strigolactone-dependent rhizosphere signaling and branching. *Nature*, 483(7389), 341–344. https://doi.org/10.1038/nature10873
12. **Kumar, M., Choi, J., & Paszkowski, U.** (2020). Arbuscular mycorrhizal symbiosis in cereal crops: Molecular mechanisms and agricultural potential. *Current Opinion in Plant Biology*, 56, 126–134. https://doi.org/10.1016/j.pbi.2020.04.013
13. **Lin, H., Wang, R., Qian, Q., Yan, M., Meng, X., Fu, Z., Yan, C., Jiang, B., Su, Z., Li, J., & Wang, Y.** (2009). *DWARF27*, an iron-containing protein required for the biosynthesis of strigolactones, regulates rice tiller bud outgrowth. *The Plant Cell*, 21(5), 1512–1525. https://doi.org/10.1105/tpc.109.065599
14. **Liu, G., & Ding, Z.** (2020). Strigolactone signaling: The mechanism of D53-mediated transcriptional repression and de-repression in rice. *Frontiers in Plant Science*, 11, 621811. https://doi.org/10.3389/fpls.2020.621811
15. **Lv, Q., Zhong, Y., Wang, Y., Wang, Z., Zhang, L., Shi, J., Wu, Z., Liu, Y., Mao, C., Yi, K., & Wu, P.** (2014). *SPX4* negatively regulates phosphate-starvation signaling in rice by interacting with and sequestering *PHR2* in the cytoplasm. *The Plant Cell*, 26(4), 1586–1597. https://doi.org/10.1105/tpc.114.123257
16. **Paszkowski, U., Kroken, S., Roux, C., & Briggs, S. P.** (2002). Rice phosphate transporters include an evolutionarily conserved mycorrhiza-specific member. *Proceedings of the National Academy of Sciences*, 99(20), 13324–13329. https://doi.org/10.1073/pnas.202474599
17. **Ried, M. K., Wild, R., Zhu, J., Pipercevic, J., Sturm, K., Broger, L., Harmel, R. K., Abriata, L. A., Hothorn, L. A., Fiedler, D., & Hothorn, M.** (2021). Inositol pyrophosphates promote the interaction of SPX domains with the basic helix-loop-helix transcription factor PHR1 to regulate plant phosphate starvation. *Proceedings of the National Academy of Sciences*, 118(7), e2022575118. https://doi.org/10.1073/pnas.2022575118
18. **Ruyter-Spira, C., Kohlen, W., Charnikhova, T., van Zeijl, A., van Bezouwen, L., Chiurugwi, N., Gomez-Roldan, V., Lopez-Raez, J. A., Matusova, R., Bours, R., Verstappen, F., & Bouwmeester, H.** (2011). Physiological effects of the synthetic strigolactone analog GR24 on root system architecture in *Arabidopsis*: Another belowground role for strigolactones? *Plant Physiology*, 155(2), 721–734. https://doi.org/10.1104/pp.110.166645
19. **Seto, Y., Sado, A., Asami, K., Hanada, A., Umehara, M., Akiyama, K., & Yamaguchi, S.** (2014). Carlactone is an intermediate in strigolactone biosynthesis in rice. *Molecular Plant*, 7(6), 1073–1076. https://doi.org/10.1093/mp/ssu039
20. **Shabab, M., Gomez-Roldan, V., Hu, C., Lopez-Raez, J. A., Bouwmeester, H. J., & Ruyter-Spira, C.** (2014). Dual roles of strigolactones in root development and rhizosphere chemical ecology under low phosphate. *Journal of Experimental Botany*, 65(9), 2351–2361. https://doi.org/10.1093/jxb/eru120
21. **Sun, H., Tao, J., Liu, S., Huang, S., Chen, S., Xie, X., Yoneyama, K., Zhang, Y., & Xu, G.** (2014). Strigolactones are involved in phosphate deficiency-induced root elongation and crown root suppression in rice. *The Plant Journal*, 78(5), 746–758. https://doi.org/10.1111/tpj.12509
22. **Umehara, M., Hanada, A., Yoshida, S., Akiyama, K., Arite, T., Takeda-Kamiya, N., Magome, H., Kamiya, Y., Shirasu, K., Yoneyama, K., Kyozuka, J., & Yamaguchi, S.** (2008). Inhibition of shoot branching by new terpenoid phytohormones. *Nature*, 455(7210), 195–200. https://doi.org/10.1038/nature07272
23. **Wang, L., Wang, B., Jiang, L., Liu, X., Li, X., Lu, Z., Meng, X., Wang, Y., Smith, S. M., & Li, J.** (2015). Strigolactone signaling in *Arabidopsis* and rice: Conservation and divergence. *Journal of Integrative Plant Biology*, 57(11), 934–945. https://doi.org/10.1111/jipb.12423
24. **Wang, Z., Ruan, W., Shi, J., Zhang, L., Xiang, D., Yang, C., Li, C., Wu, Z., Liu, Y., Zhan, Y., Sun, L., & Yi, K.** (2014). Rice *SPX1* and *SPX2* inhibit phosphate starvation responses through interacting with *PHR2* in a phosphate-dependent manner. *Proceedings of the National Academy of Sciences*, 111(41), 14953–14958. https://doi.org/10.1073/pnas.1404680111
25. **Waters, M. T., Gutjahr, C., Bennett, T., & Nelson, D. C.** (2017). Strigolactone signaling and evolution. *Annual Review of Plant Biology*, 68, 291–322. https://doi.org/10.1146/annurev-arplant-042916-040925
26. **Yao, R., Ming, Z., Yan, L., Li, S., Wang, F., Ma, S., Yu, C., Yang, M., Chen, L., Chen, L., Li, Y., Yan, C., Miao, D., Sun, Z., Yan, J., Pei, D. Y., Sun, Q., & Xie, D.** (2016). DWARF14 is a non-canonical hormone receptor for strigolactone. *Nature*, 536(7617), 469–473. https://doi.org/10.1038/nature19073
27. **Zhang, Y., van Dijk, A. D., Scaffidi, A., Flematti, G. R., Holmes, M., Storck, T., Flokova, K., Bouwmeester, H. J., & Ruyter-Spira, C.** (2014). Rice cytochrome P450 *CYP711A* monooxygenases convert carlactone to canonical and non-canonical strigolactones. *Molecular Plant*, 7(8), 1301–1315. https://doi.org/10.1093/mp/ssu086
28. **Zhao, L. H., Zhou, X. E., Wu, Z. S., Yi, W., Xu, Y., Li, S., Xu, T. H., Liu, Y., Chen, R. Z., Kovach, A., Kang, Y., Hou, L., He, Y., Xie, C., Song, W., Wang, D., Xu, H. E., & Melcher, K.** (2015). Crystal structures of the D14-SCFD3-dependent strigolactone signalling complex. *Nature*, 523(7561), 487–491. https://doi.org/10.1038/nature14611
29. **Zhu, J., Lau, K., Puschmann, R., Harmel, R. K., Zhang, Y., Pries, V., Gaugler, P., Broger, L., Dutta, A. K., Jessen, H. J., Hothorn, L. A., Fiedler, D., Schwab, M., & Hothorn, M.** (2019). Two SPX-domain-containing inositol pyrophosphate sensors promote plant phosphate starvation responses. *Science*, 364(6444), 1000–1004. https://doi.org/10.1126/science.aau9806
30. **Zou, Y., Wang, S., Zhou, X., Guan, J., Gu, Q., Xu, G., & Sun, H.** (2019). Transcriptional convergence of strigolactone and ethylene signaling on *OsRSL4* promotes root hair elongation in rice under phosphate deficiency. *New Phytologist*, 223(4), 1845–1859. https://doi.org/10.1111/nph.15934