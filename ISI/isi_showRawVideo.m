function isi_showRawVideo(filename,secondsPerFrame, playXtimes, typePlot, varargin)
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

if nargin >= 5
    hfig = varargin{1};
else
    hfig = figure;
    
end

%%%% setting for phils ISI settings
contrastAdjLims = [0.25 0.80];
numFramesPerTrial = 20; %after temporal averaging
numTrials = 20; % 20 trials
baselineFrames = 3; % whisker deflection starts after 5 sec %%###


smoothingStepSize = 1; % whisker stimulation total 5 sec (at 5 Hz)%%###
smoothingFramesPerFrame = 3;



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


%%
for playTime = 1:playXtimes
    if ~isvalid(hfig)
        return
    end
    if typePlot == 1
        
        for kk = 0:numTrials-1
            rep3 = rep2(:, :, (1:numFramesPerTrial)+numFramesPerTrial*kk);
            for k = 1:numFramesPerTrial
                clf
                imagesc(rep3(:, :, k) );
                title(['Loop ', num2str(kk), ', frame ', num2str(k)])
                colormap('gray');
                pause(secondsPerFrame)
                
                if ~isvalid(hfig)
                    return
                end
            end
        end
    elseif typePlot == 2 % plot all video frames together
        ax1  = 5;
        ax2 = numFramesPerTrial./ax1;
        l = size(rep2);
        newImNan = nan(ax1.*l(1), ax2.*l(2));
        
        for k = 0:numTrials-1
            rep3 = rep2(:, :, (1:numFramesPerTrial:numFramesPerTrial*numTrials)+k);
            for kkk = 0:ax2-1
                for kk = 0:ax1-1
                    t =rep3(:, :, (kk+1)*(kkk+1));
                    newImNan(kk*l(1)+(1:l(1)),kkk*l(2)+(1:l(2))) = t;
                    if ~isvalid(hfig)
                        return
                    end
                end
            end
            clf
            imagesc(newImNan)
            colormap('gray');
            title(['Frame ', num2str(k)])
            pause(secondsPerFrame)
            
        end
    elseif typePlot == 3 % plot the first frame for each group to see slow drift easily
        
        
        for kk = 0:numTrials-1
            rep3 = rep2(:, :, (1:numFramesPerTrial)+numFramesPerTrial*kk);
            for k = 1
                clf
                imagesc(rep3(:, :, k) );
                title(['Loop ', num2str(kk), ', frame ', num2str(k)])
                colormap('gray');
                pause(secondsPerFrame)
                
                if ~isvalid(hfig)
                    return
                end
            end
        end
        
        
    end
    drawnow
end
