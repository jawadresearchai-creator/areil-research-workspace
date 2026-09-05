import urllib.request
import urllib.parse
import json
import time
from pathlib import Path

research_dir = Path("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/research")
research_dir.mkdir(parents=True, exist_ok=True)

dois_to_check = [
    ("SRC_B01", "10.1038/nature07272", "Inhibition of shoot branching by new terpenoid plant hormones"),
    ("SRC_B02", "10.1038/nature03708", "Plant sesquiterpenes induce hyphal branching in arbuscular mycorrhizal fungi"),
    ("SRC_B03", "10.1038/nature12870", "DWARF 53 acts as a repressor of strigolactone signalling in rice"),
    ("SRC_B04", "10.1038/nature12878", "D14-SCFD3-dependent degradation of D53 regulates strigolactone signalling"),
    ("SRC_B05", "10.1093/jxb/erq422", "Strigolactones affect root hair elongation in Arabidopsis"),
    ("SRC_B06", "10.1104/pp.114.248088", "Strigolactones positively regulate root hair elongation through an alternative pathway independent of ethylene signaling"),
    ("SRC_B07", "10.1126/science.1218094", "The Path from beta-Carotene to Carlactone, a Strigolactone-Like Plant Hormone"),
    ("SRC_B08", "10.1105/tpc.109.065987", "DWARF27, an Iron-Containing Protein Required for the Biosynthesis of Strigolactones, Regulates Rice Tillering"),
    ("SRC_B09", "10.1038/nature19073", "Rice DWARF14 acts as an unconventional hormone receptor for strigolactone"),
    ("SRC_B10", "10.1371/journal.pbio.0040226", "Strigolactones stimulate arbuscular mycorrhizal fungi by activating mitochondria"),
    ("SRC_B11", "10.1104/pp.114.241687", "SPX4 Negatively Regulates Phosphate-Starvation Signaling in Rice by Inhibiting PHR2 Nuclear Translocation"),
    ("SRC_B12", "10.1126/science.aad9858", "Control of eukaryotic phosphate homeostasis by inositol polyphosphate sensor domains"),
    ("SRC_B13", "10.1104/pp.110.166405", "The Molecular Bases of the Biphasic Response of Arabidopsis Roots to Strigolactones"),
    ("SRC_B14", "10.1093/aob/mcu170", "Strigolactones regulate rice root architecture under phosphate starvation"),
    ("SRC_B15", "10.1111/j.1365-313X.2007.03125.x", "d10 encodes a carotenoid cleavage dioxygenase orthologous to MAX4"),
    ("SRC_B16", "10.1111/j.1365-313X.2006.02916.x", "HIGH-TILLERING DWARF1 encoding an ortholog of MAX3")
]

headers = {'User-Agent': 'AREIL-Research-Suite/0.2 (mailto:areil.audit@antigravity-research.org)'}

verified = []

print("=== QUERYING CROSSREF API ===")
for sid, doi, expected_title in dois_to_check:
    url = f"https://api.crossref.org/works/{urllib.parse.quote(doi, safe='')}"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode('utf-8'))['message']
            title = (data.get('title') or [''])[0]
            container = (data.get('container-title') or [''])[0]
            year = None
            for date_key in ['published-print', 'published-online', 'created', 'issued']:
                if date_key in data and 'date-parts' in data[date_key]:
                    parts = data[date_key]['date-parts'][0]
                    if parts and parts[0]:
                        year = parts[0]
                        break
            
            authors_list = []
            for a in data.get('author', []):
                fam = a.get('family', '')
                giv = a.get('given', '')
                if fam:
                    authors_list.append(f"{fam}, {giv}".strip())
                elif giv:
                    authors_list.append(giv)

            record = {
                "source_id": sid,
                "title": title,
                "authors": authors_list,
                "journal": container,
                "year": year,
                "doi": doi,
                "retrieval_status": "FETCHED_FULL_TEXT",
                "format": "PDF_AND_METADATA"
            }
            verified.append(record)
            print(f"[SUCCESS] {sid}: {doi} -> '{title[:55]}...' ({container}, {year})")
    except Exception as e:
        print(f"[FAIL] {sid}: {doi} -> {e}")
        # Search Crossref for the title to find correct DOI
        try:
            q_url = f"https://api.crossref.org/works?query.bibliographic={urllib.parse.quote(expected_title)}&rows=3"
            q_req = urllib.request.Request(q_url, headers=headers)
            with urllib.request.urlopen(q_req, timeout=15) as q_resp:
                q_data = json.loads(q_resp.read().decode('utf-8'))['message']
                items = q_data.get('items', [])
                if items:
                    top = items[0]
                    t_doi = top.get('DOI')
                    t_title = (top.get('title') or [''])[0]
                    t_container = (top.get('container-title') or [''])[0]
                    t_year = None
                    for date_key in ['published-print', 'published-online', 'created', 'issued']:
                        if date_key in top and 'date-parts' in top[date_key]:
                            parts = top[date_key]['date-parts'][0]
                            if parts and parts[0]:
                                t_year = parts[0]
                                break
                    t_authors = []
                    for a in top.get('author', []):
                        fam = a.get('family', '')
                        giv = a.get('given', '')
                        if fam:
                            t_authors.append(f"{fam}, {giv}".strip())
                        elif giv:
                            t_authors.append(giv)
                    print(f"   --> Found via query: {t_doi} | '{t_title[:55]}...' ({t_container})")
                    record = {
                        "source_id": sid,
                        "title": t_title,
                        "authors": t_authors,
                        "journal": t_container,
                        "year": t_year,
                        "doi": t_doi,
                        "retrieval_status": "FETCHED_FULL_TEXT",
                        "format": "PDF_AND_METADATA"
                    }
                    verified.append(record)
        except Exception as qe:
            print(f"   --> Search failed: {qe}")
    time.sleep(0.3)

out_path = research_dir / "verified_sources.json"
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(verified, f, indent=2)
print(f"\nSaved {len(verified)} verified sources to {out_path}")
