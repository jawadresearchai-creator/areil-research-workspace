#!/usr/bin/env python3
from pathlib import Path
import requests, gzip, tarfile, io, xml.etree.ElementTree as ET

URLS={
'gse255':'https://ftp.ncbi.nlm.nih.gov/geo/series/GSE255nnn/GSE255759/suppl/GSE255759_counts_roots.csv.gz',
'meta255':'https://ftp.ncbi.nlm.nih.gov/geo/series/GSE255nnn/GSE255759/miniml/GSE255759_family.xml.tgz',
'meta263':'https://ftp.ncbi.nlm.nih.gov/geo/series/GSE263nnn/GSE263656/miniml/GSE263656_family.xml.tgz',
'raw263':'https://ftp.ncbi.nlm.nih.gov/geo/series/GSE263nnn/GSE263656/suppl/GSE263656_RAW.tar'}

def get(url):
 r=requests.get(url,timeout=180); r.raise_for_status(); return r.content

b=get(URLS['gse255'])
print('=== GSE255759 root file first 12 lines ===')
text=gzip.decompress(b).decode('utf-8-sig','replace')
for x in text.splitlines()[:12]: print(repr(x[:1000]))
print('bytes_uncompressed',len(text.encode()))

for key in ['meta255','meta263']:
 print('\n===',key,'first sample records ===')
 tgz=get(URLS[key])
 with tarfile.open(fileobj=io.BytesIO(tgz),mode='r:gz') as tf:
  m=next(m for m in tf.getmembers() if m.name.endswith('.xml'))
  root=ET.parse(tf.extractfile(m)).getroot()
  samples=[e for e in root.iter() if e.tag.split('}')[-1]=='Sample']
  print('n_samples',len(samples))
  for s in samples[:30]:
   gsm=s.attrib.get('iid')
   vals=[]
   for e in s.iter():
    local=e.tag.split('}')[-1]
    if local in ('Title','Characteristics','Source') and (e.text or '').strip():
     vals.append((local,e.attrib.get('tag',''),(e.text or '').strip()))
   print(gsm, vals[:12])

print('\n=== GSE263656 tar members first 40 ===')
raw=get(URLS['raw263'])
with tarfile.open(fileobj=io.BytesIO(raw),mode='r') as tf:
 names=[m.name for m in tf.getmembers() if m.isfile()]
 print('n_files',len(names))
 for n in names[:40]: print(n)
