function apply_style(cfg)
%APPLY_STYLE  Applica label, direzione assi, tick e legenda alla figura corrente.

fs = cfg.fontSize;

switch lower(cfg.spectrumType)

    case 'ir'
        xlabel('Wavenumber / cm^{-1}', 'FontSize', fs, 'FontWeight', 'bold');
        ylabel('Absorbance (a.u.)',     'FontSize', fs, 'FontWeight', 'bold');

    case 'raman'
        xlabel('Raman Shift / cm^{-1}', 'FontSize', fs, 'FontWeight', 'bold');
        ylabel('Intensity (a.u.)',       'FontSize', fs, 'FontWeight', 'bold');

end

set(gca, 'XDir', 'reverse');

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
