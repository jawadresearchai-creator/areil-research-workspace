import urllib.request, urllib.parse, json

headers = {'User-Agent': 'AREIL-Research-Suite/0.2 (mailto:areil.audit@antigravity-research.org)'}

candidate_dois = [
    ("Umehara2008", "10.1038/nature07272"),
    ("Akiyama2005", "10.1038/nature03608"),
    ("Jiang2013", "10.1038/nature12870"),
    ("Zhou2013", "10.1038/nature12878"),
    ("Kapulnik2011", "10.1007/s00425-010-1310-y"),
    ("Alder2012", "10.1126/science.1218094"),
    ("Lin2009", "10.1105/tpc.109.065987"),
    ("Yao2016", "10.1038/nature19073"),
    ("Besserer2006", "10.1371/journal.pbio.0040226"),
    ("Lv2014", "10.1105/tpc.114.123208"),
    ("Wild2016", "10.1126/science.aad9858"),
    ("Arite2009", "10.1093/pcp/pcp091"),
    ("Zou2006", "10.1111/j.1365-313x.2006.02916.x")
]

for key, doi in candidate_dois:
    url = f"https://api.crossref.org/works/{urllib.parse.quote(doi, safe='')}"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))['message']
            title = (data.get('title') or [''])[0]
            container = (data.get('container-title') or [''])[0]
            year = data.get('created', {}).get('date-parts', [[0]])[0][0]
            for dk in ['published-print', 'published-online']:
                if dk in data and 'date-parts' in data[dk]:
                    p = data[dk]['date-parts'][0]
                    if p and p[0]:
                        year = p[0]
                        break
            authors = [f"{a.get('family', '')} {a.get('given', '')}".strip() for a in data.get('author', [])[:3]]
            print(f"VERIFIED: {key} -> {doi} | {year} | {container} | '{title[:50]}' | {authors}")
    except Exception as e:
        print(f"FAILED: {key} -> {doi}: {e}")
