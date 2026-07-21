% Chiara Picarelli, DCMC - Politecnico di Milano
% chiara.picarelli@polimi.it
% https://github.com/cippee/utils
% June 2026
%

function files = load_spectra(cfg)
%LOAD_SPECTRA  Return the list of .dat / .txt / .csv files in the data folder.

files = [dir(fullfile(cfg.dataFolder, '*.dat')); ...
         dir(fullfile(cfg.dataFolder, '*.txt')); ...
         dir(fullfile(cfg.dataFolder, '*.csv'))];

if isempty(files)
    error('No .dat / .txt / .csv files found in: %s', cfg.dataFolder);
end

end
