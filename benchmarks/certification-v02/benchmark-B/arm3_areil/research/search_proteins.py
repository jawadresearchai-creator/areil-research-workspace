import urllib.request
import urllib.parse
import json
from pathlib import Path

research_dir = Path("E:/Agriculture/Antigravity Research/benchmarks/certification-v02/benchmark-B/arm3_areil/research")
research_dir.mkdir(parents=True, exist_ok=True)

proteins = [
    ("OsPHR2", "PHR2 Oryza sativa"),
    ("OsSPX4", "SPX4 Oryza sativa"),
    ("OsD27", "D27 Oryza sativa"),
    ("OsCCD7_D17", "CCD7 Oryza sativa"),
    ("OsCCD8_D10", "CCD8 Oryza sativa"),
    ("OsD14", "D14 Oryza sativa"),
    ("OsD3", "D3 Oryza sativa"),
    ("OsD53", "D53 Oryza sativa")
]

uniprot_records = []
print("=== QUERYING UNIPROT REST API ===")
for sym, query in proteins:
    url = f"https://rest.uniprot.org/uniprotkb/search?query={urllib.parse.quote(query)}&format=json&size=1"
    req = urllib.request.Request(url, headers={'User-Agent': 'AREIL-Research-Suite/0.2'})
    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = json.loads(resp.read().decode('utf-8'))
            results = data.get('results', [])
            if results:
                entry = results[0]
                acc = entry.get('primaryAccession')
                uni_id = entry.get('uniProtkbId')
                rec_name = entry.get('proteinDescription', {}).get('recommendedName', {}).get('fullName', {}).get('value', 'N/A')
                seq_len = entry.get('sequence', {}).get('length', 0)
                mol_wt = entry.get('sequence', {}).get('molWeight', 0)
                record = {
                    "symbol": sym,
                    "accession": acc,
                    "id": uni_id,
                    "name": rec_name,
                    "length": seq_len,
                    "molecular_weight": mol_wt,
                    "organism": "Oryza sativa subsp. japonica"
                }
                uniprot_records.append(record)
                print(f"[SUCCESS] {sym} -> {acc} ({uni_id}): {rec_name} ({seq_len} aa, {mol_wt} Da)")
            else:
                print(f"[WARN] No result for {sym}")
    except Exception as e:
        print(f"[FAIL] {sym} -> {e}")

out_path = research_dir / "uniprot_proteins.json"
with open(out_path, "w", encoding="utf-8") as f:
    json.dump(uniprot_records, f, indent=2)
print(f"\nSaved {len(uniprot_records)} protein records to {out_path}")
