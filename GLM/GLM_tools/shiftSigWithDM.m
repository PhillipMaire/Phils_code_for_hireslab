function [DM] = shiftSigWithDM(sig, shifts, DM, varName) 

XtoADD = [];
for k = 1:length(shifts)
    tmp1 = circshiftNAN(sig, shifts(k));
%     tmp1(isnan(tmp1)) = 0;
    XtoADD  = [XtoADD , tmp1(:)];
end

%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, XtoADD];
DM.timePoints = [DM.timePoints, shifts];
DM.numInEachLabel = [DM.numInEachLabel, length(shifts)];
DM.basisFuncs = [DM.basisFuncs, {ones(1, length(shifts))}];
DM.bumpOffset = [DM.bumpOffset,shifts(1)];
DM.bumpWidth = [DM.bumpWidth, 1];
