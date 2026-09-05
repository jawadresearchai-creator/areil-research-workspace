#!/usr/bin/env python3
"""Validate-AreilLedgers.py: Strict schema, referential integrity, and state-gate validation
for all canonical AREIL research ledgers.
"""
from pathlib import Path
import argparse, json, sys

parser = argparse.ArgumentParser(description="AREIL Ledger Validator")
parser.add_argument('--root', default='.', help="AREIL or workspace root")
parser.add_argument('--project', default=None, help="Project name under projects/")
args = parser.parse_args()

root = Path(args.root)
base = (root / 'projects' / args.project / 'ledgers') if args.project else ((root / 'ledgers') if (root / 'ledgers').exists() else (root / 'research' / 'ledgers'))

required_specs = {
    'SOURCE_REGISTRY.jsonl': ('source_id', ['source_id', 'title', 'retrieval_status']),
    'EVIDENCE_LEDGER.jsonl': ('evidence_id', ['evidence_id', 'source_id', 'claim_ids', 'direction', 'verification_status']),
    'CLAIM_LEDGER.jsonl': ('claim_id', ['claim_id', 'text', 'claim_type', 'status']),
    'CONTRADICTION_LEDGER.jsonl': ('contradiction_id', ['contradiction_id', 'claim_id', 'contradiction_type', 'status']),
    'NOVELTY_LEDGER.jsonl': ('novelty_id', ['novelty_id', 'claim_id', 'search_scope', 'status']),
    'REVIEW_LEDGER.jsonl': ('review_id', ['review_id', 'reviewer_role', 'severity', 'status']),
    'DATASET_REGISTRY.jsonl': ('dataset_id', ['dataset_id', 'repository', 'accession_or_doi', 'status'])
}

errs = []
warnings = []
rows = {}

def load_ledger(name, required_keys, id_key):
    fp = base / name
    out = []
    if not fp.exists():
        # Optional ledgers can be empty files, but required primary ledgers must exist
        if name in ('SOURCE_REGISTRY.jsonl', 'EVIDENCE_LEDGER.jsonl', 'CLAIM_LEDGER.jsonl'):
            errs.append(f"Missing mandatory ledger file: {fp}")
        return out
    
    seen_ids = set()
    lines = fp.read_text(encoding='utf-8-sig').splitlines()
    for n, line in enumerate(lines, 1):
        if not line.strip():
            continue
        try:
            x = json.loads(line)
        except Exception as e:
            errs.append(f"{name}:{n}: Invalid JSON: {e}")
            continue
        
        # Check required fields
        for k in required_keys:
            if k not in x:
                errs.append(f"{name}:{n}: Missing required field '{k}'")
        
        # Check duplicate IDs
        if id_key in x:
            item_id = x[id_key]
            if item_id in seen_ids:
                errs.append(f"{name}:{n}: Duplicate primary key '{id_key}' = {item_id}")
            seen_ids.add(item_id)
        out.append(x)
    return out

for name, (idk, req_keys) in required_specs.items():
    rows[name] = load_ledger(name, req_keys, idk)

sources = {x.get('source_id') for x in rows.get('SOURCE_REGISTRY.jsonl', [])}
evidence = {x.get('evidence_id') for x in rows.get('EVIDENCE_LEDGER.jsonl', [])}
claims = {x.get('claim_id') for x in rows.get('CLAIM_LEDGER.jsonl', [])}

# Referential integrity checks
for i, x in enumerate(rows.get('EVIDENCE_LEDGER.jsonl', []), 1):
    src_id = x.get('source_id')
    if src_id and src_id not in sources:
        errs.append(f"EVIDENCE_LEDGER.jsonl:{i}: Unregistered source_id '{src_id}'")
    for cid in x.get('claim_ids', []):
        if cid and cid not in claims:
            errs.append(f"EVIDENCE_LEDGER.jsonl:{i}: Unregistered claim_id '{cid}'")

for i, x in enumerate(rows.get('CLAIM_LEDGER.jsonl', []), 1):
    cid = x.get('claim_id')
    for eid in x.get('evidence_ids', []):
        if eid and eid not in evidence:
            errs.append(f"CLAIM_LEDGER.jsonl:{i}: Unregistered evidence_id '{eid}'")
    
    # State-gate rules
    status = x.get('status', '').lower()
    ctype = x.get('claim_type', '').lower()
    if status in ('approved', 'settled', 'adjudicated') and ctype not in ('limitation', 'method'):
        if not x.get('evidence_ids'):
            errs.append(f"CLAIM_LEDGER.jsonl:{i} ({cid}): Settled claim has no linked evidence_ids")
        if x.get('verification_status', '').lower() in ('unverified', 'rejected'):
            errs.append(f"CLAIM_LEDGER.jsonl:{i} ({cid}): Claim marked {status} but verification_status is {x.get('verification_status')}")

# Contradiction ledger checks
unresolved_contradictions = {}
for i, x in enumerate(rows.get('CONTRADICTION_LEDGER.jsonl', []), 1):
    cid = x.get('claim_id')
    if cid and cid not in claims:
        errs.append(f"CONTRADICTION_LEDGER.jsonl:{i}: Contradiction refers to unknown claim_id '{cid}'")
    cstatus = x.get('status', '').lower()
    if cstatus in ('unresolved', 'critical', 'active'):
        unresolved_contradictions[cid] = x.get('contradiction_id')

# Check if approved claims have unresolved contradictions
for x in rows.get('CLAIM_LEDGER.jsonl', []):
    cid = x.get('claim_id')
    status = x.get('status', '').lower()
    if status in ('approved', 'settled') and cid in unresolved_contradictions:
        errs.append(f"CLAIM_LEDGER.jsonl: Claim '{cid}' is '{status}' but has unresolved contradiction '{unresolved_contradictions[cid]}'")

# Review ledger checks
for i, x in enumerate(rows.get('REVIEW_LEDGER.jsonl', []), 1):
    sev = x.get('severity', '').upper()
    rstatus = x.get('status', '').lower()
    if sev in ('FATAL', 'MAJOR') and rstatus == 'unresolved':
        warnings.append(f"REVIEW_LEDGER.jsonl:{i}: Open {sev} review finding '{x.get('review_id')}'")

output = {
    "base": str(base),
    "ok": len(errs) == 0,
    "total_errors": len(errs),
    "total_warnings": len(warnings),
    "errors": errs,
    "warnings": warnings,
    "ledger_counts": {k: len(v) for k, v in rows.items()}
}

print(json.dumps(output, indent=2))
sys.exit(1 if errs else 0)
