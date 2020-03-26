%% for now lets not pay attention to the protraction vs retraction touches
% close all
function adaptationITI(U, theseCells)
extractRange = -400:200;
SIGrange = 8:40;
BLrange = -300:-0;
XdisRange = [0, 300];

smoothBy = 0;
numBins = 10;
maxITItoInclude = 500;


[~, SIGrange, ~] = intersect(extractRange, SIGrange);
[~, BLrange, ~] = intersect(extractRange, BLrange);

% times for masks
BL_touch_M = 0:100;
[~, BL_touch_M, ~] = intersect(extractRange, BL_touch_M);

sig_touch_M = [];
P_UP_M = 0:100;
P_down_M = 0:100;
amp = [] ;

% mask names
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:4)
maskyExtraSettings = [{''} {''} {''} {'>5'}];
rangeOfMask = [{sig_touch_M} {P_UP_M} {P_down_M}, {amp}];


s = SPmaker(3, 1);
diff1 = {};
diff1FT = {};
betweenEdges = {};
for k = theseCells
    s = SPmaker(s);
    
    hold on
    C = U{k};
    [sigMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    
    
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] =...
        GET_touches(C, 'onset', false);
    %     touchOrder2 = touchOrder;
    U1 = unique(touchOrder);
    firstTouchInds = interTouchInterval==0;
    interTouchInterval(firstTouchInds) = nan;%where should first touches go? at 0 or 4000 or a seperate line?
    [touchExtract, touch_makeTheseNans] = ...
        getTimeAroundTimePoints(allTouches, extractRange, C.t);
    
    
    
    tmp1 = touchExtract(BL_touch_M, :);
    % find the indexes of the intersect
    v = intersect(touchExtract,tmp1);
    bmin = ismember(touchExtract,v);
    bmin(find(extractRange==0):end, :) = 0;%dont include the signal period
    BLtouchMask = find(bmin);
    
    
    spikes = squeeze(C.R_ntk).*1000;
    spikes(sigMask) = nan;
    
    Tspikes = spikes(touchExtract);
    Tspikes(touch_makeTheseNans) = nan;
    Tspikes(BLtouchMask) = nan;
    
    [touchOspikes, ITI1,edges] = binslin(interTouchInterval, Tspikes', 'equalN', numBins);
    
    betweenEdges{k} = (edges(1:end-1)+(diff(edges)./2))';
    
    sig1 = cellfun(@(x) nanmean(nanmean(x(:, SIGrange))), touchOspikes);
    BL1 = cellfun(@(x) nanmean(nanmean(x(:, BLrange))), touchOspikes);
    diff1{k} = sig1 - BL1;
    
    TspikesFirstTouch  = Tspikes(:, firstTouchInds);
    sig1FT = nanmean(nanmean(TspikesFirstTouch(SIGrange, :)));
    BL1FT = nanmean(nanmean(TspikesFirstTouch(BLrange, :)));
    diff1FT{k} = sig1FT - BL1FT;
    %     diff1 = sig1- BL1;
    
    plot([0, (betweenEdges{k}(1))],[diff1FT{k}, diff1{k}(1)] , 'o-r');
    plot(betweenEdges{k}, diff1{k}, '-o')
    
    axis tight
    linkaxes(s.mainFig.Children(:), 'x')
    
    
    
    %
    %         plot([0, log2(betweenEdges(1))],[diff1FT, diff1(1)] , 'o-r');
    %
    %         plot(log2(betweenEdges), diff1, '-o')
    %         xlim([0 log2(1024)])
    %         xt = get(gca, 'XTick');
    %         set (gca, 'XTickLabel', 2.^xt);
    

    
end

[A1, H1] = supLabel_ALL('Adaptation','Inter-Touch Interval',  'Spikes/S', [], s.allFigs);
%%
% tmpColor = brewermap(100, 'PuRd');
% R1 = tmpColor(65, :);
tpVal = .2;
tpVal2 = .7;
R1 = [1 0 0 tpVal];
gray1 = [.5 .5 .5 tpVal];

if true
    diff2 = cell2mat(diff1(~cellfun(@isempty, diff1)));
    diff2FT = cell2mat(diff1FT(~cellfun(@isempty, diff1FT)));
    betweenEdges2 = cell2mat(betweenEdges(~cellfun(@isempty, betweenEdges)));
    
%     crush
    figure; hold on
    
    plot([zeros(size(betweenEdges2(1,:))); betweenEdges2(1,:)], ...
        [diff2FT; diff2(1, :)],...
        '-', 'Color', [R1], 'LineWidth', 2)
    
    h = scatter([zeros(size(betweenEdges2(1,:))), betweenEdges2(1,:)], [diff2FT, diff2(1, :)]);
    h.MarkerEdgeColor = 'none';
    h.MarkerFaceColor = R1(1:3);
    h.MarkerFaceAlpha = tpVal;
    [h, ~] = scatterW(h);
    
    plot(betweenEdges2, diff2,'-', 'Color', [gray1], 'LineWidth', 2)
    
    h = scatter(betweenEdges2(:), diff2(:));
    h.MarkerEdgeColor = 'none';
    h.MarkerFaceColor = gray1(1:3);
    h.MarkerFaceAlpha = tpVal;
    [h, ~] = scatterW(h);
    
    
    [diff3, var1,edges] = binslin(betweenEdges2(:), diff2(:), 'equalN', numBins);
    betweenEdgesTMP = (edges(1:end-1)+(diff(edges)./2))';
    
    
    plot([0, betweenEdgesTMP(1)], [nanmean(diff2FT), nanmean(diff3{1})],...
        '-', 'Color', R1(1:3), 'LineWidth', 2)
    
    h = scatter([0, betweenEdgesTMP(1)], [nanmean(diff2FT), nanmean(diff3{1})]);
    h.MarkerEdgeColor = 'none';
    h.MarkerFaceColor = R1(1:3);
    h.MarkerFaceAlpha = tpVal2;
    [h, ~] = scatterW(h);
    
    
    
    plot(betweenEdgesTMP, cellfun(@(x) nanmean(x), diff3), 'Color', [0, 0, 0, tpVal2], 'LineWidth', 2);
    %     plot(betweenEdgesTMP, cellfun(@(x) nanmedian(x), diff3), 'Color', [1, 0, 1, .5], 'LineWidth', 2);
    h = scatter(betweenEdgesTMP, cellfun(@(x) nanmean(x), diff3));
    h.MarkerEdgeColor = 'none';
    h.MarkerFaceColor = [0 0 0];
    h.MarkerFaceAlpha = tpVal2;
    [h, ~] = scatterW(h);
    
    
    
    
end