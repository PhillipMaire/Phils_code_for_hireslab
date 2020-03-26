%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
crush
plotRange = -25:100;
percentLow = 0; % softer (sometimes mismatched) touches
percentHigh = 1;% harder touches
getOnlyFirstTouch = false;
touchType = 'onset'; % onset offset all
allCellsTouch = {};

for cellStep = 1:length(U)
    %%
    disp(num2str(cellStep))
    C = U{cellStep};
    %% make maske for pole up and down
    [poleUP_linInds, poleUP_masktrials, poleUP_maskTimes] = mask(C.meta.poleOnset, ...
        0:100,               C.t, C.k);
    [poleDOWN_linInds, poleDOWN_masktrials, poleDOWN_maskTimes] = mask(C.meta.poleOffset, ...
        0:100,               C.t, C.k, [], 'trialTime');
    %% combine masks
    allMask = unique([poleUP_linInds(:);poleDOWN_linInds(:)]);
    %% get the touches
    [allTouches, segments, protractionTouches] = GET_touches(C, touchType, getOnlyFirstTouch);
    %% select certain curvy touches
    %     [allTouches, curvyInds] = selectTouchesBasedOnCurvePercentile(C, allTouches, percentLow, percentHigh);
    %% get index for extracting time of interest
    [touchMaskInd, makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    %% get spikes and apply the mask
    spikes = squeeze(C.R_ntk) .* 1000;
    spikes(allMask) = nan;
    %% get the time of interest
    touchSpikes = spikes(touchMaskInd);
    touchSpikes(makeTheseNans) = nan;
    %% only protraction touches or retraction touches
    %     touchSpikes = touchSpikes(:, protractionTouches);
    %%
    allCellsTouch{cellStep}.protractionTouches = protractionTouches;
    allCellsTouch{cellStep}.touchSpikes = touchSpikes;
    allCellsTouch{cellStep}.segments = segments;
    allCellsTouch{cellStep}.poleUP_linInds = poleUP_linInds;
    allCellsTouch{cellStep}.poleDOWN_linInds = poleDOWN_linInds;
    allCellsTouch{cellStep}.t = C.t;
    allCellsTouch{cellStep}.k = C.k;
    %%
    figure;plot(plotRange, nanmean(touchSpikes(:, protractionTouches), 2))
    hold on ;plot(plotRange, nanmean(touchSpikes(:, ~protractionTouches), 2))
end
