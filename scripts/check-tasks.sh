#!/usr/bin/env bash
# Cohérence entre tasks/INDEX.md et les frontmatters des tâches :
# chaque T-XX de l'index a son fichier et réciproquement ; id, status, depends_on et manual identiques ;
# aucune dépendance vers un ID inconnu ; aucune dépendance circulaire ; T-00 sans dépendance.
set -u
cd "$(dirname "$0")/.."
[ -f tasks/INDEX.md ] || { echo "check-tasks : tasks/INDEX.md absent"; exit 0; }
python3 - <<'PY'
import re, sys, glob, os
ok = True
def err(m):
    global ok; ok = False; print("  " + m, file=sys.stderr)
index = {}
for line in open("tasks/INDEX.md", encoding="utf-8"):
    m = re.match(r"\|\s*(T-\d+)\s*\|\s*(.*?)\s*\|\s*(\w+)\s*\|\s*(.*?)\s*\|\s*([SML])\s*\|\s*(oui|non)\s*\|\s*(.*?)\s*\|", line)
    if m:
        tid, title, status, deps, est, manual, done = m.groups()
        deps = [d.strip() for d in re.split(r"[,\s]+", deps) if d.strip() and d.strip() != "aucune"]
        index[tid] = dict(status=status, deps=deps, manual=(manual == "oui"), done=done.strip())
files = {}
for path in sorted(glob.glob("tasks/T-*.md")):
    txt = open(path, encoding="utf-8").read()
    fm = re.match(r"---\n(.*?)\n---", txt, re.S)
    if not fm:
        err(f"{path} : frontmatter absent"); continue
    d = {}
    for l in fm.group(1).splitlines():
        k, _, v = l.partition(":")
        d[k.strip()] = v.strip()
    tid = d.get("id", "")
    if not re.match(r"T-\d+$", tid):
        err(f"{path} : id invalide '{tid}'"); continue
    if not os.path.basename(path).startswith(tid + "-"):
        err(f"{path} : le nom du fichier ne commence pas par {tid}-")
    deps = [x.strip() for x in d.get("depends_on", "[]").strip("[]").split(",") if x.strip()]
    files[tid] = dict(status=d.get("status", ""), deps=deps, manual=(d.get("manual", "false") == "true"),
                      model=d.get("model", ""), done=d.get("done_at", ""))
for tid in sorted(set(index) | set(files)):
    if tid not in index: err(f"{tid} : fichier sans entrée dans l'index")
    if tid not in files: err(f"{tid} : entrée d'index sans fichier")
for tid in sorted(set(index) & set(files)):
    i, f = index[tid], files[tid]
    if i["status"] != f["status"]: err(f"{tid} : status index '{i['status']}' vs frontmatter '{f['status']}'")
    if sorted(i["deps"]) != sorted(f["deps"]): err(f"{tid} : depends_on index {i['deps']} vs frontmatter {f['deps']}")
    if i["manual"] != f["manual"]: err(f"{tid} : manual différent entre index et frontmatter")
    if f["status"] not in ("todo", "in_progress", "blocked_manual", "done"): err(f"{tid} : statut inconnu '{f['status']}'")
    if f["model"] not in ("opus", "fable"): err(f"{tid} : model doit être opus ou fable")
    if f["status"] == "done" and not (f["done"] and i["done"]): err(f"{tid} : done sans date")
    for d in f["deps"]:
        if d not in files: err(f"{tid} : dépendance inconnue {d}")
        elif f["status"] == "done" and files[d]["status"] != "done": err(f"{tid} : done alors que {d} ne l'est pas")
if "T-00" in files and files["T-00"]["deps"]: err("T-00 ne doit avoir aucune dépendance")
# cycles
state = {}
def visit(t, stack):
    if state.get(t) == 1: err("dépendance circulaire : " + " -> ".join(stack + [t])); return
    if state.get(t) == 2: return
    state[t] = 1
    for d in files.get(t, {}).get("deps", []):
        if d in files: visit(d, stack + [t])
    state[t] = 2
for t in files: visit(t, [])
if not ok:
    print("check-tasks : incohérences (voir ci-dessus).", file=sys.stderr); sys.exit(1)
print(f"check-tasks : OK ({len(files)} tâches)")
PY
