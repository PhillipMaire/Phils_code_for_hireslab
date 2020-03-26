%%
function [dirs] = dirFinder(startDir)
dirs = regexp(genpath(startDir),['[^;]*'],'match');
end

%{
startDir = 'E:\Data\Video\PHILLIP';
dirs = regexp(genpath(startDir),['[^;]*'],'match');





allSEQs = {}
for k = 1:length(dirs)
tmp1 = dir([dirs{k}, filesep, '*.seq'])
allSEQs

end




%}

