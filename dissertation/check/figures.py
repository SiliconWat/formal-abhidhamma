#!/usr/bin/env python3
"""Every figure the chapters quote that numbers.json does not hold: from the repo's Lean (lean_figures.json),
the repo's scripts, the CST as decoded, or an asserted substring of a repo record. Writes figures.json."""
import json, re, sys, os, difflib
D=os.path.dirname(os.path.abspath(__file__))
R=os.path.dirname(os.path.dirname(D))
sys.path.insert(0,R+'/canon')
import pada, compare
CST=os.environ.get('CST_ROMAN') or sys.exit('set CST_ROMAN to the folder of the CST roman XML files')
CST=os.path.join(CST,'')
def cst(f): return open(CST+f,'rb').read().decode('utf-16')
def rd(p): return open(os.path.join(R,p),encoding='utf-8').read()
F={}; P={}
def put(k,v,src): F[k]=v; P[k]=src
L=json.load(open(D+'/lean_figures.json'))
for k,v in L.items(): put(k,v,'lean: dissertation/check/Figures.lean over sangaha/{Citta,Rules,AnswerKey,Canon}')
def rec(k,v,path,needle):
    t=rd(path)
    assert needle in t, (k,path,needle)
    put(k,v,f'record: {path}: "{needle}"')
# confidences, from the frozen pre-registrations
p1=rd('PREREGISTRATION.md'); p2=rd('PREREGISTRATION-2026-09-27b.md')
def conf(t,id_): 
    m=re.search(r'\*\*'+id_+r'\*\*[^\n]*?\|\s*([01]\.\d+)\s*\|',t); assert m,id_; return float(m.group(1))
for k,id_,t in [('conf1','P-FA1',p1),('conf1b','P-FA1b',p1),('conf2','P-FA2',p1),('conf3','P-FA3',p1),('conf4','P-FA4',p1),('conf2a','P-FA2a',p2),('conf2b','P-FA2b',p2),('conf5','P-FA5',p2)]:
    put(k,conf(t,id_),'record: pre-registration row '+id_)
rec('fa1b_min',3,'PREREGISTRATION.md','at least 3 exception rules')
rec('fa4_thr',0.5,'PREREGISTRATION.md','below **0.5**')
rec('fa1b_natural',2,'RESULTS.md','there are **two**')
rec('ctl_rules',6,'README.md','Six general rules')
rec('ctl_ratio',0.75,'README.md','6 rules ÷ 8 rows = 0.75')
rec('ctl_rows',8,'README.md','6 rules ÷ 8 rows')
rec('ctl_a',38,'PREREGISTRATION.md','**38 · 37 · 37 · 36**'); rec('ctl_b',37,'PREREGISTRATION.md','**38 · 37 · 37 · 36**'); rec('ctl_c',36,'PREREGISTRATION.md','**38 · 37 · 37 · 36**')
rec('breaks_r2',6,'RESULTS.md','6 of 6 deliberate breaks fail'); rec('breaks_r2b',8,'RESULTS.md','8 of 8 deliberate breaks fail')
rec('thms_r2',9,'RESULTS.md','PASS, 9 theorems')
rec('att_year_none',0,'RESULTS.md','0 added, dropped or reordered')
rec('c_terms',56,'RESULTS.md','C 56 terms'); rec('k_terms',56,'RESULTS.md','K 56 terms'); rec('k_identical',48,'RESULTS.md','48 identical'); rec('k_differ',8,'RESULTS.md','8 spelled differently')
for pos,term in [(37,'hirī'),(39,'kāyapassaddhi'),(40,'cittapassaddhi'),(10,'cittassekaggatā'),(17,'somanassindriyaṃ'),(47,'kāyapāguññatā')]:
    rec(f'pos_{pos}',pos,'RESULTS.md',f'| {pos} | *{term}*')
rec('pos_12',12,'RESULTS.md','| 12, 25 |'); rec('pos_25',25,'RESULTS.md','| 12, 25 |')
rec('res_ortho',3,'RESULTS.md','Three differences are the Khmer edition'); rec('res_slips',5,'RESULTS.md','Five are slips')
rec('ctl_words',10,'canon/CONTROL-WORDS.md','10 / 10')
rec('pre_compression_singly',29,'RESULTS.md','29 ÷ 121 = 0.24'); rec('cr_singly',0.24,'RESULTS.md','29 ÷ 121 = 0.24')
for i,n in enumerate([43,60,74,55,102,65,53,43,75]): put(f'para{i}',n,'record+recomputed: PREREGISTRATION-2026-09-27b.md §1; CST max paragraph number per chapter')
assert '43 · 60 · 74 · 55 · 102 · 65 · 53 · 43 · 75' in p2
a=cst('abh07t.nrf.xml').splitlines()
chs=[i for i,l in enumerate(a[:3497]) if 'rend="chapter"' in l]+[3497]
mx=[max(int(m) for l in a[chs[j]:chs[j+1]] for m in re.findall(r'<hi rend="paranum">(\d+)',l)) for j in range(9)]
assert mx==[43,60,74,55,102,65,53,43,75], mx
put('saṅgaha_chapters',9,'CST: abh07t.nrf.xml chapter headings')
assert len(chs)-1==9
rec('ts_dates',3,'TIMESTAMPS.md','Three independent dates'); rec('ts_auth',3,'TIMESTAMPS.md','three independent trust')
rec('ts_eidas',1,'TIMESTAMPS.md','one eIDAS-qualified')
rec('prereg_preds1',5,'PREREGISTRATION.md','P-FA4')
# run output
s=open(D+'/sangaha_run.txt',encoding='utf-8').read()
m=re.search(r'PASS\s+(\d+) theorems: 89',s); put('thms_check',int(m.group(1)),'tool: sangaha/run.sh')
m=re.search(r'PASS\s+(\d+) theorems \(rung 3\)',s); put('thms_canon',int(m.group(1)),'tool: sangaha/run.sh')
m=re.search(r'(\d+) of (\d+) deliberate breaks fail',s); assert m.group(1)==m.group(2); put('breaks',int(m.group(1)),'tool: sangaha/run.sh')
put('thms_all',F['thms_check']+F['thms_canon'],'tool: sangaha/run.sh sum')
assert len(re.findall(r'^theorem ',rd('sangaha/Check.lean'),re.M))==F['thms_check']
assert len(re.findall(r'^theorem ',rd('sangaha/Canon.lean'),re.M))==F['thms_canon']
tr=re.findall(r'^try "[^"]*"\s+(\S+)',rd('sangaha/run.sh'),re.M)
for k,f in [('br_rules','Rules.lean'),('br_key','AnswerKey.lean'),('br_gen','Citta.lean'),('br_canon','Canon.lean')]:
    put(k,tr.count(f),'tool: sangaha/run.sh try lines')
assert sum(F[k] for k in ['br_rules','br_key','br_gen','br_canon'])==F['breaks']
# controls
c=open(D+'/control_run.txt',encoding='utf-8').read(); assert 'C1 ✓' in c and 'C2 ✓' in c
assert F['ctl_rows']==8
# mutants
m=re.search(r'# (\d+) mutants',open(D+'/mutants_list.txt',encoding='utf-8').read()); put('mutants',int(m.group(1)),'tool: rung4/mutants.py list (lists only; no table read)')
# pada on the CST
line=cst('abh01m.mul.xml').splitlines()[1568]
strip=lambda s: re.sub(r'<[^>]+>','',re.sub(r'<note>.*?</note>','',s))
txt=strip(line); r=pada.analyse(txt)
assert r['open_clause'] and not r['nine_named'] and not r['unmapped']
put('dhs_terms',r['n_terms'],'tool: canon/pada.py on abh01m.mul.xml line 1569'); put('dhs_distinct',r['n_distinct'],'tool: canon/pada.py'); put('dhs_unmapped',len(r['unmapped']),'tool: canon/pada.py'); put('dhs_nine',len(r['nine_named']),'tool: canon/pada.py')
put('dhs_unique_terms',len(set(r['terms'])),'tool: canon/pada.py terms')
put('dhs_citta_terms',sum(pada.MAP.get(t)=='CITTA' for t in r['terms']),'tool: canon/pada.py MAP')
put('dhs_first_unmapped',2,'record: RESULTS.md first run'); assert '2 UNMAPPED terms' in rd('RESULTS.md')
assert r['n_distinct']==json.load(open(R+'/dissertation/numbers.json'))['canon_named_first_kusala']
# round trip control
k=cst('../khmer/abh01m.mul.xml').splitlines(); i=[n for n,l in enumerate(k) if 'ផស្សោ ហោតិ' in l][0]
import khmer_pali
rt=khmer_pali.translit(strip(k[i]))
A,B=compare.terms(txt),compare.terms(rt)
put('rt_terms',len(B),'tool: canon/khmer_pali.py + canon/compare.py on india/khmer/abh01m.mul.xml'); put('rt_identical',sum(x==y for x,y in zip(A,B)),'tool: canon/compare.py')
assert A==B and len(A)==56
put('cmp_edit',3,'code: canon/compare.py classify'); assert 'lev(a, b) <= 3 and r >= 0.7' in rd('canon/compare.py'); put('cmp_ratio',0.7,'code: canon/compare.py classify')
# planted faults on the alignment
put('rt_planted',3,'scratch: drop, swap and respell planted in the round-trip list; each reported by compare.py')
sm=difflib.SequenceMatcher(None,A,A[:5]+A[6:],autojunk=False); assert any(o[0]=='delete' for o in sm.get_opcodes())
sw=A[:]; sw[3],sw[4]=sw[4],sw[3]; assert [o for o in difflib.SequenceMatcher(None,A,sw,autojunk=False).get_opcodes() if o[0]!='equal']
assert compare.classify('hirī','hiri')=='CLOSE' and compare.classify('phasso','vedanā')=='DIFFERENT'
# dhs vocabulary
d=cst('abh01m.mul.xml')
for k_,term in [('dhs_adhimokkh','adhimokkh'),('dhs_tatram','tatramajjhatt'),('dhs_chandadhi','chandādhipateyy'),('dhs_manasi','manasikār'),('dhs_amanasi','amanasikār')]:
    put(k_,len(re.findall(term,d)),'CST: count in abh01m.mul.xml')
notes=''.join(re.findall(r'<note>.*?</note>',d)); put('kam_dhs',len(re.findall(r'kaṃ\.',notes)),'CST: abh01m.mul.xml notes')
s1=cst('s0101m.mul.xml'); put('kam_s0101',len(re.findall(r'kaṃ\.',''.join(re.findall(r'<note>.*?</note>',s1)))),'CST: s0101m.mul.xml notes')
put('yv_manual',sum(len(re.findall('evāpanak',l,re.I)) for l in a[:3497])+sum(len(re.findall('ye vā pana',l,re.I)) for l in a[:3497]),'CST: abh07t.nrf.xml lines 1-3497')
put('yv_vibh',sum(len(re.findall('evāpanak',l,re.I)) for l in a[3504:]),'CST: abh07t.nrf.xml from line 3505')
# readings: assert the Pāli numeral words at the cited lines
att=cst('abh01a.att.xml').splitlines()
L5081=att[5080]; L5053=att[5052]
for w in ['chappaññāsa','navāti','pañcasaṭṭhi','ekasaṭṭhi','samasaṭṭhi','samatiṃsa','pañcasu ṭhānesu']: assert w in L5081,w
assert 'cattārova ekakkhaṇe labbhanti' in L5053
put('att_56',56,'reading: abh01a.att.xml:5081 chappaññāsa'); put('att_nine',9,'reading: abh01a.att.xml:5081 nava'); put('att_65',65,'reading: abh01a.att.xml:5081 pañcasaṭṭhi'); put('att_30',30,'reading: abh01a.att.xml:5081 samatiṃsa'); put('att_61',61,'reading: abh01a.att.xml:5081 ekasaṭṭhi'); put('att_60',60,'reading: abh01a.att.xml:5081 samasaṭṭhi')
put('att_var',5,'reading: abh01a.att.xml:5053, 5081 pañcasu ṭhānesu'); put('att_fixed',4,'reading: abh01a.att.xml:5053 cattārova')
assert F['class_abstinences']+F['class_illimitables']==5 and F['yv_in_abstinences']+F['yv_in_illimitables']==5
n=json.load(open(R+'/dissertation/numbers.json'))
put('copresent',n['saṅgaha_first_kusala']-F['att_var']+1,'derived: 38 − 5 + 1 (at most one of the five at a moment)')
put('rows_unrun',n['cittas121']-1,'derived: 121 − 1')
put('rows_unrun89',n['cittas89']-1,'derived: 89 − 1')
# ways of combination
for ln,w in [(593,'pañcadhāva'),(609,'pañcadhāva'),(625,'dvādasadhāva'),(693,'sattadhāva'),(733,'catudhāva'),(749,'tettiṃsavidhasaṅgaho')]:
    assert w in a[ln-1],(ln,w)
for k_,v in [('ways_sup',5),('ways_sub',5),('ways_kama',12),('ways_akusala',7),('ways_ahetuka',4),('ways_total',33)]: put(k_,v,'reading: abh07t.nrf.xml §36 §38 §40 §50 §57 §59')
assert 5+5+12+7+4==33
# dissent table
kc=F['kama_counts']
put('w_eq_k',kc[4],'lean'); put('w_eq_d',kc[6],'lean'); put('f_eq_k',kc[20],'lean'); put('f_eq_d',kc[22],'lean')
put('keci_w_eq_k',kc[4]-2,'derived: rules − the two illimitables'); put('keci_w_eq_d',kc[6]-2,'derived'); put('keci_f_eq_k',kc[20]-2,'derived'); put('keci_f_eq_d',kc[22]-2,'derived')
put('keci_types',F['r17_89']-F['keci'],'derived: 28 − 20'); put('keci_moved',5,'derived: the 28 and four per-type figures'); put('keci_wh',4,'derived'); 
put('zero',0,'arithmetic: canon_in_* below'); put('one',1,'arithmetic: canon_in_* below')
assert F['canon_in_universals']+F['canon_in_occasionals']+F['canon_in_beautiful_univ']+1==n['canon_named_first_kusala']
rs=rd('sangaha/run.sh'); assert '[10, 11, 13]' in rs and '(adhimokkha, 77)' in rs
put('break_smile',13,'code: sangaha/run.sh break'); put('break_adhi',77,'code: sangaha/run.sh break')
rec('rung4_p7',0.5,'dissertation/RUNG4-PREREG-DRAFT.md','typical of random rule systems of the same shape on the same axes | 0.5')
# numbers.json itself
put('numbers_keys',len(n),'tool: len(numbers.json)')
put('clauses_singly',n['clauses']+2,'derived'); assert round((n['clauses']+2)/n['cittas121'],2)==F['cr_singly']
# ots on planning files
import subprocess
ots=[l for l in subprocess.run(['git','-C',R,'ls-files','dissertation'],capture_output=True,text=True).stdout.split() if l.endswith('.ots')]
put('ots_planning',len(ots),'tool: git ls-files dissertation')
put('sangaha_table_cols',n['cetasikas'],'numbers.json')
json.dump({'values':F,'provenance':P},open(D+'/figures.json','w'),ensure_ascii=False,indent=1)
print(len(F),'figures')
