clear; clc; close all;

cfg = config();
pal = mypalette();

files = dir(fullfile(cfg.dataFolder, '*.dat'));
if isempty(files)
    error('Nessun file .dat trovato in: %s', cfg.dataFolder);
end

figure('Color', 'w'); hold on; box on;

usedColors = [];
for i = 1:length(files)
    [color, usedColors] = pick_color(pal, i, cfg, usedColors);
    plot_spectrum( ...
        fullfile(files(i).folder, files(i).name), ...
        color, cfg.spectrumType, cfg.delimiter, cfg.headerLines, ...
        cfg.xColumn, cfg.yColumn, cfg.lineWidth, ...
        cfg.normalizeSpectrum, cfg.applySmoothing, cfg.smoothingWindow);
end

apply_style(cfg);

if cfg.saveFigure
    exportgraphics(gcf, cfg.outputName, 'Resolution', cfg.outputDPI);
end
