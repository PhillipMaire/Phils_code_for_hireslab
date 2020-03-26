%% pretouch velocity vs spikes evoked at touch
% what are spikes evoked at toucha nd how do i get them, same window or
% different winodw for each? for now the window will be 8:40ms
% so blocking out the BL doesnt really make much of a difference I think
% what to do is just have a large BL
function [] = pretouchVelVStouchEvokedSpikes(U, theseCells, varargin)

numBins = 12;
smoothBy = 1;

extractRange = -400:100;
preTouchVelRange = -10:-1;
[~, preTouchInds, ~] = intersect(extractRange, preTouchVelRange);
touchWindow = 8:40;
[~, touchWindow, ~] = intersect(extractRange, touchWindow);
touchBL = -300:-50;
[~, touchBL, ~] = intersect(extractRange, touchBL);


BLtouch_M = 0:40;% mask for touches in the baseline period only
[~, BLtouch_M, ~] = intersect(extractRange, BLtouch_M);
BLOCK_TOUCHES_IN_BL = false;% tuens out this is not really desirable becasue it doesnt change too much but makes
%everything rougher.
spout = SPmaker(3, 1);
betweenEdges = {};
spikes1 ={};
for k = theseCells
    spout = SPmaker(spout);
    C = U{k};
    
    [allTouches, segments, protractionTouches, touchOrder] = GET_touches(C, 'onset', false);
    [touchExtract,~,  nanInd] = getTimeAroundTimePoints(allTouches, extractRange, C.t, 'removenans');
    % timeInds =
    Vel = squeeze(C.S_ctk(2, :, :))./1000;
    
    preTouchVel = nanmean(Vel(touchExtract(preTouchInds, :)));
    
    spikes = squeeze(C.R_ntk)*1000;
    Tspikes = spikes(touchExtract);
    if BLOCK_TOUCHES_IN_BL
        tmp1 = touchExtract(BLtouch_M, :);
        % find the indexes of the intersect
        v = intersect(touchExtract,tmp1);
        BLtouchMask = ismember(touchExtract,v);
        BLtouchMask(find(extractRange==0):end, :) = 0;%dont include the signal period
        Tspikes(BLtouchMask) = nan;
    end
    
    sig1 = nanmean(Tspikes(touchWindow, :));
    BL1 = nanmean(Tspikes(touchBL, :));
    spikesEvoked = (sig1 - BL1);
    
    [spikes1{k}, var1,edges] = binslin(preTouchVel(:), spikesEvoked', 'equalN', numBins);
    
    betweenEdges{k} = (edges(1:end-1)+(diff(edges)./2))';
    
    
    hold on
    
    plot(betweenEdges{k}', smooth(cellfun(@(x) nanmean(x), spikes1{k}), smoothBy), 'b-o');
    hold on
    axis tight
    linkaxes(spout.mainFig.Children(:), 'x')
    %     ylim([0 60])
    %     keyboard
end
[A1, H1] = supLabel_ALL('velocity dependent spike','Pre-touch Velocity (units)',  'Spikes/S', []);
% set(H1{1}, 'FontSize', 30)
if nargin ==3 & varargin{1} == true
    
    figure
    toPlot = toPlot(~cellfun(@isempty, toPlot));
    betweenEdges = betweenEdges(~cellfun(@isempty, betweenEdges));
    allEdges = cell2mat(betweenEdges);
    allPlots = cell2mat(toPlot);
    plot(allEdges, allPlots, 'Color', [.5 .5 .5, .5], 'LineWidth', 2);
    edges = linspace(min(allEdges(:)), max(allEdges(:)), numBins+1);
    [n,edges,bin] = histcounts(allEdges(:) , edges)
    [allPlots2, var1,edges] = binslin(allEdges(:), allPlots(:), 'equalN', numBins);
    hold on
    betweenEdgesTMP = (edges(1:end-1)+(diff(edges)./2))';
    plot(betweenEdgesTMP, cellfun(@(x) nanmean(x), allPlots2), 'Color', [1, 0, 0, .5], 'LineWidth', 2);
    plot(betweenEdgesTMP, cellfun(@(x) nanmedian(x), allPlots2), 'Color', [1, 0, 1, .5], 'LineWidth', 2);
    
end