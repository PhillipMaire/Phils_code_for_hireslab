%% only plot 'good' touches based on curature. can look at just high curve touches too.
% crush
% dateString1 = datestr(now,'yymmdd_HHMM');
plotRange = -100:200;
preToucBL = -30:-1;
barsTestRange = -100:100;
percentLow = 0; % softer (sometimes mismatched) touches
percentHigh = 1;% harder touches
getOnlyFirstTouch = false;
touchType = 'onset'; % onset offset all
allCellsTouch = {};
[SPout] = SPmaker(5, 9);
[SPout2] = SPmaker(5, 9);
smoothBy =10;% for determining significant region
numInARow = 5;%for significance must have 5 continious past the threshold
multPLotBy = 1000;% for skp/sec
removeSpikesInSignalLessThan = 0.5; %if SPK/s is lower than this is will be grayed out and considered insigificant

%%
title1 = sprintf(['smooth %d, numInARow %d'], smoothBy, numInARow);
%%
% alpha1 = 0.05;
stdThresh = 1.960;  % 1.645 is the 95th percentile; 1.960 is the 97.5th
minNumberOfValuesPerBin = 20;
%% times for masks
touch_M = [];
P_UP_M = [];
P_down_M = [];
P_UP_M = [];
P_down_M = [];
amp = [] ;
%% mask names
remLowerThan = 20; % any segment of below 20 made but chopping up the signal sue to the mask. will be removed
varNames = masky;
varNames = varNames(1:4)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
maskyExtraSettings = [{''} {''}  {''} {''}];
%%
theseCells = 1:length(U)
for cellStep = 4:45
    %%
    disp(num2str(cellStep))
    C = U{cellStep};
    %% make maske for pole up and down
    [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    % % %     [allMaskBL, maskDetailsBL] = masky(varNames, {[0:50], [], [], []}, C, 0, maskyExtraSettings);
    
    %% get the touches
    [allTouches, segments, protractionTouches, touchOrder] = GET_touches(C, touchType, getOnlyFirstTouch);
    
    %% select certain curvy touches
    %     [allTouches, curvyInds] = selectTouchesBasedOnCurvePercentile(C, allTouches, percentLow, percentHigh);
    %% get index for extracting time of interest
    [touchExtractInd, makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    [preTouchRegion, makeTheseNansPreTouch] = getTimeAroundTimePoints(allTouches, preToucBL, C.t);
    [testRegion, makeTheseNanstestRegion] = getTimeAroundTimePoints(allTouches, barsTestRange, C.t);
    
    %     [preTouchRegion, makeTheseNansPreTouch] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), preToucBL, C.t);
    
    %% get spikes and apply the mask
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    %% get the times of interest
    touchSpikes = spikes(touchExtractInd);
    touchSpikes(makeTheseNans) = nan;
    touchSpikes(sum(~isnan(touchSpikes), 2)<minNumberOfValuesPerBin, :) = nan;
    %     goodInds = find(~isnan(mean(touchSpikes, 1)));
    
    
    %     spikes = squeeze(C.R_ntk);
    PreTouchSpikes = spikes(preTouchRegion);
    PreTouchSpikes(makeTheseNansPreTouch) = nan;
    PreTouchSpikes(sum(~isnan(PreTouchSpikes), 2)<minNumberOfValuesPerBin, :) = nan;
    
    
    testRegionSpikes = spikes(testRegion);
    testRegionSpikes(makeTheseNanstestRegion) = nan;
    testRegionSpikes(sum(~isnan(testRegionSpikes), 2)<minNumberOfValuesPerBin, :) = nan;
    %% removeNanTrials
    
    
    %%
    [SPout] = SPmaker(SPout);
    y = smooth(nanmean(touchSpikes(:, :), 2), smoothBy);
    plot(plotRange, multPLotBy*y, 'k-')
    hold on ;
    axis tight
    
    PreTouchSpikes2 = smooth(nanmean(PreTouchSpikes, 2), smoothBy);
    
    
    %     SEM1 =2.*( nanstd( PreTouchSpikes2(:) )) / (sqrt( length( PreTouchSpikes2(:))));
    std1 =stdThresh.*( nanstd( PreTouchSpikes2(:) ));
    plot([xlim;xlim]', multPLotBy*(nanmean(PreTouchSpikes(:))+[std1, std1; -std1, -std1]'), '--g');
    axis tight
    highlightInds1 = []; highlightInds2 = [];
    
    %%
    
    %%
    try
        [~, matOut] = findInARowFINAL(y>(nanmean(PreTouchSpikes(:))+std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        [highlightInds1] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds1),multPLotBy* y(highlightInds1), 'b.');
    catch
    end
    try
        [~, matOut] = findInARowFINAL(y<(nanmean(PreTouchSpikes(:))-std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        [highlightInds2] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds2), multPLotBy*y(highlightInds2), 'r.');
    catch
    end
    if multPLotBy*nanmean(touchSpikes(:))<=removeSpikesInSignalLessThan|| multPLotBy*nanmean(PreTouchSpikes(:))<=0
        set(gca,'Color',[.5 .5 .5])
    end
    title(sprintf('BL %0.2f SIG %0.2f', multPLotBy*nanmean(PreTouchSpikes(:)), multPLotBy*nanmean(touchSpikes(:))))
    %%
    allCellsTouch{cellStep}.protractionTouches = protractionTouches;
    allCellsTouch{cellStep}.SIG = touchSpikes;
    allCellsTouch{cellStep}.segments = segments;
    allCellsTouch{cellStep}.BL = PreTouchSpikes;
    allCellsTouch{cellStep}.plotRange = plotRange;
    %     allCellsTouch{cellStep}.t = C.t;
    %     allCellsTouch{cellStep}.k = C.k;
    allCellsTouch{cellStep}.sigEcite = highlightInds1;
    allCellsTouch{cellStep}.sigInhibit = highlightInds2;
    allCellsTouch{cellStep}.isTooLowSPK = multPLotBy*nanmean(touchSpikes(:))<=removeSpikesInSignalLessThan || multPLotBy*nanmean(PreTouchSpikes(:))<=0;
    
    %%
    testRegSIG =nanmean(testRegionSpikes, 2);
    %     if length(find(round(1000*testRegSIG(:))~=0))>5 && length(find(round(1000*testRegSIG(:)>1)))>=1
    bp = defaultParams;
    %     bp.tau = 10
    bp.prior_id = 'POISSON'
    bp.dparams = 5;
    testRegBARS = barsP(round(1000*testRegSIG(:)), [1, length(testRegSIG)], size(testRegionSpikes, 2), bp);
    
    
    figure;
    
    plot(testRegBARS.confBands)
    hold on
    plot(testRegBARS.mean)
    plot(round(1000*testRegSIG(:)))
    figure
    testRegionSpikes(isnan(testRegionSpikes)) = 0;
    smoothingParam = [5, 2];
    test3 = imgaussfilt(testRegionSpikes', smoothingParam);
    test3 = fixGaussFilt(1000*test3, smoothingParam);
    imagescnan(test3)
    colormap(turbo)
    colorbar
    %     else
    %     end
    dummy=1
end

if saveOn
    fullscreen(SPout.mainFig)
    fn = ['touchResponse_', dateString1];
    saveFigAllTypes(fn, SPout.mainFig, saveDir, 'touchSTD.m');
end
%%
%{
saveName = 'allTouch_minSpkPerSecThreshold_STD_BL0to50noTouch'
dateString1 = datestr(now,'yymmdd_HHMM');
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
eval([saveName,    '= hibernatescript(''touchSTD.m'');'    ])
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\TOUCH')
fullscreen(SPout.mainFig)
SPout.mainFig.Name = eval(saveName);
fig2svg([saveName,  dateString1, '.svg'], SPout.mainFig)
%    close(SPout.mainFig)
save([saveName, dateString1], saveName)
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
% revivescript(funcString)
%}