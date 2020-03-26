
%

%% get the directories to look in (looks in all sub directories)
dateStringVar = datestr(now, 'yyyymmddTHHMMSS');



dAll = {};
materDirSet = {...
    'X:\Video\PHILLIP\AH0927\190324\Camera_1'...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    ''...
    };

%%
for kkkk = 1:length(materDirSet)
    
    tmp = regexp(genpath(materDirSet{kkkk}),['[^;]*'],'match');
    
    dAll(end+1:end+length(tmp), 1) = tmp(:);
end
for k = 1:length(dAll)
    
end
dAll

%
% tmp1 = []
% ind1 = find(tmp1==0)
% dAll = Book1(ind1)
% % dAll = {...
% %     'D:\test2'...
% %     'D:\test'...
% %     };
clear saveNames
clear filelist_mp4

%%
saveNames = {};
for k = 1:numel(dAll)
    k
    d = dAll{k};
    %     d = d{1};
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
% try
%     nameToLoad = ['C:\Users\maire\Documents', filesep, 'saveNames_', dateStringVar]
%     save(['C:\Users\maire\Documents', filesep, 'saveNames_', dateStringVar]);
% catch
% end
%%%%%%%%%%% load(nameToLoad)
%% load vars and track poles
%  pause(60*60*2.2)


% first remove 4000 frame videos
% trackDatShitPhil190402
%%

tic
removingUnder4000FrameVidsAndOtherFiles2FUNC(materDirSet)
toc
%

% suggest to run this and below at the saem time that way you can jsut walk away;
%

%

failedTest = [];
for k = 1:numel(dAll)
    k
    
    %     try
    d = dAll{k};
    %         d = d{1};
    cd(d);
    if d(end) == '\' || d(end) == '/' %add a filesep if you need one
        %do nothing
    else
        d = [d, filesep];
        
    end
    
    
    
    
    filelist_mp4=dir([d '*.mp4'])
    
    
    if ~isempty(filelist_mp4)
        
        %             barTracker_SAH_mega_part2(saveNames{k}, d, skipFilesThatExist)
        barTracker_SAH_mega_part2('', d, false)
        
    end
    %     catch
    %         failedTest(end+1) = k ;
    %     end
end

%% load bar files and find ones that are not correct and correc them using linear regression of motor positions with tracked positions

for k = 1:numel(dAll)
    k
    
    %     try
    d = [dAll{k}, filesep];
    %         d = d{1};
    cd(d);
    
end
%%
removeAllFilesThatDontMatchTrials(input1 , input2)
% valid input examples are like these below...
% filelist_measurements=dir([d '*.measurements']);
% filelist_whiskers=dir([d '*.whiskers']);
% filelist_mp4=dir([d '*.mp4']);
% filelist_bar=dir([d '*.bar']);
% one for each input
% should look something like below
% removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.measurements']))
% removeAllFilesThatDontMatchTrials(dir([d '*.mp4']), dir([d '*.whiskers']))
