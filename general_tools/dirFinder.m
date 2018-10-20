%%
function [dirs] = dirFinder(startDir)
dirs = regexp(genpath(startDir),['[^;]*'],'match');
end