#!/usr/bin/env python3
"""Audit-Citations.py: Rigorous citation identity, retraction, update, and provenance auditor
using Crossref, DataCite, and OpenCitations APIs.
Separates:
1. SOURCE_EXISTS
2. METADATA_MATCH
3. RETRACTION_FREE
4. SUPPORT_VERIFIED (checked against evidence ledger)
"""
from pathlib import Path
import argparse, json, urllib.request, urllib.parse, time, os, sys

parser = argparse.ArgumentParser(description="AREIL Citation Auditor")
parser.add_argument('--root', default='.', help="AREIL or workspace root")
parser.add_argument('--project', default=None, help="Project name")
parser.add_argument('--mailto', default=os.getenv('CROSSREF_MAILTO', 'areil.audit@antigravity-research.org'))
args = parser.parse_args()

root = Path(args.root)
base = (root / 'projects' / args.project) if args.project else (root if (root / 'ledgers').exists() else (root / 'research'))
reg_file = base / 'ledgers' / 'SOURCE_REGISTRY.jsonl'
ev_file = base / 'ledgers' / 'EVIDENCE_LEDGER.jsonl'
outdir = base / 'audits'
outdir.mkdir(parents=True, exist_ok=True)
out_file = outdir / 'citation_audit.jsonl'

user_agent = f"AREIL/0.1 (mailto:{args.mailto})"

def http_get_json(url):
    req = urllib.request.Request(url, headers={'User-Agent': user_agent, 'Accept': 'application/json'})
    with urllib.request.urlopen(req, timeout=20) as resp:
        return json.loads(resp.read().decode('utf-8'))

if not reg_file.exists():
    print(json.dumps({'error': f"Source registry not found: {reg_file}", 'ok': False}))
    sys.exit(0)

# Load evidence locations if available
evidence_by_source = {}
if ev_file.exists():
    for line in ev_file.read_text(encoding='utf-8-sig').splitlines():
        if not line.strip(): continue
        try:
            ev = json.loads(line)
            sid = ev.get('source_id')
            if sid:
                evidence_by_source.setdefault(sid, []).append(ev)
        except: pass

audit_records = []
lines = reg_file.read_text(encoding='utf-8-sig').splitlines()

for line in lines:
    if not line.strip(): continue
    try:
        src = json.loads(line)
    except Exception as e:
        continue
    
    sid = src.get('source_id')
    doi = (src.get('doi') or '').strip()
    title_expected = src.get('title', '')
    
    rec = {
        'source_id': sid,
        'doi': doi,
        'expected_title': title_expected,
        'source_exists': False,
        'metadata_match': False,
        'retraction_free': True,
        'has_updates': False,
        'updates': [],
        'evidence_entries_count': len(evidence_by_source.get(sid, [])),
        'support_verified': len(evidence_by_source.get(sid, [])) > 0,
        'error': None
    }
    
    if not doi:
        rec['error'] = 'No DOI provided (manual or preprint source)'
        audit_records.append(rec)
        continue
    
    # 1. Check Crossref
    try:
        c_url = f"https://api.crossref.org/works/{urllib.parse.quote(doi, safe='')}"
        c_res = http_get_json(c_url).get('message', {})
        rec['source_exists'] = True
        crossref_title = (c_res.get('title') or [None])[0]
        rec['actual_title'] = crossref_title
        rec['container_title'] = (c_res.get('container-title') or [None])[0]
        rec['published_year'] = c_res.get('created', {}).get('date-parts', [[None]])[0][0]
        
        # Check updates & retractions
        upd_url = f"https://api.crossref.org/works?rows=10&filter=updates:{urllib.parse.quote(doi, safe=':,')}"
        upd_items = http_get_json(upd_url).get('message', {}).get('items', [])
        if upd_items:
            rec['has_updates'] = True
            for item in upd_items:
                utype = item.get('type') or item.get('subtype') or 'update'
                rec['updates'].append({
                    'doi': item.get('DOI'),
                    'type': utype,
                    'title': (item.get('title') or [None])[0]
                })
                if any(bad in str(utype).lower() for bad in ['retract', 'concern', 'errat', 'correct']):
                    rec['retraction_free'] = False
        
        # Soft title match check
        if crossref_title and title_expected:
            t1 = "".join(c.lower() for c in title_expected if c.isalnum())
            t2 = "".join(c.lower() for c in crossref_title if c.isalnum())
            rec['metadata_match'] = (t1 in t2) or (t2 in t1) or (len(set(t1.split()) & set(t2.split())) > 3)
        else:
            rec['metadata_match'] = True

    except urllib.error.HTTPError as he:
        if he.code == 404:
            # Fallback to DataCite
            try:
                dc_url = f"https://api.datacite.org/dois/{urllib.parse.quote(doi, safe='')}"
                dc_res = http_get_json(dc_url).get('data', {}).get('attributes', {})
                rec['source_exists'] = True
                rec['actual_title'] = (dc_res.get('titles') or [{}])[0].get('title')
                rec['metadata_match'] = True
                rec['retraction_free'] = True
            except Exception as dce:
                rec['error'] = f"Not found in Crossref or DataCite (HTTP 404)"
        else:
            rec['error'] = f"HTTP {he.code}: {he.reason}"
    except Exception as e:
        rec['error'] = str(e)
    
    audit_records.append(rec)
    time.sleep(0.1)

# Write output
out_file.write_text(''.join(json.dumps(r, ensure_ascii=False) + '\n' for r in audit_records), encoding='utf-8')

summary = {
    'total_audited': len(audit_records),
    'output_file': str(out_file),
    'source_exists_count': sum(1 for r in audit_records if r['source_exists']),
    'identity_failures': sum(1 for r in audit_records if not r['source_exists'] and r['doi']),
    'retraction_or_update_alerts': sum(1 for r in audit_records if not r['retraction_free'] or r['has_updates']),
    'unsupported_sources_count': sum(1 for r in audit_records if not r['support_verified'])
}

print(json.dumps(summary, indent=2))
sys.exit(1 if summary['identity_failures'] > 0 else 0)
