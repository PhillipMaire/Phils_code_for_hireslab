%%
% dateString1 = datestr(now,'yymmdd_HHMM');
%%
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad')
save([dateString1  '_allCellsTouch'], 'allCellsTouch')
save([dateString1  '_pole'], 'pole')
save([dateString1  '_V'], 'V')
save([dateString1  '_Whisk'], 'Whisk')
save([dateString1  '_allWhiskingVar'], 'allWhiskingVar')

%

daNames = {...
    'poleSTD.m'...
    'plotmodindexandthesortedheatmapofnormalizedresponses.m'...
    'touchSTD.m'...
    'whiskingVariablesTuningWithMasksEqualBins_bootstrap_noAnova.m'...
    'simpleWhiskingModulation.m'...
    'spikerateVSdepth.m'...
    'protractionVSretraction'...
    }
allPrograms = {};
for k = 1:length(daNames)
allPrograms{k} = hibernatescript(daNames{k})
end

save([dateString1  '_allPrograms'], 'allPrograms')