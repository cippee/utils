clear; clc; close all;

cfg = config();
pal = mypalette();

%% ---- Toggle rapidi (sovrascrivono config.m) ------------------------------

normalizeSpectrum = false;      % true/false  - normalizza ogni spettro sul proprio massimo
stackPlots        = false;      % false = tutti sovrapposti sugli stessi assi
                                % true  = un subplot per spettro, impilati verticalmente

cfg.normalizeSpectrum = normalizeSpectrum;
cfg.stackPlots        = stackPlots;

%% ---- Caricamento file -----------------------------------------------------

files = dir(fullfile(cfg.dataFolder, '*.dat'));
if isempty(files)
    error('Nessun file .dat trovato in: %s', cfg.dataFolder);
end

usedColors = [];

if cfg.stackPlots

    %% ==========================================================
    %  MODALITÀ STACK: un subplot per spettro, impilati verticalmente
    % ===========================================================

    figure('Color', 'w');
    t = tiledlayout(length(files), 1, 'TileSpacing', 'compact', 'Padding', 'compact');

    for i = 1:length(files)
        nexttile; hold on; box on;

        [color, usedColors] = pick_color(pal, i, cfg, usedColors);
        plot_spectrum( ...
            fullfile(files(i).folder, files(i).name), ...
            color, cfg.spectrumType, cfg.delimiter, cfg.headerLines, ...
            cfg.xColumn, cfg.yColumn, cfg.lineWidth, ...
            cfg.normalizeSpectrum, cfg.applySmoothing, cfg.smoothingWindow);

        [~, name, ~] = fileparts(files(i).name);
        title(name, 'FontSize', cfg.fontSize-4, 'Interpreter', 'none');

        set(gca, ...
            'XDir',       'normal', ...
            'FontSize',   cfg.fontSize-2, ...
            'TickDir',    'out', ...
            'Layer',      'top', ...
            'XMinorTick', 'on', ...
            'YMinorTick', 'on');

        if i < length(files)
            set(gca, 'XTickLabel', []);
        end
    end

    switch lower(cfg.spectrumType)
        case 'uv-abs'
            xlabel(t, 'Wavelength / nm',   'FontSize', cfg.fontSize, 'FontWeight', 'bold');
            ylabel(t, 'Absorbance (a.u.)', 'FontSize', cfg.fontSize, 'FontWeight', 'bold');

        case 'uv-molar'
            xlabel(t, 'Wavelength / nm',           'FontSize', cfg.fontSize, 'FontWeight', 'bold');
            ylabel(t, '\epsilon / M^{-1} cm^{-1}', 'FontSize', cfg.fontSize, 'FontWeight', 'bold');
    end

else

    %% ==========================================================
    %  MODALITÀ OVERLAY: tutti gli spettri sugli stessi assi
    % ===========================================================

    figure('Color', 'w'); hold on; box on;

    for i = 1:length(files)
        [color, usedColors] = pick_color(pal, i, cfg, usedColors);
        plot_spectrum( ...
            fullfile(files(i).folder, files(i).name), ...
            color, cfg.spectrumType, cfg.delimiter, cfg.headerLines, ...
            cfg.xColumn, cfg.yColumn, cfg.lineWidth, ...
            cfg.normalizeSpectrum, cfg.applySmoothing, cfg.smoothingWindow);
    end

    apply_style(cfg);

end

if cfg.saveFigure
    exportgraphics(gcf, cfg.outputName, 'Resolution', cfg.outputDPI);
end
