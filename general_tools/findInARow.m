function [segmentsTMP] = findInARow(arrayIN, varargin)
%% input an array of of numbers that are lin inds (
% inputarray = find([0,0,1,1,1,1,0,0,0,1,0,1,1])
%
% inputarray =  [3     4     5     6    10    12    13]
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
if ~isempty(arrayIN)
    if nargin >2  % input the time in each trial spo for me its 4000 or cellTMP.t or U{1}.t
        error('too many input args')
    elseif nargin ==2
        timeInEachTrial = varargin{1};
        MaxIn = max((arrayIN(:)));
        numTrials = ceil(MaxIn./timeInEachTrial);
        tmp1 = zeros(timeInEachTrial, numTrials);
        tmp1(arrayIN) = 1;
        endSave = tmp1(end, :);
        tmp1(end, :) = 0;
        arrayIN = find(tmp1);
    else
        if length(unique(arrayIN))==2 && all(unique(arrayIN)==[0; 1]) %if array of ones and zeros then turn into array of inds
            %     arrayIN = cumsum(arrayIN);
            %     addTo = 1;
            arrayIN = find(arrayIN(:));
        else
            arrayIN = arrayIN(:);
        end
        
        timeInEachTrial = inf;
        endSave = [];
    end
    
    
    
    
    diffDetect = arrayIN(:) - (1:length(arrayIN))';
    [startNums , uniqueInds,~] = unique(diffDetect,'stable');
    startNums = arrayIN(uniqueInds);
    lengthArray = circshift(uniqueInds, -1) - uniqueInds;
    lengthArray(end) = 1+length(arrayIN)-uniqueInds(end);
    segmentsTMP = [startNums(:) , startNums(:)+lengthArray(:)-1, lengthArray(:)];
    
    trialsStart = ceil(segmentsTMP(:, 1)./ timeInEachTrial);
    segmentsTMPtimes = segmentsTMP(:,1:2);
    segmentsTMP4= mod(segmentsTMPtimes,timeInEachTrial);
    segmentsTMP = [segmentsTMP, trialsStart, segmentsTMP4];
    secondToEnd = find((mod(segmentsTMP(:, 2), timeInEachTrial))==(timeInEachTrial-1));
    [~, indsToAdd1to, ~] = intersect(segmentsTMP(secondToEnd, 4), find(endSave==1));
    segmentsTMP(secondToEnd(indsToAdd1to), [2, 6]) = segmentsTMP(secondToEnd(indsToAdd1to), [2, 6])+1;
    if nargin ==1
        segmentsTMP = segmentsTMP(:, 1:3);
    end
    
else
    warning('input is empty');
    segmentsTMP = [];
end