function [DM] = bumpConvUpdateDM(varName, sig, ...
    widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM)

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps);
% convolve
[convolvedMAT_all] = convolveSigWithBumps(allBumps, sig,widthBumps, bumpsOffset); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts-widthBumps./2+bumpsOffset];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
DM.basisFuncs = [DM.basisFuncs, {allBumps}];
DM.bumpOffset = [DM.bumpOffset,bumpsOffset];
DM.bumpWidth = [DM.bumpWidth, widthBumps];


