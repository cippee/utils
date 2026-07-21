clear; clc; close all;

cfg = config();
pal = mypalette();

%% ---- Quick toggles (override config.m) -----------------------------------

normalizeSpectrum = false;      % true/false  - normalize each spectrum to its own maximum
stackPlots        = true;       % false = all spectra overlaid on the same axes
                                 % true  = one subplot per spectrum, stacked vertically
colorMode         = 'random';   % 'random' | 'sequential' | 'manual'
colorIndices      = [];         % used only if colorMode = 'manual', e.g. [1 5 9]
xLim              = [];         % [] = automatic, otherwise [xmin xmax], e.g. [400 4000]
yLim              = [];         % [] = automatic, otherwise [ymin ymax], e.g. [0 1]

cfg.normalizeSpectrum = normalizeSpectrum;
cfg.stackPlots        = stackPlots;
cfg.colorMode         = colorMode;
cfg.colorIndices      = colorIndices;
cfg.xLim              = xLim;
cfg.yLim              = yLim;

%% ---- Load files -----------------------------------------------------------

files = load_spectra(cfg);

%% ---- Plot -----------------------------------------------------------------

if cfg.stackPlots
    plot_stack(files, pal, cfg);
else
    plot_overlay(files, pal, cfg);
end

if cfg.saveFigure
    exportgraphics(gcf, cfg.outputName, 'Resolution', cfg.outputDPI);
end
