function plot_overlay(files, pal, cfg)
%PLOT_OVERLAY  Plotta tutti gli spettri sovrapposti sugli stessi assi.

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

if ~isempty(cfg.xLim)
    xlim(cfg.xLim);
end

apply_style(cfg);

end
