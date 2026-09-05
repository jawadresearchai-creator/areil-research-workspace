import urllib.request, urllib.parse, json

headers = {'User-Agent': 'AREIL-Research-Suite/0.2 (mailto:areil.audit@antigravity-research.org)'}

dois = [
    ("SRC_B01", "10.1038/nature07272"),
    ("SRC_B02", "10.1038/nature03608"),
    ("SRC_B03", "10.1038/nature12870"),
    ("SRC_B04", "10.1038/nature12878"),
    ("SRC_B05", "10.1007/s00425-010-1310-y"),
    ("SRC_B06", "10.1093/jxb/erq464"),
    ("SRC_B07", "10.1093/jxb/eru029"),
    ("SRC_B08", "10.1126/science.1218094"),
    ("SRC_B09", "10.1105/tpc.109.065987"),
    ("SRC_B10", "10.1038/nature19073"),
    ("SRC_B11", "10.1371/journal.pbio.0040226"),
    ("SRC_B12", "10.1105/tpc.114.123208"),
    ("SRC_B13", "10.1126/science.aad9858"),
    ("SRC_B14", "10.1093/pcp/pcp091"),
    ("SRC_B15", "10.1111/j.1365-313X.2007.03210.x"),
    ("SRC_B16", "10.1111/j.1365-313X.2006.02916.x"),
    ("SRC_B17", "10.1104/pp.110.166645"),
    ("SRC_B18", "10.1038/s41477-021-00878-8")
]

all_ok = True
for sid, doi in dois:
    url = f"https://api.crossref.org/works/{urllib.parse.quote(doi, safe='')}"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            data = json.loads(resp.read().decode('utf-8'))['message']
            title = (data.get('title') or [''])[0].encode('ascii', 'replace').decode('ascii')
            container = (data.get('container-title') or [''])[0].encode('ascii', 'replace').decode('ascii')
            print(f"PASS: {sid} | {doi} | {container} | '{title[:50]}'")
    except Exception as e:
        print(f"FAIL: {sid} | {doi} -> {e}")
        all_ok = False

print("\nALL DOIs PASS VALIDATION:", all_ok)
