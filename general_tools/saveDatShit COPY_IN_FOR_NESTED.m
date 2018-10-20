[saveName] = saveDatShit
function [saveName] = saveDatShit
directoryString = 'C:\Users\Public\Documents';
cd(directoryString);
dateString = datestr(now,'yymmdd_HHMMSS');
saveName = [directoryString, filesep, 'saveDatShit_', dateString];
save(saveName)
end