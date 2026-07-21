function plot_stack(files, pal, cfg)
%PLOT_STACK  Plot one spectrum per subplot, stacked vertically.

figure('Color', 'w');
t = tiledlayout(length(files), 1, 'TileSpacing', 'compact', 'Padding', 'compact');

usedColors = [];
axHandles  = gobjects(length(files), 1);

for i = 1:length(files)
    axHandles(i) = nexttile; hold on; box on;

    [color, usedColors] = pick_color(pal, i, cfg, usedColors);
    plot_spectrum( ...
        fullfile(files(i).folder, files(i).name), ...
        color, cfg.spectrumType, cfg.delimiter, cfg.headerLines, ...
        cfg.xColumn, cfg.yColumn, cfg.lineWidth, ...
        cfg.normalizeSpectrum, cfg.applySmoothing, cfg.smoothingWindow);

    [~, name, ~] = fileparts(files(i).name);
    title(name, 'FontSize', cfg.fontSize-4, 'Interpreter', 'none');

    set(gca, ...
        'XDir',       'reverse', ...
        'FontSize',   cfg.fontSize-2, ...
        'TickDir',    'out', ...
        'Layer',      'top', ...
        'XMinorTick', 'on', ...
        'YMinorTick', 'on');

    if i < length(files)
        set(gca, 'XTickLabel', []);
    end
end

%% ---- Align x-axis across all subplots ------------------------------------
% If cfg.xLim is not set, compute the union of all individual ranges
% instead of leaving each subplot autoscaled independently.

if ~isempty(cfg.xLim)
    xl = cfg.xLim;
else
    allLims = cell2mat(arrayfun(@(ax) xlim(ax), axHandles, 'UniformOutput', false));
    xl = [min(allLims(:,1)), max(allLims(:,2))];
end

set(axHandles, 'XLim', xl);
if ~isempty(cfg.yLim), set(axHandles, 'YLim', cfg.yLim); end
linkaxes(axHandles, 'x');

switch lower(cfg.spectrumType)
    case 'ir'
        xlabel(t, 'Wavenumber / cm^{-1}', 'FontSize', cfg.fontSize, 'FontWeight', 'bold');
        ylabel(t, 'Absorbance (a.u.)',    'FontSize', cfg.fontSize, 'FontWeight', 'bold');

    case 'raman'
        xlabel(t, 'Raman Shift / cm^{-1}', 'FontSize', cfg.fontSize, 'FontWeight', 'bold');
        ylabel(t, 'Intensity (a.u.)',       'FontSize', cfg.fontSize, 'FontWeight', 'bold');
end

end
