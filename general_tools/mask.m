%{

cellTMP = U{1}
spikes = squeeze(cellTMP.R_ntk) .* 1000;
% define the points here we use all touches
touchFirstAll = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
touchLateALL = find(squeeze(cellTMP.S_ctk(11,:,:))==1);
points = sort([touchFirstAll; touchLateALL]);

% time aorund the points to remove
rangeRemoveVariable = -10:200;

% length of each trial
lengthOfTimeEachTrial = cellTMP.t
numTrials = cellTMP.k

tic
[linInds, masktrials, maskTimes] = mask(points, rangeRemoveVariable, lengthOfTimeEachTrial, numTrials);
toc



C= U{1};
points = squeeze(cellTMP.S_ctk(9, :, :));
tic
[linInds, masktrials, maskTimes] = mask(points, -20:200, C.t, C.k, 1:10);
toc


% OOOOOOORRRRRRRRRRRRRRRR

% select certain trials to keep  and remove all others with mask
trialsToKeep = 1;

tic
[linInds, masktrials, maskTimes] = makeMask(points, rangeRemoveVariable,lengthOfTimeEachTrial,numTrials, trialsToKeep);
toc
%}
function [linInds, masktrials, maskTimes] = mask...
    (points, rangeRemoveVariable,lengthOfTimeEachTrial,numTrials, varargin)
% varargin are keepTrialInds and 'trialTime'

if isempty(rangeRemoveVariable)
    disp('rangeRemoveVariable is empty returning empty arrays');
    linInds = []; masktrials= []; maskTimes = [];
else
    
    if numel(points) == lengthOfTimeEachTrial * numTrials %% for matrixes of size equal to time and trial of 1s and 0s
        tmp1 = points;tmp1(isnan(tmp1)) = 0;
        if all(size(points) == [lengthOfTimeEachTrial, numTrials ]) && all(unique(tmp1)==[0;1])
            points = find(points==1);
        else
            error('For a matrix of 1''s and 0''s or 1''s and NANs make sure it is time by trials')
        end
        
    elseif numel(points) == numTrials
        if max(points)<=lengthOfTimeEachTrial %for variables with time and their index is the trial
            points = points(:) + ((0:(numTrials-1)).*lengthOfTimeEachTrial)';
            points = points(~isnan(points));
        elseif max(points)<=5*lengthOfTimeEachTrial
            if nargin == 6 && strcmpi(varargin{2}, 'trialtime')
                %for example when you look at pole down time and it goes past
                %4000 becasue it records past that time period. we want to toss
                %those.
                points(points>lengthOfTimeEachTrial) = nan;
                points = points(:) + ((0:(numTrials-1)).*lengthOfTimeEachTrial)';
                points = points(~isnan(points));
                
            else
                string1 = sprintf(['first input is not in an accepted format. If you are using \n'...
                    'pole down times (for example) where the index is the trial number \n'...
                    'and the value is the time, sometimes the time goes past the limit \nof the '...
                    'total trial time. USE INPUT ''trialtime'', FOR INPUT 6 \n(LEAVE INPUT 5 BLANK IF NEEDED) '...
                    'TO INDICATE THAT THIS IS THAT TYPE OF INPUT DATA']);
                error(string1);
            end
        end
    end % and the default which is is the linear inds of the events
    
    
    
    masktrials = ceil(points./lengthOfTimeEachTrial);
    maskTimes  = mod(points, lengthOfTimeEachTrial);
    maskTimes(maskTimes==0) = lengthOfTimeEachTrial;
    maskTimes = maskTimes(:);
    % numTrial = max(masktrials(:));
    % for selecting certain trials to look at pole position for example
    if nargin == 5
        if ~isblank(varargin{1})
            keepTrialInds = varargin{1};
            
            remTrials = setdiff(1:numTrials, keepTrialInds);
            remLinInds = (remTrials(:)-1)*lengthOfTimeEachTrial+1;
            remLinInds = remLinInds(:) + (0:lengthOfTimeEachTrial-1);
            
            
            keepTrialInds = varargin{1};
            keepTrialInds2 = sum((masktrials(:) - keepTrialInds(:)') == 0, 2);
            masktrials = masktrials(logical(keepTrialInds2));
            maskTimes = maskTimes(logical(keepTrialInds2));
        end
    end
    % apply the time range to the mask
    maskTimes = maskTimes(:)+rangeRemoveVariable(:)';
    runOver = [find(maskTimes>lengthOfTimeEachTrial); find( maskTimes<=0)];
    masktrials = repmat(masktrials(:), 1, size(maskTimes , 2));
    % nan out the runover
    maskTimes(runOver) = nan;
    masktrials(runOver) = nan;
    %get unique inds to what we want to remove then remove the nan points casue we cant index those
    linInds = unique((masktrials-1).*(lengthOfTimeEachTrial...
        -.00000000000000000000001) + maskTimes);
    
% % % % % % %         linInds = unique((masktrials-1).*(lengthOfTimeEachTrial-realmin) + maskTimes);
    
    
    %added this subtraction point becasue I was getting rounding error
    linInds = linInds(~isnan(linInds));
    % get the other inds now
    masktrials = round(ceil(linInds./lengthOfTimeEachTrial));
    maskTimes  = round(mod(linInds, lengthOfTimeEachTrial));
    linInds = round(linInds);
    
end





