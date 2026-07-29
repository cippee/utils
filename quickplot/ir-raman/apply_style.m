% Chiara Picarelli, DCMC - Politecnico di Milano
% chiara.picarelli@polimi.it
% https://github.com/cippee/utils
% May 2026
%

function apply_style(cfg)
%APPLY_STYLE  Set axis labels, direction, ticks, and legend on the current axes.

fs = cfg.fontSize;

switch lower(cfg.spectrumType)
    case 'ir'
        defaultX = 'Wavenumber / cm^{-1}';
        defaultY = 'Absorbance (a.u.)';
    case 'raman'
        defaultX = 'Raman Shift / cm^{-1}';
        defaultY = 'Intensity (a.u.)';
    otherwise
        defaultX = '';
        defaultY = '';
end

if isempty(cfg.xLabel), xLbl = defaultX; else, xLbl = cfg.xLabel; end
if isempty(cfg.yLabel), yLbl = defaultY; else, yLbl = cfg.yLabel; end

xlabel(xLbl, 'FontSize', fs, 'FontWeight', 'bold');
ylabel(yLbl, 'FontSize', fs, 'FontWeight', 'bold');

if cfg.xReverse
    set(gca, 'XDir', 'reverse');
else
    set(gca, 'XDir', 'normal');
end

set(gca, ...
    'FontSize',   fs, ...
    'LineWidth',  1.4, ...
    'TickDir',    'out', ...
    'TickLength', [0.015 0.015], ...
    'Layer',      'top');

set(gca, 'XMinorTick', 'on');
set(gca, 'YMinorTick', 'on');

legend('Location', 'best', 'Interpreter', 'none', 'Box', 'off');

end
