function [segmentsTMP] = findInARow(inputarray, varargin)
%% input an array of of numbers that are lin inds (
% inputarray = find([0,0,1,1,1,1,0,0,0,1,0,1,1])
%
% inputarray =
%
%      3     4     5     6    10    12    13
%% and it will return the start and end length of continious numbers so it with output
% segmentsTMP =
% start    end     length
% [3,       6,         4;
% 10,       10,        1;
% 12,       13,        2]


% if you put in the trial length as varargin then 
% segmentsTMP =
% start    end     length   trialNumber  start    end  (where the last ones or NOT lin inds but for each trial) 
% [3,       6,         4;
% 10,       10,        1;
% 12,       13,        2                               ]
diffDetect = inputarray(:) - (1:length(inputarray))';
[startNums , uniqueInds,~] = unique(diffDetect);
startNums = inputarray(uniqueInds);
lengthArray = circshift(uniqueInds, -1) - uniqueInds;
lengthArray(end) = 1+length(inputarray)-uniqueInds(end);
segmentsTMP = [startNums(:) , startNums(:)+lengthArray(:)-1, lengthArray(:)];
if nargin >2  % input the time in each trial spo for me its 4000 or cellTMP.t or U{1}.t
    
    error('too many input args')
elseif nargin ==2 
    timeInEachTrial = varargin{1};
  
    trials = ceil(segmentsTMP(:, 1)./ timeInEachTrial);
       segmentsTMPtimes = segmentsTMP(:,1:2);
%     segmentsTMP3 = segmentsTMP2(:,1:2);
    segmentsTMP4= mod(segmentsTMPtimes,timeInEachTrial);
    segmentsTMP = [segmentsTMP, trials, segmentsTMP4];
    
    

end
end