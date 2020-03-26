function [poleMask]  = MASK_pole(cellTMP, poleMaskTimeUP, poleMaskTimeDOWN)
poleMask = ones(cellTMP.t, cellTMP.k);
if ~isempty(poleMaskTimeUP)
    makeLinInds = ((0:cellTMP.k -1) .* cellTMP.t)';
    makeLinInds = repmat(makeLinInds, [1, length(poleMaskTimeUP)]);
    poleU = ((cellTMP.meta.poleOnset)'+poleMaskTimeUP);
    poleU(find(poleU >cellTMP.t)) = cellTMP.t;
    poleU = poleU +makeLinInds;
    
    poleMask(poleU) = nan;
end
if ~isempty(poleMaskTimeDOWN)
    
    makeLinInds = ((0:cellTMP.k -1) .* cellTMP.t)';
    makeLinInds = repmat(makeLinInds, [1, length(poleMaskTimeDOWN)]);
    poleD = ((cellTMP.meta.poleOffset)'+poleMaskTimeDOWN);
    poleD(find(poleD >cellTMP.t)) = cellTMP.t;
    poleD = poleD +makeLinInds;
    poleMask(poleD) = nan;
    
    poleMask(poleU) = nan;
    
end







