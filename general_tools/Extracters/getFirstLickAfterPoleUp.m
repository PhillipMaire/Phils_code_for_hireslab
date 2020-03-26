function AL = getFirstLickAfterPoleUp(C)

AL = C.meta.beamBreakTimesMat - C.meta.poleOnset;
AL(AL<=0) = inf;
AL(isnan(AL)) = inf;
AL = nanmin(AL, [], 1);
AL = AL(~isinf(AL));