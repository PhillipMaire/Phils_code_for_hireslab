%% you need to have to Download FFmpeg and put it in cmd path (see site instalation)
%% for this program to work

%%%%%%%% HAD TO TYPE THE BELOW TO GET THE SYSTEM COMMAND WORKING WITH
%%%%%%%% FFMPEG
%%%%%
%     setenv('PATH', [getenv('PATH') 'PATH=C:\Program Files\MATLAB\R2017a\bin\win64;path\to\C:\ffmpeg\bin;C:\ffmpeg-20180213-474194a-win64-static\bin;C:\ProgramData\Oracle\Java\javapath;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\MATLAB\R2017a\bin;C:\Program Files\WhiskerTracking\bin;C:\Program Files\MATLAB\R2013b\bin;C:\Program Files\Git\cmd;C:\Program Files (x86)\QuickTime\QTSystem\;C:\Program Files (x86)\Plantronics\Spokes3G\;C:\Users\maire\AppData\Local\GitHubDesktop\bin;C:\Users\maire\AppData\Local\GitHubDesktop\bin;c:\ffmpeg\binC:\ffmpeg-20180213-474194a-win64-static\bin'])
% DONT TYPE THIS THIS IS THE PATH --> PATH=C:\Program Files\MATLAB\R2017a\bin\win64;path\to\C:\ffmpeg\bin;C:\ffmpeg-20180213-474194a-win64-static\bin;C:\ProgramData\Oracle\Java\javapath;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files\MATLAB\R2017a\bin;C:\Program Files\WhiskerTracking\bin;C:\Program Files\MATLAB\R2013b\bin;C:\Program Files\Git\cmd;C:\Program Files (x86)\QuickTime\QTSystem\;C:\Program Files (x86)\Plantronics\Spokes3G\;C:\Users\maire\AppData\Local\GitHubDesktop\bin;C:\Users\maire\AppData\Local\GitHubDesktop\bin;c:\ffmpeg\binC:\ffmpeg-20180213-474194a-win64-static\bin


%% LOOKS IN ALL SUB DIRECTORIES!!!!!!!!!!!!!!!!


%% SETTINGS
nameStringToPlaceNewDir = 'PHILLIP';
sepSuspiciousFilesOut = 0; %if set to 1 will move files that are less 4000
%frames but smaller size than the largest video that is NOT 4000 frames, a
%lot of the time these videos will have weird movement or the light wasnt
%on or something similar making them useless... if set to 1 (on) then go
%and check these videos and put them back if you want them.

UserInputThreshold = 9999999999; % this variabe sets another variable below
%   SETBELOW -->      thresholdNum4000Vids %some files are 4000 but
%   smaller in size compared to the videos less than 4000 frames, this
%   waits until this many videos are discovered with 4000 frames before it
%   stops and decides that the rest are 4000 (or more)

SaveNameAddEnd = '....'; %for the saved variables for suspicious videos

%% ---------------

%WILL SEARCH EVERY FOLDER IN AN SUB DIRECTORY
% materDirSet = {'E:\', 'L:\AH0718\', 'J:\Animals\PM0001\'};
% materDirSet = {'E:\AH0718\18021\'};
materDirSet = {...
    'Y:\Whiskernas\Data\Video\PHILLIP\AH0987'...
    'Y:\Whiskernas\Data\Video\PHILLIP\AH0928'...
    };



clear allSuspiciousMP4s
allSuspiciousMP4s = cell(0,2);
for kkkk = 1:numel(materDirSet)
% % % % % %     try
% % % % % %         dAll = dirFinder(materDirSet{kkkk});%simple program but like it names---full program is below--one line
% % % % % %     catch
        dAll = regexp(genpath(materDirSet{kkkk}),['[^;]*'],'match');
% % % % % %     end
    %     dAll = {'E:\GreaterThan4000\PM0001\180129'}
    % dAll= {...
    %     'Z:\Data\Video\PHILLIP\AH0714\170921\',...
    %     'Z:\Data\Video\PHILLIP\AH0714\170922\',...
    %     'Z:\Data\Video\PHILLIP\AH0705\171106\',...
    %     'Z:\Data\Video\PHILLIP\AH0705\171107\'};
    
    
    for kkk =1:2 %smaller and larger files
        if kkk ==1
            folderString = 'LessThan4000\';
        elseif kkk==2
            folderString = 'GreaterThan4000\';
        end
        
        % % dAll= {'Z:\Data\Video\PHILLIP\AH0706\171101\'};
        
        for kk = 1: numel(dAll)
            
            d = dAll{kk};
            testDirName1 = strfind(d, 'LessThan4000');
            testDirName2 = strfind(d, 'GreaterThan4000');
            if isempty(testDirName1) && isempty(testDirName1)
                display(['Looking in ', d, '   ','for files ', folderString(1:end-1)]);
                if d(end) == '\' || d(end) == '/' %add a filesep if you need one
                    %do nothing
                else
                    d= [d,filesep];
                end
                cd(d)
                % % % % % % [status,cmdout] = system(['cd ', d])
                
                filelist_measurements=dir([d '*.measurements']);
                filelist_whiskers=dir([d '*.whiskers']);
                filelist_mp4=dir([d '*.mp4']);
                
                %%% bytes are in different spots for different versions of
                %%% matlab, have to index that location
                cellIndex = strfind(fieldnames(filelist_mp4), 'bytes');
                index = false(1, numel(cellIndex));
                for k = 1:numel(cellIndex)
                    if isempty(cellIndex{k})
                    else
                        index(k) = (cellIndex{k} == 1);
                    end
                end
                byteLocation = find(index);
                
                
                filelist_mp4_cell = struct2cell(filelist_mp4);
                filelist_mp4_mat = cell2mat(filelist_mp4_cell(byteLocation,:)); %so can be sorted by size
                [sortedBytes, indexSmall2Large] = sort(filelist_mp4_mat);
                indexLarge2Small = fliplr(indexSmall2Large);
                filelist_measurements_cell = struct2cell(filelist_measurements);
                filelist_whiskers_cell = struct2cell(filelist_whiskers);
                
                breakTest = 0;
                numFrames ='0';
                counter = 0 ;
                counterOf4000 = 0;
                indexToUse = 1; %just set temp to be greater than coun.gets set below
                allFrameNumbers = 0; %create empty array for storing all frame numbers
                thresholdNum4000Vids = UserInputThreshold;
                % so use this to find multiple 4000 frame videos in a row and
                if length(filelist_mp4_mat) < thresholdNum4000Vids  &&  length(filelist_mp4_mat)>1
                    thresholdNum4000Vids =  size(filelist_mp4_cell, 2);
                    display(['          autoset threshold length to ', num2str(thresholdNum4000Vids), ' because set threshold exceeds number of videos']);
                end
                % discount the rest before them.
                if ~isempty(filelist_mp4_cell)
                    while counterOf4000 <= thresholdNum4000Vids && counter <= numel(indexToUse) && breakTest == 0
                        if kkk ==1 %for removing small files
                            indexToUse = indexSmall2Large;
                            sortedBytes = sortedBytes;
                        elseif kkk==2 %for removing large files
                            indexToUse = indexLarge2Small;
                            sortedBytes = sortedBytes;
                        end
                        for k = indexToUse
                            
                            counter = counter +1;
                            if counter > numel(indexToUse)
                                breakTest = 1;
                                break
                            end
                            
                            cmdStringP1 = 'ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 '; %%% leave space at end
                            cmdStringP2 = ['"',d,filelist_mp4(k).name,'"'];
                            bytesString = [num2str(filelist_mp4(k).bytes), ' bytes '];
                            cmdStringP2ENDfile = ['"',d,filelist_mp4(indexToUse(end)).name,'"'];
                            commandFinal = [cmdStringP1 cmdStringP2];
                            commandFinalENDfile = [cmdStringP1 cmdStringP2ENDfile];
                            
                            [status,numFrames] = system(commandFinal);
                            framesNumber = str2num(numFrames);
                            allFrameNumbers(counter) = framesNumber;
                            if counter == 1
                                [~, no4000vidTest] = system(commandFinalENDfile);
                                if kkk == 1
                                    if str2num(no4000vidTest)<4000 || framesNumber>4000 %if the largest files is less than 4000 OR the smallest files is greater than 4000 skip everything
                                        breakTest = 1;
                                        display('                    No 4000 frame videos... skipping');
                                        break
                                    end
                                elseif kkk == 2
                                    if str2num(no4000vidTest)>4000 || framesNumber<4000 %
                                        breakTest = 1;
                                        display('                    No 4000 frame videos... skipping');
                                        break
                                    end
                                end
                            end
                            
                            
                            if framesNumber == 4000;
                                counterOf4000 = counterOf4000 +1;
                                if counterOf4000 >= thresholdNum4000Vids % doesnt always count videos correctly
                                    breakTest = 1;
                                    break
                                end
                            end
                            display(['                    ', bytesString ,numFrames(1:end-1), ' frames for file ', cmdStringP2]);
                            
                        end
                        
                        if str2num(no4000vidTest)<4000 && kkk == 1
                            display('                    largest MP4 is less than 4000... skipping');
                            break
                        elseif str2num(no4000vidTest)>4000 && kkk == 2
                            display('                    smallest MP4 is greater than 4000... skipping');
                            break
                        end
                        counter = counter +1; %get out of the while loop in case every MP4 was looked over.
                    end
                    
                    indexNOT4000 = find(allFrameNumbers ~= 4000);
                    if isempty(indexNOT4000)
                        largestBadVid = 0;
                    else
                        largestBadVid = indexNOT4000(end);
                    end
                    suspiciousVids = setdiff((1:largestBadVid)', indexNOT4000);%videos containing
                    %4000 frames but are smaller than the ones that are smaller
                    %than the ones under 4000 frames
                    
                    
                    % % % % % %                 largestBadVid= counter-1;
                    
                    %%%%%%%got the number of the largest bad video (less than 400 frames
                    %%%%%%%now have to remove the others by copyng them
                    if largestBadVid>0
                        %only run if files are less than 4000 and if the directory actual has a file with 4000 frames
                        AllIndex= zeros(3, largestBadVid);%allocate mem. have the location of all 3 file types (whisker mp4 and measure)
                        AllIndex(1,:) = indexToUse(1:largestBadVid); %set the locations of the mp4 files
                        for k = 1:largestBadVid
                            mp4FileName = filelist_mp4(indexToUse(k)).name; %get file name
                            baseFileName = mp4FileName(1:end-3);%filename with dot but no file type for getting files with same name but different ending (i.g. .whisker files)
                            
                            %Find the measure file (most of the time the files
                            %line up but not always this is why this is needed
                            indexCellW = strfind(filelist_whiskers_cell(1,:), baseFileName); % a 1 where this file is located
                            indexWhiskers = find(not(cellfun('isempty', indexCellW)));%fileName location in filelist_whiskers_cell
                            if ~isempty(indexWhiskers)
                                AllIndex(2,k) = indexWhiskers;%if it doesnt exist set the index to blank
                                %important becasue otherwise it will be out of
                                %order
                            end
                            %Find the measure file (most of the time the files
                            %line up but not always this is why this is needed
                            indexCellM = strfind(filelist_measurements_cell(1,:), baseFileName);% a 1 where this file is located
                            indexMeasures = find(not(cellfun('isempty', indexCellM)));%fileName location in filelist_measurements_cell
                            if ~isempty(indexMeasures)
                                AllIndex(3,k) = indexMeasures;%if it doesnt exist set the index to blank
                                %important becasue otherwise it will be out of
                                %order
                            end
                        end
                        %% transfer not 4000 frame vids to their locations
                        countIndex = 0;
                        numBadVids = numel(indexNOT4000);
                        for k = indexNOT4000 %only grab the small videos
                            %there are a few in there that are smaller but
                            %actually have 4000 frames... well deal with these later
                            countIndex = countIndex +1;
                            AllIndexNOT4000(:,countIndex) = AllIndex(:,k);
                        end
                        clear allFile
                        for k = 1:numBadVids % get all files to be moves to a new folder
                            allFile(k) = strcat(d, filelist_mp4_cell(1,AllIndexNOT4000(1,k),1));
                            if AllIndexNOT4000(2,k)~=0
                                allFile(k+numBadVids) = strcat(d, filelist_whiskers_cell(1,AllIndexNOT4000(2,k),1));
                            end
                            if AllIndexNOT4000(3,k)~=0
                                allFile(k+numBadVids*2) = strcat(d, filelist_measurements_cell(1,AllIndexNOT4000(3,k),1));
                            end
                        end
                        
                        slashLocations = strfind(d,'\');
                        nameLoc = strfind(d,nameStringToPlaceNewDir);% + length(nameStringToPlaceNewDir)-1;
                        newVar = find(slashLocations>nameLoc);
                        slashToPlaceDir = slashLocations(newVar(1));
                        
                        
                        newD = [d(1:slashToPlaceDir),folderString,d(slashToPlaceDir+1:end)];
                        mkdir(newD);
                        display(['Moving ', num2str(numel(allFile)), ' files that are less than 4000 frames to...']);
                        display(['     ', newD]);
                        for k = 1:numel(allFile)
                            moveCommand = ['move ','"',allFile{k} ,'"', ' ','"', newD,'"'];
                            system(moveCommand);
                        end
                        %% transfer suspecious vids to their location
                        
                        countIndex = 0;
                        suspiciousVids = suspiciousVids';
                        numSuspiciousVids = numel(suspiciousVids);
                        if numSuspiciousVids > 0
                            clear allFile
                            for k = suspiciousVids %only grab the small videos
                                %there are a few in there that are smaller but
                                %actually have 4000 frames... well deal with these later
                                countIndex = countIndex +1;
                                AllIndexSUSPICIOUS4000(:,countIndex) = AllIndex(:,k);
                            end
                            clear allFile
                            clear suspiciousBytes
                            for k = 1:numSuspiciousVids % get all files to be moves to a new folder
                                allFile(k) = strcat(d, filelist_mp4_cell(1,AllIndexSUSPICIOUS4000(1,k),1));
                                suspiciousBytes(k) = filelist_mp4(AllIndexSUSPICIOUS4000(1,k)).bytes;
                                if AllIndexSUSPICIOUS4000(2,k)~=0
                                    allFile(k+numSuspiciousVids) = strcat(d, filelist_whiskers_cell(1,AllIndexSUSPICIOUS4000(2,k),1));
                                end
                                if AllIndexSUSPICIOUS4000(3,k)~=0
                                    allFile(k+numSuspiciousVids*2) = strcat(d, filelist_measurements_cell(1,AllIndexSUSPICIOUS4000(3,k),1));
                                end
                            end
                            
                            slashLocations = strfind(d,'\');
                            slashToPlaceDir = slashLocations(end-2);
                            
                            if sepSuspiciousFilesOut ==1 %%% only run is user wants
                                newD = [d(1:slashToPlaceDir),'suspiciouslySmall4000frames\',d(slashToPlaceDir+1:end)];
                                mkdir(newD);
                                display(['Moving ', num2str(numel(allFile)), ' files that are 4000 frame but small in size to...']);
                                display(['     ', newD]);
                                for k = 1:numel(allFile)
                                    moveCommand = ['move ',allFile{k} , ' ', newD];
                                    system(moveCommand);
                                end
                            else    %otherwise create a list for user to look at
                                allSuspiciousMP4s(end+1:end+numSuspiciousVids,1) = allFile(1:numSuspiciousVids);
                                for iter = 1: length(suspiciousBytes)
                                    allSuspiciousMP4s{end-iter+1, 2} = suspiciousBytes(end-iter+1);
                                end
                            end
                        end
                    end
                    
                    %%%section for giving proper report on what happened
                    if largestBadVid == 0 && ~(str2num(no4000vidTest)<4000)
                        display('                    GREAT! Smallest video is 4000 frames already.');
                    end
                    
                else
                    display('                    no MP4''s in this folder... skipping');
                end
            end
        end
    end
    display(['DONE ', num2str(kkkk), ' of ' num2str(numel(materDirSet))]);
    
end
allSuspiciousMP4s;
%%

try
    saveName = ['C:\Users\maire\Documents\allSuspMP4s',  datestr(now, 'yyyymmddTHHMMSS'), '_', SaveNameAddEnd];
catch
    saveName = ['C:\Users\maire\Documents\allSuspMP4s',  datestr(now, 'yyyymmddTHHMMSS')];
end
save(saveName, 'allSuspiciousMP4s');







