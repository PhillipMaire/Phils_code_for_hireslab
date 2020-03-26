%% for cellStep = 1:length(U)
close all
%%
plotRange = -200:200;
zeroPoint = find(plotRange==0);
addToZeroPoint = 3:8;
cellStep = 36
%     %%
disp(num2str(cellStep))
cellTMP = U{cellStep};
%     %% make maske for pole up and down
poleMaskTime = 0:200;
makeLinInds = ((0:cellTMP.k -1) .* 4000)';
makeLinInds = repmat(makeLinInds, [1, length(poleMaskTime)]);
poleU = ((cellTMP.meta.poleOnset)'+poleMaskTime);
poleD = ((cellTMP.meta.poleOffset)'+poleMaskTime);
poleU(find(poleU >cellTMP.t)) = cellTMP.t;
poleD(find(poleD >cellTMP.t)) = cellTMP.t;
poleU = poleU +makeLinInds;
poleD = poleD +makeLinInds;

poleMask = ones(cellTMP.t, cellTMP.k);
poleMask(poleD) = nan;
poleMask(poleU) = nan;
%     %%
touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
%     touchLateOnset = touchFirstOnset(1); % plot only the first touches
allTouches = unique([touchFirstOnset; touchLateOnset]);


touchFirstOFF = find(squeeze(cellTMP.S_ctk(9+1,:,:))==1);
touchLateOFF = find(squeeze(cellTMP.S_ctk(12+1,:,:))==1);
%     touchLateOnset = touchFirstOnset(1); % plot only the first touches
allTouchesOFF = unique([touchFirstOFF; touchLateOFF]);
%     %%

figure

curve = squeeze(cellTMP.S_ctk(6,:,:));
curveTouch = curve(allTouches+(plotRange));
% % % SET HIGH VALUES TO LOWER MAX
toFindOutliersMAT = curveTouch>0.06;
outliear = isoutlier(curveTouch(toFindOutliersMAT));
outlierINDS = find(toFindOutliersMAT);
curveTouch(outlierINDS(outliear)) = max(max(~(curveTouch(toFindOutliersMAT))));
% % % 
trials = ceil(allTouches./4000);
imagesc(curveTouch)
%     %%

[sorted, index]=sort(nanmean(curveTouch(:, addToZeroPoint+zeroPoint), 2))
%     %%
%%%
figure
% curve = squeeze(cellTMP.S_ctk(6,:,:));
% curveTouch = curve(allTouches+(plotRange));

curveTouch2 = curveTouch(index, :);
imagesc(curveTouch2)
trialsSorted = trials(index);


findNormal= abs(sorted-nanmedian(sorted));
figure;(plot(findNormal))
indexNrmaltouches = find(findNormal<=0.01);



%

findNormal= abs(nanmean(curveTouch(:, addToZeroPoint+zeroPoint), 2)-nanmedian(nanmean(curveTouch(:,addToZeroPoint+zeroPoint), 2)));
figure;(plot(sort(findNormal)))
indexNrmaltouches2 = find(findNormal<=0.01);








% end