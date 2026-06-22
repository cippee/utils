function [color, usedColors] = pick_color(pal, i, cfg, usedColors)
%PICK_COLOR  Seleziona il colore per la curva i-esima.
%
%   Modalità (cfg.colorMode):
%     'random'     - indice casuale senza ripetizioni
%     'sequential' - segue l'ordine della palette
%     'manual'     - usa gli indici in cfg.colorIndices

nColors = size(pal, 1);

switch cfg.colorMode

    case 'random'
        available = setdiff(1:nColors, usedColors);
        if isempty(available)
            available  = 1:nColors;     % ricomincia se palette esaurita
            usedColors = [];
        end
        idx        = available(randi(numel(available)));
        color      = pal(idx, :);
        usedColors = [usedColors, idx];

    case 'sequential'
        idx   = mod(i-1, nColors) + 1;
        color = pal(idx, :);

    case 'manual'
        if isempty(cfg.colorIndices)
            error('colorMode = manual ma cfg.colorIndices è vuoto.');
        end
        idx   = cfg.colorIndices(mod(i-1, numel(cfg.colorIndices)) + 1);
        color = pal(idx, :);

    otherwise
        error('colorMode non riconosciuto: %s', cfg.colorMode);

end

end
