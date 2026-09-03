#!/usr/bin/env python3
# Chiara Picarelli, DCMC - Politecnico di Milano
# chiara.picarelli@polimi.it
# https://github.com/cippee/utils
# September 2026
#
# fchk2dipole.py -- from a Gaussian .fchk, write the geometry (.xyz), the dipole
# arrow (.bild) and a reference-frame triad placed outside the molecule
# (_axes.bild). Everything is in the same frame (fchk input orientation) and
# named after the fchk, written next to it.
#
#   fchk2dipole.py trans.fchk   ->  trans.xyz  trans-dipole.bild  trans-axes.bild
#   -s SCALE            dipole arrow scale, Angstrom/Debye (default 1)
#   --tail origin|com   dipole arrow tail (default com)

import sys, re, os, argparse

BOHR = 0.52917721          # Angstrom / Bohr
DEBYE = 2.5417464          # Debye / a.u.
AXLEN = 3.0                # axis arrow length, Angstrom
AXPAD = 2.0                # gap between molecule box and the axis corner, Angstrom
SYM = ('X H He Li Be B C N O F Ne Na Mg Al Si P S Cl Ar K Ca Sc Ti V Cr Mn '
       'Fe Co Ni Cu Zn Ga Ge As Se Br Kr').split()

def block(txt, label, n):
    """Read n numbers of the vector field `label` from an fchk (single slab)."""
    m = re.search(re.escape(label) + r"\s+[IR]\s+N=\s*(\d+)\s*\n", txt)
    if not m:
        sys.exit("field missing in fchk: " + label)
    slab = txt[m.end(): m.end() + n * 25 + 400]
    nums = re.findall(r"[-+]?\d+\.?\d*(?:[EeDd][-+]?\d+)?", slab)[:n]
    return [float(x.replace('D', 'E')) for x in nums]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('fchk')
    ap.add_argument('-s', '--scale', type=float, default=1)
    ap.add_argument('--tail', choices=('com', 'origin'), default='com')
    a = ap.parse_args()

    txt = open(a.fchk).read()
    nat = int(re.search(r"Number of atoms\s+I\s+(\d+)", txt).group(1))
    Z = [int(z) for z in block(txt, "Atomic numbers", nat)]
    m = block(txt, "Real atomic weights", nat)
    xyz_bohr = block(txt, "Current cartesian coordinates", 3 * nat)
    dip_au = block(txt, "Dipole Moment", 3)

    R = [[xyz_bohr[3*i+k] * BOHR for k in range(3)] for i in range(nat)]  # Angstrom
    M = sum(m)
    com = [sum(m[i]*R[i][k] for i in range(nat)) / M for k in range(3)]   # Angstrom
    dip = [d * DEBYE for d in dip_au]                                     # Debye
    tot = sum(d*d for d in dip) ** 0.5

    print(f"file       : {a.fchk}")
    print(f"atoms      : {nat}   mass = {M:.4f} amu")
    print(f"dipole D   : {dip[0]:.4f} {dip[1]:.4f} {dip[2]:.4f}   |mu| = {tot:.4f}")
    print("convention : Gaussian dipole, points from - to + charge (reproduced as-is)")
    print(f"COM (Ang)  : {com[0]:.4f} {com[1]:.4f} {com[2]:.4f}")

    tail = com if a.tail == 'com' else [0.0, 0.0, 0.0]
    head = [tail[k] + a.scale * dip[k] for k in range(3)]
    arrow = (f".arrow {tail[0]:.4f} {tail[1]:.4f} {tail[2]:.4f} "
             f"{head[0]:.4f} {head[1]:.4f} {head[2]:.4f} 0.15 0.40 0.75")

    # reference triad anchored at the lower corner of the bounding box, so it
    # sits outside the molecule instead of on top of the (near-origin) COM
    lo = [min(R[i][k] for i in range(nat)) - AXPAD for k in range(3)]
    ax = [
        ("red",   [lo[0]+AXLEN, lo[1],       lo[2]      ], "x"),
        ("green", [lo[0],       lo[1]+AXLEN, lo[2]      ], "y"),
        ("blue",  [lo[0],       lo[1],       lo[2]+AXLEN], "z"),
    ]

    stem = os.path.splitext(a.fchk)[0]
    xyz_path  = stem + ".xyz"
    bild_path = stem + "-dipole.bild"
    ax_path   = stem + "-axes.bild"

    with open(xyz_path, 'w') as f:
        f.write(f"{nat}\n{a.fchk} - input orientation, Angstrom\n")
        for i in range(nat):
            s = SYM[Z[i]] if Z[i] < len(SYM) else str(Z[i])
            f.write(f"{s:2s} {R[i][0]:14.8f} {R[i][1]:14.8f} {R[i][2]:14.8f}\n")

    with open(bild_path, 'w') as f:
        f.write(f".comment  dipole from {a.fchk}\n")
        f.write(f".comment  mu = ({dip[0]:.4f}, {dip[1]:.4f}, {dip[2]:.4f}) D"
                f", |mu| = {tot:.4f} D\n")
        f.write(f".comment  tail = {a.tail}; scale s = {a.scale} Angstrom/Debye\n")
        f.write(".comment  convention: Gaussian dipole, points from - to + charge (as-is)\n")
        f.write(".comment  arrow: x1 y1 z1  x2 y2 z2  shaft_r  head_r  shaft_fraction\n")
        f.write(".color red\n" + arrow + "\n")

    with open(ax_path, 'w') as f:
        f.write(f".comment  reference-frame axes for {a.fchk}\n")
        f.write(f".comment  corner outside the bounding box; length {AXLEN} A"
                f", x red / y green / z blue\n")
        for col, tip, lab in ax:
            f.write(f".color {col}\n")
            f.write(f".arrow {lo[0]:.4f} {lo[1]:.4f} {lo[2]:.4f} "
                    f"{tip[0]:.4f} {tip[1]:.4f} {tip[2]:.4f} 0.1 0.25 0.75\n")

    print(f"written    : {xyz_path}")
    print(f"written    : {bild_path}")
    print(f"written    : {ax_path}")

if __name__ == '__main__':
    main()
