function [imageVar] = isi_video2(filename,frameRate)
% modified by Phillip Maire to make videos 08/20/2018
% Modified from isi_meanMapCache by Jinho Kim 01/09/2016
% Take numFramesPerTrial, nchunk, baselineFrames, and smoothLengthFrames as parameters
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

contrastAdjLims = [0.25 0.50];
numFramesPerTrial = 200; %after temporal averaging
%calculated by cam pulse number divided by 2 then divided by temporal
%averaging 
numTrials = 20; % 20 trials

baselineFrames = 30; % whisker deflection starts after 5 sec %%###
smoothLengthFrames = 10; % whisker stimulation total 5 sec (at 5 Hz)%%###
frameStepSize = 10;


if nargin < 2
    error('Must input a file name and frames per sec.')
    % elseif nargin < 2
    %     error('Must input the numFramesPerTrial (frames in each trial)')
    % elseif nargin < 3
    %     error('Must input the nchunk (number of trials)')
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
numFramesInVid = numFramesPerTrial - baselineFrames - smoothLengthFrames;

framesIndex = 1:frameStepSize :numFramesPerTrial;
framesIndex = framesIndex +(numFramesPerTrial-framesIndex(end));
framesIndex = framesIndex - smoothLengthFrames;
framesIndex = framesIndex(find(framesIndex>0));
rep2 = read_qcamraw([filename '.qcamraw'], 1:4000);

for movieIter = 1:length(framesIndex)
    disp(movieIter)
    movieIter2 = framesIndex(movieIter);
    stimPeriod =  movieIter2 : movieIter2 + smoothLengthFrames;
    if exist([filename '.qcamraw'],'file')
        f = 1;
        for k = 1:numTrials
%             f+numFramesPerTrial-1
            rep = rep2(:,:,f:(f+numFramesPerTrial-1));
            stim = mean(rep(:,:,stimPeriod),3)/numTrials;
            base = mean(rep(:,:,basePeriod),3)/numTrials;
            if k==1
                stimMean = stim;
                baseMean = base;
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
    imageVar = mat2gray(imageVar);
    imageVar = imadjust(imageVar,contrastAdjLims,[]);
% % % % % % % % % % % % % % % % % % % % % %     imageVar2 = imshow(imageVar, []);
% % % % % % % % % % % % % % % % % % % % % %     testString = num2str(movieIter2);
% % % % % % % % % % % % % % % % % % % % % %     RGB = insertText(imageVar2,[0 0],testString,'AnchorPoint','LeftBottom');
    % create movie array first
    if movieIter == 1
        movieArray = NaN(size(imageVar, 1), size(imageVar, 2), numTrials - baselineFrames - smoothLengthFrames);
    end
    movieArray(:, :, movieIter) = imageVar;
end

v = VideoWriter([filename, '.avi']);%%###
v.FrameRate = frameRate;%%###
open(v);
movieArray2 = mat2gray(movieArray);
for k = 1:length(framesIndex)
    frame = movieArray2(:,:,k);
    writeVideo(v,frame);

end
close(v);

fid2 = fopen( [filename '.txt'], 'wt' );
fprintf( fid2, '%s\n', ['total frames in video = ' num2str(length(framesIndex))]);
fprintf( fid2, '%s\n', ['total frames originally = ' num2str(numFramesPerTrial)]);
fprintf( fid2, '%s\n', ['total frames originally baseline = ' num2str(baselineFrames)]);
fprintf( fid2, '%s\n', ['frame step size = ' num2str(frameStepSize)]);
fprintf( fid2, '%s\n', ['num original frames in one video frame = ' num2str(smoothLengthFrames)]);
fprintf( fid2, '%s\n\n', ['video frame rate = ' num2str(frameRate)]);
for k = 1:length(framesIndex)

  fprintf( fid2, '%s\n', ['vidoeFrame num ' num2str(k) ' made from original frames ' num2str(framesIndex(k)) '-', num2str(framesIndex(k)+20)]);
end
fclose(fid2);
