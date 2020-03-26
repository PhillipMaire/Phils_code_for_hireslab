%% only plot 'good' touches based on curature. can look at just high curve touches too.
% crush
% dateString1 = datestr(now,'yymmdd_HHMM');
plotRange = -25:50;
preToucBL = -25:-1;
prePoleBL = -400:-20;
percentLow = 0; % softer (sometimes mismatched) touches
percentHigh = 1;% harder touches
getOnlyFirstTouch = false;
touchType = 'onset'; % onset offset all
allCellsTouch = {};
[SPout] = SPmaker(5, 9);
[SPout2] = SPmaker(5, 9);

smoothBy = 5;
%% times for masks
touch_M = [];
P_UP_M = 0:100;
P_down_M = 0:100;
amp = [] ;
%% mask names
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:4)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
maskyExtraSettings = [{''} {''}  {''} {''}];
%%
for cellStep = 1:length(U)
    %%
    disp(num2str(cellStep))
    C = U{cellStep};
    %% make maske for pole up and down
    [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    %% get the touches
    [allTouches, segments, protractionTouches] = GET_touches(C, touchType, getOnlyFirstTouch);
    %% select certain curvy touches
    %     [allTouches, curvyInds] = selectTouchesBasedOnCurvePercentile(C, allTouches, percentLow, percentHigh);
    %% get index for extracting time of interest
    [touchExtractInd, makeTheseNans] = getTimeAroundTimePoints(allTouches, plotRange, C.t);
    [preTouchRegion, makeTheseNansPreTouch] = getTimeAroundTimePoints(allTouches, preToucBL, C.t);
    %% get spikes and apply the mask
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    %% get the times of interest
    touchSpikes = spikes(touchExtractInd);
    touchSpikes(makeTheseNans) = nan;
    PreTouchSpikes = spikes(preTouchRegion);
    PreTouchSpikes(makeTheseNansPreTouch) = nan;
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
    %% removeNanTrials
    
    
    %%
    [SPout] = SPmaker(SPout);
    y = 1000*nanmean(touchSpikes(:, :), 2);
    plot(plotRange, smooth(y, smoothBy), 'b-')
    hold on ;
    axis tight
%     [SPout2] = SPmaker(SPout2);
%     y = 1000*nanmean(touchSpikes(:, ~protractionTouches), 2);
%     plot(plotRange, smooth(y, smoothBy), 'r-')
%     hold on ;
    axis tight
    %%
    figure(SPout.mainFig)
    preTouchBL =PreTouchSpikes(:, :);
    [CI, sizeCI] = philsCIs(preTouchBL(:) ,.05, size(preTouchBL, 2));
    plot([xlim;xlim]', 1000*(nanmean(preTouchBL(:))+[sizeCI, sizeCI; -sizeCI, -sizeCI]'), '--b');
    
%     figure(SPout2.mainFig)
%     preTouchBL =PreTouchSpikes(:, ~protractionTouches);
%     [CI, sizeCI] = philsCIs(preTouchBL(:) ,.05, size(preTouchBL, 2));
%     plot([xlim;xlim]', 1000*(nanmean(preTouchBL(:))+[sizeCI, sizeCI; -sizeCI, -sizeCI]'), '--r');
    % % % % % % % % % % % % % % % % % % % % % % % %     figure(SPout.mainFig)
    % % % % % % % % % % % % % % % % % % % % % % % %     preTouchBL =PreTouchSpikes(:, protractionTouches);
    % % % % % % % % % % % % % % % % % % % % % % % %     sizeCI = nanstd(preTouchBL(:))
    % % % % % % % % % % % % % % % % % % % % % % % %     plot([xlim;xlim]', 1000*(nanmean(preTouchBL(:))+[sizeCI, sizeCI; -sizeCI, -sizeCI]'), '--b');
    % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % %     figure(SPout2.mainFig)
    % % % % % % % % % % % % % % % % % % % % % % % %     preTouchBL =PreTouchSpikes(:, ~protractionTouches);
    % % % % % % % % % % % % % % % % % % % % % % % %     sizeCI = nanstd(preTouchBL(:))
    % % % % % % % % % % % % % % % % % % % % % % % %     plot([xlim;xlim]', 1000*(nanmean(preTouchBL(:))+[sizeCI, sizeCI; -sizeCI, -sizeCI]'), '--r');
    
    
    %     [CI, sizeCI] = philsCIs(prePoleSpikes(:) ,.05, size(prePoleSpikes, 2));
    %     plot([xlim;xlim]', 1000*(nanmean(preTouchBL(:))+[sizeCI, sizeCI; -sizeCI, -sizeCI]'), '--y')
    
    %         keyboard
    % % %         %% plot backgrounds first
    % % %     backGroundOpacity = 0.07;
    % % %     lineProps. col = {'r'};
    % % %     lineProps.opacity = backGroundOpacity;
    % % %     yCI95 = reshape(yCI95, [size(yMean), 2]);
    % % %
    % % %     x = [plotRange(:); plotRange(:)];
    % % %     y = [1000*nanmean(touchSpikes(:, ~protractionTouches), 2); ...
    % % %         1000*nanmean(touchSpikes(:, protractionTouches), 2)];
    % % %     mseb(x,y,  yCI95)
    % % %
    % % %
    % % %     [CI, sizeCI] = philsCIs(PreTouchSpikes(:) ,.05)
    % % %
    % % %     x = plotRange;
    % % %     y = (touchSpikes(:, protractionTouches))';
    % % %
    % % %
    % % %
    % % %
    % % %     N = size(y,1);                                      % Number of ‘Experiments’ In Data Set
    % % %     yMean = nanmean(y);                                    % Mean Of All Experiments At Each Value Of ‘x’
    % % %     ySEM = nanstd(y)/sqrt(N);                              % Compute ‘Standard Error Of The Mean’ Of All Experiments At Each Value Of ‘x’
    % % %     CI95 = tinv([0.025 0.975], N-1);                    % Calculate 95% Probability Intervals Of t-Distribution
    % % %     yCI95 = bsxfun(@times, ySEM, CI95(:));              % Calculate 95% Confidence Intervals Of All Experiments At Each Value Of ‘x’
    % % %     figure
    % % %     plot(x, yMean)                                      % Plot Mean Of All Experiments
    % % %     hold on
    % % %
    % % %     %%
    % % %     plot(x, yCI95+yMean)                                % Plot 95% Confidence Intervals Of All Experiments
    % % %     hold off
    % % %     grid
    % % %     %%
    % % %
    % % %
    % % %     %% plot backgrounds first
    % % %     backGroundOpacity = 0.07;
    % % %     lineProps. col = {'r'};
    % % %     lineProps.opacity = backGroundOpacity;
    % % %     yCI95 = reshape(yCI95, [size(yMean), 2]);
    % % %     mseb(x(:)',yMean(:),  yCI95)
    %%
end
%%


% keyboard
cd('C:\Users\maire\Downloads\tmpsave')
% sdf(gcf, 'default18')
fullscreen

%    saveas(gcf, ['touch_and95%_CI_', num2str(dateString1),'.svg'])
%    saveas(gcf, [svName, '_', num2str(dateString1),'EqualN.svg'])