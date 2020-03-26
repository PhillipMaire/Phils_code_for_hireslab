%% pretouch velocity vs spikes evoked at touch
% what are spikes evoked at toucha nd how do i get them, same window or
% different winodw for each? for now the window will be 8:40ms
% third input is if we want a population average plot
function [] = pretouchVelVStouchEvokedSpikes(U, theseCells, varargin)
numBins = 10;
smoothBy = 1;

extractRange = -50:100;
preTouchVelRange = -10:-1;
[~, preTouchInds, ~] = intersect(extractRange, preTouchVelRange);
touchWindow = 8:40;
[~, touchWindow, ~] = intersect(extractRange, touchWindow);
touchBL = -33:-1;
[~, touchBL, ~] = intersect(extractRange, touchBL);

spout = SPmaker(3, 1);
betweenEdges = {};
spikes1 ={};
for k = theseCells(:)'
    spout = SPmaker(spout);
    C = U{k};
    
    [allTouches, segments, protractionTouches, touchOrder] = GET_touches(C, 'onset', false);
    [timeInds,~,  makeTheseNans] = getTimeAroundTimePoints(allTouches, extractRange, C.t, 'removenans');
    % timeInds =
    Vel = squeeze(C.S_ctk(2, :, :))./1000;
    
    preTouchVel = nanmean(Vel(timeInds(preTouchInds, :)));
    
    spikes = squeeze(C.R_ntk)*1000;
    touchSpikes = nanmean(spikes(timeInds(touchWindow, :)));
    BLspikes = nanmean(spikes(timeInds(touchBL, :)));
    
    spikesEvoked = (touchSpikes-BLspikes);
    length(touchBL)
    
    [spikes1{k}, var1,edges] = binslin(preTouchVel(:), spikesEvoked(:), 'equalN', numBins);
    
    betweenEdges{k} = (edges(1:end-1)+(diff(edges)./2))';
    
    toPlot{k} = smooth(cellfun(@nanmean, spikes1{k}), smoothBy);
    plot(betweenEdges{k}, toPlot{k}, 'b-o');
    hold on
    axis tight
    linkaxes(spout.mainFig.Children(:), 'x')
    
    %     keyboard
end
[A1, H1] = supLabel_ALL('velocity dependent spike','Pre-touch Velocity (units)',  'Spikes/S', []);

if nargin ==3 && varargin{1} == true
    
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
% set(H1{1}, 'FontSize', 30)





