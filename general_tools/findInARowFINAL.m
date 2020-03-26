function [segmentsOUT, matOut] = findInARowFINAL(arrayIN, varargin)
%{
arrayIN = [1;1;2;3;4;5;5;5;5;5;5;5;6;7;8;9;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47;47]
[segmen, tsOUT] = findInARowFINAL(arrayIN)
%}
arrayIN = arrayIN(~isnan(arrayIN));
segmentsOUT = struct;
arrayIN = arrayIN(:);
addTo = 0;
if length(unique(arrayIN))==2 && all(unique(arrayIN)==[0; 1]) %if array of ones and zeros then turn into array of inds
    %     arrayIN = cumsum(arrayIN);
    %     addTo = 1;
    arrayIN = find(arrayIN==1);
end

if nargin >2  % input the time in each trial spo for me its 4000 or cellTMP.t or U{1}.t
    error('too many input args')
elseif nargin ==2
    timeInEachTrial = varargin{1};
    MaxIn = max(arrayIN(:));
    numTrials = ceil(MaxIn./timeInEachTrial);
    tmp1 = zeros(timeInEachTrial, numTrials);
    tmp1(arrayIN) = 1;
    endSave = tmp1(end, :);
    tmp1(end, :) = 0;
    arrayIN = find(tmp1);
end



% this is the meat of the code
diffMat = (arrayIN') - (1:length(arrayIN)) ;
[uniqDiffMat, ~] = unique(diffMat, 'stable');
findMat = diffMat == reshape(uniqDiffMat, [1, 1, numel(uniqDiffMat)]);
findMat = findMat(:, :, squeeze(sum(findMat, 2)~=0));
[~,numsInArow,inArow] = ind2sub(size(findMat),find(findMat));
if ~isempty(inArow)
    segmentsOUT.startInds = [1; find(diff(inArow)>0)+1];
    segmentsOUT.endInds = [find(diff(inArow)>0); length(inArow)];
    segmentsOUT.startInds = numsInArow([1; find(diff(inArow)>0)+1])+addTo;
    segmentsOUT.endInds = numsInArow([find(diff(inArow)>0); length(inArow)]);
    segmentsOUT.startNum = arrayIN(segmentsOUT.startInds );
    segmentsOUT.endNum = arrayIN(segmentsOUT.endInds);
    segmentsOUT.lengthSegment = (segmentsOUT.endInds-segmentsOUT.startInds)+1;
end
matOut = struct2array(segmentsOUT);

if nargin ==2
    trialsStart = ceil(matOut(:, 3)./ timeInEachTrial);
    segmentsTMPtimes = matOut(:,3:4);
    segmentsTMP4= mod(segmentsTMPtimes,timeInEachTrial);
    matOut = [matOut, trialsStart, segmentsTMP4];
    secondToEnd = find((mod(matOut(:, 4), timeInEachTrial))==(timeInEachTrial-1));
    [~, indsToAdd1to, ~] = intersect(matOut(secondToEnd, 6), find(endSave==1));
    matOut(secondToEnd(indsToAdd1to), [4, 8]) = matOut(secondToEnd(indsToAdd1to), [4, 8])+1;
    segmentsOUT.trial = matOut(:, 6);
    segmentsOUT.trialTimeStart = matOut(:, 7);
    segmentsOUT.trialTimeEnd = matOut(:, 8);
end




%%
%{

inMat = [1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0];

inMat = double(inMat);
inMat(inMat==0) = nan;
tmp1 = find(diff(inMat)==0);
inArow = unique([tmp1(:), tmp1(:)+1])

segmentsOUT.startInds = [1; find(diff(inArow)>1)+1];
segmentsOUT.endInds = [find(diff(inArow)>1); length(inArow)];


%}