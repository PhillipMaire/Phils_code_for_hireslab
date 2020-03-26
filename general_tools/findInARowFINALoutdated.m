function [segmentsOUT, matOut] = findInARowFINAL(arrayIN)
%{
arrayIN = [1;1;2;3;4;5;5;5;5;5;5;5;6;7;8;9;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31;32;33;34;35;36;37;38;39;40;41;42;43;44;45;46;47;47]
[segmen
tsOUT] = findInARowFINAL(arrayIN)
%}
segmentsOUT = struct;
arrayIN = arrayIN(:);
addTo = 0;
if length(unique(arrayIN))==2 && all(unique(arrayIN)==[0; 1])
    arrayIN = cumsum(arrayIN);
    addTo = 1;
end

% this is the meat of the code
diffMat = (arrayIN') - (1:length(arrayIN)) ;
[uniqDiffMat, rmInd] = unique(diffMat, 'stable');
findMat = diffMat == reshape(uniqDiffMat, [1, 1, numel(uniqDiffMat)]);
findMat = findMat(:, :, squeeze(sum(findMat, 2)~=1));
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
if nargout == 2
    matOut = struct2array(segmentsOUT);
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