
%

%% get the directories to look in (looks in all sub directories)
dateStringVar = datestr(now, 'yyyymmddTHHMMSS');




materDirSet = {'E:\Data\Video\PHILLIP\PM0001\'};
for kkkk = 1:length(materDirSet)
try
    dAll = dirFinder(materDirSet{kkkk});%simple program but like it names---full program is below--one line
catch
    dAll = regexp(genpath(materDirSet),['[^;]*'],'match');
end
end





% % dAll = {...
% %     'D:\test2'...
% %     'D:\test'...
% %     };
clear saveNames
clear filelist_mp4
%% choose the pole positions and save the variables
for k = 1:numel(dAll)
    d = dAll{k};
    cd(d);
    if d(end) == '\' || d(end) == '/' %add a filesep if you need one
        %do nothing
    else
        d = [d,filesep];
    end
    filelist_mp4=dir([d '*.mp4']);
    if ~isempty(filelist_mp4)
        saveNames{k} = barTracker_SAH_mega;
    end
end
try
    nameToLoad = ['C:\Users\maire\Documents', filesep, 'saveNames_', dateStringVar]
save(['C:\Users\maire\Documents', filesep, 'saveNames_', dateStringVar]);
catch
end
%%%%%%%%%%% load(nameToLoad)
%% load vars and track poles

for k = 1:numel(dAll)
    d = dAll{k};
    cd(d);
    if d(end) == '\' || d(end) == '/' %add a filesep if you need one
        %do nothing
    else
        d = [d,filesep];
    end
    
    filelist_mp4=dir([d '*.mp4']);
    if ~isempty(filelist_mp4)
        barTracker_SAH_mega_part2(saveNames{k})
    end
end
%%


