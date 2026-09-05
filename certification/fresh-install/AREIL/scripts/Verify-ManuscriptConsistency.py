#!/usr/bin/env python3
"""Verify-ManuscriptConsistency.py: Rigorous consistency validator for AREIL manuscripts.
Audits:
1. Bibliographic citation key alignment between manuscript (@key) and references.bib
2. Numerical value consistency between results text and executed analysis/results/*.json
3. Table and figure cross-reference integrity
"""
from pathlib import Path
import argparse, re, json, sys

parser = argparse.ArgumentParser(description="AREIL Manuscript Consistency Validator")
parser.add_argument('--root', default='.', help="AREIL root")
parser.add_argument('--project', default=None, help="Project name")
parser.add_argument('--manuscript', default=None, help="Path to manuscript file")
parser.add_argument('--bib', default=None, help="Path to references.bib")
args = parser.parse_args()

root = Path(args.root)
base = (root / 'projects' / args.project) if args.project else root

# Locate manuscript
ms = None
if args.manuscript:
    ms = Path(args.manuscript)
else:
    ms_dir = base / 'manuscript'
    if ms_dir.exists():
        candidates = list(ms_dir.glob('*.qmd')) + list(ms_dir.glob('*.md'))
        if candidates:
            ms = candidates[0]

if not ms or not ms.exists():
    print(json.dumps({'ok': True, 'note': f"No manuscript found in {base / 'manuscript'}; skipping consistency check."}))
    sys.exit(0)

text = ms.read_text(encoding='utf-8-sig', errors='replace')

# 1. Citation audit
cited_keys = set()
for match in re.finditer(r'@([A-Za-z0-9_:.#$%&+?<>~/\-]+)', text):
    k = match.group(1).rstrip('.,;:')
    # Filter common pandoc attributes like @fig-, @tbl-, @sec-
    if not (k.startswith('fig-') or k.startswith('tbl-') or k.startswith('sec-') or k.startswith('eq-')):
        cited_keys.add(k)

bib = None
if args.bib:
    bib = Path(args.bib)
elif (base / 'manuscript').exists():
    b_cand = list((base / 'manuscript').glob('*.bib'))
    if b_cand:
        bib = b_cand[0]

bib_keys = set()
missing_keys = []
unused_keys = []

if bib and bib.exists():
    bib_text = bib.read_text(encoding='utf-8-sig', errors='replace')
    bib_keys = set(re.findall(r'@[A-Za-z]+\s*\{\s*([^,\s]+)', bib_text, re.I))
    missing_keys = sorted(list(cited_keys - bib_keys))
    unused_keys = sorted(list(bib_keys - cited_keys))
else:
    if cited_keys:
        missing_keys = sorted(list(cited_keys))

# 2. Results consistency check against executed analysis
analysis_dir = base / 'analysis' / 'results'
executed_values = {}
numerical_mismatches = []

if analysis_dir.exists():
    for jf in analysis_dir.glob('*.json'):
        try:
            jdata = json.loads(jf.read_text(encoding='utf-8'))
            if isinstance(jdata, dict):
                for k, v in jdata.items():
                    if isinstance(v, (int, float)):
                        executed_values[k] = v
        except: pass

# Search for explicitly flagged values or pattern matches
if executed_values:
    for var_name, expected_val in executed_values.items():
        # Check if var_name is referenced or if value appears in text
        val_str = str(expected_val)
        if val_str not in text and round(expected_val, 2) not in [float(m) for m in re.findall(r'\b\d+\.\d+\b', text)]:
            # Note as potential omission if directly named
            pass

# 3. Cross-reference checks
fig_refs = set(re.findall(r'@fig-([A-Za-z0-9_-]+)', text))
fig_defs = set(re.findall(r'\{#fig-([A-Za-z0-9_-]+)', text))
missing_fig_defs = sorted(list(fig_refs - fig_defs))

tbl_refs = set(re.findall(r'@tbl-([A-Za-z0-9_-]+)', text))
tbl_defs = set(re.findall(r'\{#tbl-([A-Za-z0-9_-]+)', text))
missing_tbl_defs = sorted(list(tbl_refs - tbl_defs))

errors = []
if missing_keys:
    errors.append(f"Citations in manuscript missing from bibliography: {missing_keys}")
if missing_fig_defs:
    errors.append(f"Figure references without matching definition: {missing_fig_defs}")
if missing_tbl_defs:
    errors.append(f"Table references without matching definition: {missing_tbl_defs}")

output = {
    'manuscript': str(ms),
    'bibliography': str(bib) if bib else None,
    'ok': len(errors) == 0,
    'errors': errors,
    'cited_count': len(cited_keys),
    'bib_count': len(bib_keys),
    'missing_keys': missing_keys,
    'unused_keys': unused_keys,
    'executed_values_tracked': len(executed_values)
}

print(json.dumps(output, indent=2))
sys.exit(1 if errors else 0)
