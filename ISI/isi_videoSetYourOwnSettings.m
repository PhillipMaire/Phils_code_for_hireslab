function [imageVar] = isi_videoSetYourOwnSettings(filename,frameRate, numFramesPerTrial, numTrials,baselineFrames, numFramesInSignal)
% modified by Phillip Maire to make videos 08/20/2018
% any variable will activate ffmpeg to make contrast adjusted video ;)
% Modified from isi_meanMapCache by Jinho Kim 01/09/2016
% Take numFramesPerTrial, nchunk, baselineFrames, and smoothingStepSize as parameters
% Just take 1 file only.

%   Will display the resulting mean difference image (ISI "blob" map) in
%    imtool().  May require contrast/brightness adjustment with the imtool().
%
% See files isi_writeRunMeans.m and isi_meanMap.m for explanation of what's
% computed.
%
% Requires: read_qcamraw.m, Image Processing Toolbox.
%
% DHO, 10/08.

numberOfFrames = numFramesInQcam([filename '.qcamraw'])

%%%% setting for phils ISI settings
contrastAdjLims = [0.25 0.80];
if false
    
    numFramesPerTrial = 50; %after temporal averaging
    numTrials = 20; % 20 trials
    baselineFrames = 3; % whisker deflection starts after 5 sec %%###
    numFramesInSignal = 3;%captured signal to subtract from BL
end
smoothingStepSize = 1; % whisker stimulation total 5 sec (at 5 Hz)%%###
if (numFramesPerTrial.*numTrials) ~= numberOfFrames
    adjVal = numberOfFrames./(numFramesPerTrial.*numTrials);
    if adjVal == round(adjVal)
        keyboard
        numFramesPerTrial = numFramesPerTrial.*adjVal;
        baselineFrames = baselineFrames.*adjVal;
        numFramesInSignal = numFramesInSignal.*adjVal;
        warning(['temporal averaging was not normal so adjusted the frames per trial value by multiplying it by ', num2str(adjVal)])
        
    else
        error('file may be incomplete')
    end
    
end
% %
%%%% setting for normal ISI settings
% contrastAdjLims = [0.25 0.80] these seem to be optimal - PSM
% contrastAdjLims = [0.25 0.75] this has higher SNR but you loose some of the subtle changes
% un like the 25 80 which has high SNR with those.
% % % % contrastAdjLims = [0.25 0.80];
% % % % numFramesPerTrial = 20; %after temporal averaging
% % % % numTrials = 20; % 20 trials
% % % %
% % % % baselineFrames = 5; % whisker deflection starts after 5 sec %%###
% % % % smoothingStepSize = 1; % whisker stimulation total 5 sec (at 5 Hz)%%###
% % % % numFramesInSignal = 3;% tested this and it seems that 3 is the best setting for strongest signal


% if nargin < 2
%     error('Must input a file name and frames per sec.')
% elseif nargin>3
%     error('to many inputs')
% end
if nargin ~= 6
    error('wrong number of inputs must be 6')
end
outputfileheader = [filename '_result'];
outputfileheader_temp = outputfileheader;
outputfileindex = 0;
while(1)
    if exist([outputfileheader_temp '.mat'], 'file')
        outputfileindex = outputfileindex + 1;
        outputfileheader_temp = [outputfileheader, '_', num2str(outputfileindex)];
    else
        break
    end
end
outputfilename = [outputfileheader_temp '.mat'];

basePeriod = 1 : baselineFrames;

% First, strip file name of any either extension:
x = strfind(filename, '.qcamraw');
if ~isempty(x) % argument includes .qcamraw extension
    filename = filename(1:(x-1));
end
% If doesn't exist, try to load corresponding .qcamraw file with
% raw data:
numFramesInVid = numFramesPerTrial - baselineFrames - smoothingStepSize;

framesIndex = 1:smoothingStepSize :numFramesPerTrial;
framesIndex = framesIndex +(numFramesPerTrial-framesIndex(end));
% framesIndex = framesIndex - smoothingStepSize;
% framesIndex = framesIndex(find(framesIndex>0));
rep2 = read_qcamraw([filename '.qcamraw'], 1:(numFramesPerTrial.*numTrials));
if false %make video of the entire list of videos in order (so 20 trials it will combine all and make a long video with each video in order)
    
    nameVid = ['ALL', '.avi'];
    v = VideoWriter(nameVid);%%###
    v.FrameRate = frameRate;%%###
    open(v);
    %  movieArray2 = mat2gray(movieArray);
    % movieArray2 = movieArray;
    for frameIter3 = 1:(numFramesPerTrial.*numTrials)
        frame = rep2(:,:,frameIter3);
        %     imadjust(frame,contrastAdjLims,[]);
        writeVideo(v,mat2gray(frame)');
    end
    close(v);
    
end
if false %make vid of mean of all videos
    
    nameVid = ['ALLtogether', '.avi'];
    v = VideoWriter(nameVid);%%###
    v.FrameRate = frameRate;%%###
    open(v);
    %  movieArray2 = mat2gray(movieArray);
    % movieArray2 = movieArray;
    inds4Frames = 0:numFramesPerTrial:(numFramesPerTrial.*numTrials)-numFramesPerTrial+1;
    allFrame(:,:,1) = rep2(:,:,1);%tmp to replace
    for frameIter3 = 1:(numFramesPerTrial)
        inds4Frames2 = inds4Frames +(frameIter3);
        frame = rep2(:,:,inds4Frames2);
        frame = mean(frame,3);
        allFrame(:,:,frameIter3) = frame;
        %     imadjust(frame,contrastAdjLims,[]);
        writeVideo(v,mat2gray(frame)');
    end
    close(v);
    
end
if false
    if ~exist('allFrame')
        inds4Frames = 0:numFramesPerTrial:(numFramesPerTrial.*numTrials)-numFramesPerTrial+1;
        allFrame(:,:,1) = rep2(:,:,1);%tmp to replace
        for frameIter3 = 1:(numFramesPerTrial)
            inds4Frames2 = inds4Frames +(frameIter3);
            frame = rep2(:,:,inds4Frames2);
            frame = mean(frame,3);
            allFrame(:,:,frameIter3) = frame;
        end
    end
    tmp = mean(allFrame(:,:,1:3),3);
    allFrame = double(allFrame)-repmat(tmp, [1,1,size(allFrame,3)]);
    
    nameVid = ['ALLtogetherSubtracted', '.avi'];
    v = VideoWriter(nameVid);%%###
    v.FrameRate = frameRate;%%###
    open(v);
    for k = 1:numFramesPerTrial
        writeVideo(v,imadjust(mat2gray(allFrame(:,:,k)))');
    end
    close(v);
end

%   tmpFrame = imadjust(tmpFrame);
%     tmpFrame = imadjust(tmpFrame,contrastAdjLims,[]);

framesIndex2 = framesIndex +numFramesInSignal-1;
totalFrames = length(find(framesIndex2<=numFramesPerTrial));
% totalFrames = ceil(((numFramesPerTrial-numFramesInSignal+1)./smoothingStepSize));
% totalFrames = floor(numFramesPerTrial./smoothingStepSize);
% totalFrames = totalFrames +1 - numFramesInSignal;

normMaxVar = -9999999;%overwritten later leave alone
normMinVar = 999999999; %overwritten later leave alone
fid2 = fopen( [filename '.txt'], 'wt' );
for movieIter = 1:totalFrames
    movieIter2 = framesIndex(movieIter);
    stimPeriod =  movieIter2 : movieIter2 + numFramesInSignal-1;
    framInfoTXT = ['frames ''', num2str(stimPeriod), ''' of ', num2str(numFramesPerTrial), ' '...
        '  to make frame ', num2str(movieIter), ' of ', num2str(totalFrames)];
    disp(framInfoTXT);
    fprintf( fid2, '%s\n', framInfoTXT);
    
    for basIter = 1:numTrials
        
    end
    if exist([filename '.qcamraw'],'file')
        f = 1;
        for k = 1:numTrials
            %             f+numFramesPerTrial-1
            rep = rep2(:,:,f:(f+numFramesPerTrial-1)); %one entire trial (including basline and signal and such)
            if false % make video for each trial
                
                
                
                nameVid = [num2str(k), '.avi'];
                v = VideoWriter(nameVid);%%###
                v.FrameRate = frameRate;%%###
                open(v);
                %  movieArray2 = mat2gray(movieArray);
                % movieArray2 = movieArray;
                for frameIter3 = 1:numFramesPerTrial
                    frame = rep(:,:,frameIter3);
                    %     imadjust(frame,contrastAdjLims,[]);
                    writeVideo(v,mat2gray(frame)');
                end
                close(v);
                
                
            end
            stim = mean(rep(:,:,stimPeriod),3)/numTrials;
            base = mean(rep(:,:,basePeriod),3)/numTrials;
            
            test(:,:,k) = stim;
            if k==1
                stimMean = stim;
                baseMean = base;
                
                %                 get a regular blurred picture from the ISI video
            else
                stimMean = stimMean + stim;
                baseMean = baseMean + base;
            end
            f = f+numFramesPerTrial;
        end
        diffMean = (stimMean - baseMean)./baseMean * 100;
        % Didn't find .mat file, so write it now:
        %         save([num2str(movieIter), '_', outputfilename], 'stimMean', 'baseMean','diffMean');
    else
        error(['Could not find either file ' filename '.qcamraw!'])
    end
    
    
    imageVar = diffMean';
    
    normMaxVarTMP = max(max(imageVar));
    normMinVarTMP = min(min(imageVar));
    if normMaxVarTMP>normMaxVar
        normMaxVar = normMaxVarTMP;
    end
    if normMinVarTMP<normMinVar
        normMinVar = normMinVarTMP;
    end
    
    % create movie array first
    if movieIter == 1
        movieArray = NaN(size(imageVar, 1), size(imageVar, 2), numTrials - baselineFrames - smoothingStepSize);
    end
    movieArray(:, :, movieIter) = imageVar;
    %     figure
    %     imagesc(mat2gray(imageVar))
end
for  movieIter = 1:totalFrames
    % use this to make sure max and min points are the same across
    %the video so that normalizaiton doesnt make the video 'blinky'
    tmpFrame = movieArray(:,:,movieIter);
    tmpFrame(1,1) = normMaxVar;
    
    tmpFrame(1,2) = normMinVar;
    tmpFrame = mat2gray(tmpFrame);
    
    tmpFrame = imadjust(tmpFrame);
    %     tmpFrame = imadjust(tmpFrame,contrastAdjLims,[]);
    movieArray2(:,:,movieIter) = tmpFrame;
end

nameVid = [filename, '.avi'];
v = VideoWriter(nameVid);%%###
v.FrameRate = frameRate;%%###
open(v);
%  movieArray2 = mat2gray(movieArray);
% movieArray2 = movieArray;
for k = 1:totalFrames
    frame = movieArray2(:,:,k);
    %     imadjust(frame,contrastAdjLims,[]);
    writeVideo(v,frame);
end
close(v);

% print some info to text file
fprintf( fid2, '%s\n\n', ['total frames in video = ' num2str(totalFrames)]);
fprintf( fid2, '%s\n', ['total frames originally = ' num2str(numFramesPerTrial)]);
fprintf( fid2, '%s\n', ['total frames originally baseline = ' num2str(baselineFrames)]);
fprintf( fid2, '%s\n', ['# Orig frames in 1 frame of new = ' num2str(numFramesInSignal)]);
fprintf( fid2, '%s\n', ['smoothing step size = ' num2str(smoothingStepSize)]);
fprintf( fid2, '%s\n\n', ['video frame rate = ' num2str(frameRate)]);
fclose(fid2);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % if mpegContrast
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     string = 'ffplay -vf eq=brightness=0.8:contrast=4: ';%gamma=.4 ';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     directory = '';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     saveName = [filename, '.mp4'];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     %     commandFinal = [string, directory, nameVid];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     commandFinal = ['ffmpeg -i ', directory, nameVid, ' -vf eq=brightness=', num2str(brightnessVar),...
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %         ':contrast=', num2str(contrastVar), ':gamma=', num2str(gammaVar), ' -c:a copy ', directory, saveName];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     system(commandFinal);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
