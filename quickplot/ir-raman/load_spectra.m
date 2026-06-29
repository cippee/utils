function files = load_spectra(cfg)
%LOAD_SPECTRA  Carica la lista dei file .dat/.txt dalla cartella dati.

files = [dir(fullfile(cfg.dataFolder, '*.dat')); dir(fullfile(cfg.dataFolder, '*.txt'))];
if isempty(files)
    error('Nessun file .dat/.txt trovato in: %s', cfg.dataFolder);
end

end
