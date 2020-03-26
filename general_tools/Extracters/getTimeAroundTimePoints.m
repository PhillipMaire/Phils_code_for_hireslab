function [timeInds, makeTheseNans, varargout] = getTimeAroundTimePoints(timePoints, timeRange, timeInTrial, varargin)
if nargout < 2 && ~(nargin==4 && strcmpi(varargin{1}, 'removenans'))
    
    error(['YO DOG!! You need 2 outputs here. One is the indexing matrix', ...
        ' but where nans need to be, there are currently ones!!! The second output is your nanindex',...
        'which you will use to populate your matrix with nans where there needs to be AFTER you use the indexing matrix '])
elseif  nargin > 3 && nargout< 3
    error(['for nan removal you need a third output argument. This is the same as makeTheseNans but this way '...
        'you dont have to change your code that uses these outputs becasue you want to use the 3rd output as something different'])
    
end
%% THE INPUT MUST BE LINEAR INDS
varargout{1} = [];
%%
timeInds = (timePoints(:)' + timeRange(:));
[~, trialToMatch] = min(abs(timeRange)); %this is the trial known to be from the correct trial
% get the trial numbers
touchMaskIndTrial = ceil(timeInds./timeInTrial);
% subtract the trial number from the trial numbers at the '0' point
% represented at trialToMatch (where the trial the touch happened in)
touchMaskIndTrial = touchMaskIndTrial - touchMaskIndTrial(trialToMatch, :);
%find only the ones that are the same trial the touch was extracted from
makeTheseNans = find(touchMaskIndTrial~=0);
% thie is only temporarry. because of edge problems which include going out of index range
% and include running off into the next trial we are going to replace these all with nans later
% for now make sure that they index without erroring out by giving it a 1
timeInds(makeTheseNans) = 1;
% keep only the ind that are in that same trial

if nargin == 4
    tmp1 = varargin{1};
    if strcmpi(tmp1, 'removenans')
        badTrials = unique(ceil(makeTheseNans./timeInTrial));
        keepInds = setdiff(1:size(timeInds, 2), badTrials);
        timeInds = timeInds(:, keepInds);
        
%         mod(makeTheseNans, length(timeRange));
        
        varargout{1} = badTrials;% this is the ind to the 
        % timepoint that has at least one nan in it so it was removed 
        makeTheseNans = [];
    else
        error('Unrecognized input');
    end
    
    
end
