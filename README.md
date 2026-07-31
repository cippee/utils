# Utils

A lightweight collection of scripts and small tools I use for data analysis, plotting, file handling, and other routine research tasks.  
Nothing fancy - just a repo to keep useful scripts in one place, make them reusable, and avoid rewriting the same thing every few months.

## Structure

```
utils/
├── quickplot/                       # plotting scripts, figure templates, quick visualization tools
│   ├── ir-raman/                    # main.m plots all ir/raman spectral data in './data'
│   └── uv/                          # main.m plots all uv spectral data in './data'
├── render/                          # render presets (.cmd command files)
│   ├── molecule-style.cmd           # custom Chimera preset b+s molecule, silhouettes, 3-point light
│   ├── orbital-style.cmd            # as above + signed volume surface (level 0.02)
│   ├── fukui-style.cmd              # orbital look tuned for Fukui cubes (level 0.004)
│   └── fukui-snapshots.cmd          # save front view, turn y 90, save again
├── misc/                            # one-off helpers
│   └── top2charges/
│       └── top2vmdcharges.sh        # GROMACS .top/.itp -> '$sel set charge {...}' for VMD IR spectra
└── workflow/                        # batch runners, automation helpers
```

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

## License

MIT
