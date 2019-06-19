function removingUnder4000FrameVidsAndOtherFiles2FUNC(materDirSet)
stopForTrouble = 1
%% search for base directory the removed under and over 4000 frame folders will be in this folder
nameStringToPlaceNewDir = 'PHILLIP';
%% WILL SEARCH EVERY FOLDER AND IN EVERY SUB DIRECTORY
% materDirSet = {...
%     'D:\Data\Video\PHILLIP\AH0976\190325(actuall 26th at midnight)\Camera_1'...
%     };
%% set the number of frames you want to keep (videos with this many frames ONLY will be kept in the OG directory the rest will be coppied to a mirror directory
numFrameVids2keep = 4000;
%% remove all the dirs with certain text in them (to not look in them) 
remDirWithText = {...
    'Than4000'...
    'deleteThese'...
    };
% %% turn off mmread error that says frame does not exist bcause we know this will be the case for most videos
% warning('off','mmread:general'); % only needed when using mmread dont use that anymore
%% get the directories
dAll = {};
for k = 1:numel(materDirSet)
    delim1 = ';';if filesep == '/'; delim1 = ':'; end% test if mac
    dAll1 = regexp(genpath(materDirSet{k}),['[^',delim1 ,']*'],'match');
    dAll = [dAll(:);  dAll1(:)];
end
%% remove all the dirs with certain text in them
for k = 1:length(remDirWithText)
    testDirName1 = strfind(dAll, remDirWithText{k});
    dAll = dAll(cellfun(@isempty, testDirName1));
end
%%
if isempty(dAll)
    warning('no directories after removing directories with key words')
end
%%

for k = 1:length(dAll)
    d = [dAll{k}, filesep];
    filelist_mp4=dir([d '*.mp4']);
    framesInVid = [];
    longerThan10 = [];
    for kk = 1:size(filelist_mp4, 1)
        disp(filelist_mp4(kk).name);
        tic
        try
            % first try with video reader it is faster, works with videos that
            % are originally AVIs output from stream pix and then converted to
            % MP4 IDK why this is but hey its nice!!!!
            vidObj = VideoReader([d, filelist_mp4(kk).name ]);
            %             framesInVid(kk) =vidObj.NumberOfFrames;
            framesInVid(kk) = round(vidObj.Duration .* vidObj.FrameRate);
            
            %             SizeVids(kk) = nansum([1, ((xyloOb.NumberOfFrames - numFrames) ./ abs(xyloOb.NumberOfFrames - numFrames))]);
            % 0 means less than set number 1  means is set number 2 means more than set number
        catch MES
            cmdStringP1 = 'ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 '; %%% leave space at end
            cmdStringP2 = ['"',d,filelist_mp4(kk).name,'"'];
            bytesString = [num2str(filelist_mp4(kk).bytes), ' bytes '];
            %                 cmdStringP2ENDfile = ['"',d,filelist_mp4(indexToUse(end)).name,'"'];
            commandFinal = [cmdStringP1 cmdStringP2];
            %                 commandFinalENDfile = [cmdStringP1 cmdStringP2ENDfile];
            if contains( MES.message, 'Error Creating Source')
                framesInVid(kk)  = nan;% bad video will make matlab crash if MMREAD trys to read it
            elseif contains(MES.message, 'Error Creating Source') || contains(MES.message, 'Failed to initialize')
                
                [status,numFrames] = system(commandFinal);
                framesInVid(kk) = str2num(numFrames);
            else
                for iter1 = 1:10
                    warning('UNKNOWN ERROR WITH VIDEO READER WILL TRY FFMPEG IF IT FAILS REMOVE THE FOLLOWING FILE MANUALLY')
                    disp(filelist_mp4(kk).name);
                end
                [status,numFrames] = system(commandFinal);
                framesInVid(kk) = str2num(numFrames);
            end
        end
        if toc >15
            disp(['File ', filelist_mp4(kk).name, ' had trouble loading and took longer than 10 sec']);
            if stopForTrouble == 1
                longerThan10(end+1) = kk;
            end
        end
    end
    %% all screwy files
    if ~isempty(longerThan10);
        tmp1 = struct2cell(filelist_mp4);
        tmp1= tmp1(1, :);
        allscrewyFiles = tmp1(longerThan10)
        save([dAll{k}, filesep, 'allscrewyFiles'], 'allscrewyFiles')
    end
    %% move the file into their respectve folders
    warning('off','MATLAB:MKDIR:DirectoryExists'); %turn off dir already exists warning
    filelist_mp4_cellALL = struct2cell(filelist_mp4);
    folderStringALL = {'LessThan4000','GreaterThan4000','deleteThese'}
    indexALL = {find(framesInVid < numFrameVids2keep), find(framesInVid > numFrameVids2keep), find(isnan(framesInVid))};
    for kkk = 1:length(folderStringALL)
        folderString = folderStringALL{kkk};
        filelist_mp4_cell =  filelist_mp4_cellALL(:, indexALL{kkk});
        slashLocations = strfind(d,'\');
        nameLoc = strfind(d,nameStringToPlaceNewDir);% + length(nameStringToPlaceNewDir)-1;
        newVar = find(slashLocations>nameLoc);
        slashToPlaceDir = slashLocations(newVar(1));
        newD = [d(1:slashToPlaceDir),folderString,filesep, d(slashToPlaceDir+1:end)];
        for kkkk = 1:size(filelist_mp4_cell, 2)
            mkdir(newD);
            filelist_mp4_cell2 = filelist_mp4_cell(:,kkkk);
            matchingFs = struct2cell(dir([filelist_mp4_cell2{2},...
                filesep, filelist_mp4_cell2{1}(1:strfind(filelist_mp4_cell2{1}, 'mp4') -1), '*']));
            for kkkkk = 1:size(matchingFs, 2)
                moveCommand = ['move ','"',matchingFs{2, kkkkk},filesep, matchingFs{1, kkkkk}  ,'"', ' ','"', newD,'"'];
                system(moveCommand);
            end
        end
    end
    warning('on','MATLAB:MKDIR:DirectoryExists'); %turn it back on
    
end



