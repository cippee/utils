function files = load_spectra(cfg)
%LOAD_SPECTRA  Carica la lista dei file .dat dalla cartella dati.

files = dir(fullfile(cfg.dataFolder, '*.dat'));
if isempty(files)
    error('Nessun file .dat trovato in: %s', cfg.dataFolder);
end

end
