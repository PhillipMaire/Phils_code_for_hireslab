% distance between two lines (uses shorter line to define comaprison points

function [MeanDist, numPtsCompared,smallLineDists,  indLocFINALtoLargeLine, largeLine, smallLine] = distBet2Lines (line1, line2)
% mean dist is the measure of seperation of the 2 lines
% num points is equal to the length of the smallest line
% smallLineDists are the individual distances of the small line (in order) to the large lines closest points
% which correspond to the next variable (indLocFINALtoLargeLine)
% indLocFINALtoLargeLine is the respective ind on the large line which have the shortest distance to
% that point on the small line. So if indLocFINALtoLargeLine(1) == 3, then the first point on the
% small line is closest to the 3rd point on the large line. 
% the last two are the outputs of the lines large and small so you can use the inds vairables

% combine the lines and determine the smallest line
[~, dontTurn] = max(size(line1))
if dontTurn~= 1 
    line1 = line1';
end
[~, dontTurn] = max(size(line2))
if dontTurn~= 1 
    line2 = line2';
end
    
setTo(1) = size(line1,1);
setTo(2) = size(line2,1);
[~, dim2use] = min(setTo);
lineComb = [line1; line2];
% indicate the large and small line
if dim2use ==1
    smallLine = line1; largeLine = line2;
elseif dim2use ==2
    largeLine = line1; smallLine = line2;
end
% get all the distances and then get the matrix comparing just the two lines (NOT comparing line1
% points to other line1 ponts. 
Ds = pdist(lineComb);
Zs = squareform(Ds);
L1L2dists = Zs(1:setTo(1),setTo(1)+1:end);

[dists1, indLoc] = min(L1L2dists, [], dim2use);
[smallLineDists, indDist2] = sort(dists1);
indLocFINALtoLargeLine = indLoc(indDist2);
% get the final distances 
smallLineDists = smallLineDists(1:setTo(dim2use));
indLocFINALtoLargeLine = indLocFINALtoLargeLine(1:setTo(dim2use));
MeanDist = mean(smallLineDists);
numPtsCompared = setTo(dim2use);
end