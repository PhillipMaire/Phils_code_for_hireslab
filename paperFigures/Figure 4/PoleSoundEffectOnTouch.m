%%

extractRange = -400:100;
extract2plot = -25:60;
numBins = 12;

spdim1 = 1;
spdim2 = 2;
spout = SPmaker(spdim1, spdim2);
TwinSize = 1:50;

% color line
numCols =1001;
interpBY = 50000; % for scatter color line interp
LIMIT_maxKappa_TO_ABS_MAX = 500
RemoveTouchDelaysGreaterThan = 500
tmpCol = turbo(numCols);
colVec =linspace(0, LIMIT_maxKappa_TO_ABS_MAX ,numCols);
CI_Alpha = .05;
Twin = {};
touchWindow = {};
% limit num touches to
limT2 = inf;
for k = theseCells
    C = U{k};
    
    V2 = V{3, k};
    if V2.isSig
        V3 = getSignalRegionFromVarray(V2, extractRange);
        touchWindow{k} =V3.SIGindsExtractRange;
        Twin{k} = V3.SIGinds;
        %         Twin{k} = TwinSize;
        %     if ~any(isnan(touchWindow{k})) && (V3.excitedResponse == type1 || type1 == 2)
        
        
        %         [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] ...
        %             = GET_touches(C, 'all', false);
        [~, segments, ~, ~, ~] = GET_touches(C, 'onset', true);
        if limT2<size(segments, 1)
            sampInds = sort(randsample(size(segments, 1), limT2));
        else
            sampInds = 1:size(segments, 1);
        end
        segments = segments(sampInds , :);
        %         [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(segments(:, 1), extractRange, C.t);
        % 1) touch window plus added on from end of touch
        %{
ok so delta kappa is change in curvature right? so what do I want to quantify for each touch?
 a) total change in kappa over a touch. but this would lead to different lengths of change for
 different touch making the statistics of spikes per second very different.. I think this is a hard
 no
 b) instantanious delta kappa, but this is and issue

        %}
        % 2)
        %     V3.SIGinds(1):V3.SIGinds(end)+
        %%
        segments = segments(segments(:, 7)==1, :);% only protraction touches
        Ton = segments(:, 5);
        Pup = C.meta.poleOnset(segments(:, 4));
        Ton = Ton(:)- Pup(:);
        Spk = squeeze(C.R_ntk);
        %         Spk = Spk(segments(:, 4) ,:);
        
        
        [Extract1, Extract1_makeTheseNans] = getTimeAroundTimePoints(segments(:, 1), extract2plot, C.t);
        KSpk = Spk(Extract1);
        KSpk(Extract1_makeTheseNans) = nan;
        
        [Sorted1, Sinds] = sort(Ton);
        remGreaterThan = Sorted1>RemoveTouchDelaysGreaterThan;
        Sorted1 = Sorted1(~remGreaterThan);
        Sinds = Sinds(~remGreaterThan);
        KSpk = KSpk(:, Sinds);
        
        %% make the raster
        % % %         extract around max kappa point
        % %         [MaxKapExtr, MaxKapExtr_makeTheseNans] = getTimeAroundTimePoints(maxDeltaTrialTimeInd, extractMaxKap, C.t);
        %         % extract from touch onset
        
        [X1, y1] = find(KSpk>0);
        spout = SPmaker(spout);
        scatter(X1+extract2plot(1), y1, 'k.');
        axis tight
        
        [~, ~, win1] = intersect(Twin{k}, extract2plot)
        tuningCurve = 1000*(nansum(KSpk(win1, :))./length(Twin{k}));
        %         figure;plot(smooth(tuningCurve, 100))
        % imagesc(KSpk)     BASED ON THIS I SHOULD EXTRACT THE TOUCHES FROM TOUCH ONSET...
        %% set up axis
        xlabel('Time from touch (ms)')
        set(gca, 'TickLength',[0 0])
        set(gca, 'Color','none')
        set(gca,'YTickLabel',[]);
        ylimSave = ylim;
        
        xlim([extract2plot(1), extract2plot(end)]);
        hp = squareTransparent([Twin{k}(1), Twin{k}(end)], ylim, .1, 3);% 3 to make sure it covers all data
        set(hp, 'EdgeColor', 'none', 'FaceColor', 'c')
        ax1 = gca;
        ax1_pos = get(ax1,'Position');
        axes('Position',ax1_pos,...
            'xcolor','r',...
            'XAxisLocation','top',...
            'yaxislocation','right','Color','none');hold on
        hold on
        %% prepping colorline
        x1 = Sorted1;
        y1 = 1:length(Sorted1);
        x2 = linspace(min(x1), max(x1), interpBY);
        [~, keepInds] = unique(x1);
        y2 = interp1(x1(keepInds), y1(keepInds),x2,'linear');
        [~, a2] = min(abs(abs(x2(:)') - colVec(:)));
        %%
        sc1 = scatter(x2,y2 ,[], tmpCol(a2, :));
        axis tight
        
        set(sc1, 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', 'none', 'LineWidth', .15264)
        
        set(gca,'YTickLabel',[]);
        xlabel('Touch delay from pole onset (ms)','color','r')
        %         sc1.SizeData = .01;
        box off
        %         xlim([0, 1].*LIMIT_maxKappa_TO_ABS_MAX);
        xlim([0, RemoveTouchDelaysGreaterThan]);
        %% equal bins
        [spkCount, TfromPole,edges] = binslin(Sorted1(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, TfromPole);
        spout = SPmaker(spout);
        %         plot(tuneCur, kapVals, '-k')
        
        
%         yTrials2plot = round(edgesBetween(cumsum([1; cellfun(@(x) length(x), TfromPole)])));
        yTrials2plot = round(edgesBetween([1; cumsum(cellfun(@(x) length(x), TfromPole))]))

        CIset = [];
        CIsize = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
        end
        [hl, hp] = boundedline(tuneCur, yTrials2plot, CIsize(:), ...
            'k-',  'orientation', 'horiz', 'transparency', 1);
        hl.Color = 'b'
        xlim([0, max(xlim)])
        xlabel('Spikes/Sec')
        %         ylabel('Max delta kappa at touch (degrees)')
        set(gca, 'TickLength',[0 0])
        set(gca, 'Color','none')
        set(gca,'YTickLabel',[]);
        %%
        ylim(ylimSave)
        tmpCB = colorbar();
        caxis([0, LIMIT_maxKappa_TO_ABS_MAX]);
        colormap(tmpCol)
        tmpCB.TickLabels{end} = [tmpCB.TickLabels{end}, '+']
        title(['Cell num ', num2str(k)])
        %         test1 = 1
        
    end
end

%%

