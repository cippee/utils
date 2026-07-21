% Chiara Picarelli, DCMC - Politecnico di Milano
% chiara.picarelli@polimi.it
% https://github.com/cippee/utils
% May 2026
%

function apply_style(cfg)
%APPLY_STYLE  Set axis labels, direction, ticks, and legend on the current axes.

fs = cfg.fontSize;

switch lower(cfg.spectrumType)

    case 'uv-abs'
        xlabel('Wavelength / nm',   'FontSize', fs, 'FontWeight', 'bold');
        ylabel('Absorbance (a.u.)', 'FontSize', fs, 'FontWeight', 'bold');

    case 'uv-molar'
        xlabel('Wavelength / nm',           'FontSize', fs, 'FontWeight', 'bold');
        ylabel('\epsilon / M^{-1} cm^{-1}', 'FontSize', fs, 'FontWeight', 'bold');

end

set(gca, 'XDir', 'normal');

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
