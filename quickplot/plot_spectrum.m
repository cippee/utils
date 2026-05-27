function plot_spectrum( ...
    filename, ...
    color, ...
    spectrumType, ...
    delimiter, ...
    headerLines, ...
    xColumn, ...
    yColumn, ...
    lineWidth, ...
    normalizeSpectrum, ...
    applySmoothing, ...
    smoothingWindow)

%% =========================
%  IMPORT OPTIONS
% ==========================

opts = detectImportOptions(filename);

opts.DataLines = [headerLines+1 Inf];
opts.Delimiter = delimiter;

%% =========================
%  READ FILE
% ==========================

T = readtable(filename, opts);

%% =========================
%  TABLE -> ARRAY
% ==========================

rawData = table2array(T);

% Conversione robusta se MATLAB legge testo
if iscell(rawData)

    rawData = cellfun(@str2double, rawData);

end

%% =========================
%  REMOVE INVALID ROWS
% ==========================

rawData = rawData(~any(isnan(rawData),2), :);

%% =========================
%  EXTRACT COLUMNS
% ==========================

x = rawData(:, xColumn);
y = rawData(:, yColumn);

%% =========================
%  SORTING
% ==========================

[x, idx] = sort(x);
y = y(idx);

%% =========================
%  NORMALIZATION
% ==========================

if normalizeSpectrum
    y = y ./ max(abs(y));
end

%% =========================
%  SMOOTHING
% ==========================

if applySmoothing
    y = smoothdata(y, 'sgolay', smoothingWindow);
end

%% =========================
%  PLOT
% ==========================

[~, name, ~] = fileparts(filename);

plot(x, y, ...
    'LineWidth', lineWidth, ...
    'Color', color, ...
    'DisplayName', name);

fprintf('Loaded: %s\n', filename);

end