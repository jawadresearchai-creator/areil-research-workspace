import urllib.request
import urllib.parse
import json
import time

dois = [
    "10.1126/science.1245159",
    "10.1126/science.343.6168.290",
    "10.1080/15592324.2024.2370706",
    "10.1038/s41467-017-02340-3",
    "10.1126/science.1245970",
    "10.4161/psb.28420",
    "10.1016/j.febslet.2009.07.007",
    "10.1080/15592324.2025.2555965",
    "10.1104/pp.113.233429",
    "10.1093/pcp/pcv134",
    "10.1080/15592324.2020.1748282",
    "10.4161/psb.5.6.11579",
    "10.1105/tpc.016337"
]

headers = {"User-Agent": "AREIL-Auditor/1.0 (mailto:audit@areil.org)"}
results = []
print("--- QUERYING CROSSREF ---")
for d in dois:
    url = f"https://api.crossref.org/works/{urllib.parse.quote(d, safe='')}"
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))["message"]
            title = data.get("title", ["No title"])[0]
            journal = data.get("container-title", ["No journal"])[0]
            year = data.get("created", {}).get("date-parts", [[None]])[0][0]
            authors = [a.get("family", "") + ", " + a.get("given", "") for a in data.get("author", [])[:4]]
            res = {
                "doi": d,
                "status": "OK",
                "year": year,
                "journal": journal,
                "title": title,
                "authors": authors
            }
            results.append(res)
            print(f"OK: {d} -> {year} | {journal} | {title[:60]}...")
    except Exception as e:
        res = {"doi": d, "status": "FAIL", "error": str(e)}
        results.append(res)
        print(f"FAIL: {d} -> {e}")
    time.sleep(0.2)

print("\n--- QUERYING UNIPROT ---")
uniprot_ids = {
    "P2K1_ARATH": "Q9LQ52",
    "FER_ARATH": "Q9M1K5",
    "RBOHD_ARATH": "Q9FI00",
    "APY1_ARATH": "Q9LYT6",
    "APY2_ARATH": "Q9LX93"
}

uniprot_results = {}
for name, uid in uniprot_ids.items():
    u_url = f"https://rest.uniprot.org/uniprotkb/{uid}.json"
    try:
        req = urllib.request.Request(u_url, headers=headers)
        with urllib.request.urlopen(req, timeout=15) as resp:
            udata = json.loads(resp.read().decode("utf-8"))
            rec_name = udata.get("proteinDescription", {}).get("recommendedName", {}).get("fullName", {}).get("value", "")
            gene_name = udata.get("genes", [{}])[0].get("geneName", {}).get("value", "")
            seq_len = udata.get("sequence", {}).get("length", 0)
            func = ""
            for c in udata.get("comments", []):
                if c.get("commentType") == "FUNCTION":
                    func = c.get("texts", [{}])[0].get("value", "")
                    break
            uniprot_results[name] = {
                "id": uid,
                "gene": gene_name,
                "name": rec_name,
                "length": seq_len,
                "function": func[:200]
            }
            print(f"UniProt {uid} ({name}): Gene={gene_name}, Name={rec_name}, Length={seq_len} aa")
    except Exception as e:
        print(f"UniProt FAIL {uid}: {e}")
    time.sleep(0.2)

with open("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/research/crossref_results.json", "w", encoding="utf-8") as f:
    json.dump(results, f, indent=2)

with open("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/research/uniprot_results.json", "w", encoding="utf-8") as f:
    json.dump(uniprot_results, f, indent=2)

print("\nSuccessfully queried APIs and saved results.")
