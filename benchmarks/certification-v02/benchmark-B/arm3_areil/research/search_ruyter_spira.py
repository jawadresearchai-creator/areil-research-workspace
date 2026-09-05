import urllib.request, urllib.parse, json

term = "Ruyter-Spira biphasic strigolactone"
url = f"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term={urllib.parse.quote(term)}&retmode=json"
req = urllib.request.Request(url, headers={'User-Agent': 'AREIL/0.2'})
with urllib.request.urlopen(req, timeout=10) as resp:
    data = json.loads(resp.read().decode('utf-8'))
    id_list = data.get('esearchresult', {}).get('idlist', [])
    print("PubMed IDs:", id_list)

if id_list:
    sum_url = f"https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=pubmed&id={','.join(id_list)}&retmode=json"
    with urllib.request.urlopen(urllib.request.Request(sum_url, headers={'User-Agent': 'AREIL/0.2'})) as sresp:
        sdata = json.loads(sresp.read().decode('utf-8'))['result']
        for pmid in id_list:
            item = sdata.get(pmid, {})
            title = item.get('title')
            source = item.get('source')
            pubdate = item.get('pubdate')
            articleids = {x.get('idtype'): x.get('value') for x in item.get('articleids', [])}
            print(f"PMID {pmid}: {pubdate} | {source} | DOI: {articleids.get('doi')} | {title}")
