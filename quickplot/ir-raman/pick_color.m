function [color, usedColors] = pick_color(pal, i, cfg, usedColors)
%PICK_COLOR  Select the color for the i-th curve.
%
%   Modes (cfg.colorMode):
%     'random'     - random index without repetition
%     'sequential' - follows palette order
%     'manual'     - uses indices in cfg.colorIndices

nColors = size(pal, 1);

switch cfg.colorMode

    case 'random'
        available = setdiff(1:nColors, usedColors);
        if isempty(available)
            available  = 1:nColors;     % restart if palette is exhausted
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
            error('colorMode = manual but cfg.colorIndices is empty.');
        end
        idx   = cfg.colorIndices(mod(i-1, numel(cfg.colorIndices)) + 1);
        color = pal(idx, :);

    otherwise
        error('Unrecognized colorMode: %s', cfg.colorMode);

end

end
