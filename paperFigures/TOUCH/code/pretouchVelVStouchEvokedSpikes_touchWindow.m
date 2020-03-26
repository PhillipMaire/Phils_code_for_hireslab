%% pretouch velocity vs spikes evoked at touch
% what are spikes evoked at toucha nd how do i get them, same window or
% different winodw for each? for now the window will be 8:40ms
% so blocking out the BL doesnt really make much of a difference I think
% what to do is just have a large BL

function [] = pretouchVelVStouchEvokedSpikes_touchWindow(U, theseCells, V, type1)

% type1 1 for protraction 0 for retraction set to 2 to ignore it
LIMIT_VEL_TO_ABS_MAX = 3%3%2.75;


numBins = 30;
smoothBy = 1;
XvalType = 2; % see this ecplained below
extractRange = -400:100;
preTouchVelRange = -5:-1;
[~, preTouchInds, ~] = intersect(extractRange, preTouchVelRange);
% touchWindow = 8:40;
% [~, touchWindow, ~] = intersect(extractRange, touchWindow);
touchBL = -300:-50;
[~, touchBL, ~] = intersect(extractRange, touchBL);
rastXlims = -25:50;
[~, rastXlimsCUT, ~] = intersect(extractRange, rastXlims);


BLtouch_M = 0:40;% mask for touches in the baseline period only
[~, BLtouch_M, ~] = intersect(extractRange, BLtouch_M);
BLOCK_TOUCHES_IN_BL = false;% masks out this is not really desirable becasue it doesnt change too much but makes
%everything rougher.
spdim1 = 3;
spdim2 = 1;
spout = SPmaker(spdim1, spdim2);
spout2 = SPmaker(spdim1, spdim2);

betweenEdges = {};
spikes1 ={};
% Nums1 = {};
toPlot = {};
sortedRastCell = {};
sortedVel = {};
Twin = {};
touchWindow = {};
for k = theseCells
    C = U{k};
    
    V2 = V{3, k};
    V3 = getSignalRegionFromVarray(V2, extractRange);
    touchWindow{k} =V3.SIGindsExtractRange;
    Twin{k} = V3.SIGinds;
    if ~any(isnan(touchWindow{k})) && (V3.excitedResponse == type1 || type1 == 2)
        
        spout = SPmaker(spout);
        
        
        [allTouches, segments, protractionTouches, touchOrder] = GET_touches(C, 'onset', false);
        [touchExtract,~,  nanInds] = getTimeAroundTimePoints(allTouches, extractRange, C.t, 'removenans');
        protractionTouches = protractionTouches(setdiff(1:length(protractionTouches), nanInds));
        % timeInds =
        Vel = squeeze(C.S_ctk(2, :, :))./1000;
        
        preTouchVel = nanmean(Vel(touchExtract(preTouchInds, :)));
        limitMaxInds = preTouchVel<-LIMIT_VEL_TO_ABS_MAX | preTouchVel>LIMIT_VEL_TO_ABS_MAX;
        preTouchVel(limitMaxInds)= LIMIT_VEL_TO_ABS_MAX*(preTouchVel(limitMaxInds)./abs(preTouchVel(limitMaxInds)));
        
        LIMIT_VEL_TO_ABS_MAX
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
        
        sig1 = nanmean(Tspikes(touchWindow{k}, :));
        BL1 = nanmean(Tspikes(touchBL, :));
        spikesEvoked = (sig1 - BL1);
        
        [spikes1{1, k}, var1,edges] = binslin(preTouchVel', spikesEvoked', 'equalN', numBins);
%         [Nums1{1, k}, var1,edges] = binslin(preTouchVel', (1:length(preTouchVel))', 'equalN', numBins);
        
        [sortedVel{1, k}, sortedInds] = sort(preTouchVel);
        sortedRastCell{1, k} = Tspikes(:, sortedInds);
        
        if XvalType == 1 %use midpoint between edges
            betweenEdges{1, k} = (edges(1:end-1)+(diff(edges)./2))';
        elseif XvalType == 2 % use the mean of the xvals
            betweenEdges{1, k} = cellfun(@nanmean, var1);
        end
        
        hold on
        toPlot{1, k} = smooth(cellfun(@nanmean, spikes1{1, k}), smoothBy);
        plot(betweenEdges{1, k}', toPlot{1, k}, ['k-o']);
        hold on
        axis tight
        if spout.lastPlotTrigger == 1
            linkaxes(spout.mainFig.Children(:), 'x');
        end
        ylim([0 60])
        xlim([-LIMIT_VEL_TO_ABS_MAX , LIMIT_VEL_TO_ABS_MAX])
        
        spout2 = SPmaker(spout2);
        hold on
        cellfun(@length, spikes1{1, k})
        tmp1 = [1; cumsum(cellfun(@length, spikes1{1, k}))]
        
        
    else
        %         keyboard
    end
end
[A1, H1] = supLabel_ALL('Pre-touch velocity dependent touch response','Pre-touch Velocity (degrees/ms)',  'Spikes/S', [], spout.allFigs);
% figure(gcf)

%%
remInds = ~cellfun(@isempty, toPlot);
sortedVel = sortedVel(1, remInds);
sortedRastCell = sortedRastCell(1, remInds);
Twin = Twin(1, remInds);
touchWindow = touchWindow(1, remInds);
%%
spout = SPmaker(1, 3);

numCols =1001;
spout = SPmaker(1, 3);
% TPval = .1;

% tmpCol = (brewermap(numCols, 'RdPu'));
tmpCol = turbo(numCols);
colVec =linspace(0, LIMIT_VEL_TO_ABS_MAX ,numCols);
FcolResPeriod = 'c';%[0 0 1];%blue
p2 = {};
interpBY = 50000; % for scatter color line interp

for k = 1:length(sortedVel)
    %%
    spout = SPmaker(spout);
    hold on
    % nan out so dots and axes dont overlap
    tmp1 = sortedRastCell{k};
    tmp1([1:(rastXlimsCUT(1)-1), (1+rastXlimsCUT(end)):end], :) = nan;
    [x1, y1] = find(tmp1>0);
    x1 = x1-find(extractRange==0);
    Bdots = scatter(x1,y1,   'k.')
    set(gca, 'Color','none')
    axis tight
    xlim([rastXlims(1)-1, rastXlims(end)+1]);% prevent axis data overlap
    ylim(ylim+[-1 1]*10);% prevent axis data overlap
    hold on
    xlabel('Time from touch onset (ms)')
    
    %%
    set(gca, 'TickLength',[0 0])
    set(gca, 'Color','none')
    hp = squareTransparent([Twin{k}(1), Twin{k}(end)], ylim, 1, 3);% 3 to make sure it covers all data
    set(hp, 'EdgeColor', 'none', 'FaceColor', FcolResPeriod)
    % % set(gca, 'YTick',[])
    % % %%
    set(gca,'YTickLabel',[]);
    %     set(gca,'XTickLabel',[]);
    ax1 = gca;
    ax1_pos = get(ax1,'Position');
    axes('Position',ax1_pos,...
        'xcolor','r',...
        'XAxisLocation','top',...
        'yaxislocation','right','Color','none');hold on
    hold on
    ylim(ylim+[-1 1]*10);% prevent axis data overlap
    %%
    x1 = sortedVel{k};
    y1 = 1:length(sortedVel{k});
    
    
    x2 = linspace(min(x1), max(x1), interpBY);
    [~, keepInds] = unique(x1);
    y2 = interp1(x1(keepInds), y1(keepInds),x2,'linear');
    [~, a2] = min(abs(abs(x2(:)') - colVec(:)));
    sc1 = scatter(x2,y2 ,[], tmpCol(a2, :));
    set(sc1, 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', 'none', 'LineWidth', .15264)
    sc1.SizeData = .01
    axis tight
    set(gca,'YTickLabel',[]);
    xlabel('Pretouch velocity (degrees/ms)','color','r')
    %%
    box off
    % set(gca,'XTick',[], 'YTick',[])
    set(gca, 'TickLength',[0 0])
    ylim(ylim+[-1 1]*10);% prevent axis data overlap
    xlim([-1, 1].*LIMIT_VEL_TO_ABS_MAX);
end
dumbX = min(xlim) - range(xlim);
dumbY = min(ylim) - range(ylim);
h{1} = plot(dumbX, dumbY - range(ylim), 'cs', 'MarkerFaceColor', 'c');

legend([h{1}, Bdots], ...
    'Touch period', 'Spikes')
%%
% make colorbar
figure
imagescnan(flip(colVec'))
colormap( tmpCol)
colorbar


%%
%{

fn = 'tuningCruve PreTouchVel'
loc1 = 'C:\Users\maire\Dropbox\HIRES_LAB\S2_project\paper Figures';
% export_fig([loc1, filesep, fn, '.eps'], '-depsc', '-painters', '-r10000', '-transparent')
export_fig([fn, '.eps'], '-depsc', '-painters', '-r1200')
fix_eps_fonts([fn, '.eps'], 'Arial')
%}
%%
figure;
cb = colorbar('horiz');
colormap(tmpCol);
caxis([0 LIMIT_VEL_TO_ABS_MAX]);
% [A1, H1] = supLabel_ALL('Pre-touch velocity dependent touch response','Pre-touch Velocity (degrees/ms)',  'Spikes/S', [], spout.allFigs);








%%

% set(H1{1}, 'FontSize', 30)
% if nargin ==3 & varargin{1} == true

figure
if ~all(remInds(1, :)==remInds(1, :))
    error('something weird happened unevenprotraction and retraction plots ')
end
toPlot = reshape(toPlot(remInds), 1, []);
betweenEdges = reshape(betweenEdges(remInds), 1, []);
tmpColor = brewermap(20, 'RdBu');
TPval1 = .8;
TPval2 = .3;
colorCell = {[0 0 0]}
h = {};
allEdges = cell2mat(betweenEdges(1, :));
allPlots = cell2mat(toPlot(1, :));
h{end+1} = plot(allEdges, allPlots, 'Color', [colorCell{1},TPval2] , 'LineWidth', 2);
edges = linspace(min(allEdges(:)), max(allEdges(:)), numBins+1);
%     [n,edges,bin] = histcounts(allEdges(:) , edges);
[allPlots2, var1,edges] = binslin(allEdges(:), allPlots(:), 'equalN', numBins);
hold on
betweenEdgesTMP = (edges(1:end-1)+(diff(edges)./2))';
h{end+1} = plot(betweenEdgesTMP, cellfun(@(x) nanmean(x), allPlots2), 'Color', [colorCell{1},TPval1], 'LineWidth', 2);
%     h{end+1} = plot(betweenEdgesTMP, cellfun(@(x) nanmedian(x), allPlots2), 'Color', [colorCell{1},TPval1], 'LineWidth', 2, 'lineStyle', '--');

% end
legend([h{1}(1) h{2}], ...
    'single cells', 'mean')

% legend([h{1}(1) h{2}, h{3}], ...
%     'single cells', 'mean', 'median')
[A1, H1] = supLabel_ALL('Pre-touch velocity dependent touch response','Pre-touch Velocity (degrees/ms)',  'Spikes/S', []);
