function [image] = isi_video(filename,frameRate)
% modified by Phillip Maire to make videos 08/20/2018
% Modified from isi_meanMapCache by Jinho Kim 01/09/2016
% Take chunksize, nchunk, baseline, and stimdur as parameters
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
contrastAdjLims = [0.2 0.7];
chunksize = 20; % 20 sec imaging
nchunks = 20; % 20 trials
baseline = 3; % whisker deflection starts after 5 sec %%###
stimdur = 3; % whisker stimulation total 5 sec (at 5 Hz)%%###


if nargin < 2
    error('Must input a file name.')
    % elseif nargin < 2
    %     error('Must input the chunksize (frames in each trial)')
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

basePeriod = 1 : baseline;

% First, strip file name of any either extension:
x = strfind(filename, '.qcamraw');
if ~isempty(x) % argument includes .qcamraw extension
    filename = filename(1:(x-1));
end
% If doesn't exist, try to load corresponding .qcamraw file with
% raw data:

for movieIter = 1:nchunks - baseline - stimdur
    stimPeriod = baseline + movieIter : baseline + movieIter + stimdur;
    if exist([filename '.qcamraw'],'file')
        f = 1;
        for k = 1:nchunks
            rep = read_qcamraw([filename '.qcamraw'], f:(f+chunksize-1));
            stim = mean(rep(:,:,stimPeriod),3)/nchunks;
            base = mean(rep(:,:,basePeriod),3)/nchunks;
            if k==1
                stimMean = stim;
                baseMean = base;
            else
                stimMean = stimMean + stim;
                baseMean = baseMean + base;
            end
            f = f+chunksize;
        end
        diffMean = (stimMean - baseMean)./baseMean * 100;
        % Didn't find .mat file, so write it now:
        %         save([num2str(movieIter), '_', outputfilename], 'stimMean', 'baseMean','diffMean');
    else
        error(['Could not find either file ' filename '.qcamraw!'])
    end
    image = diffMean';
    image = mat2gray(image);
    image = imadjust(image,contrastAdjLims,[]);
    % create movie array first
    if movieIter == 1
        movieArray = NaN(size(image, 1), size(image, 2), nchunks - baseline - stimdur);
    end
    movieArray(:, :, movieIter) = image;
end

v = VideoWriter([filename, '.avi']);%%###
v.FrameRate = frameRate;%%###
open(v);
movieArray2 = mat2gray(movieArray);
for k = 1:10
    frame = movieArray2(:,:,k);
    writeVideo(v,frame);
end

close(v);
