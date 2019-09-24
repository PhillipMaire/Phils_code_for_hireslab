function [DM] = combineVarsDM = (DM, toCombine, varName)
% toCombine is a vector with 3 numbers 1 and 2 are the variables that will combine
M = toCombine;

L = length(DM.label);
[min1, minInd] = min(DM.bumpOffset(M));
[max1, maxInd] = max(DM.bumpOffset(M));
R1 = range(DM.bumpOffset(M));
keepInds = setdiff(1:L, M(2));

DM.label{M(1)} = varName;
DM.label = DM.label(keepInds);

DM.numInEachLabel(M(1)) = sum(DM.numInEachLabel(M(1)), DM.numInEachLabel(M(2)));
DM.numInEachLabel = DM.numInEachLabel(keepInds);

DM.bumpOffset(M(1)) = min1;
DM.bumpOffset = DM.bumpOffset(keepInds);

DM.basisFuncs{M(1)} = [circshiftNAN(DM.basisFuncs{M(maxInd)}), DM.basisFuncs{M(minInd)}+R1];
DM.basisFuncs = DM.basisFuncs(keepInds);

if DM.bumpWidth(M(1)) == DM.bumpWidth(M(2))
    DM.bumpWidth = DM.bumpWidth(keepInds);
elseif any(DM.bumpWidth(M) == 1)
    error('you can not combine these 2 types of variables!!one has a basis function the other does not!')
else
    DM.bumpWidth(M(1)) = inf; % they dont match so this variables has depreciated.
    % the basis function plotter program only used this term to determine if it is a basis function
    % variable or not.
    DM.bumpWidth = DM.bumpWidth(keepInds);
end
