% Chiara Picarelli, DCMC - Politecnico di Milano
% chiara.picarelli@polimi.it
% https://github.com/cippee/utils
% May 2026
%

clear; clc; close all;

cfg = config();
pal = mypalette();

%% ---- Quick toggles (override config.m) -----------------------------------

spectrumType      = 'raman';        % 'ir'    -> Wavenumber / Absorbance
                                 % 'raman' -> Raman Shift / Intensity
normalizeSpectrum = false;      % true/false  - normalize each spectrum to its own maximum
stackPlots        = true;       % false = all spectra overlaid on the same axes
                                 % true  = one subplot per spectrum, stacked vertically
colorMode         = 'manual';   % 'random' | 'sequential' | 'manual'
colorIndices      = [25 26 27]; % used only if colorMode = 'manual', e.g. [19 20 21]
xReverse          = false;      % true = reversed x-axis (standard for IR/Raman)
xLim              = [1000 3500]; % [] = automatic, otherwise [xmin xmax], e.g. [400 4000]
yLim              = [];          % [] = automatic, otherwise [ymin ymax], e.g. [0 1]
xLabel            = '';          % '' = default from spectrumType, or e.g. 'Wavenumber / cm^{-1}'
yLabel            = '';          % '' = default from spectrumType, or e.g. 'Absorbance (a.u.)'

cfg.spectrumType      = spectrumType;
cfg.normalizeSpectrum = normalizeSpectrum;
cfg.stackPlots        = stackPlots;
cfg.colorMode         = colorMode;
cfg.colorIndices      = colorIndices;
cfg.xReverse          = xReverse;
cfg.xLim              = xLim;
cfg.yLim              = yLim;
cfg.xLabel            = xLabel;
cfg.yLabel            = yLabel;

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
