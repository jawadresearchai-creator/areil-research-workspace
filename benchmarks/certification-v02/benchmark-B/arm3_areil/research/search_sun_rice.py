import urllib.request, urllib.parse, json

url = "https://api.crossref.org/works?query.author=Hao+Sun&query.bibliographic=strigolactones+rice+root&filter=type:journal-article&rows=5"
req = urllib.request.Request(url, headers={'User-Agent': 'AREIL-Research-Suite/0.2 (mailto:areil.audit@antigravity-research.org)'})
with urllib.request.urlopen(req, timeout=15) as resp:
    items = json.loads(resp.read().decode('utf-8'))['message']['items']
    for it in items:
        title = (it.get('title') or [''])[0].encode('ascii', 'replace').decode('ascii')
        doi = it.get('DOI')
        container = (it.get('container-title') or [''])[0]
        year = None
        for dk in ['published-print', 'published-online', 'created']:
            if dk in it and 'date-parts' in it[dk]:
                p = it[dk]['date-parts'][0]
                if p and p[0]: year = p[0]; break
        authors = [a.get('family', '') for a in it.get('author', [])[:4]]
        print(f"DOI: {doi} | Year: {year} | Journal: {container} | Authors: {authors}")
        print(f"  Title: {title}\n")
