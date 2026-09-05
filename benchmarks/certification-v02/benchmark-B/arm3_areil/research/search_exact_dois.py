import urllib.request, urllib.parse, json, time

headers = {'User-Agent': 'AREIL-Research-Suite/0.2 (mailto:areil.audit@antigravity-research.org)'}

queries = [
    ("Umehara 2008", "Inhibition of shoot branching by new terpenoid plant hormones Umehara"),
    ("Akiyama 2005", "Plant sesquiterpenes induce hyphal branching in arbuscular mycorrhizal fungi Akiyama"),
    ("Jiang 2013", "DWARF 53 acts as a repressor of strigolactone signalling in rice Jiang"),
    ("Zhou 2013", "D14-SCFD3-dependent degradation of D53 regulates strigolactone signalling Zhou"),
    ("Kapulnik 2011", "Strigolactones affect root hair elongation in Arabidopsis Kapulnik"),
    ("Sun 2014 Root Hair", "Strigolactones positively regulate root hair elongation through an alternative pathway independent of ethylene signaling Sun"),
    ("Sun 2014 RSA", "Strigolactones regulate rice root architecture in response to phosphorus and nitrogen starvation Sun"),
    ("Alder 2012", "The Path from beta-Carotene to Carlactone, a Strigolactone-Like Plant Hormone Alder"),
    ("Lin 2009", "DWARF27, an Iron-Containing Protein Required for the Biosynthesis of Strigolactones Lin"),
    ("Yao 2016", "DWARF14 is a non-canonical hormone receptor for strigolactone Yao"),
    ("Besserer 2006", "Strigolactones Stimulate Arbuscular Mycorrhizal Fungi by Activating Mitochondria Besserer"),
    ("Lv 2014", "SPX4 Negatively Regulates Phosphate Signaling and Homeostasis in Rice Lv"),
    ("Wild 2016", "Control of eukaryotic phosphate homeostasis by inositol polyphosphate sensor domains Wild"),
    ("Ruyter-Spira 2011", "The Molecular Bases of the Biphasic Response of Arabidopsis Roots to Strigolactones Ruyter-Spira"),
    ("Arite 2007", "d10 promotes open tillering and encodes a carotenoid cleavage dioxygenase orthologous to MAX4 Arite"),
    ("Zou 2006", "The rice HIGH-TILLERING DWARF1 encoding an ortholog of Arabidopsis MAX3 Zou"),
    ("Arite 2009", "d14, a strigolactone-insensitive mutant of rice Arite"),
    ("Wang 2014", "The SPX-MFS protein OsPHO1;2 is required for phosphorus translocation Wang"),
    ("Ried 2021", "Inositol pyrophosphates promote the interaction of SPX domains with the basic helix-loop-helix transcription factor PHR Ried"),
    ("Gutjahr 2008", "Presymbiotic, Arbuscular, and Parasite-Induced Gene Expression in Rice Roots Gutjahr")
]

results = []
for tag, q in queries:
    url = f"https://api.crossref.org/works?query.bibliographic={urllib.parse.quote(q)}&rows=1"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode('utf-8'))['message']['items']
            if data:
                item = data[0]
                doi = item.get('DOI')
                title = (item.get('title') or [''])[0]
                container = (item.get('container-title') or [''])[0]
                year = None
                for dk in ['published-print', 'published-online', 'created', 'issued']:
                    if dk in item and 'date-parts' in item[dk]:
                        parts = item[dk]['date-parts'][0]
                        if parts and parts[0]:
                            year = parts[0]
                            break
                authors = [f"{a.get('family', '')}, {a.get('given', '')}".strip() for a in item.get('author', [])]
                res = {
                    "tag": tag,
                    "doi": doi,
                    "title": title,
                    "container": container,
                    "year": year,
                    "authors": authors
                }
                results.append(res)
                print(f"MATCH [{tag}]: DOI={doi} | Year={year} | Journal={container}")
                print(f"   Title: {title}")
                print(f"   First Author: {authors[0] if authors else 'N/A'}\n")
    except Exception as e:
        print(f"ERROR [{tag}]: {e}")
    time.sleep(0.3)

with open("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/research/crossref_verified_dois.json", "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2, ensure_ascii=False)
