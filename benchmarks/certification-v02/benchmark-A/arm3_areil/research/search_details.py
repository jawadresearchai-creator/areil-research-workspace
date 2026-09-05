import urllib.request
import urllib.parse
import json
import time

headers = {"User-Agent": "AREIL-Auditor/1.0 (mailto:audit@areil.org)"}

def search_crossref(query):
    url = f"https://api.crossref.org/works?query={urllib.parse.quote(query)}&rows=3"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=15) as resp:
        data = json.loads(resp.read().decode("utf-8"))["message"]["items"]
        for it in data:
            doi = it.get("DOI")
            title = (it.get("title") or [""])[0]
            journal = (it.get("container-title") or [""])[0]
            year = it.get("created", {}).get("date-parts", [[None]])[0][0]
            print(f"  -> DOI: {doi} | {year} | {journal} | {title}")

print("Search 1: Shih FERONIA mechanical")
search_crossref("The receptor kinase FERONIA is required for mechanical signaling in Arabidopsis roots Shih 2014")

print("\nSearch 2: Tanaka extracellular ATP")
search_crossref("Extracellular ATP acts as a damage-associated molecular pattern in Arabidopsis Tanaka 2014")

print("\nSearch 3: Steinebrunner Apyrase")
search_crossref("Disruption of apyrases inhibits pollen germination in Arabidopsis Steinebrunner 2003")

print("\nSearch 4: UniProt by locus tag")
genes = ["AT5G60300", "AT3G51550", "AT5G47910", "AT3G04080", "AT5G19810"]
for g in genes:
    url = f"https://rest.uniprot.org/uniprotkb/search?query={g}&size=1"
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=15) as resp:
        res = json.loads(resp.read().decode("utf-8"))["results"]
        if res:
            acc = res[0]["primaryAccession"]
            name = res[0]["proteinDescription"]["recommendedName"]["fullName"]["value"]
            print(f"  -> Gene {g}: Accession {acc} | {name}")
