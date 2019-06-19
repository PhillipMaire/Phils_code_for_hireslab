function trackDatShitPhil190505(varargin)
%% this programs needs to have ffmpeg installed and uses a program called MPARALLEL
% pretty sure we dont use MParallel at all anymore
% TRACKING_QUE_WITH_STATS- queues up different directories for tracking assignments
% The spiritual sucessor to whiskerQueue
% USER CAN JUST RUN PROGRAM AND WILL BE PROMPTED THIS PROGRAM ONLY NEEDS
% =========================================================================
% ADJUSTABLE SETTINGS
% =========================================================================
% testing if you have ffmpeg
[status,result] = system('ffmpeg');
if ~isempty(strfind(result, 'not recognized'))
    error('you need to install FFMPEG on this PC first and make sure matlab can route commands to it using system command. then put ffmpeg in matlabs working directory.then restart matlab and cmp prompt. See this mat file for further instructions')
    % %  Installing FFmpeg in Windows
    % % Download a static build from here.
    % % Use 7-Zip to unpack it in the folder of your choice.
    % % Open a command prompt with administrator's rights.
    % % NOTE: Use CMD.exe, do not use Powershell! The syntax for accessing environment variables is different from the command shown in Step 4 - running it in Powershell will overwrite your System PATH with a bad value.
    % % Run the command (see note below; in Win7 and Win10, you might want to use the Environmental Variables area of the Windows Control Panel to update PATH):
    % % only replace the path\to\ffmpeg\bin part below leave the paths alone. both cmd primt and matlab need to be restarted befire
    % % FFMPEG will work. 
    % % setx /M PATH "path\to\ffmpeg\bin;%PATH%"
    % % Do not run setx if you have more than 1024 characters in your system PATH variable. See this post on SuperUser that discusses alternatives. Be sure to alter the command so that path\to reflects the folder path from your root to ffmpeg\bin.
    % % (Here's another explanation with pictures.)
end
% TRACKING PARAMETERS -----------------------------------------------------
videoQuality = 3;
% videoQuality = 2 quality is really good quality and mostly not needed. it could be
% useful to use this high quality of the video is blurry and you need to
% maximize the tracking if it is bad or something
% whisker videos on rig1 (extracellular rig) has
% video size of abou 70, 000 kb for videoQuality = 2;
% most of the time video quality of 3 is fine and about the same size as
% the MP4s converted the old way (~30, 000 kb)
NUMBER_OF_WHISKERS = 1;
PIXEL_DENSITY = 0.033;
FACE_LOCATION = 'top';
deleteMP4ifExist = true; %will delete any mp4s that are being converted and overwrite(random mp4s will not be affected)
DISPLAY_STATISTICS = true;
% CONVERT_ALL_VIDEOS = false;
%NOTE IF YOU DELETE ALL MEASURE WHISKER DEFAULT PARAMS AND DETECTOR BANK IF
%YOU RUN THIS PROGRAM, IF YOU ARE CONVERITNG VIDEO IT WILL DELETE MP4S THAT
%HAVE THE SAME NAME AS THE THE NEW MP4
if nargin==0
NUMBER_OF_RESERVED_CORES = 0;
elseif nargin ==1
    NUMBER_OF_RESERVED_CORES = varargin{1};
else 
    error('to many inputs')
end
USE_ERROR_CHECK = false;
OVERWRITE_MP4S = false;
%%% this is the key word used to skip over tracking for some mp4s this just
%%% chooses which boxes to auto check user can check whatever she wants.
keywordUncheck = {...
    'nano'...
    };
keywordRemoveDir = {...
    'LessThan4000'...
    'GreaterThan4000'...
    'removedExtraFiles'...
    'test'...
    };
% % % % % % % searchInAllOfTheseDirs = 'L:\';
% % % % % % % letterDriveForEndDir = 'L';
%% directory here OOOOORRRRRRRR
% % DIRECTORY LIST ----------------------------------------------------------
% %Directory to find files to convert or track >>>
% startDirList = {...
%     'C:\Users\shires\Desktop\testConversion\testPhil2';...
%     'C:\Users\shires\Desktop\testConversion\testPhil';...
%     };
% %Directory to send tracked files >>>
% endDirList = {...
%     'C:\Users\shires\Desktop\testConversion\testPhil2';...
%     'C:\Users\shires\Desktop\testConversion\testPhil';...
%     };
% % VIDEO CONVERSION LIST ---------------------------------------------------
% %If you want to selective convert, fill this out in same order as directories:
% %Make sure to set CONVERT_ALL_VIDEOS to false to use this function >>>

%% directory here NOT BOTH THOUGH

% searchInAllOfTheseDirs = 'Q:\needToTrack'

searchInAllOfTheseDirs = uigetdir('C', 'SELECT MASTER FOLDER WITH ALL SEQ YOU WANT TO CONVERT');
letterDriveForEndDir = searchInAllOfTheseDirs;
% letterDriveForEndDir =  uigetdir(searchInAllOfTheseDirs, 'SELECT MASTER FOLDER TO PLACE FILES (YOU CAN CHOOSE THE SAME FOLDER)');
[startDirList, endDirList, trackMP4dirs, convertSEQdirs] = getAllDirWithSeq_NESTED315496874654184...
    (searchInAllOfTheseDirs, letterDriveForEndDir);


% % % currentDir = pwd;
% % % cd(searchInAllOfTheseDirs);
% % %
% % % fid2 = fopen('END_DIR.txt','wt');
% % %
% % %  fprintf(fid2,
% % %      cd(currentDir)

%%
% =========================================================================
% Queue settings should only be changed above this line
% =========================================================================

if exist('MParallel.exe','file') == 0
    error('''MParallel.exe'' not found in directory please add to matlab directory')
end



%TRACKING STARTS HERE!
allFileClock = tic;
sumFiles = 0;
sumTrackTime = 0;
sumConversionTime = 0;
sumCopyTime = 0;
for iterAllFiles = 1:length(startDirList)
    %     if CONVERT_ALL_VIDEOS == true
    %         [copyTime, trackTime, convertTime, totalFiles] = start_whisker_tracking_NESTED51648512(...
    %             startDirList{iterAllFiles}, endDirList{iterAllFiles}, true, PIXEL_DENSITY, NUMBER_OF_WHISKERS, ...
    %             FACE_LOCATION, NUMBER_OF_RESERVED_CORES, USE_ERROR_CHECK);
    %     else
    
    trackMP4dirs = logical(trackMP4dirs);
    convertSEQdirs =logical(convertSEQdirs);
    [copyTime, trackTime, convertTime, totalFiles] = start_whisker_tracking_NESTED51648512(...
        startDirList{iterAllFiles}, endDirList{iterAllFiles}, convertSEQdirs(iterAllFiles), PIXEL_DENSITY, NUMBER_OF_WHISKERS, ...
        FACE_LOCATION, NUMBER_OF_RESERVED_CORES, USE_ERROR_CHECK, trackMP4dirs(iterAllFiles));
    %     end
    % save text file with info on tracking
    fid = fopen('TIME_INFO.txt','wt');
    fprintf(fid,...
        '%s\n%s\n\n','start directory',startDirList{iterAllFiles},...
        'end directory',   endDirList{iterAllFiles},...
        'total files', num2str(totalFiles),...
        'conversion time', num2str(convertTime/60),...
        'average conversion time per file', num2str(convertTime/(60*totalFiles)),...
        'track time', num2str(trackTime/60),...
        'average track time per file', num2str(trackTime/(60*totalFiles)),...
        'copy time', num2str(copyTime/60),...
        'average copy time per file', num2str(copyTime/(60*totalFiles)),...
        'total time', num2str((copyTime+trackTime+convertTime)/60),...
        'average total time per file', num2str((copyTime+trackTime+convertTime)/(60*totalFiles)),...
        'ALL TIMES ARE IN MINUTES')
    fclose(fid);
    
    
    
    sumFiles = sumFiles + totalFiles;
    sumTrackTime = sumTrackTime + trackTime;
    sumConversionTime = sumConversionTime + convertTime;
    sumCopyTime = sumCopyTime + copyTime;
end

% =========================================================================
% TRACKING STATISTICS
% =========================================================================
if DISPLAY_STATISTICS == true
    allFileTime = toc(allFileClock);
    totalHours = floor(allFileTime/3600);
    extraMinutes = floor(rem(allFileTime,3600)/60);
    extraSeconds = rem(rem(allFileTime,3600),60);
    %Some more math
    convPct = 100*(sumConversionTime/allFileTime);
    trackPct = 100*(sumTrackTime/allFileTime);
    timePerFile = allFileTime/sumFiles;
    %Display stats
    fprintf('Tracking statistics: \n')
    fprintf('Total time: %.00f hours %.00f minutes %.02f seconds \n', ...
        totalHours, extraMinutes, extraSeconds)
    fprintf('Of this time: \n')
    fprintf('Video conversion took %.02f seconds or %.02f percent of the total time \n', sumConversionTime, convPct)
    fprintf('Whisker tracking took %.02f seconds or %.02f percent of the total time \n', sumTrackTime, trackPct)
    fprintf('You tracked a total of %.00f files with an average time of %.02f seconds per file \n', sumFiles, timePerFile)
    fprintf('Aaaaaaaaaaaaand we''re done! \n')
    
end


%% ##end of main program

    function [copyTime, trackTime, convertTime, totalFiles] = start_whisker_tracking_NESTED51648512(varargin)
        convertTime = 0;
        % START_WHISKER_TRACKING An improved version of the mp4 converter and Janelia farm whisker tracking script
        % START_WHISKER_TRACKING(STARTDIR, ENDDIR) specifies location of current files and where to send them, defaults to working directory
        % START_WHISKER_TRACKING(STARTDIR, ENDDIR, CONVERTVIDEO) CONVERTVIDEO = 1 will convert seq -> mp4, = 0 will skip conversion
        % START_WHISKER_TRACKING(STARTDIR, ENDDIR, CONVERTVIDEO, WHISKERNUM, PIXDEN) Adjust whisker number or pixel density as appropriate
        % START_WHISKER_TRACKING(STARTDIR, ENDDIR, CONVERTVIDEO, WHISKERNUM, PIXDEN, TRANSFERVIDEO) TRANSFERVIDEO = 1 copies files to end directory, =0 will not copy
        
        %% CHANGE LOG -----------------------------------------------------------
        
        %  Change                            Date            Editor
        % -----------------------------------------------------------------
        %  Initial Script                   2014-12-13      J. Sy
        %  Variation for Jon                2017-10-06      J. Cheung
        %  Added mp4 converter selector     2017-10-13      J. Sy
        %  Function name change             2017-12-13      J. Sy
        %  Added new parameters             2017-12-15      J. Sy
        
        
        %% SECTION 1: INPUT HANDLING -------------------------------------------
        %Default Settings:
        startDir = pwd;
        endDir = pwd;
        convertVideo = 0; %mp4 converter will run
        whiskerNum = 1; %Default number of whiskers is 1
        pixDen = 0.033; %This is the default pixel density
        faceSide = 'top';
        transferVideo = true; %Default to transfering to end directory
        reservedCores = 0; %Standard is to not reserve any cores for parallel
        errorCheck = false; %Default to not performin JK error check
        
        if nargin == 0
            fprintf('Function called empty, setting all parameters to default')
            fprintf('Everything will be processed in the current directory')
        else
            %Handle variable argument processing in subfunction so all the code people don't care about can be at the top
            [startDir, endDir, convertVideo, pixDen, whiskerNum, faceSide, reservedCores, errorCheck, tracON] = varInputHandler(varargin);
        end
        %If startDir and endDir are the same, don't transfer Video
        if strcmp(startDir, endDir)
            transferVideo = false;
        end
        numCores = feature('numcores'); %identify number of cores available for MATLAB to use
        numCores = numCores - reservedCores;
        
        cd(startDir)
        
        %% SECTION 2: CONVERT .SEQ TO .MP4 --------------------------------------
        mp4List = dir([startDir filesep '*mp4']);
        seqList = dir([startDir filesep '*seq']);
        dateString = datestr(now, 'yymmdd_HHMM');
        save([dateString, '_seqListAndInfoForAligning'], 'seqList')
        if convertVideo == 1
            if isempty(seqList)
                error('There are no SEQ files in the directory: %c', startDir)
            end
            %See if all the mp4s already exist
            if length(mp4List) == length(seqList) && OVERWRITE_MP4S ~= true
                Q = input(['You appear to have already converted these .seq files to .mp4s. \n' ...
                    'Enter 0 to skip conversion. Enter 1 to create different mp4s. Enter 2 to overwrite old .mp4s ']);
                switch Q
                    case 0
                        convertVideoReally = 0;
                    case 1
                        convertVideoReally = 1;
                    case 2
                        Q2 = input('Are you absolutely sure you want to delete the old mp4s and replace them? [Y/N] ');
                        if strcmpi(Q2, 'y')
                            system(['rm' startDir filesep '*.mp4']);
                        else
                            convertVideoReally = 1;
                        end
                    otherwise
                        fprintf('Input statement invalid, mp4 conversion will not occur \n')
                end
            else
                convertVideoReally = 1;
            end
%             %See if any .mp4s exist
%             if ~isempty(mp4List)
%                 warning('Some MP4 files already exist in this directory, this may cause issues in conversion later')
%             end
            %Run converter
            convertVideoReally = 1;
            if convertVideoReally == 1
                tic
                fprintf('STARTING MP4 CONVERSION OF %s \n', startDir)
                p = gcp('nocreate'); % If no pool, do not create new one.
                %                 if isempty(p)
                %                     poolsize = 0;
                %                 else
                %                     poolsize = p.NumWorkers;
                %                 end
                %                 if poolsize ~= numCores
                %                     delete(gcp('nocreate'));
                %                     parpool(numCores);
                %                 end
                norpix_seq_reader_jsy_NESTED321865468546(seqList, startDir);
                
                
                %% convert the mp4s using FFmpeg so that they read 0-3999 on whiski and not 0-7998
                
                %                 disp('FINISHED CONVERTING TO AVI');
                convertTime = toc;
                fprintf('FINISHED MP4 CONVERSION \n')
                %                 convertTime = toc;
            else
                convertTime = 0;
            end
        else
            fprintf('Skipping video conversion in %s \n', startDir)
        end
        
        %% SECTION 3: TRACK MP4 FILES WITH JANELIA TRACKER ----------------------
        if tracON ==1
            mp4List = dir([startDir filesep '*mp4']);
            if isempty(mp4List)
                error('There are no MP4 files to track in the directory: %s', startDir)
            end
            tic;
            fprintf('STARTING WHISKER TRACKING OF %s \n', startDir)
            makeDefaultParamsFile_NESTED156361856977761; %Nested function that creates the default params file from
            whisker_tracker_true_parallel_nested6485464888159(pixDen, whiskerNum, faceSide, numCores, errorCheck)
        end
        %%
        % % %         if exist([startDir filesep 'default.parameters'],'file') == 2
        % % %             whisker_tracker_true_parallel_nested6485464888159(pixDen, whiskerNum, faceSide, numCores, errorCheck) % Uses 'classify' for multiple whisker tracking.
        % % %         else %outdated becasue there will always be a default params file copied to the
        % % %             try
        % % %                 system('copy C:\Users\shires\Documents\GitHub\jkWhisker\default.parameters startDir');
        % % %             catch
        % % %                 try
        % % %                     system('copy Z:\default.parameters startDir');
        % % %                     whisker_tracker_true_parallel_nested6485464888159(pixDen, whiskerNum, faceSide, numCores, errorCheck)
        % % %                 catch
        % % %                     warning('No default.parameters')
        % % %                     proceedQ = input(['No default.parameters file found, do you want to have '...
        % % %                         'the tracker autogenerate one that might be incorrect [Y/N]']);
        % % %                     if strcmpi(proceedQ, 'y')
        % % %                         whisker_tracker_true_parallel_nested6485464888159(pixDen, whiskerNum, faceSide, numCores, errorCheck)
        % % %                     else
        % % %                         error('Cannot proceed, no default.parameters file')
        % % %                     end
        % % %                 end
        % % %             end
        % % %         end
        disp('FINISHED TRACKING \n')
        trackTime = toc;
        
        
        nf_mp4 = length(dir('*.mp4'));
        nf_whiskers = length(dir('*.whiskers'));
        nf_measurements = length(dir('*.measurements'));
        %         if nf_mp4 ~= nf_whiskers || nf_mp4 ~= nf_measurements
        %             error('Number of files do not match')
        %         end
        totalFiles = nf_whiskers;
        
        %% SECTION 4: COPY FILES ------------------------------------------------
        copyTime = 0;
        if transferVideo == 1
            tic;
            system(['copy ', startDir, '\*.mp4 ', endDir]);
            system(['copy ', startDir, '\*.whiskers ', endDir]);
            system(['copy ', startDir, '\*.measurements ', endDir]);
            system(['copy ', startDir, '\default.parameters ', endDir]);
            system(['copy ', startDir, '\*.detectorbank ', endDir]);
            system(['copy ', startDir, '\*.txt ', endDir]);
            copyTime = toc;
        end
    end


%% ------------------------------------------------------------------------------
%And here is a subfunction to handle the varargin stuff because most people don't want to see this
    function [startDir, endDir, convertVideo, whiskerNum, pixDen, faceSide, rCores, eCheck, tracON] = varInputHandler(vInputs)
        %Defaults
        inputN = length(vInputs);
        startDir = pwd;
        endDir = pwd;
        convertVideo = 1; %mp4 converter will run
        whiskerNum = 1; %Default number of whiskers is 1
        pixDen = 0.033; %This is the default pixel density
        rCores = 0; %Standard is to not reserve any cores for parallel
        eCheck = false; %Default to not performin JK error check
        faceSide = 'top'; %Default to top side
        
        %PARAMETER 1: Where to find files
        if inputN >= 1 %Change start directory
            %Empty call
            if strcmpi(vInputs{1},'')
                %Change NOTHING
            else
                %Check if actually a directory
                if ischar(vInputs{1})
                    startDir = vInputs{1};
                else
                    error('Directory name must be string')
                end
                %Check if exist
                if exist(vInputs{1},'dir') ~= 7
                    error('Cannot find input directory %c', vInputs{1})
                end
            end
        end
        %PARAMETER 2: Where to transfer files
        if inputN >= 2 %Change end directory
            %Empty call
            if strcmp(vInputs{2},'')
                %Change NOTHING
            else
                %Check if actually a directory
                if ischar(vInputs{2})
                    endDir = vInputs{2};
                else
                    error('Directory name must be string')
                end
                %Check if exist
                if exist(vInputs{2},'dir') ~= 7
                    error('Cannot find output directory %c', vInputs{2})
                end
            end
        end
        %PARAMETER 3: Do we need to convert SEQs?
        if inputN >= 3
            if vInputs{3} == 1 || strcmpi(vInputs{3},'true')
                convertVideo = 1;
            elseif vInputs{3} == 0 || strcmpi(vInputs{3},'false')
                convertVideo = 0;
            else
                fprintf('Improper entry for video parameter, defaulting to convertVideo = TRUE')
            end
        end
        %PARAMETER 4: Number of whiskers to track
        if inputN >= 4
            if vInputs{4} == 0 || strcmp(vInputs{4},'')
                %Do nothing
            else
                whiskerNum = vInputs{4};
            end
        end
        %PARAMETER 5: Pixel density
        if inputN >= 5
            if vInputs{5} == 0 || strcmp(vInputs{5},'')
                %Do nothing
            else
                pixDen = vInputs{5};
            end
        end
        %PARAMETER 6: Where is the face in the image?
        if inputN >= 6
            if ischar(vInputs{6})
                faceSide = vInputs{6};
            else
                warning('Invalid face side input, defaulting to "top"')
            end
        end
        %PARAMETER 7: Should we save any CPU cores for non-tracking?
        if inputN >= 7
            if isnumeric(vInputs{7})
                rCores = vInputs{7};
            end
        end
        %PARAMETER 8: Whether or not to perform Jinho's error check (the check will not be parallel)
        if inputN >= 8
            switch vInputs{8}
                case 1
                    eCheck = true;
                case 0
                    eCheck = false;
                otherwise
                    warning('Invalid error check input, defaulting to false')
            end
        end
        if inputN >= 9
            if isnumeric(vInputs{7})
                tracON = vInputs{9};
            end
        end
        %EXTRA PARAMETERS
        if inputN > 9
            fprintf('You called this function with too many variables, ignoring extras')
        end
    end


%%%%%%%%%% program 2 start


    function [] = norpix_seq_reader_jsy_NESTED321865468546(seqList, startDir)
        disp('STARTING CONVERSION, you wont see much for awhile... relax');
        for iter1ParForCoversion = 1:length(seqList)
            seqIn = seqList(iter1ParForCoversion).name;
            messageName = ['converting ', num2str(iter1ParForCoversion),' of ', num2str(length(seqList)),' ', seqIn];
            disp(messageName);
            
            
            
            %Open file
            seqID = fopen(seqIn);
            
            %Read important header information
            fseek(seqID, 548, 'bof');
            iWidth = fread(seqID, [1], 'ulong');
            iHeight = fread(seqID, [1], 'ulong');
            iBitDepth = fread(seqID, [1], 'ulong');
            iRBitDepth = fread(seqID, [1], 'ulong'); %Discard, useless
            iSize = fread(seqID, [1], 'ulong');
            fseek(seqID, 580, 'bof');
            iTrueSize = fread(seqID, [1], 'ulong');
            
            %Perform sanity checks
            if (iWidth*iHeight) ~= iSize
                error('Nonsensical image size')
            end
            
            %Create mp4 name
            [~,seqName,~] = fileparts(seqIn);
            mp4Name = [seqName ''];
            
            %Create and open mp4 file
            newVid = VideoWriter(mp4Name, 'Uncompressed AVI');
            %             newVid.Quality = 100;
            open(newVid)
            
            %Jump to first frame
            fseek(seqID, 8192, 'bof');
            frameNum = 0;
            
            %Begin frame extraction and writing loop
            finishedWriting = 0;
            while finishedWriting == 0
                %Read frame from seq
                validPos = fseek(seqID, 8192+iTrueSize*frameNum, 'bof');
                if validPos == -1
                    break
                end
                currentFrame = fread(seqID, [iWidth,iHeight], 'uint8');
                [checkW, checkH] = size(currentFrame);
                if currentFrame == -1
                    break
                elseif checkW ~= iWidth
                    break
                elseif checkH ~= iHeight
                    break
                end
                currentFrame = rot90(currentFrame, -1);
                currentFrame = fliplr(currentFrame);
                %Scale range to be between 0 and 1
                scaleVal = max(max(currentFrame));
                currentFrame = currentFrame/scaleVal;
                
                writeVideo(newVid, currentFrame)
                
                frameNum = frameNum + 1;
            end
            close(newVid)
            fclose(seqID);
            %%%%#######################
            aviName = [mp4Name, '.avi'];
            
            endFileName = [startDir, filesep, mp4Name, '.mp4'];
            while ~isempty(strfind(endFileName, '\\'))
                endFileName(strfind(endFileName, '\\')) = '';
            end
            commandFinal =  ['ffmpeg -i "', [startDir, filesep, aviName],...
                '" -c:v mpeg4 -qscale:v ',num2str(videoQuality) ,' -c:a libmp3lame -qscale:a 1 "',...
                endFileName, '"'];
            while ~isempty(strfind(commandFinal, '\\'))
                % replace double slashes
                commandFinal(strfind(commandFinal, '\\')) = '';
            end
            if deleteMP4ifExist == false
                %dont run this keep old mp4
            elseif   exist(endFileName, 'file') ~= 0 && deleteMP4ifExist == true
                delete(endFileName);
                [cmdOUT,messageName] = system(commandFinal);
            else %if video doesnt exist and we do want to convert it
                [cmdOUT,messageName] = system(commandFinal);
            end
            if cmdOUT ~=0
                warning('ffmpeg system command did not work ther is no MP4 of this file')
                keyboard
            end
            delete(aviName)
        end
    end

%%%%%%START PROGRAM 3


% WHISKER_TRACKER_TRUE_PARALLEL(PIXDEN, WHISKERNUM, FACE, VIDEOTYPE, MPARALLEL)
%performs parallel processing on video files using the Janelia Farm whisker
%tracker.

%% Change Log
% Change                             Editor            Date
%-------------------------------------------------------------------------------
% Initial creation                   J. Sy             2014-08-04
% Initial edits                      S.A. Hires        2014-08-04
% Added error-check                  J. Kim            2017-09-18
% Changed directory recognition      J. Cheung         2017-09-27
% Parallelization w/ MParallel       J. Sy             2017-12-13
% Function renaming and options      J. Sy             2017-12-15

% Notes ------------------------------------------------------------------------
%In theory, sections 3 (CLASSIFY) and 3.5 (CLASSIFY-SINGLE-WHISKER) should
%not be in use at the same time, since they do the same thing
% Created by SAH and JS, 2014-08-04


    function [traceTime, totalTime] = whisker_tracker_true_parallel_nested6485464888159(varargin)
        %% (0) SET PARAMETERS: set parameters based on inputs
        totalTStart = tic;
        
        % DEFAULTS
        pixDen = 0.33;
        whiskerNum = 1;
        vidType = '.mp4';
        faceSide = 'top';
        numCores = feature('numcores'); %Number of cores to run on, by default, all of them
        errorCheck = false;
        
        %Reset inputs
        if nargin == 5
            pixDen = varargin{1};
            whiskerNum = varargin{2};
            faceSide = varargin{3};
            numCores = varargin{4};
            errorCheck = varargin{5};
        end
        
%         Find MParallel
        if exist('MParallel.exe','file') == 2
            %MParallel is already on the path. Yay!
            mpPath = which('MParallel.exe');
        else
            try
                %See if we can get MParallel from the NAS
                system('copy Z:\Software\WhiskerTracking\MParallel.exe startDir');
                mpPath = which('MParallel.exe');
            catch
                error('Cannot find MParallel.exe on the path')
            end
        end
        %% if tracing again have to delete the detector banks
        toDelete = dir('*detectorbank');
        if ~isempty(toDelete)
            display('Deleting the detector bank so that the trace step works correctly');
            for kk = 1:length(toDelete)
                delete(toDelete(kk).name);
            end
        end
        %% delete whisker and meas files
        toDelete = dir('*whiskers');
        if ~isempty(toDelete)
            display('Deleting the whiskers so that the trace step works correctly');
            for kk = 1:length(toDelete)
                delete(toDelete(kk).name);
            end
        end
        toDelete = dir('*measurements');
        if ~isempty(toDelete)
            display('Deleting the measurements so that the trace step works correctly');
            for kk = 1:length(toDelete)
                delete(toDelete(kk).name);
            end
        end
        %% (1) TRACE: Uses Janelia Farm's whisker tracking software to track all whiskers in a directory
        traceTStart = tic;
        tracecmd = sprintf(['dir /b *%s | %s --count=%.00f --shell --stdin'...
            ' --pattern="trace {{0}} {{0:N}}.whiskers"'], vidType, mpPath, numCores);
        system(tracecmd);
        traceTime = toc(traceTStart);
        
        %% (2) MEASURE: Generates measurements of traced shapes for later evaluation
        measurecmd = sprintf(['dir /b *.whiskers | %s --count=%.00f --shell --stdin'...
            ' --pattern="measure --face %s {{0}} {{0:N}}.measurements"'], mpPath, numCores, faceSide);
        system(measurecmd);
        
        %% (2)-1 Error check and re-do the analysis (2017/09/18 JK)
        if errorCheck == true
            mp4_flist = dir(['*' vidType]);
            mp4_list = zeros(length(mp4_flist),1);
            for i = 1 : length(mp4_flist)
                mp4_list(i) = str2double(strtok(mp4_flist(i).name,'.')); % assume that all filenames are integers
            end
            whiskers_flist = dir('*.whiskers');
            whiskers_list = zeros(length(whiskers_flist),1);
            for i = 1 : length(whiskers_flist)
                whiskers_list(i) = str2double(strtok(whiskers_flist(i).name,'.'));
            end
            measure_flist = dir('*.measurements');
            measure_list = zeros(length(measure_flist),1);
            for i = 1 : length(measure_flist)
                measure_list(i) = str2double(strtok(measure_flist(i).name,'.'));
            end
            if length(measure_flist) < length(mp4_flist)
                % 1) re-trace those failed to trace before
                if length(whiskers_flist) < length(mp4_flist)
                    trace_errorlist = setdiff(mp4_list,whiskers_list);
                    for i = 1 : length(trace_errorlist)
                        temp_fname = num2str(trace_errorlist(i));
                        sout = system(['trace ' temp_fname vidType ' ' temp_fname]);
                        trial_ind = 0;
                        while (sout ~= 0 && trial_ind < 3)
                            sout = system(['trace ' temp_fname vidType ' ' temp_fname]);
                            trial_ind = trial_ind + 1;
                        end
                        if sout == 0
                            disp([temp_fname vidType ' traced successfully'])
                        else
                            disp(['Failed to trace ' temp_fname])
                        end
                    end
                end
                % 2) re-measure
                
                measure_errorlist = setdiff(mp4_list,measure_list);
                for i = 1 : length(measure_errorlist)
                    temp_fname = num2str(measure_errorlist(i));
                    sout = system(['measure ' '--face ' faceSide ' ' temp_fname '.whiskers ' temp_fname '.measurements']);
                    trial_ind = 0;
                    while (sout ~= 0 && trial_ind < 3)
                        sout = system(['measure ' '--face ' faceSide ' ' temp_fname '.whiskers ' temp_fname '.measurements']);
                        trial_ind = trial_ind + 1;
                    end
                    if sout == 0
                        disp([temp_fname '.whiskers has been measured'])
                    else
                        disp(['Failed to measure ' temp_fname '.whiskers'])
                    end
                end
            end
            % 3) for those still remaining not measured, trace again and then  measure them
            measure_flist = dir('*.measurements');
            if length(measure_flist) < length(mp4_flist)
                measure_list = zeros(length(measure_flist),1);
                for i = 1 : length(measure_flist)
                    measure_list(i) = str2double(strtok(measure_flist(i).name,'.'));
                end
                measure_errorlist = setdiff(mp4_list,measure_list);
                for i = 1 : length(measure_errorlist)
                    temp_fname = num2str(measure_errorlist(i));
                    sout = system(['trace ' temp_fname '.mp4 ' temp_fname]);
                    trial_ind = 0;
                    while (sout ~= 0 && trial_ind < 3)
                        sout = system(['trace ' temp_fname '.mp4 ' temp_fname]);
                        trial_ind = trial_ind + 1;
                    end
                    if sout == 0
                        disp([temp_fname '.mp4 traced successfully'])
                    else
                        disp(['Failed to trace ' temp_fname])
                    end
                end
                for i = 1 : length(measure_errorlist)
                    temp_fname = num2str(measure_errorlist(i));
                    sout = system(['measure --face' faceSide ' ' temp_fname '.whiskers ' temp_fname '.measurements']);
                    trial_ind = 0;
                    while (sout ~= 0 && trial_ind < 3)
                        sout = system(['measure --face' faceSide ' ' temp_fname '.whiskers ' temp_fname '.measurements']);
                        trial_ind = trial_ind + 1;
                    end
                    if sout == 0
                        disp([temp_fname '.whiskers measured successfully'])
                    else
                        disp(['Failed to measure ' temp_fname])
                    end
                end
            end
        end
        %% (3) CLASSIFY: Helps refine tracing to more accurately determine which shapes are whiskers
        %Use for multiple whiskers
        % %         measFiles = dir('*measurements');
        % %         tic
        % %         for n=1:length(measFiles)
        % %             [~, outputFileName] = fileparts(measFiles(n).name);
        % %             classifyCMD = ['classify '  outputFileName...
        % %                 '.measurements face ' faceSide ' --px2mm ' num2str(pixDen) ' -n '...
        % %                 num2str(whiskerNum) ' --limit5.0:25.0']
        % %             system(classifyCMD);
        % %             display([measFiles(n).name ' has been classified'])
        % %         end
        % %           toc
        
        
        classifycmd = sprintf(['dir /b *.measurements | %s --count=%.00f --shell --stdin'...
            ' --pattern="classify {{0}} {{0:N}}.measurements %s --px2mm %.02f -n %.00f --limit5.0:25.0"'], ...
            mpPath, numCores, faceSide, pixDen, whiskerNum);
        system(classifycmd);
        
        %% (4) RECLASSIFY: Refines previous step
        % classes = dir('*.measurements');
        %
        % parfor n=1:length(classes)
        %     [~, outputFileName] = fileparts(classes(n).name);
        %     system(['reclassify ' classes(n).name ' ' outputFileName '.measurements' ' ' '-n ' whiskerNum]);
        %     display([classes(n).name ' has been reclassified'])
        %     display([classes(n).name ' completed'])
        % end
        %%
        totalTime = toc(totalTStart);
    end
%Please visit http://whiskertracking.janelia.org/wiki/display/MyersLab/Whisker+Tracking+Tutorial
%for more information
%   Clack NG, O'Connor DH, Huber D, Petreanu L, Hires A., Peron, S., Svoboda, K., and Myers, E.W. (2012)
%   Automated Tracking of Whiskers in Videos of Head Fixed Rodents.
%   PLoS Comput Biol 8(7):e1002591. doi:10.1371/journal.pcbi.1002591


%%%%%%%%START PROGRAM 4
    function [startDirListOutput, endDirListOutput, trackMP4, ConvertToMP4] = getAllDirWithSeq_NESTED315496874654184(searchInAllOfTheseDirs, letterDriveForEndDir)
        CONVERT_ALL_VIDEOS = 1; % delete when done
        %% get the directories with SEQ files to run tracking on
        %         mp4INdirectory = zeros(1000, 1);
        %         seqINdirectory = zeros(1000, 1);
        sameDirectoryTrigger =  isequal(searchInAllOfTheseDirs, letterDriveForEndDir);
        clear allDirsToRun startDirListOutput
        counter =0;
        if ~iscell(searchInAllOfTheseDirs)
            searchInAllOfTheseDirs2{:} = searchInAllOfTheseDirs;
            searchInAllOfTheseDirs = searchInAllOfTheseDirs2;
        end
        % % % % %              containsMP4s = 0;
        % % % % %             containsSEQs =0 ;
        startDirListOutput = {};
        %         for kkkk = 1:length(searchInAllOfTheseDirs)
        kkkk = 1;
        %add ending if needed
        if ~(searchInAllOfTheseDirs{kkkk}(end) == '\' || searchInAllOfTheseDirs{kkkk}(end) == '/')
            searchInAllOfTheseDirs{kkkk}= [searchInAllOfTheseDirs{kkkk}, filesep];
        end
        dAll = regexp(genpath(searchInAllOfTheseDirs{kkkk}),['[^;]*'],'match');
        
        seqANDmp4numbers = [];
        % remove all the directories with keywords chocen above
        remDirsInds = [];
        for removeString = 1:length(keywordRemoveDir)
        remDirsInds(:,removeString) = cellfun(@isempty,(strfind(lower(dAll), lower(keywordRemoveDir{removeString}))));
        end
          keepDirs = find(sum(remDirsInds,2)==length(keywordRemoveDir)); % get all the dirs with NONE of the key words 
          dAll= dAll(keepDirs);%
        
        for k = 1:numel(dAll)
            d = dAll{k};
            cd(d);
            if d(end) == '\' || d(end) == '/'
                %do nothing
            else
                d = [d,filesep];%add a filesep if you need one
            end
            filelist_seq = dir([d '*.seq']);
            filelist_mp4 = dir([d '*.mp4']);
            filelist_whiskers = dir([d '*.whiskers']);
            filelist_measurements = dir([d '*.measurements']);
            filelist_xml = dir([d '*.xml']);
            filelist_bar = dir([d '*.bar']);
            filelist_WL = dir([d '*WL.mat']);
            filelist_WST = dir([d '*WST.mat']);
            filelist_WT = dir([d '*WT.mat']);
            
            seqANDmp4numbers(k,1) = length(filelist_seq);
            seqANDmp4numbers(k,2) = length(filelist_mp4);
            seqANDmp4numbers(k,3) = length(filelist_whiskers);
            seqANDmp4numbers(k,4) = length(filelist_measurements);
            seqANDmp4numbers(k,5) = length(filelist_xml);
            seqANDmp4numbers(k,6) = length(filelist_bar);
            seqANDmp4numbers(k,7) = length(filelist_WL);
            seqANDmp4numbers(k,8) = length(filelist_WST);
            seqANDmp4numbers(k,9) = length(filelist_WT);
            counter = counter +1;
            if ~isempty(filelist_seq) && isempty(strfind(d, '$'))
                startDirListOutput{counter,1} = d;
            else
                startDirListOutput{counter,1} = [];
            end
            
            if  ~isempty(filelist_mp4) && isempty(strfind(d, '$'))
                startDirListOutput{counter,2} = d;
            else
                startDirListOutput{counter,2} = [];
            end
            
            if  ~isempty(filelist_whiskers) && isempty(strfind(d, '$'))
                startDirListOutput{counter,3} = d;
            else
                startDirListOutput{counter,3} = [];
            end
            
            if  ~isempty(filelist_measurements) && isempty(strfind(d, '$'))
                startDirListOutput{counter,4} = d;
            else
                startDirListOutput{counter,4} = [];
            end
            
            if  ~isempty(filelist_xml) && isempty(strfind(d, '$'))
                startDirListOutput{counter,5} = d;
            else
                startDirListOutput{counter,5} = [];
            end
            
        end
        %         end
        
        
        %%
        %         if isempty(startDirListOutput)
        %             error('there aren''t any SEQ files in the directory or any subdirectory you chose')
        %         elseif isempty(startDirListOutput)
        %             error('you set convert video to false and there are no mp4s in the directory or any subdirectories')
        %         end
        % find the end dirs
        
        seqINDS = find(~cellfun(@isempty,startDirListOutput(:,1)));
        mp4INDS = find(~cellfun(@isempty,startDirListOutput(:,2)));
%         whiskersINDS = find(~cellfun(@isempty,startDirListOutput(:,3)));
%         measurementsINDS = find(~cellfun(@isempty,startDirListOutput(:,4)));
%         xmlINDS = find(~cellfun(@isempty,startDirListOutput(:,5)));
        allVidINDS = unique([seqINDS(:) ; mp4INDS(:)]);
        
        addRightSideToLeft = setdiff( mp4INDS,seqINDS);
        tmp = startDirListOutput(:,2);
        startDirListOutput(addRightSideToLeft) = tmp(addRightSideToLeft);
        %         for allvidstep = 1:length(tmp)
        %         if isempty(tmp{allvidstep})
        %         end
        
        [~, mp4INDS, ~] = intersect(allVidINDS,mp4INDS(:));
        [~, seqINDS, ~] = intersect(allVidINDS,seqINDS(:));
        seqANDmp4numbers = seqANDmp4numbers(allVidINDS,:);
        
        startDirListOutput2 = startDirListOutput(allVidINDS);
        allVidINDS = unique([seqINDS(:) ; mp4INDS(:)]);
        endDirListOutput = startDirListOutput;
        %         if sameDirectoryTrigger
        %             endDirListOutput = startDirListOutput;
        %         else
        %             for iterForFindingDirs = 1: length(startDirListOutput)
        %                 if length(letterDriveForEndDir) == 1
        %                     endDirListending = startDirListOutput{iterForFindingDirs}(2:end);
        %                     endDirListOutput{iterForFindingDirs,1} = [letterDriveForEndDir, endDirListending];
        %
        %                 elseif letterDriveForEndDir (2) == ':'
        %                     if ~(letterDriveForEndDir(end) == '\' || letterDriveForEndDir(end) == '/') && iterForFindingDirs==1
        %                         letterDriveForEndDir = [letterDriveForEndDir, filesep];
        %                     end
        %                     endDirListending = startDirListOutput{iterForFindingDirs}(4:end);
        %                     endDirListOutput{iterForFindingDirs,1} = [letterDriveForEndDir, endDirListending];
        %
        %                 else
        %                     error(['end directory input not correct format, must be a single drive letter (one character) or drive letter with colon like this ''C:\newFolder'''])
        %                 end
        %
        %             end
        %         end
        
        
        %% gui portion for selecting directories
        guiCheckboxFig =  figure('units','normalized','outerposition',[0 0 1 1]);
        dataCell= num2cell(true(numel(startDirListOutput2(seqINDS)),1));
        tmp = num2cell(seqANDmp4numbers(seqINDS,:));
        dataCell = [dataCell, tmp];
        table1 = uitable('Parent', guiCheckboxFig, 'Units', 'normal', 'Position', [.05 .5 .9 .5], ...
            'columnname', {'SEQ to MP4|Yes/No', 'num SEQs', 'numMP4s', 'num measurements', ...
            'num whiskers', 'num xml', 'num_Bar', 'num_WL', 'num_WST' , 'num_WT' },...
            'columnformat',{'logical', 'numeric', 'numeric'},...
            'ColumnEditable', [true, false, false],...
            'rowname',startDirListOutput2(seqINDS),...
            'data',dataCell);
        
        
        tbl2checklist = false(numel(startDirListOutput2(allVidINDS)),1);
        tmp = cellfun(@isempty, startDirListOutput2);
        dir2TMP = startDirListOutput2;
        if any(tmp)
            dir2TMP{tmp} = '.';
        end
        doTrackIndsTMP = [];
        for removeString = 1:length(keywordUncheck)
        doTrackIndsTMP(:,removeString) = cellfun(@isempty,(strfind(lower(dir2TMP(allVidINDS)), lower(keywordUncheck{removeString}))));
        end
        doTrackInds = find(sum(doTrackIndsTMP,2)==length(keywordUncheck));
        tbl2checklist(doTrackInds)= true; % only chekc those without the keyword keywordDontTrack
        
        % % % % % %         table2 = uitable('Parent', guiCheckboxFig, 'Units', 'normal', 'Position', [.05 0 .9 .5], ...
        % % % % % %             'columnname', {'track MP4|Yes/No'},...
        % % % % % %             'columnformat',{'logical'},...
        % % % % % %             'ColumnEditable', true,...
        % % % % % %             'rowname',startDirListOutput2(allVidINDS),...
        % % % % % %             'data',tbl2checklist);
        dataCell= num2cell(tbl2checklist);
        tmp = num2cell(seqANDmp4numbers(allVidINDS,:));
        dataCell = [dataCell, tmp];
        
        table2 = uitable('Parent', guiCheckboxFig, 'Units', 'normal', 'Position', [.05 0 .9 .5], ...
            'columnname', {'Track MP4|Yes/No', 'num SEQs', 'numMP4s', 'num measurements',...
            'num whiskers', 'num xml', 'num_Bar', 'num_WL', 'num_WST' , 'num_WT' },...
            'columnformat',{'logical', 'numeric', 'numeric'},...
            'ColumnEditable', [true, false, false],...
            'rowname',startDirListOutput2(allVidINDS),...
            'data',dataCell);
        tmpData = cell2mat(table2.Data(:, 2:end));
        table2XML = table(startDirListOutput2(allVidINDS), tmpData(:,1), tmpData(:,2), ...
            tmpData(:,3), tmpData(:,4), tmpData(:,5), tmpData(:,2)-tmpData(:,3), ...
            tmpData(:,2)-tmpData(:,4), tmpData(:,6), tmpData(:,7), tmpData(:,8), tmpData(:,9));
        table2XML.Properties.VariableNames = {'name_and_location','num_SEQs', 'numMP4s', 'num_measurements', 'num_whiskers', 'num_xml', ...
            'MP4_minus_meas', 'MP4_minus_Whisk', 'num_Bar', 'num_WL', 'num_WST' , 'num_WT'};
                dateString = datestr(now, 'yymmdd_HHMM');

        nameOfXLSX = [searchInAllOfTheseDirs{:}, filesep, 'TrackingINFO_', dateString, '.xlsx'];
      
        btnPRINT = uicontrol('Style', 'pushbutton', 'String', 'Print to XLSX',...
            'units', 'normalized',...
            'Position', [.85 .25 .1 .15],...
            'Callback', {@pushbutton_callback,table2XML, nameOfXLSX});
        function pushbutton_callback(src,event,table2XML, nameOfXLSX)
            writetable(table2XML, nameOfXLSX)
        end
        
        btn = uicontrol('Style', 'pushbutton', 'String', 'done',...
            'units', 'normalized',...
            'Position', [.85 .5 .1 .15],...
            'Callback', 'uiresume(gcbf)');
        uiwait(gcf)
        ConvertToMP4 = get(table1, 'data');
        ConvertToMP4 = cell2mat(ConvertToMP4(:,1));
        %         tmp = zeros(length(startDirListOutput),1);
        %         tmp(seqINDS) = ConvertToMP4;
        %         ConvertToMP4 = tmp;
        trackMP4 = get(table2, 'data');
        trackMP4 = cell2mat(trackMP4(:,1));
        close(guiCheckboxFig);
        ConvertToMP4 = seqINDS(ConvertToMP4);
        trackMP4 = allVidINDS(trackMP4);
        
        
        %%
        onlyTheseDirs = unique([trackMP4(:);ConvertToMP4(:)]);
        
        trackMP4 =   ismember(onlyTheseDirs, trackMP4);
        ConvertToMP4 =  ismember(onlyTheseDirs, ConvertToMP4);
        startDirListOutput = startDirListOutput2(onlyTheseDirs);
        seqANDmp4numbers = seqANDmp4numbers(onlyTheseDirs, :);
        trackMP4final = zeros(length(startDirListOutput),1);
        ConvertToMP4final = zeros(length(startDirListOutput),1);
        
        
        endDirListOutput = startDirListOutput2(onlyTheseDirs);
        guiCheckboxFig2 =  figure('units','normalized','outerposition',[.1 .1 .8 .8]);
        guiCheckbox.table = uitable('units', 'normal', 'outerposition', [0, 0, 1, 1], ...
            'columnname', {'end Directory You can edit this if you want'},...
            'columnformat',{'char'},...
            'ColumnEditable', true,...
            'rowname',startDirListOutput,...
            'data',endDirListOutput);
        guiCheckbox.table.ColumnWidth = {700};
       btn = uicontrol('Style', 'pushbutton', 'String', 'done',...
            'units', 'normalized',...
            'Position', [.85 .5 .1 .15],...
            'Callback', 'uiresume(gcbf)');
        uiwait(gcf)
        
        endDirsUserSelected = get(guiCheckbox.table, 'data');
        close(guiCheckboxFig2);
        endDirListOutput = endDirsUserSelected;
        %% try to make the directories after selecting the start dirs
        for iterForFindingDirs = 1: length(startDirListOutput)
            [statusNum, msg, msgID] = mkdir(endDirListOutput{iterForFindingDirs});
            if statusNum ==0
                error(['could not make end directory ', endDirListOutput{iterForFindingDirs}])
                
            end
        end
        %% if you wanted to track video but there was only SEQ files then force convert mp4 first
        ConvertToMP4(find(trackMP4 - seqANDmp4numbers(:,2)>=1) == 1) = 1;
        
    end
%%%%function5 start
    function makeDefaultParamsFile_NESTED156361856977761
        %% makes a default params file with below settings in the current directory
        fid = fopen('default.parameters','wt');
        defaultParamsText = ['[error]\n',...
            'SHOW_DEBUG_MESSAGES     1\n',...
            'SHOW_PROGRESS_MESSAGES  0\n',...
            '\n',...
            '[reclassify]\n',...
            'HMM_RECLASSIFY_SHP_DISTS_NBINS 16\n',...
            'HMM_RECLASSIFY_VEL_DISTS_NBINS 8096\n',...
            'HMM_RECLASSIFY_BASELINE_LOG2   -500.0\n',...
            'COMPARE_IDENTITIES_DISTS_NBINS 8096\n',...
            'IDENTITY_SOLVER_VELOCITY_NBINS 8096\n',...
            'IDENTITY_SOLVER_SHAPE_NBINS    16\n',...
            '\n',...
            '[trace]\n',...
            'SEED_METHOD                    SEED_ON_MHAT_CONTOURS // Specify seeding method: may be SEED_ON_MHAT_CONTOURS, SEED_ON_GRID, or SEED_EVERYWHERE\n',...
            'SEED_ON_GRID_LATTICE_SPACING   50           // (pixels)\n',...
            'SEED_SIZE_PX                   4            // Width of the seed detector in pixels.\n',...
            'SEED_ITERATIONS                1            // Maxium number of iterations to re-estimate a seed.\n',...
            'SEED_ITERATION_THRESH          0.0          // (0 to 1) Threshold score determining when a seed should be reestimated.\n',...
            'SEED_ACCUM_THRESH              0.0          // (0 to 1) Threshold score determining when to accumulate statistics\n',...
            'SEED_THRESH                    0.99         // (0 to 1) Threshold score determining when to generate a seed\n',...
            '\n',...
            'HAT_RADIUS                     1.5          // Mexican-hat radius for whisker detection (seeding)\n',...
            'MIN_LEVEL                      1            // Level-set threshold for mexican hat result.  Used for seeding on mexican hat contours.\n',...
            'MIN_SIZE                       20           // Minimum # of pixels in an object considered for mexican-hat based seeding.\n',...
            '\n',...
            '                                            // detector banks parameterization.  If any of these change, the detector banks\n',...
            '                                            // should be deleted.  They will be regenerated on the next run.\n',...
            '                                            //\n',...
            'TLEN                           8            // (px) half the size of the detector support.  If this is changed, the detector banks must be deleted.\n',...
            'OFFSET_STEP                    .1           // pixels\n',...
            'ANGLE_STEP                     18.          // divisions of pi/4\n',...
            'WIDTH_STEP                     .2           // (pixels)\n',...
            'WIDTH_MIN                      0.4          // (pixels) must be a multiple of WIDTH_STEP\n',...
            'WIDTH_MAX                      6.5          // (pixels) must be a multiple of WIDTH_STEP\n',...
            'MIN_SIGNAL                     5.0          // minimum detector response per detector column.  Typically: (2*TLEN+1)*MIN_SIGNAL is the threshold determining when tracing stops.\n',...
            'MAX_DELTA_ANGLE                10.1         // (degrees)  The detector is constrained to turns less than this value at each step.\n',...
            'MAX_DELTA_WIDTH                6.0          // (pixels)   The detector width is constrained to change less than this value at each step.\n',...
            'MAX_DELTA_OFFSET               6.0          // (pixels)   The detector offset is constrained to change less than this value at each step.\n',...
            'HALF_SPACE_ASSYMETRY_THRESH    0.25         // (between 0 and 1)  1 is completely insensitive to asymmetry\n',...
            'HALF_SPACE_TUNNELING_MAX_MOVES 50           // (pixels)  This should be the largest size of an occluding area to cross\n',...
            '\n',...
            'FRAME_DELTA                    1            // [depricated?] used in compute_zone to look for moving objects\n',...
            'DUPLICATE_THRESHOLD            5.0          // [depricated?]\n',...
            'MIN_LENGTH                     20           // [depricated?]           If span of object is not 20 pixels will not use as a seed\n',...
            'MIN_LENSQR                     100          // [depricated?]           (MIN_LENGTH/2)^2\n',...
            'MIN_LENPRJ                     14           // [depricated?] [unused]  floor(MIN_LENGTH/sqrt(2))\n'];
        fprintf(fid, defaultParamsText);
        fclose(fid);
    end
end