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

%% ---- Read data -----------------------------------------------------------
% Auto-detect delimiter from extension: .csv -> comma, otherwise use cfg.delimiter.
% readmatrix is used directly to avoid detectImportOptions misidentifying the
% first data row as a column header.

[~, ~, ext] = fileparts(filename);

% For CSV files force comma; for everything else let readmatrix auto-detect
% the delimiter — more robust than passing ' ' explicitly for space-separated files.
if strcmpi(ext, '.csv')
    % Auto-detect comma vs semicolon (European locale) from the first line.
    fid = fopen(filename, 'r');
    firstLine = fgetl(fid);
    fclose(fid);
    if contains(firstLine, ';')
        csvDelim = ';';
    else
        csvDelim = ',';
    end
    rawData = readmatrix(filename, 'Delimiter', csvDelim, 'NumHeaderLines', headerLines);
else
    % CommentStyle '%' skips lines beginning with % (common in spectroscopy output).
    rawData = readmatrix(filename, 'NumHeaderLines', headerLines, 'CommentStyle', '%');
end
rawData = rawData(~any(isnan(rawData), 2), :);  % remove rows with NaN

%% ---- Extract columns -----------------------------------------------------

x = rawData(:, xColumn);
y = rawData(:, yColumn);

%% ---- Sort by x -----------------------------------------------------------

[x, idx] = sort(x);
y = y(idx);

%% ---- Normalize -----------------------------------------------------------

if normalizeSpectrum
    y = y ./ max(abs(y));
end

%% ---- Smooth --------------------------------------------------------------

if applySmoothing
    y = smoothdata(y, 'sgolay', smoothingWindow);
end

%% ---- Plot ----------------------------------------------------------------

[~, name, ~] = fileparts(filename);

plot(x, y, ...
    'LineWidth', lineWidth, ...
    'Color',     color, ...
    'DisplayName', name);

fprintf('Loaded: %s\n', filename);

end
