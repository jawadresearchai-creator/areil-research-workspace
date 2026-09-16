#!/usr/bin/env python3
"""CITRUS-NET independent molecular triangulation.

Primary orchard observations are NEVER merged with these public datasets.
Public resources:
  GSE263656 - citrus graft-union vascular RNA-seq
  GSE255759 - citrus root water-deficit RNA-seq
Published qPCR anchor:
  Paudel et al. 2017, Sci Rep 7:15429, DOI 10.1038/s41598-017-15762-2

The molecular panel is prespecified at the gene-family/module level BEFORE
numerical differential-expression results are inspected:
  vascular/lignification: LAC/laccase, class-III peroxidase, PAL, C4H, 4CL, CCR, CAD
  graft organization: AUX/IAA, SAUR
  hydraulic transport: PIP1 and PIP2 aquaporins

This script downloads public data, records provenance/checksums, runs independent
contrasts, maps identifiers with g:Profiler when possible, and writes a bounded
triangulation report. It does not create or simulate qPCR data.
"""
from __future__ import annotations
import hashlib, json, os, re, tarfile, time, math
from pathlib import Path
import requests
import pandas as pd
import numpy as np
from scipy import stats
from statsmodels.stats.multitest import multipletests

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "public_molecular" / "raw"
OUT = ROOT / "public_molecular" / "results"
RAW.mkdir(parents=True, exist_ok=True)
OUT.mkdir(parents=True, exist_ok=True)

URLS = {
    "gse255_roots": "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE255nnn/GSE255759/suppl/GSE255759_counts_roots.csv.gz",
    "gse263_raw": "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE263nnn/GSE263656/suppl/GSE263656_RAW.tar",
    "gse263_miniml": "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE263nnn/GSE263656/miniml/GSE263656_family.xml.tgz",
    "gse255_miniml": "https://ftp.ncbi.nlm.nih.gov/geo/series/GSE255nnn/GSE255759/miniml/GSE255759_family.xml.tgz",
    "graft_article": "https://pmc.ncbi.nlm.nih.gov/articles/PMC11222572/",
    "paudel_article": "https://pmc.ncbi.nlm.nih.gov/articles/PMC5684345/",
}

MODULE_PATTERNS = {
    "vascular_lignification": [r"\blaccase\b", r"\bLAC\d*\b", r"class.?III peroxidase", r"\bperoxidase\b", r"phenylalanine ammonia.?lyase", r"\bPAL\b", r"cinnamate.?4.?hydroxylase", r"\bC4H\b", r"4.?coumarate.*CoA ligase", r"\b4CL\b", r"cinnamoyl.?CoA reductase", r"\bCCR\b", r"cinnamyl alcohol dehydrogenase", r"\bCAD\b"],
    "graft_organization": [r"AUX.?IAA", r"auxin.*IAA", r"small auxin.*RNA", r"\bSAUR\b"],
    "hydraulic_PIP": [r"plasma membrane intrinsic protein", r"aquaporin.*PIP", r"\bPIP1[;:]?\d?\b", r"\bPIP2[;:]?\d?\b"],
}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for chunk in iter(lambda: f.read(1024*1024), b''):
            h.update(chunk)
    return h.hexdigest()


def download(name: str, url: str) -> Path:
    dest = RAW / Path(url).name
    if not dest.exists() or dest.stat().st_size == 0:
        print(f"Downloading {name}: {url}")
        with requests.get(url, stream=True, timeout=120) as r:
            r.raise_for_status()
            with dest.open('wb') as f:
                for chunk in r.iter_content(1024*1024):
                    if chunk: f.write(chunk)
    return dest


def bh(pvals):
    arr=np.asarray(pvals,float)
    out=np.full(len(arr), np.nan)
    ok=np.isfinite(arr)
    if ok.any(): out[ok]=multipletests(arr[ok], method='fdr_bh')[1]
    return out


def logcpm(mat: pd.DataFrame):
    lib=mat.sum(axis=0).replace(0,np.nan)
    cpm=mat.divide(lib,axis=1)*1e6
    return np.log2(cpm+0.5)


def two_group_stats(expr: pd.DataFrame, ctrl_cols, trt_cols, method_label):
    a=expr[ctrl_cols].astype(float); b=expr[trt_cols].astype(float)
    mean_a=a.mean(axis=1); mean_b=b.mean(axis=1)
    log2fc=mean_b-mean_a
    p=[]
    for i in expr.index:
        try:
            _, pv=stats.ttest_ind(b.loc[i].values,a.loc[i].values,equal_var=False,nan_policy='omit')
        except Exception: pv=np.nan
        p.append(pv)
    res=pd.DataFrame({'gene_id':expr.index.astype(str),'mean_ctrl':mean_a.values,'mean_treat':mean_b.values,'log2FC':log2fc.values,'pvalue':p})
    res['padj']=bh(res.pvalue)
    res['analysis_method']=method_label
    return res


def parse_miniml(tgz: Path):
    import xml.etree.ElementTree as ET, tempfile
    rows=[]
    with tarfile.open(tgz,'r:gz') as tf:
        member=next(m for m in tf.getmembers() if m.name.endswith('.xml'))
        root=ET.parse(tf.extractfile(member)).getroot()
    ns={'m':'http://www.ncbi.nlm.nih.gov/geo/info/MINiML'}
    for smp in root.findall('.//m:Sample',ns):
        gsm=smp.attrib.get('iid')
        title=smp.findtext('m:Title',default='',namespaces=ns)
        chars={}
        for c in smp.findall('.//m:Characteristics',ns):
            tag=c.attrib.get('tag','').strip().lower().replace(' ','_')
            chars[tag]=(c.text or '').strip()
        rows.append({'gsm':gsm,'title':title,**chars})
    return pd.DataFrame(rows)


def read_gse263_counts(rawtar: Path):
    frames=[]
    with tarfile.open(rawtar,'r') as tf:
        for m in tf.getmembers():
            if not m.isfile(): continue
            if not re.search(r'count\.txt(?:\.gz)?$',m.name): continue
            f=tf.extractfile(m)
            if f is None: continue
            import gzip, io
            data=f.read()
            if m.name.endswith('.gz'): data=gzip.decompress(data)
            df=pd.read_csv(io.BytesIO(data),sep='\t',header=None,comment='#')
            if df.shape[1] < 2: continue
            df=df.iloc[:,:2]; df.columns=['gene_id','count']
            gsm_match=re.search(r'(GSM\d+)',m.name)
            gsm=gsm_match.group(1) if gsm_match else m.name.split('_')[0]
            df=df[~df.gene_id.astype(str).str.startswith('__')]
            s=df.set_index('gene_id')['count'].rename(gsm)
            frames.append(s)
    if not frames: raise RuntimeError('No count files found in GSE263656_RAW.tar')
    mat=pd.concat(frames,axis=1).fillna(0)
    return mat


def try_gprofiler_map(ids):
    # Deterministic identifier mapping only; not enrichment and not result-driven selection.
    try:
        from gprofiler import GProfiler
        gp=GProfiler(return_dataframe=True)
        chunks=[]
        ids=list(map(str,ids))
        for i in range(0,len(ids),500):
            q=ids[i:i+500]
            d=gp.convert(organism='cclementina',query=q)
            if d is not None and len(d): chunks.append(d)
            time.sleep(0.15)
        if not chunks: return pd.DataFrame(columns=['incoming','converted','name','description'])
        d=pd.concat(chunks,ignore_index=True)
        keep=[c for c in ['incoming','converted','name','description','namespaces'] if c in d.columns]
        return d[keep].drop_duplicates()
    except Exception as e:
        print('g:Profiler mapping failed:',e)
        return pd.DataFrame(columns=['incoming','converted','name','description'])


def annotate_results(res, mapping):
    if mapping.empty:
        res['annotation']=''; return res
    m=mapping.copy()
    m['annotation']=m[[c for c in ['name','description','converted'] if c in m.columns]].fillna('').astype(str).agg(' | '.join,axis=1)
    m=m.groupby('incoming',as_index=False).annotation.apply(lambda x:' || '.join(dict.fromkeys(x)))
    return res.merge(m,left_on='gene_id',right_on='incoming',how='left').drop(columns=['incoming'],errors='ignore').fillna({'annotation':''})


def assign_module(annotation: str):
    txt=str(annotation)
    hits=[]
    for mod,pats in MODULE_PATTERNS.items():
        if any(re.search(p,txt,re.I) for p in pats): hits.append(mod)
    return ';'.join(hits)

# ---- acquire ----
files={k:download(k,u) for k,u in URLS.items() if k in {'gse255_roots','gse263_raw','gse263_miniml','gse255_miniml'}}
prov=[]
for k,p in files.items(): prov.append({'resource':k,'url':URLS[k],'file':str(p.relative_to(ROOT)),'bytes':p.stat().st_size,'sha256':sha256(p)})
(OUT/'provenance.json').write_text(json.dumps(prov,indent=2))

# ---- GSE263656 ----
meta263=parse_miniml(files['gse263_miniml'])
meta263.to_csv(OUT/'GSE263656_sample_metadata.csv',index=False)
mat263=read_gse263_counts(files['gse263_raw'])
mat263.to_csv(OUT/'GSE263656_count_matrix.csv.gz',compression='gzip')
map263=try_gprofiler_map(mat263.index)
map263.to_csv(OUT/'GSE263656_gene_mapping.csv',index=False)

# Build metadata heuristically from MINiML characteristics and title.
def rowtext(r): return ' | '.join(str(v) for v in r.values if pd.notna(v)).lower()
meta263['all_text']=meta263.apply(rowtext,axis=1)

def select263(scion, position, rootstock):
    sc=scion.lower(); pos=position.lower(); rs=rootstock.lower()
    out=[]
    for _,r in meta263.iterrows():
        t=r['all_text']
        if sc in t and pos in t and rs in t: out.append(r.gsm)
    return [x for x in out if x in mat263.columns]

comparisons263=[]
for scion in ['bearss','valencia']:
    ctrl=select263(scion,'below','us-812')
    inc=select263(scion,'below','us-1283')
    if len(ctrl)>=2 and len(inc)>=2:
        expr=logcpm(mat263)
        res=two_group_stats(expr,ctrl,inc,'Welch t-test on log2(CPM+0.5); public mapped counts')
        res=annotate_results(res,map263)
        res['module']=res.annotation.map(assign_module)
        res['dataset']='GSE263656'; res['contrast']=f'{scion}_below_US1283_vs_US812'
        res.to_csv(OUT/f'GSE263656_{scion}_below_DE.csv',index=False)
        comparisons263.append(res)
    else:
        print('WARNING unresolved GSE263 metadata for',scion,'ctrl',ctrl,'inc',inc)

# ---- GSE255759 ----
roots=pd.read_csv(files['gse255_roots'],compression='gzip')
# gene column is first non-sample column; transpose if needed.
gene_col=roots.columns[0]
roots=roots.set_index(gene_col)
roots=roots.apply(pd.to_numeric,errors='coerce').fillna(0)
roots.to_csv(OUT/'GSE255759_roots_matrix_as_deposited.csv.gz',compression='gzip')
map255=try_gprofiler_map(roots.index)
map255.to_csv(OUT/'GSE255759_gene_mapping.csv',index=False)

# Determine whether deposited values are integer-like.
vals=roots.to_numpy(float)
integer_like=np.nanmax(np.abs(vals-np.round(vals))) < 1e-8
method255='Welch t-test on log2(CPM+0.5)' if integer_like else 'Welch t-test on log2(deposited_value+0.5); GEO describes deposited file ambiguously as counts/RPKM'
expr255=logcpm(roots) if integer_like else np.log2(roots+0.5)

comparisons255=[]
for combo in ['ML2x','ML4x','PL2x','PL4x']:
    ctrl=[c for c in expr255.columns if re.search(rf'{combo}Ctrl_',str(c),re.I)]
    wd=[c for c in expr255.columns if re.search(rf'{combo}WD_',str(c),re.I)]
    if len(ctrl)>=2 and len(wd)>=2:
        res=two_group_stats(expr255,ctrl,wd,method255)
        res=annotate_results(res,map255)
        res['module']=res.annotation.map(assign_module)
        res['dataset']='GSE255759'; res['contrast']=f'{combo}_WD_vs_Ctrl'
        res.to_csv(OUT/f'GSE255759_{combo}_root_WD_vs_Ctrl.csv',index=False)
        comparisons255.append(res)
    else: print('WARNING columns not found for',combo,ctrl,wd)

allres=pd.concat(comparisons263+comparisons255,ignore_index=True) if (comparisons263 or comparisons255) else pd.DataFrame()
if not allres.empty:
    panel=allres[allres.module.astype(str).str.len()>0].copy()
    panel.to_csv(OUT/'prespecified_molecular_panel_results.csv',index=False)
    # Module-level transparent summary: number mapped; number FDR<.05; direction consistency.
    summ=[]
    for (dataset,contrast,module),g in panel.groupby(['dataset','contrast','module']):
        sig=g[g.padj<0.05]
        summ.append({'dataset':dataset,'contrast':contrast,'module':module,'mapped_genes':len(g),'fdr05_genes':len(sig),'median_log2FC':float(g.log2FC.median()),'sig_up':int((sig.log2FC>0).sum()),'sig_down':int((sig.log2FC<0).sum())})
    sm=pd.DataFrame(summ)
    sm.to_csv(OUT/'module_summary.csv',index=False)
else:
    panel=pd.DataFrame(); sm=pd.DataFrame()

# GO/NO-GO rule from prespecified design.
graft_signal=False; hydraulic_signal=False
if not sm.empty:
    graft_rows=sm[(sm.dataset=='GSE263656') & (sm.module.isin(['vascular_lignification','graft_organization']))]
    hydraulic_rows=sm[(sm.dataset=='GSE255759') & (sm.module=='hydraulic_PIP')]
    graft_signal=bool((graft_rows.fdr05_genes>0).any())
    # for PIPs, allow either FDR signal or repeated directional module shift in >=2 independent contrasts
    hyd_sig=bool((hydraulic_rows.fdr05_genes>0).any())
    dirs=np.sign(hydraulic_rows.median_log2FC.replace(0,np.nan).dropna()) if len(hydraulic_rows) else pd.Series(dtype=float)
    repeated_dir=(len(dirs)>=2 and max((dirs>0).sum(),(dirs<0).sum())>=2)
    hydraulic_signal=hyd_sig or repeated_dir

decision='MAIN_RESULTS_GO' if (graft_signal and hydraulic_signal) else ('SUPPLEMENT_ONLY' if (graft_signal or hydraulic_signal) else 'DO_NOT_USE')

report=f"""# CITRUS-NET public molecular triangulation\n\n## Claim boundary\nThese public expression data are independent contextual evidence. They were not generated from the Sargodha Kinnow root-graft experiment and must not be described as qPCR or transcriptomic measurements from those trees.\n\n## Prespecified modules\n- Vascular/lignification: LAC/laccase, class-III peroxidase, PAL, C4H, 4CL, CCR, CAD.\n- Graft organization: AUX/IAA and SAUR.\n- Hydraulic transport: PIP1/PIP2 aquaporins.\n\n## Resources\n- GSE263656: vascular tissue above/below compatible and incompatible citrus graft unions.\n- GSE255759: citrus roots under control vs 9-day water deficit across four scion/rootstock/ploidy combinations.\n- qPCR anchor: Paudel et al. 2017 (Sci Rep 7:15429), where citrus root PIP1/PIP2 transcripts were measured by real qPCR and related to root hydraulic conductivity.\n\n## Data-fitness note\nGSE255759 GEO metadata describes the deposited root file inconsistently as 'counts (RPKM)'. This pipeline therefore checks whether values are integer-like. Dataset-specific method actually used: **{method255}**. Effects from the two public datasets are never pooled.\n\n## Predefined inclusion decision\n**{decision}**\n\nA molecular arm enters the main Results only when a prespecified vascular/graft module is supported in GSE263656 AND the PIP/hydraulic module is supported in GSE255759. Otherwise it remains supplementary or is excluded.\n\n## qPCR status\nNo qPCR values were simulated, imputed, or generated. Published citrus qPCR is cited only as independent external support.\n"""
(OUT/'MOLECULAR_TRIANGULATION_REPORT.md').write_text(report)
(OUT/'decision.json').write_text(json.dumps({'decision':decision,'graft_module_supported':graft_signal,'hydraulic_PIP_supported':hydraulic_signal,'gse255_method':method255},indent=2))
print(report)
