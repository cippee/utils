clear; clc; close all;

cfg = config();
pal = mypalette();

%% ---- Toggle rapidi (sovrascrivono config.m) ------------------------------

normalizeSpectrum = false;      % true/false  - normalizza ogni spettro sul proprio massimo
stackPlots        = true;      % false = tutti sovrapposti sugli stessi assi
                                 % true  = un subplot per spettro, impilati verticalmente
colorMode         = 'manual';   % 'random' | 'sequential' | 'manual'
colorIndices      = [25 26 27];         % usato solo se colorMode = 'manual', es. [19 20 21]
xLim              = [190 1200];         % [] = automatico, altrimenti [xmin xmax], es. [200 800]

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
