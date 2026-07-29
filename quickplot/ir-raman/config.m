% Chiara Picarelli, DCMC - Politecnico di Milano
% chiara.picarelli@polimi.it
% https://github.com/cippee/utils
% May 2026
%

function cfg = config()
%CONFIG  All settings for the IR/Raman spectra plotting script.
%        Edit only this file.

%% ---- Data ----------------------------------------------------------------

cfg.dataFolder   = 'data';      % folder containing .dat / .txt / .csv files
cfg.delimiter    = ' ';         % column delimiter (ignored for .csv files)
cfg.headerLines  = 0;           % number of header lines to skip
cfg.xColumn      = 1;           % x-axis column index
cfg.yColumn      = 2;           % y-axis column index

%% ---- Spectrum type -------------------------------------------------------
%  'ir'    -> reversed x-axis, labels: Wavenumber / Absorbance
%  'raman' -> reversed x-axis, labels: Raman Shift / Intensity

cfg.spectrumType = 'ir';

%% ---- Preprocessing -------------------------------------------------------

cfg.normalizeSpectrum = false;  % normalize each spectrum to max(|y|)
cfg.applySmoothing    = false;  % apply Savitzky-Golay smoothing
cfg.smoothingWindow   = 7;      % smoothing window width (must be odd)

%% ---- Layout --------------------------------------------------------------
%  false -> all spectra overlaid on the same axes
%  true  -> one subplot per spectrum, stacked vertically

cfg.stackPlots = false;

%% ---- Appearance ----------------------------------------------------------

cfg.lineWidth = 2.2;
cfg.fontSize  = 16;

%% ---- Axis options --------------------------------------------------------

cfg.xReverse = true;    % true = reversed x-axis (standard for IR/Raman)
cfg.xLim     = [];      % e.g. [400 4000]  ([] = automatic)
cfg.yLim     = [];      % e.g. [0 1]       ([] = automatic)

%  '' = use default label from spectrumType; any other string overrides it
cfg.xLabel   = '';      % e.g. 'Wavenumber / cm^{-1}'
cfg.yLabel   = '';      % e.g. 'Absorbance (a.u.)'

%% ---- Colors --------------------------------------------------------------
%  'random'     -> random indices without repetition (default)
%  'sequential' -> follows palette order
%  'manual'     -> use indices in cfg.colorIndices
%                  e.g. cfg.colorIndices = [1 5 9] -> deep blue, emerald, burnt orange

cfg.colorMode    = 'random';
cfg.colorIndices = [];          % used only if colorMode = 'manual'

%% ---- Export --------------------------------------------------------------

cfg.saveFigure = false;
cfg.outputName = 'spectra.png';
cfg.outputDPI  = 600;

end
