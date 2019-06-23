%{
spikes = squeeze(cellTMP.R_ntk) .* 1000;
cellTMP = U{cellStep}

% define the points here we use all touches
touchFirstAll = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
touchLateALL = find(squeeze(cellTMP.S_ctk(11,:,:))==1);
points = sort([touchFirstAll; touchLateALL]); 

% time aorund the points to remove
rangeRemoveVariable = -10:200;

% length of each trial 
lengthOfTimeEachTrial = cellTMP.t

tic
[linInds, masktrials, maskTimes] = makeMask(points, rangeRemoveVariable,lengthOfTimeEachTrial);
toc

% OOOOOOORRRRRRRRRRRRRRRR

% select certain trials to keep  and remove all others with mask
trialsToKeep = 1;

tic
[linInds, masktrials, maskTimes] = makeMask(points, rangeRemoveVariable,lengthOfTimeEachTrial, trialsToKeep);
toc
%}
function [linInds, masktrials, maskTimes] = makeMask(points, rangeRemoveVariable,lengthOfTimeEachTrial, varargin)

masktrials = ceil(points./lengthOfTimeEachTrial);
maskTimes  = mod(points, lengthOfTimeEachTrial);
numTrial = max(masktrials(:));
% for selecting certain trials to look at pole position for example
if nargin == 4
keepTrialInds = varargin{1};
keepTrialInds2 = sum((masktrials(:) - keepTrialInds(:)') == 0, 2);
masktrials = masktrials(logical(keepTrialInds2));
maskTimes = maskTimes(logical(keepTrialInds2));
end
% apply the time range to the mask
maskTimes = maskTimes+rangeRemoveVariable;
runOver = [find(maskTimes>lengthOfTimeEachTrial); find( maskTimes<=0)];
masktrials = repmat(masktrials(:), 1, size(maskTimes , 2));
% nan out the runover 
maskTimes(runOver) = nan;
masktrials(runOver) = nan;
%get unique inds to what we want to remove then remove the nan points casue we cant index those 
linInds = unique((masktrials-1).*(lengthOfTimeEachTrial-.000000000001) + maskTimes);%added this subtraction point becasue I was getting rounding error
linInds = linInds(~isnan(linInds));
% get the other inds now
masktrials = round(ceil(linInds./lengthOfTimeEachTrial));
maskTimes  = round(mod(linInds, lengthOfTimeEachTrial));
linInds = round(linInds);







