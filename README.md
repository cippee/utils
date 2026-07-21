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
└── workflow/                        # batch runners, automation helpers
```

## License

MIT
