#!/usr/bin/env bash
# ==============================================================
#  macports_update.sh — Routine di manutenzione MacPorts
#  Uso: sudo ./macports_update.sh [--dry-run]
# ==============================================================

set -euo pipefail

# ── Colori ─────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ── Helpers ────────────────────────────────────────────────────
info()    { echo -e "${CYAN}▶ $*${RESET}"; }
success() { echo -e "${GREEN}✔ $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠ $*${RESET}"; }
error()   { echo -e "${RED}✘ $*${RESET}" >&2; exit 1; }
separator() { echo -e "${BOLD}──────────────────────────────────────────${RESET}"; }

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

run() {
    if $DRY_RUN; then
        echo -e "${YELLOW}[dry-run] $*${RESET}"
    else
        "$@"
    fi
}

# ── Controlli preliminari ──────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || error "Questo script richiede macOS."
command -v port &>/dev/null   || error "'port' non trovato. MacPorts è installato?"
[[ "$EUID" -eq 0 ]]           || error "Esegui con sudo: sudo $0"

$DRY_RUN && warn "Modalità DRY-RUN: nessuna modifica verrà apportata."
separator

# ── 1. selfupdate ──────────────────────────────────────────────
info "[1/6] Aggiornamento di MacPorts (selfupdate)…"
run port selfupdate
success "MacPorts aggiornato."
separator

# ── 2. outdated ────────────────────────────────────────────────
info "[2/6] Port con aggiornamenti disponibili…"
OUTDATED=$(port outdated 2>/dev/null || true)
if [[ -z "$OUTDATED" || "$OUTDATED" == *"No installed ports are outdated"* ]]; then
    success "Tutti i port sono aggiornati."
else
    echo "$OUTDATED"
fi
separator

# ── 3. upgrade outdated ────────────────────────────────────────
info "[3/6] Aggiornamento dei port obsoleti…"
run port upgrade outdated
success "Port aggiornati."
separator

# ── 4. uninstall inactive ──────────────────────────────────────
info "[4/6] Rimozione delle versioni inattive…"
INACTIVE=$(port installed inactive 2>/dev/null || true)
if [[ -z "$INACTIVE" || "$INACTIVE" == *"None of the specified ports are installed"* ]]; then
    success "Nessuna versione inattiva da rimuovere."
else
    echo "$INACTIVE"
    run port uninstall inactive
    success "Versioni inattive rimosse."
fi
separator

# ── 5. reclaim ─────────────────────────────────────────────────
info "[5/6] Pulizia dello spazio disco (reclaim)…"
# 'reclaim' è interattivo; usiamo --disable-follow-dependencies per forzarlo
run port reclaim --disable-follow-dependencies 2>/dev/null || \
    warn "Comando 'reclaim' non disponibile in questa versione di MacPorts (opzionale)."
separator

# ── 6. Riepilogo ───────────────────────────────────────────────
info "[6/6] Riepilogo installazione…"
TOTAL=$(port installed 2>/dev/null | grep -c "  @" || true)
echo -e "  Port installati (attivi): ${BOLD}${TOTAL}${RESET}"
echo ""
success "Routine MacPorts completata!"
separator
