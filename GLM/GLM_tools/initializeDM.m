function DM = initializeDM(C)

DM = struct;
DM.x = [];
DM.y = squeeze(C.R_ntk);
DM.y =DM.y(:);
DM.timePoints = [];
DM.label = {};
DM.numInEachLabel = [];
DM.basisFuncs = {};
DM.bumpOffset = [];
DM.bumpWidth = [];