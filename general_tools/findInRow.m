function [segmentsTMP] = findInRow(inputarray)
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

diffDetect = inputarray(:) - (1:length(inputarray))';
[startNums , uniqueInds,~] = unique(diffDetect);
startNums = inputarray(uniqueInds);
lengthArray = circshift(uniqueInds, -1) - uniqueInds;
lengthArray(end) = 1+length(inputarray)-uniqueInds(end);
segmentsTMP = [startNums(:) , startNums(:)+lengthArray(:)-1, lengthArray(:)];


end