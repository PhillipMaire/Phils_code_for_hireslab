%input a your U array for a single cell 'U{1}' and then positive or
%negative value. the program will out put spike data for for the window
%specified. for example -400 would be 400 ms before pole onset. fo shift
%value varargin see below comment 

function [spikesInWin, infoPoleSpike] = spikeRatePoleUp(array, window,varargin)
%% get the spike rate before pole up and after for certain time windows (based on pole up)
poleOnsetTimesALL = array.meta.poleOnset*1000;%%%%NOTE: IF YOU WANT TO SHIFT EVERYTHING
%%% RELATIVE TO POLE ONSET (ie capture time -200:400 where 0 is pole up)
%%% JUST SHIFT THIS VALUE (ie input time window of 600 and subtract this
%%% value by 200).
normNumInputs = 2;
if nargin>normNumInputs
    shiftVal = varargin{1};
    poleOnsetTimesALL=  poleOnsetTimesALL + shiftVal;
end
meanPoleUp = mean(poleOnsetTimesALL);

%% catching errors
minPoleUp = min(poleOnsetTimesALL);
maxPoleUp = max(poleOnsetTimesALL);
minAfterPoleTime = floor(4000 - maxPoleUp);
if window<0
    if floor(minPoleUp)<abs(window)
        error(['window too large. min pre pole up time ',num2str(floor(minPoleUp)), ...
            ' with window size of ', num2str(window)])
    end
elseif window>0
    if minAfterPoleTime < window
        error([' window too large.  max length after pole ',num2str(minAfterPoleTime), ...
            ' with window size of ', num2str(window)])
    end
elseif window ==0
    error([' window cant be 0 try again'])
end
%% get only the windows size out of the spikes (add or minus 1 to make sure correct numbers)
poleOnsetTimesALLround = round(poleOnsetTimesALL);
realWindow = zeros(2,numel(poleOnsetTimesALLround));
if window>0
    winOther = poleOnsetTimesALLround + window-1;
    realWindow(1,:) = poleOnsetTimesALLround;
    realWindow(2,:) = winOther;
else
    winOther = poleOnsetTimesALLround + window+1;
    realWindow(2,:) = poleOnsetTimesALLround;
    realWindow(1,:) = winOther;
end
%%
spikes = squeeze(array.R_ntk);
spikes = spikes';

spikesInWin = zeros(numel(winOther),abs(window));
for k = 1:numel(winOther)
    spikesInWin(k,:) = spikes(k,realWindow(1,k):realWindow(2,k));
end

infoPoleSpike.cellNum = array.cellNum;
infoPoleSpike.minPoleUp = minPoleUp;
infoPoleSpike.maxPoleUp = maxPoleUp;
infoPoleSpike.minAfterPoleTime = minAfterPoleTime;
infoPoleSpike.spikesPerSecTrial = sum(spikesInWin,2)/(abs(window)/1000);
infoPoleSpike.meanSpikesPerSec = mean( infoPoleSpike.spikesPerSecTrial);
infoPoleSpike.stdMeanSpksPerTrial = std( infoPoleSpike.spikesPerSecTrial);
