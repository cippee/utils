clear; clc; close all;

cfg = config();
pal = mypalette();

%% ---- Toggle rapidi (sovrascrivono config.m) ------------------------------

normalizeSpectrum = true;      % true/false  - normalizza ogni spettro sul proprio massimo
stackPlots        = true;      % false = tutti sovrapposti sugli stessi assi
                                 % true  = un subplot per spettro, impilati verticalmente
colorMode         = 'random';   % 'random' | 'sequential' | 'manual'
colorIndices      = [];         % usato solo se colorMode = 'manual', es. [1 5 9]
xLim              = [1800 2350];         % [] = automatico, altrimenti [xmin xmax], es. [400 4000]

cfg.normalizeSpectrum = normalizeSpectrum;
cfg.stackPlots        = stackPlots;
cfg.colorMode         = colorMode;
cfg.colorIndices      = colorIndices;
cfg.xLim              = xLim;

%% ---- Caricamento file -----------------------------------------------------

files = load_spectra(cfg);

%% ---- Plot ------------------------------------------------------------

if cfg.stackPlots
    plot_stack(files, pal, cfg);
else
    plot_overlay(files, pal, cfg);
end

if cfg.saveFigure
    exportgraphics(gcf, cfg.outputName, 'Resolution', cfg.outputDPI);
end
