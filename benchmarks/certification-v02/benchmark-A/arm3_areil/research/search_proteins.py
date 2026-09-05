import urllib.request
import urllib.parse
import json

headers = {"User-Agent": "AREIL-Auditor/1.0 (mailto:audit@areil.org)"}

genes = {
    "P2K1/DORN1": "AT5G60300",
    "FERONIA": "AT3G51550",
    "RBOHD": "AT5G47910",
    "APY1": "AT3G04080",
    "APY2": "AT5G19810",
    "RRFT1/ERF72": "AT4G39780"
}

uniprot_records = {}
for name, locus in genes.items():
    url = f"https://rest.uniprot.org/uniprotkb/search?query={locus}&size=1"
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode("utf-8"))["results"]
            if data:
                entry = data[0]
                acc = entry["primaryAccession"]
                desc = entry.get("proteinDescription", {})
                rec_name = desc.get("recommendedName", {}).get("fullName", {}).get("value") or \
                           desc.get("submissionNames", [{}])[0].get("fullName", {}).get("value", "")
                seq_len = entry.get("sequence", {}).get("length", 0)
                uniprot_records[name] = {
                    "locus": locus,
                    "accession": acc,
                    "protein_name": rec_name,
                    "length_aa": seq_len
                }
                print(f"{name} ({locus}): Accession {acc}, Length {seq_len} aa, Name: {rec_name}")
    except Exception as e:
        print(f"Error for {name}: {e}")

with open("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-A/arm3_areil/research/uniprot_proteins.json", "w", encoding="utf-8") as f:
    json.dump(uniprot_records, f, indent=2)

print("Saved protein records.")
