# Utils

A lightweight collection of scripts and small tools I use for data analysis, plotting, file handling, and other routine research tasks.  
Nothing fancy - just a repo to keep useful scripts in one place, make them reusable, and avoid rewriting the same thing every few months.

## Structure

```
utils/
├── quickplot/                       # plotting scripts, figure templates, quick visualization tools
│   ├── ir-raman/                    # main.m plots all ir/raman spectral data in './data'
│   └── uv/                          # main.m plots all uv spectral data in './data'
├── render/                          # molecular-graphics presets
│   ├── chimera/                     # UCSF Chimera presets (.cmd)
│   ├── chimerax/                    # ChimeraX ports of the same presets (.cxc)
│   └── axes.bild                    # XYZ reference-frame triad at the origin
├── misc/                            # one-off helpers
│   ├── top2charges/
│   │   └── top2vmdcharges.sh        # GROMACS .top/.itp -> '$sel set charge {...}' for VMD IR spectra
│   └── fchk2dipole/
│       └── fchk2dipole.py           # Gaussian .fchk -> geometry (.xyz) + dipole & axes (.bild)
└── workflow/                        # batch runners, automation helpers
```

## render

UCSF Chimera presets live in `render/chimera/` (`.cmd`); their ChimeraX ports are
in `render/chimerax/` (`.cxc`, applied with `open file.cxc`). Both cover a
ball-and-stick look (`molecule-style`), signed orbital/Fukui isosurfaces
(`orbital-style`, and `fukui-style` at level 0.004) and a two-view snapshot macro
(`fukui-snapshots`). `axes.bild` draws an XYZ reference triad (`open axes.bild`).

## misc/top2charges

VMD computes the IR spectrum from the dipole autocorrelation, so the charge
field of every atom has to be filled in by hand. The script reads the partial
charges from the `[ atoms ]` section of a GROMACS topology and prints the Tcl
lines to paste into the Tk Console:

```bash
./top2vmdcharges.sh spiral.top
```
```tcl
set sel [atomselect top "all"]
$sel set charge {0.13111 -0.14150 -0.10535 ... 0.11360}
$sel delete
```

`#include` directives are followed recursively and the charges are expanded
according to `[ molecules ]` (name + `n_mol`), so the order matches the
coordinate file GROMACS writes. Without a `[ molecules ]` section - a bare
`.itp` - every moleculetype is emitted once. On stderr it reports atoms per
molecule and the total charge, warning if it is not an integer.

Everything goes on a single line by default, because the Tk Console chokes on
multi-line braced lists. Useful flags: `-s "not water"` for a different
selection, `-m NAME` to pick one moleculetype, `-o file.tcl` to save, `-p` for
the bare list, `-n N` / `-1` to wrap. `-h` for the rest.

## misc/fchk2dipole

Pulls everything needed to draw a molecule's permanent dipole from a Gaussian
formatted checkpoint. Given `mol.fchk` it writes, next to it:

- `mol.xyz`         - geometry (input orientation, Angstrom)
- `mol-dipole.bild` - the dipole as a red arrow, tail at the center of mass
- `mol-axes.bild`   - an XYZ reference triad parked outside the bounding box

```bash
python3 fchk2dipole.py mol.fchk
```

Coordinates, dipole and center of mass all come from the same fchk (its input
orientation - the frame cubegen writes the `.cube` in), so the arrow overlays the
molecule with no rotation. The dipole keeps the Gaussian convention (points from
- to +). Flags: `-s` arrow scale in Angstrom/Debye (default 1.5, a negative value
flips the arrow), `--tail origin|com` (default com). Open the outputs in ChimeraX
with `open`. Standard library only.

## License

MIT
