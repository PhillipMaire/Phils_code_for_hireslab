function [latency1, poleOnsetTriggeredWhiskingLatency] = getPoleTriggeredWhiskingOnsets(C, limits1, poleString)
% OnsetsALL_CELLS
% look in this region relitive to onset of pole
% limits1 = [0, 400];
if strcmpi(poleString, 'poleUP')
    poleType = C.meta.poleOnset(:)
elseif strcmpi(poleString, 'poleDOWN')
    poleType = C.meta.poleOffset(:);
    poleType(poleType>C.t) = nan;
else
    error('pole string must be either poleUP or poleDOWN')
end
% Wsegs =C.whiskOnset.segmentsFinal;
Wsegs = [];
Wsegs(:, 4) = C.whiskOnset.trialNums;
Wsegs(:, 3) = C.whiskOnset.trialTimeONSETS;
% C.whiskOnset.trialNums


poleOnsetTriggeredWhiskingLatency = nan(length(poleType(:)), 1);
for k = 1:length(poleType(:))
    tmp2 = Wsegs(find(Wsegs(:, 4)==k), :);
    tmp3 = poleType(k)+limits1;
    ind1 = find(tmp2(:, 3)>tmp3(1) & tmp2(:, 3)<tmp3(end));
    if ~isempty(ind1)
        poleOnsetTriggeredWhiskingLatency(k) = tmp2(ind1(1), 3);
    end
    
end
latency1 = poleOnsetTriggeredWhiskingLatency(:) - poleType(:);

if length(poleOnsetTriggeredWhiskingLatency)~= C.k
    keyboard % make sure there are exactly as many trials as onsets
end
%%
% figure;hist(latency1, 100)
