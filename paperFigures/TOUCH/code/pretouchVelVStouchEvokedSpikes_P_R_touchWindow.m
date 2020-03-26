%% pretouch velocity vs spikes evoked at touch
% what are spikes evoked at toucha nd how do i get them, same window or
% different winodw for each? for now the window will be 8:40ms
% so blocking out the BL doesnt really make much of a difference I think
% what to do is just have a large BL
function [] = pretouchVelVStouchEvokedSpikes_P_R_touchWindow(U, theseCells, V, type1)

% type1 1 for protraction 0 for retraction



numBins = 5;
smoothBy = 1;

extractRange = -400:100;
preTouchVelRange = -5:-1;
[~, preTouchInds, ~] = intersect(extractRange, preTouchVelRange);
touchWindow = 8:40;
[~, touchWindow, ~] = intersect(extractRange, touchWindow);
touchBL = -300:-50;
[~, touchBL, ~] = intersect(extractRange, touchBL);


BLtouch_M = 0:40;% mask for touches in the baseline period only
[~, BLtouch_M, ~] = intersect(extractRange, BLtouch_M);
BLOCK_TOUCHES_IN_BL = false;% masks out this is not really desirable becasue it doesnt change too much but makes
%everything rougher.
spout = SPmaker(3, 1);
betweenEdges = {};
spikes1 ={};
toPlot = {};
for k = theseCells
    C = U{k};
    
    V2 = V{3, k};
    V3 = getSignalRegionFromVarray(V2, extractRange);
    touchWindow =V3.SIGindsExtractRange;
    if ~any(isnan(touchWindow)) && V3.excitedResponse == type1
        
        spout = SPmaker(spout);
        
        
        [allTouches, segments, protractionTouches, touchOrder] = GET_touches(C, 'onset', false);
        [touchExtract,~,  nanInds] = getTimeAroundTimePoints(allTouches, extractRange, C.t, 'removenans');
        protractionTouches = protractionTouches(setdiff(1:length(protractionTouches), nanInds));
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
        for kk = 1:2
            if kk ==1
                PRinds = protractionTouches==1;
                color1 = 'b';
            else
                PRinds =  protractionTouches==0;
                color1 = 'r';
            end
            [spikes1{kk, k}, var1,edges] = binslin(preTouchVel(PRinds)', spikesEvoked(PRinds)', 'equalN', numBins);
            
            %         betweenEdges{kk, k} = (edges(1:end-1)+(diff(edges)./2))';
            betweenEdges{kk, k} = cellfun(@nanmean, var1);
            
            hold on
            toPlot{kk, k} = smooth(cellfun(@nanmean, spikes1{kk, k}), smoothBy);
            plot(betweenEdges{kk, k}', toPlot{kk, k}, [color1, '-o']);
            hold on
            axis tight
            
        end
        if spout.lastPlotTrigger == 1
            linkaxes(spout.mainFig.Children(:), 'x');
        end
        %     ylim([0 60])
        %     keyboard
    else
        %         keyboard
    end
end
[A1, H1] = supLabel_ALL('Pre-touch velocity dependent touch response','Pre-touch Velocity (degrees/ms)',  'Spikes/S', [], spout.allFigs);
% set(H1{1}, 'FontSize', 30)
% if nargin ==3 & varargin{1} == true

figure
remInds = ~cellfun(@isempty, toPlot);
if ~all(remInds(1, :)==remInds(1, :))
    error('something weird happened unevenprotraction and retraction plots ')
end
toPlot = reshape(toPlot(remInds), 2, []);
betweenEdges = reshape(betweenEdges(remInds), 2, []);
tmpColor = brewermap(20, 'RdBu');
TPval1 = .8;
TPval2 = .3;
colorCell = {[0 0 1], [1 0 0]}
h = {};
for kk = 1:2
    allEdges = cell2mat(betweenEdges(kk, :));
    allPlots = cell2mat(toPlot(kk, :));
    h{end+1} = plot(allEdges, allPlots, 'Color', [colorCell{kk},TPval2] , 'LineWidth', 2);
    edges = linspace(min(allEdges(:)), max(allEdges(:)), numBins+1);
    %     [n,edges,bin] = histcounts(allEdges(:) , edges);
    [allPlots2, var1,edges] = binslin(allEdges(:), allPlots(:), 'equalN', numBins);
    hold on
    betweenEdgesTMP = (edges(1:end-1)+(diff(edges)./2))';
    h{end+1} = plot(betweenEdgesTMP, cellfun(@(x) nanmean(x), allPlots2), 'Color', [colorCell{kk},TPval1], 'LineWidth', 2);
    h{end+1} = plot(betweenEdgesTMP, cellfun(@(x) nanmedian(x), allPlots2), 'Color', [colorCell{kk},TPval1], 'LineWidth', 2, 'lineStyle', '--');
end
% end
legend([h{1}(1), h{4}(1), h{2}, h{3}, h{5}, h{6}], ...
    'single cell protraction', 'single cell retraction', 'mean protraction', 'median protraction', 'mean retraction', 'median retraction')
[A1, H1] = supLabel_ALL('Pre-touch velocity dependent touch response','Pre-touch Velocity (degrees/ms)',  'Spikes/S', []);
