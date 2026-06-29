function cfg = config()
%CONFIG  Tutte le impostazioni dello script di plotting spettri UV-Vis.
%        Modifica solo questo file.

%% ---- Dati ---------------------------------------------------------------

cfg.dataFolder   = 'data';          % cartella con i .dat
cfg.delimiter    = ' ';             % delimitatore colonne
cfg.headerLines  = 0;               % righe di header da saltare
cfg.xColumn      = 1;               % colonna asse x
cfg.yColumn      = 2;               % colonna asse y

%% ---- Tipo di spettro ----------------------------------------------------
%  'uv-abs'   -> x non invertito, label Wavelength / Absorbance
%  'uv-molar' -> x non invertito, label Wavelength / Molar absorptivity

cfg.spectrumType = 'uv-abs';

%% ---- Preprocessing ------------------------------------------------------

cfg.normalizeSpectrum = true;       % normalizza su max(|y|)
cfg.applySmoothing    = false;      % Savitzky-Golay smoothing
cfg.smoothingWindow   = 7;          % finestra smoothing (dispari)

%% ---- Layout --------------------------------------------------------------
%  false -> tutti gli spettri sovrapposti sugli stessi assi
%  true  -> un subplot per spettro, impilati verticalmente

cfg.stackPlots = false;

%% ---- Grafica ------------------------------------------------------------

cfg.lineWidth = 2.2;
cfg.fontSize  = 16;

%% ---- Asse X ---------------------------------------------------------------
%  [] -> automatico, altrimenti [xmin xmax], es. [200 800]

cfg.xLim = [];

%% ---- Colori -------------------------------------------------------------
%  'random'     -> indici casuali senza ripetizioni (default)
%  'sequential' -> segue l'ordine della palette (come prima)
%  'manual'     -> usa gli indici in cfg.colorIndices
%                  es. cfg.colorIndices = [1 5 9] -> deep blue, emerald, burnt orange

cfg.colorMode    = 'random';
cfg.colorIndices = [];              % usato solo se colorMode = 'manual'

%% ---- Export -------------------------------------------------------------

cfg.saveFigure = false;
cfg.outputName = 'spectra.png';
cfg.outputDPI  = 600;

end
