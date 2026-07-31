#!/usr/bin/env bash
#
# top2vmdcharges.sh -- extract partial charges from a GROMACS topology and emit
#                      the VMD/Tcl lines needed to set them on a selection
#                      (e.g. for the IR spectrum computed by VMD's dipole/
#                      autocorrelation machinery, which reads the charge field).
#
# Usage:
#   ./top2vmdcharges.sh system.top [options]
#
# Options:
#   -s, --selection TEXT   atomselect text            (default: "all")
#   -v, --varname NAME     Tcl variable name          (default: sel)
#   -m, --molecule NAME    only this moleculetype, once (ignores [ molecules ])
#   -I, --include DIR      extra directory to search for #include files (repeatable)
#   -n, --per-line N       wrap the list every N charges (default: 0 = one
#                          single line, which is what the Tk Console wants)
#   -1, --one-per-line     one charge per line
#   -o, --output FILE      write to FILE instead of stdout
#   -p, --plain            print only the bare charge list (no Tcl wrapper)
#   -h, --help             this help
#
# Notes:
#   * #include "file.itp" directives are followed recursively (relative to the
#     including file, then to -I dirs, then to CWD).
#   * charges are expanded according to [ molecules ] (name + n_mol), so the
#     order matches the coordinate file GROMACS would write. If there is no
#     [ molecules ] section (e.g. a bare .itp), every moleculetype found is
#     emitted once, in order of appearance.
#   * a warning is printed on stderr if the total charge is not ~integer.
#
set -euo pipefail

# Force the C locale. Under a comma-decimal locale (it_IT, de_DE, ...) awk
# would read "0.13111" as 0 and print charges as "0,13111", which Tcl cannot
# parse -- so every charge would silently come out as zero.
export LC_ALL=C LC_NUMERIC=C

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
usage() { sed -n '2,/^set -euo/p' "$0" | sed 's/^# \{0,1\}//; $d'; }

SEL_TEXT="all"
VARNAME="sel"
ONLY_MOL=""
PER_LINE=0          # 0 = everything on one line
OUTFILE=""
PLAIN=0
TOPFILE=""
INCDIRS=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        -s|--selection)   SEL_TEXT="${2:?}"; shift 2 ;;
        -v|--varname)     VARNAME="${2:?}"; shift 2 ;;
        -m|--molecule)    ONLY_MOL="${2:?}"; shift 2 ;;
        -I|--include)     INCDIRS+=("${2:?}"); shift 2 ;;
        -n|--per-line)    PER_LINE="${2:?}"; shift 2 ;;
        -1|--one-per-line) PER_LINE=1; shift ;;
        -o|--output)      OUTFILE="${2:?}"; shift 2 ;;
        -p|--plain)       PLAIN=1; shift ;;
        -h|--help)        usage; exit 0 ;;
        -*)               die "unknown option: $1" ;;
        *)                [[ -z "$TOPFILE" ]] || die "only one topology file allowed"
                          TOPFILE="$1"; shift ;;
    esac
done

[[ -n "$TOPFILE" ]] || { usage; exit 1; }
[[ -f "$TOPFILE" ]] || die "no such file: $TOPFILE"
[[ "$PER_LINE" =~ ^[0-9]+$ ]] || die "--per-line needs a non-negative integer"

# ---------------------------------------------------------------- flatten ----
# Recursively inline #include "..." directives into a single stream.
flatten() {
    local file="$1" depth="${2:-0}" base line target cand
    (( depth < 32 )) || die "#include nesting too deep (circular include?)"
    base="$(cd "$(dirname "$file")" && pwd)"
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ ^[[:space:]]*#include[[:space:]]+[\"\<]([^\"\>]+)[\"\>] ]]; then
            target="${BASH_REMATCH[1]}"
            cand=""
            for d in "$base" "${INCDIRS[@]:-}" "."; do
                [[ -n "$d" && -f "$d/$target" ]] && { cand="$d/$target"; break; }
            done
            [[ -f "$target" ]] && cand="${cand:-$target}"
            if [[ -n "$cand" ]]; then
                flatten "$cand" $((depth + 1))
            else
                printf 'warning: could not resolve #include "%s" (skipped)\n' \
                       "$target" >&2
            fi
        else
            printf '%s\n' "$line"
        fi
    done < "$file"
}

# ------------------------------------------------------------------ parse ----
CHARGES="$(flatten "$TOPFILE" | awk -v only="$ONLY_MOL" '
    # strip comments and trailing whitespace
    { sub(/;.*/, ""); sub(/[[:space:]]+$/, "") }
    /^[[:space:]]*$/ { next }
    /^[[:space:]]*#/ { next }              # leftover preprocessor directives

    # section headers:  [ name ]
    /^[[:space:]]*\[/ {
        s = $0
        gsub(/[][[:space:]]/, "", s)
        section = tolower(s)
        if (section == "moleculetype") expect_name = 1
        next
    }

    section == "moleculetype" && expect_name {
        curmol = $1; expect_name = 0
        mtorder[++nmt] = curmol
        next
    }

    section == "atoms" && curmol != "" {
        if (NF < 7) {
            printf("warning: %s atom %s has no explicit charge column\n",
                   curmol, $1) > "/dev/stderr"
            q = 0
        } else q = $7
        n = ++natoms[curmol]
        charge[curmol, n] = q
        next
    }

    section == "molecules" {
        nmol++; molname[nmol] = $1; molcount[nmol] = (NF >= 2 ? $2 : 1)
        next
    }

    END {
        if (only != "") { nmol = 1; molname[1] = only; molcount[1] = 1 }
        else if (nmol == 0) {
            # bare .itp: no [ molecules ] -- emit every moleculetype once
            if (nmt == 0) {
                print "error: no [ moleculetype ] found in topology" \
                      > "/dev/stderr"
                exit 3
            }
            printf("info: no [ molecules ] section, using every " \
                   "moleculetype once\n") > "/dev/stderr"
            for (i = 1; i <= nmt; i++) {
                molname[i] = mtorder[i]; molcount[i] = 1
            }
            nmol = nmt
        }
        total = 0; k = 0
        for (i = 1; i <= nmol; i++) {
            m = molname[i]
            if (!(m in natoms)) {
                printf("error: moleculetype \"%s\" not found in topology " \
                       "(missing #include?)\n", m) > "/dev/stderr"
                exit 4
            }
            for (r = 1; r <= molcount[i]; r++)
                for (a = 1; a <= natoms[m]; a++) {
                    # print the token verbatim: no reformatting, so the values
                    # are exactly those written in the topology
                    print charge[m, a]
                    total += charge[m, a] + 0; k++
                }
            printf("info: %-20s n_mol=%-6d atoms/mol=%d\n",
                   m, molcount[i], natoms[m]) > "/dev/stderr"
        }
        printf("info: %d charges, total = %+.5f\n", k, total) > "/dev/stderr"
        nearest = int(total + (total >= 0 ? 0.5 : -0.5))
        dev = total - nearest; if (dev < 0) dev = -dev
        if (dev > 1e-4)
            printf("warning: total charge is not an integer (%+.5f)\n",
                   total) > "/dev/stderr"
    }
')"

[[ -n "$CHARGES" ]] || die "no charges extracted"

# ------------------------------------------------------------------ write ----
emit() {
    local list
    if [[ "$PER_LINE" -eq 0 ]]; then
        # single line: safest to paste into the Tk Console, which mangles
        # multi-line braced lists
        list="$(printf '%s\n' "$CHARGES" | paste -sd' ' -)"
    else
        list="$(printf '%s\n' "$CHARGES" | awk -v n="$PER_LINE" '
            { printf("%s%s", (c % n ? " " : (c ? "\n    " : "    ")), $1); c++ }
            END { printf("\n") }')"
    fi

    if [[ "$PLAIN" -eq 1 ]]; then
        printf '%s\n' "$list"
        return
    fi
    printf '# charges from %s -- paste into VMD (Extensions > Tk Console)\n' \
           "$(basename "$TOPFILE")"
    printf 'set %s [atomselect top "%s"]\n' "$VARNAME" "$SEL_TEXT"
    if [[ "$PER_LINE" -eq 0 ]]; then
        printf '$%s set charge {%s}\n' "$VARNAME" "$list"
    else
        printf '$%s set charge {\n%s}\n' "$VARNAME" "$list"
    fi
    printf '$%s delete\n' "$VARNAME"
}

if [[ -n "$OUTFILE" ]]; then
    emit > "$OUTFILE"
    printf 'info: written to %s\n' "$OUTFILE" >&2
else
    emit
fi
