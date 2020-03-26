%%
function [allOfFileType] = dirALL(startDir, stringIN)
%{
[allOfFileType] = dirALL('E:\Data\Video\PHILLIP\AH0688', '*.mp4')
used teh same as dir command except it searches in all subfolders of that
folder and all subfolders of those and so on.
%}
dirs = regexp(genpath(startDir),['[^;]*'],'match');
allOfFileType = struct;
for k = 1:length(dirs)
    tmp2 = dir([dirs{k}, filesep, stringIN]);
    if ~isempty(fieldnames(tmp2))
        if isempty(fieldnames(allOfFileType))
            allOfFileType = tmp2;
        else
            allOfFileType = [allOfFileType;tmp2];
        end
        tmp7 = regexp([allOfFileType.folder allOfFileType.name, ';'],['[^;]*'],'match');
        
    end
end
%{

toRec = dirALL('E:\Data\Video\PHILLIP\AH0688', '*.whiskers');
toRec2 = dirALL('E:\Data\Video\PHILLIP\AH0688', '*.measurements');


recycle









%}