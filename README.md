# Utils

A lightweight collection of scripts and small tools I use for data analysis, plotting, file handling, and other routine research tasks.  
Nothing fancy - just a repo to keep useful scripts in one place, make them reusable, and avoid rewriting the same thing every few months.

## Structure

```
utils/
├── analysis/                        # data processing, statistics, filters, small helpers
│   ├── df_excited_states.ipynb      # parser for excited-state output files
│   └── df_contacts_h5.ipynb         # parser for contacts analysis of h5md sieve.x output
├── quickplot/                       # plotting scripts, figure templates, quick visualization tools
│   ├── ir-raman/                    # main.m plots all ir/raman spectral data in './data'
│   └── uv/                          # main.m plots all uv spectral data in './data'
├── render/                          # molecular rendering presets & scripts
│   ├── Picarelli_custom-molecules.cmd   # Chimera preset: b+s, silhouettes, 3-point light
│   ├── Picarelli_custom-orbitals.cmd    # as above + signed volume (orbital/Fukui) colours
│   └── fukui/                       # main.pml renders all Fukui .cube in './data' (PyMOL)
├── workflow/                        # batch runners, automation helpers
└── misc/                            # everything that doesn’t fit elsewhere
```

## License

MIT
