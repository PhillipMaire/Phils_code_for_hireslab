%%
function measureFindMissedClass_specificFrames_simple2
%% find the frames that the program missclassifiedthat means that ther is no 0 whisker in the frame
%% also loooks at double frames which is u
%%
% this program assumes you have removed videos with less than 4000 frames
% it also assumes the same frame size for a single session, this is used to calculate the likelyhood that a whisker is not tracked
% during a frame because it it outside the camera view, this might lead to classifying a whisker that is not the main whisker athough
% this would be very unlikely if the video size is at all similar to the others (not like 2000*2000 vs 540*330 for example) and is near
% impossible if there are no other long whiskers in the video.
%%

whiskerNumber = 0; %set whisker number you are interested in
frameNumbers = (0:3999)';
clear errorCatch


%% get the directories with measurements files to run through
clear allDirsToRun
counter =0;
dateString = datestr(now,'yymmdd_HHMM');
materDirSet = {'D:\backup\Data\Video\PHILLIP'};

saveName = [materDirSet{1},filesep, 'measClassTestVars_', dateString];





fid = fopen( [materDirSet{1},filesep, 'classifyCorrectlyTest_', dateString, '.txt'], 'wt' );
fid2 = fopen( [materDirSet{1},filesep, 'classifyCorrectlyTestQuickLook_', dateString, '.txt'], 'wt' );
for kkkk = 1:length(materDirSet)
    dAll = regexp(genpath(materDirSet{kkkk}),['[^;]*'],'match');
    
    for k = 1:numel(dAll)
        currentDir = dAll{k};
        cd(currentDir);
        if currentDir(end) == '\' || currentDir(end) == '/'
            %do nothing
        else
            currentDir = [currentDir,filesep];%add a filesep if you need one
        end
        filelist_measurements = dir([currentDir '*.measurements']);
        if ~isempty(filelist_measurements)
            counter = counter +1;
            allDirsToRun{counter} = currentDir;
        end
    end
end
allDirsToRun = allDirsToRun'

%%
clear filelist_ALL test6
counter = 0 ;

%%

%% for progress bar information.. how many total files
disp('checking all directories to find all measurements files');
totalNumFiles = 0;
for k = 1: length(allDirsToRun)
    if ~isempty(allDirsToRun{k});
        cd(allDirsToRun{k});
        currentDir = allDirsToRun{k};
        filelist_measurements = dir([currentDir '*.measurements']);
        filelist_ALL2{k} = filelist_measurements;
        totalNumFiles = totalNumFiles + length(filelist_measurements);
    end
end
%% actual analysis part
for k = 1: length(allDirsToRun)
    clearvars -except saveName allDirsToRun counter currentDir dAll dateString errorCatch fid fid2 filelist_ALL2 filelist_measurements frameNumbers k kkkk materDirSet totalNumFiles whiskerNumber
    if ~isempty(allDirsToRun{k});
        cd(allDirsToRun{k});
        currentDir = allDirsToRun{k};
        filelist_measurements = dir([currentDir '*.measurements']);
        filelist_ALL{k} = filelist_measurements;
        mostRed = [];
        allRed = [];
        someMissed = [];
        if ~isempty(filelist_measurements)
            for kk = 1:length(filelist_measurements)
                if kk ==1
                    display(['processing directory ''', currentDir, ''' now, there are ', num2str(length(filelist_measurements)), ' files to process']);
                end
                counter = counter +1; %for progress bar
                fileNameM = filelist_measurements(kk).name;
                
                
                %%
                % % % % % % % % % % % % % % % %         fieldNamesM
                % % %         Columns 1 through 10
                % % %
                % % %     'fid'    'wid'    'label'    'face_x'    'face_y'    'length'    'score'    'angle'    'curvature'    'follicle_x'
                % % %
                % % %   Columns 11 through 13
                % % %
                % % %     'follicle_y'    'tip_x'    'tip_y'
                try
                    [measurmentMat, fieldNamesM, measurmentstruct] = loadMeasurementsMat(fileNameM);
                    %% make the mat easy to work with
                    
                    
                    
                    fidW = measurmentMat(:,1);
                    widW = measurmentMat(:,2);
                    labelW = measurmentMat(:,3);
                    face_xW = measurmentMat(:,4);
                    face_yW = measurmentMat(:,5);
                    lengthW = measurmentMat(:,6);
                    scoreW = measurmentMat(:,7);
                    angleW = measurmentMat(:,8);
                    curvatureW = measurmentMat(:,9);
                    follicel_xW = measurmentMat(:,10);
                    follicle_yW = measurmentMat(:,11);
                    tip_xW = measurmentMat(:,12);
                    tip_yW = measurmentMat(:,13);
                    
                    whiskerIndex = labelW == whiskerNumber;
                    classWhiskSingle = measurmentMat(whiskerIndex, :);
                    
                    allYellow(kk) = isempty(whiskerIndex);
                    allRedtmp = sum(whiskerIndex)/length(whiskerIndex);
                    mostRed(kk) = allRedtmp>=0.9;
                    allRed(kk) = allRedtmp ==1;
                    if allRed(kk) == 1 %% this just means it classified all whisker as the selected whisker
                        % so dont save the whole thing because it can get too big in
                        % stead put a NaN value there.
                        classWhiskALL{kk} = nan(1);
                    else
                        classWhiskALL{kk} = classWhiskSingle;
                    end
                    %% frames tracked (includes doubles and miss frames can be off becasue of miss frames and double frames (more than one 0 per frame)
                    % % % % %         framsTrackedAllFolders{kk, k} = sum(whiskerIndex);
                    %% get double tracked and missing frames
                    %input an array of 1's and 0's and it will sort through and get the double and missing frames
                    [missingFrames, indexDupFrames, dupFrames, atLeastOneFrameTracked, DubFrameNum_and_Count] = doubleAndMissing(whiskerIndex);
                    countMissingFramesALL(kk) = length(missingFrames);
                    missingFramesALL{kk} = missingFrames;
                    DubFrameNum_and_CountALL{kk} = DubFrameNum_and_Count;
                    atLeastOneFrameTrackedALL{kk} = atLeastOneFrameTracked;
                    someMissed(kk) =~isempty(missingFrames);
                    someDouble(kk) = ~isempty(dupFrames);
                    %% estimate if there is a good fit for the missed whisker
                    
                    % %         for j = 1:length(missingFrames) % j
                    % %             singleWhiskerMeasMat = measurmentMat(whiskerIndex,:);
                    % %             framenum = missingFrames(j) ;%framenum
                    % %             %%  find nearest frames with tracked whisker around frame number
                    % %             numFramesAround =  12  ;    %  %%%%set to get this many of the closest in time to the tracked whisker under the assumption
                    % %             %%%%that surrounding frames will be similar.
                    % %             diffMatAbs = abs(framenum-atLeastOneFrameTracked);
                    % %             [difMatAbsSort, DMASindex] = sort(diffMatAbs);
                    % %             framesAroundFrame = sort(atLeastOneFrameTracked(DMASindex(1:numFramesAround)));
                    % %             %% find features of surrounding frames
                    % %             framesAroundFrame = intersect(framesAroundFrame,atLeastOneFrameTracked );
                    % %             counter2 = 0;
                    % %             for findFrames = 1:length(framesAroundFrame)
                    % %                 if ~isempty(find(singleWhiskerMeasMat(:,1) == framesAroundFrame(findFrames)))
                    % %                     counter2 = counter2+1;
                    % %                     framesAroundFrame2(counter2) = find(singleWhiskerMeasMat(:,1) == framesAroundFrame(findFrames));
                    % %                 end
                    % %             end
                    % %             surroundingFeatures = singleWhiskerMeasMat(framesAroundFrame2,:);
                    % %
                    % %             %% find length around similar angles as most recent angle
                    % %             lengthTest(1) = mean(surroundingFeatures(:,6));
                    % %             lengthTest(2) = median(surroundingFeatures(:,6));
                    % %             %******** if min of length test times ).8 or some number, is larger than max of unclassifed whisker then move on the
                    % %             %correct whisker isnt correct
                    % %             %%%% actually only eliminate it if you are sure so maybe compare to the minimum then do the other test with angle and tip
                    % %             %%%% and stuff
                    % %             %% fing and compare the angle of the whiskers in question
                    % %
                    % %             %%
                    % %             %% get the missing frame info
                    % %             indexFrame = framenum == fidW;%index
                    % %             missingFrame = measurmentMat(indexFrame,:);      %trackedThisFrame
                    % %
                    % %
                    % %         end
                    % %
                    
                    %%
                catch errorMess
                    errorCatch(kk) = 1;
                    errorMessCell{kk} = errorMess;
                end
                errorCatch(kk) = 0;
                errorMessCell{kk} = 0;
                progressbarNESTED(counter/totalNumFiles);
            end
            % print in doc the following
            % dir
            % allRed count
            % most red count
            

            
            %%
            missStruct = struct([]);
            tmp_fileName = struct2cell(filelist_ALL{k});
            fileNamesInLoop = tmp_fileName(1,:);
            
            for k_miss = find(someMissed==1)%% run through only trials with miss
                missStruct(end+1).dir = currentDir;
                missStruct(end).fileName = fileNamesInLoop{k_miss};
                missStruct(end).numberMissed = countMissingFramesALL(k_miss);
                missStruct(end).missingFrameNums = missingFramesALL{k_miss};
                missStruct(end).measurmentMatForSelectedWhisker = classWhiskALL{k_miss};
                missStruct(end).allYellow = allYellow(k_miss);
                %%%% then idealy an angle of the last tracked frame for each of the
                %%%% missed frames. used to help rule out whiker going off camera
                %%%% vs the tracker actually screwing up the classification or
                %%%% whikser failing ot track becasue the video is shit.
            end
            %%
            doubleStruct = struct([]);
            % doubleStruct.dir = currentDir;
            for k_dub = find(someDouble==1)%% run through only trials with miss
                doubleStruct(end+1).dir = currentDir;
                doubleStruct(end).fileName = fileNamesInLoop{k_dub};
                doubleStruct(end).numberDouble = length(DubFrameNum_and_CountALL{k_dub}(:,1));
                doubleStruct(end).doubleFrameNums_and_Count = DubFrameNum_and_CountALL{k_dub};
                doubleStruct(end).measurmentMatForSelectedWhisker = classWhiskALL{k_dub};
                doubleStruct(end).allWhiskerRed = allRed(k_dub);
                doubleStruct(end).mostWhiskerRed = mostRed(k_dub);
                %%%% then idealy an angle of the last tracked frame for each of the
                %%%% missed frames. used to help rule out whiker going off camera
                %%%% vs the tracker actually screwing up the classification or
                %%%% whikser failing ot track becasue the video is shit.
            end
            errorStruct = struct([]);
            for k_err = find(errorCatch ==1)
                errorStruct(end+1).dir = currentDir;
                errorStruct(end).fileName = fileNamesInLoop{k_err};
                errorStruct(end).message = errorMessCell{k_err};
            end
            
            
            
            finalDirSaveName = [saveName, filesep];
            mkdir(finalDirSaveName);
            finalSaveName = [finalDirSaveName, fileNameM(1:13)];
            
            addNumLoop = 1;
            while exist([finalSaveName, '.mat'],'file') ==2
                addNumLoop = addNumLoop+1;
                if addNumLoop ==2
                    finalSaveName = [finalSaveName, '_', num2str(addNumLoop)];
                else
                    finalSaveName(end) =  num2str(addNumLoop);
                end
                
            end
            save(finalSaveName, 'doubleStruct', 'missStruct', 'errorStruct');
            
                        fprintf( fid, 'finalSave Name %s\ndirectory %s \nmean all red %s \nmean most red %s \nmean some missed %s \nall Whiskers Red %s \nmost whisker red %s \nsome missed frames %s\n\n\n####next\n\n\n', ...
                finalSaveName, allDirsToRun{k},num2str(mean(allRed)),num2str(mean(mostRed)),num2str(mean(someMissed)), num2str(allRed), num2str(mostRed), num2str(someMissed));
            
            fprintf( fid2, 'finalSave Name %s\ndirectory %s \nmean all red %s \nmean most red %s \nmean some missed %s \nall Whiskers Red %s \nmost whisker red %s \nsome missed frames %s\nTotal Files %s \n\n\n####next\n\n\n', ...
                finalSaveName, allDirsToRun{k},num2str(mean(allRed)),num2str(mean(mostRed)),num2str(mean(someMissed)), num2str(sum(allRed)), num2str(sum(mostRed)), num2str(sum(someMissed)), num2str(length(allRed)));
            
        end
    end
end

fclose(fid);
fclose(fid2);

% % % % % % % % % %
% % % % % % % % % % [~, NumFolders] = size(framsTrackedAllFolders);
% % % % % % % % % % emptieInds = find(cellfun(@isempty,framsTrackedAllFolders));
% % % % % % % % % % framsTrackedAllFolders(emptieInds) = {NaN};
% % % % % % % % % % framsTrackedAllFoldersMat = cell2mat(framsTrackedAllFolders);
% % % % % % % % % % finalList = cell(0,3);
% % % % % % % % % % for k = 1:NumFolders
% % % % % % % % % %     not4000 = (framsTrackedAllFoldersMat(:, k)~=4000).*(~isnan(framsTrackedAllFoldersMat(:, k)));
% % % % % % % % % %     not4000indLocal = find(not4000);
% % % % % % % % % %     if numel(not4000indLocal)>0
% % % % % % % % % %         for kk = 1:numel(not4000indLocal)
% % % % % % % % % %             fileName = filelist_ALL{k}(not4000indLocal(kk)).name;
% % % % % % % % % %             fullFileName = [allDirsToRun{k}, fileName];
% % % % % % % % % %             totalTrackedFrames = framsTrackedAllFoldersMat(not4000indLocal(kk), k);
% % % % % % % % % %             finalList{end+1, 1} = fileName;
% % % % % % % % % %             finalList{end, 2} = 4000 - totalTrackedFrames;
% % % % % % % % % %             finalList{end, 3} = fullFileName;
% % % % % % % % % %             finalList{end, 4} = allDirsToRun{k};
% % % % % % % % % %             finalList{end, 5} = numel(not4000indLocal);
% % % % % % % % % %             finalList{end, 6} = [finalList{end, 3}(1:end-12),'mp4'];
% % % % % % % % % %             finalList{end, 7} = [finalList{end, 3}(1:end-12),'whiskers'];
% % % % % % % % % %             %     finalList(ggg, 1)
% % % % % % % % % %         end
% % % % % % % % % %     end
% % % % % % % % % %
% % % % % % % % % % end
% prompt = 'save Variable?';
% saveON = input(prompt,'s')
% if strcmp(lower(saveON), 'yes') || lower(saveON) == 'y' || lower(saveON) == 1
%     prompt = 'paste the path of the variable or jsut the name to save on current path   ';
%     savePath = input(prompt,'s');
%     save(savePath, 'finalList')
% end
%% save final struct



%%
% % % % % % % % % % [saveName] = saveDatShit(dateString)
% % % % % % % % % %
% % % % % % % % % %     function [saveName] = saveDatShit(dateString)
% % % % % % % % % % %         directoryString = 'C:\Users\Public\Documents';
% % % % % % % % % % %         cd(directoryString);
% % % % % % % % % %         saveName = [materDirSet{1}, filesep, 'saveDatShit_', dateString];
% % % % % % % % % %         save(saveName, 'finalList')
% % % % % % % % % %     end
%%

    function [missingFrames, indexDupFrames, dupFrames, atLeastOneFrameTracked, DubFrameNum_and_Count] = doubleAndMissing(whiskerIndex)
        %% missingFrames = frames without selected whisker
        %% indexDupFrames = cell array with the indices of all frames determined to have at least one double frame
        %%                  it corresponds to dupFrames in terms of order
        %% dupFrames = all frames with 2 or more of the selected whisker tracked, use this to find out which frames
        %%              indexDupFrames correspond to.
        %% atLeastOneFrameTracked = frames with at least one trakced whisker that is the selected whisker.
        %% DubFrameNum_and_Count = for only double whisker frames, first column the frame number. second column
        %%                        is the number of whiskers that are classified as the selected whisker in that frame.
        %% look for double frames
        % whiskerIndex = all whiskers matching frame id
        fidSingle = fidW(whiskerIndex);
        % fidSingle = all frames with the selected whisker in it
        % firstUnique
        % indices to unique values in column 3
        [atLeastOneFrameTracked, firstUnique, ~] = unique(fidSingle);
        DubFrameNum_and_Count = atLeastOneFrameTracked;
        DubFrameNum_and_Count(1:length(atLeastOneFrameTracked), 2) = 1; %preset to one cause we know at least one is tracked
        for findDubs = 1: length(atLeastOneFrameTracked)
            if sum(fidSingle == fidSingle(firstUnique(findDubs))) >1 %only populate double frames
                DubFrameNum_and_Count(findDubs, 2) = sum(fidSingle == fidSingle(firstUnique(findDubs)));
            end
        end
        % DubFrameNum_and_Count first col frame number second colum number of selected whisker in that frame
        % duplicate indices
        
        % duplicate values
        doubleIndex = DubFrameNum_and_Count(:,2)>1;
        DubFrameNum_and_Count = DubFrameNum_and_Count(doubleIndex, :);
        dupFrames = DubFrameNum_and_Count(:,1);
        
        
        indexDupFrames = cell(0);
        for jjjjjjjj = 1: length(dupFrames)
            indexDupFrames{jjjjjjjj,1} = find(dupFrames(jjjjjjjj)==fidSingle);%###
        end
        
        %% look for missing frames
        missingFrames = setdiff(frameNumbers,fidSingle);
        
    end
%%
% finalList is the in order of columns
% 1 name of file
% 2 number of frames without a num 0 whisker in it (missed whiskers0
% 3 full directory of file
% 4 folder path
% 5 how many files have at lease one missing zero in that folder
% counttest = sum(cell2mat(framsTrackedAllFolders)~=4000)

%%%%%#(&^%*&^$*&$&^%$*8765(^%(*&^58&^%9%9*&^%
    function progressbarNESTED(varargin)
        % Description:
        %   progressbar() provides an indication of the progress of some task using
        % graphics and text. Calling progressbar repeatedly will update the figure and
        % automatically estimate the amount of time remaining.
        %   This implementation of progressbar is intended to be extremely simple to use
        % while providing a high quality user experience.
        %
        % Features:
        %   - Can add progressbar to existing m-files with a single line of code.
        %   - Supports multiple bars in one figure to show progress of nested loops.
        %   - Optional labels on bars.
        %   - Figure closes automatically when task is complete.
        %   - Only one figure can exist so old figures don't clutter the desktop.
        %   - Remaining time estimate is accurate even if the figure gets closed.
        %   - Minimal execution time. Won't slow down code.
        %   - Randomized color. When a programmer gets bored...
        %
        % Example Function Calls For Single Bar Usage:
        %   progressbar               % Initialize/reset
        %   progressbar(0)            % Initialize/reset
        %   progressbar('Label')      % Initialize/reset and label the bar
        %   progressbar(0.5)          % Update
        %   progressbar(1)            % Close
        %
        % Example Function Calls For Multi Bar Usage:
        %   progressbar(0, 0)         % Initialize/reset two bars
        %   progressbar('A', '')      % Initialize/reset two bars with one label
        %   progressbar('', 'B')      % Initialize/reset two bars with one label
        %   progressbar('A', 'B')     % Initialize/reset two bars with two labels
        %   progressbar(0.3)          % Update 1st bar
        %   progressbar(0.3, [])      % Update 1st bar
        %   progressbar([], 0.3)      % Update 2nd bar
        %   progressbar(0.7, 0.9)     % Update both bars
        %   progressbar(1)            % Close
        %   progressbar(1, [])        % Close
        %   progressbar(1, 0.4)       % Close
        %
        % Notes:
        %   For best results, call progressbar with all zero (or all string) inputs
        % before any processing. This sets the proper starting time reference to
        % calculate time remaining.
        %   Bar color is choosen randomly when the figure is created or reset. Clicking
        % the bar will cause a random color change.
        %
        % Demos:
        %     % Single bar
        %     m = 500;
        %     progressbar % Init single bar
        %     for i = 1:m
        %       pause(0.01) % Do something important
        %       progressbar(i/m) % Update progress bar
        %     end
        %
        %     % Simple multi bar (update one bar at a time)
        %     m = 4;
        %     n = 3;
        %     p = 100;
        %     progressbar(0,0,0) % Init 3 bars
        %     for i = 1:m
        %         progressbar([],0) % Reset 2nd bar
        %         for j = 1:n
        %             progressbar([],[],0) % Reset 3rd bar
        %             for k = 1:p
        %                 pause(0.01) % Do something important
        %                 progressbar([],[],k/p) % Update 3rd bar
        %             end
        %             progressbar([],j/n) % Update 2nd bar
        %         end
        %         progressbar(i/m) % Update 1st bar
        %     end
        %
        %     % Fancy multi bar (use labels and update all bars at once)
        %     m = 4;
        %     n = 3;
        %     p = 100;
        %     progressbar('Monte Carlo Trials','Simulation','Component') % Init 3 bars
        %     for i = 1:m
        %         for j = 1:n
        %             for k = 1:p
        %                 pause(0.01) % Do something important
        %                 % Update all bars
        %                 frac3 = k/p;
        %                 frac2 = ((j-1) + frac3) / n;
        %                 frac1 = ((i-1) + frac2) / m;
        %                 progressbar(frac1, frac2, frac3)
        %             end
        %         end
        %     end
        %
        % Author:
        %   Steve Hoelzer
        %
        % Revisions:
        % 2002-Feb-27   Created function
        % 2002-Mar-19   Updated title text order
        % 2002-Apr-11   Use floor instead of round for percentdone
        % 2002-Jun-06   Updated for speed using patch (Thanks to waitbar.m)
        % 2002-Jun-19   Choose random patch color when a new figure is created
        % 2002-Jun-24   Click on bar or axes to choose new random color
        % 2002-Jun-27   Calc time left, reset progress bar when fractiondone == 0
        % 2002-Jun-28   Remove extraText var, add position var
        % 2002-Jul-18   fractiondone input is optional
        % 2002-Jul-19   Allow position to specify screen coordinates
        % 2002-Jul-22   Clear vars used in color change callback routine
        % 2002-Jul-29   Position input is always specified in pixels
        % 2002-Sep-09   Change order of title bar text
        % 2003-Jun-13   Change 'min' to 'm' because of built in function 'min'
        % 2003-Sep-08   Use callback for changing color instead of string
        % 2003-Sep-10   Use persistent vars for speed, modify titlebarstr
        % 2003-Sep-25   Correct titlebarstr for 0% case
        % 2003-Nov-25   Clear all persistent vars when percentdone = 100
        % 2004-Jan-22   Cleaner reset process, don't create figure if percentdone = 100
        % 2004-Jan-27   Handle incorrect position input
        % 2004-Feb-16   Minimum time interval between updates
        % 2004-Apr-01   Cleaner process of enforcing minimum time interval
        % 2004-Oct-08   Seperate function for timeleftstr, expand to include days
        % 2004-Oct-20   Efficient if-else structure for sec2timestr
        % 2006-Sep-11   Width is a multiple of height (don't stretch on widescreens)
        % 2010-Sep-21   Major overhaul to support multiple bars and add labels
        %
        
        persistent progfig progdata lastupdate
        
        % Get inputs
        if nargin > 0
            input = varargin;
            ninput = nargin;
        else
            % If no inputs, init with a single bar
            input = {0};
            ninput = 1;
        end
        
        % If task completed, close figure and clear vars, then exit
        if input{1} == 1
            if ishandle(progfig)
                delete(progfig) % Close progress bar
            end
            clear progfig progdata lastupdate % Clear persistent vars
            drawnow
            return
        end
        
        % Init reset flag
        resetflag = false;
        
        % Set reset flag if first input is a string
        if ischar(input{1})
            resetflag = true;
        end
        
        % Set reset flag if all inputs are zero
        if input{1} == 0
            % If the quick check above passes, need to check all inputs
            if all([input{:}] == 0) && (length([input{:}]) == ninput)
                resetflag = true;
            end
        end
        
        % Set reset flag if more inputs than bars
        if ninput > length(progdata)
            resetflag = true;
        end
        
        % If reset needed, close figure and forget old data
        if resetflag
            if ishandle(progfig)
                delete(progfig) % Close progress bar
            end
            progfig = [];
            progdata = []; % Forget obsolete data
        end
        
        % Create new progress bar if needed
        if ishandle(progfig)
        else % This strange if-else works when progfig is empty (~ishandle() does not)
            
            % Define figure size and axes padding for the single bar case
            height = 0.03;
            width = height * 8;
            hpad = 0.02;
            vpad = 0.25;
            
            % Figure out how many bars to draw
            nbars = max(ninput, length(progdata));
            
            % Adjust figure size and axes padding for number of bars
            heightfactor = (1 - vpad) * nbars + vpad;
            height = height * heightfactor;
            vpad = vpad / heightfactor;
            
            % Initialize progress bar figure
            left = (1 - width) / 2;
            bottom = (1 - height) / 2;
            progfig = figure(...
                'Units', 'normalized',...
                'Position', [left bottom width height],...
                'NumberTitle', 'off',...
                'Resize', 'off',...
                'MenuBar', 'none' );
            
            % Initialize axes, patch, and text for each bar
            left = hpad;
            width = 1 - 2*hpad;
            vpadtotal = vpad * (nbars + 1);
            height = (1 - vpadtotal) / nbars;
            for ndx = 1:nbars
                % Create axes, patch, and text
                bottom = vpad + (vpad + height) * (nbars - ndx);
                progdata(ndx).progaxes = axes( ...
                    'Position', [left bottom width height], ...
                    'XLim', [0 1], ...
                    'YLim', [0 1], ...
                    'Box', 'on', ...
                    'ytick', [], ...
                    'xtick', [] );
                progdata(ndx).progpatch = patch( ...
                    'XData', [0 0 0 0], ...
                    'YData', [0 0 1 1] );
                progdata(ndx).progtext = text(0.99, 0.5, '', ...
                    'HorizontalAlignment', 'Right', ...
                    'FontUnits', 'Normalized', ...
                    'FontSize', 0.7 );
                progdata(ndx).proglabel = text(0.01, 0.5, '', ...
                    'HorizontalAlignment', 'Left', ...
                    'FontUnits', 'Normalized', ...
                    'FontSize', 0.7 );
                if ischar(input{ndx})
                    set(progdata(ndx).proglabel, 'String', input{ndx})
                    input{ndx} = 0;
                end
                
                % Set callbacks to change color on mouse click
                set(progdata(ndx).progaxes, 'ButtonDownFcn', {@changecolor, progdata(ndx).progpatch})
                set(progdata(ndx).progpatch, 'ButtonDownFcn', {@changecolor, progdata(ndx).progpatch})
                set(progdata(ndx).progtext, 'ButtonDownFcn', {@changecolor, progdata(ndx).progpatch})
                set(progdata(ndx).proglabel, 'ButtonDownFcn', {@changecolor, progdata(ndx).progpatch})
                
                % Pick a random color for this patch
                changecolor([], [], progdata(ndx).progpatch)
                
                % Set starting time reference
                if ~isfield(progdata(ndx), 'starttime') || isempty(progdata(ndx).starttime)
                    progdata(ndx).starttime = clock;
                end
            end
            
            % Set time of last update to ensure a redraw
            lastupdate = clock - 1;
            
        end
        
        % Process inputs and update state of progdata
        for ndx = 1:ninput
            if ~isempty(input{ndx})
                progdata(ndx).fractiondone = input{ndx};
                progdata(ndx).clock = clock;
            end
        end
        
        % Enforce a minimum time interval between graphics updates
        myclock = clock;
        if abs(myclock(6) - lastupdate(6)) < 0.01 % Could use etime() but this is faster
            return
        end
        
        % Update progress patch
        for ndx = 1:length(progdata)
            set(progdata(ndx).progpatch, 'XData', ...
                [0, progdata(ndx).fractiondone, progdata(ndx).fractiondone, 0])
        end
        
        % Update progress text if there is more than one bar
        if length(progdata) > 1
            for ndx = 1:length(progdata)
                set(progdata(ndx).progtext, 'String', ...
                    sprintf('%1d%%', floor(100*progdata(ndx).fractiondone)))
            end
        end
        
        % Update progress figure title bar
        if progdata(1).fractiondone > 0
            runtime = etime(progdata(1).clock, progdata(1).starttime);
            timeleft = runtime / progdata(1).fractiondone - runtime;
            timeleftstr = sec2timestr(timeleft);
            titlebarstr = sprintf('%2d%%    %s remaining', ...
                floor(100*progdata(1).fractiondone), timeleftstr);
        else
            titlebarstr = ' 0%';
        end
        set(progfig, 'Name', titlebarstr)
        
        % Force redraw to show changes
        drawnow
        
        % Record time of this update
        lastupdate = clock;
        
    end
% ------------------------------------------------------------------------------
    function changecolor(h, e, progpatch) %#ok<INUSL>
        % Change the color of the progress bar patch
        
        % Prevent color from being too dark or too light
        colormin = 1.5;
        colormax = 2.8;
        
        thiscolor = rand(1, 3);
        while (sum(thiscolor) < colormin) || (sum(thiscolor) > colormax)
            thiscolor = rand(1, 3);
        end
        
        set(progpatch, 'FaceColor', thiscolor)
        
    end
% ------------------------------------------------------------------------------
    function timestr = sec2timestr(sec)
        % Convert a time measurement from seconds into a human readable string.
        
        % Convert seconds to other units
        w = floor(sec/604800); % Weeks
        sec = sec - w*604800;
        d = floor(sec/86400); % Days
        sec = sec - d*86400;
        h = floor(sec/3600); % Hours
        sec = sec - h*3600;
        m = floor(sec/60); % Minutes
        sec = sec - m*60;
        s = floor(sec); % Seconds
        
        % Create time string
        if w > 0
            if w > 9
                timestr = sprintf('%d week', w);
            else
                timestr = sprintf('%d week, %d day', w, d);
            end
        elseif d > 0
            if d > 9
                timestr = sprintf('%d day', d);
            else
                timestr = sprintf('%d day, %d hr', d, h);
            end
        elseif h > 0
            if h > 9
                timestr = sprintf('%d hr', h);
            else
                timestr = sprintf('%d hr, %d min', h, m);
            end
        elseif m > 0
            if m > 9
                timestr = sprintf('%d min', m);
            else
                timestr = sprintf('%d min, %d sec', m, s);
            end
        else
            timestr = sprintf('%d sec', s);
        end
        
        
    end
%%%%%#(&^%*&^$*&$&^%$*8765(^%(*&^58&^%9%9*&^%


end


