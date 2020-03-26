%% pole location tuning params

numBinsPoleLoc = 10;
smoothByLOC = 10;
%%
extractRange = -400:601;
extract2plot = -300:600;
numBins = 10;

% spdim1 = 1;
% spdim2 = 2;
% spout = SPmaker(spdim1, spdim2);
TwinSize = 1:50;
%   SUBPLOT('position',[left bottom width height])
pos1 = {...
    [.4 .1 .28 .8]...% raster middle
    [.7 .1 .28 .8]...%
    [.1 .1 .24 .35]...%
    [.1 .55 .24 .35]...%
    };
% color line
numCols =1001;
interpBY = 50000; % for scatter color line interp
LIMIT_maxKappa_TO_ABS_MAX = 250
RemoveTouchDelaysGreaterThan = 250
tmpCol = turbo(numCols);
colVec =linspace(0, LIMIT_maxKappa_TO_ABS_MAX ,numCols);
CI_Alpha = .05;
Twin = {};
touchWindow = {};
% limit num touches to
limT2 = inf;
for k = theseCells(:)'
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
        if limT2<size(segments, 1) %if we need to limit the size so to make everything visibly comparible
            sampInds = sort(randsample(size(segments, 1), limT2));
        else
            sampInds = 1:size(segments, 1);
        end
        segments = segments(sampInds , :);
        
        
        %%
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
        poleUPtimes = C.meta.poleOnset(segments(:, 4))+(C.t*(segments(:, 4)))';
        
        [Extract1, Extract1_makeTheseNans] = getTimeAroundTimePoints(poleUPtimes, extract2plot, C.t);
        KSpk = Spk(Extract1);
        KSpk(Extract1_makeTheseNans) = nan;
        
        [Sorted1, Sinds] = sort(Ton);
        remGreaterThan = Sorted1>RemoveTouchDelaysGreaterThan;
        Sorted1 = Sorted1(~remGreaterThan);
        Sinds = Sinds(~remGreaterThan);
        segments = segments(Sinds, :);
        KSpk = KSpk(:, Sinds);
        
        
        %% get the pole up response
        V1 = getSignalRegionFromVarray(V{1, k}, extractRange);
        R1 = range(V1.SIGinds);
        poleRespPeriod = -Sorted1(:) +V1.SIGinds(:)';
        %% make the raster
        % % %         extract around max kappa point
        % %         [MaxKapExtr, MaxKapExtr_makeTheseNans] = getTimeAroundTimePoints(maxDeltaTrialTimeInd, extractMaxKap, C.t);
        %         % extract from touch onset
        
        [X1, y1] = find(KSpk>0);
        figure;
        subplot('position',pos1{1})
        %         spout = SPmaker(spout);
        scatter(X1+extract2plot(1), y1, 'k.');
        axis tight
        ytmp = ylim;
        xtmp = xlim;
        [~, ~, win1] = intersect(Twin{k}, extract2plot)
        tuningCurve = 1000*(nansum(KSpk(win1, :))./length(Twin{k}));
        hold on
        plot(poleRespPeriod(:, 1), 1:length(tuningCurve), 'b');
        plot(poleRespPeriod(:, end), 1:length(tuningCurve), 'b');
        xlim(xtmp)
        ylim(ytmp)
        %         figure;plot(smooth(tuningCurve, 100))
        % imagesc(KSpk)     BASED ON THIS I SHOULD EXTRACT THE TOUCHES FROM TOUCH ONSET...
        %% set up axis
        xlabel('Time from touch (ms)')
        set(gca, 'TickLength',[0 0])
        set(gca, 'Color','none')
        set(gca,'YTickLabel',[]);
        ylimSave = ylim;
        
        xlim([extract2plot(1), extract2plot(end)]);
        hp = squareTransparent([Twin{k}(1), Twin{k}(end)], ylim, .7, 0);% 3 to make sure it covers all data
        set(hp, 'EdgeColor', 'none', 'FaceColor', 'c');
        uistack(hp, 'bottom');
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
        %%
        set(sc1, 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', 'none', 'LineWidth', .15264)
        %%
%                 set(sc1, 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', .3, 'LineWidth', .15264)

        %         set(sc1, 'MarkerEdgeAlpha', .9)
        %         uistack(sc1, 'bottom');
        %%
        set(gca,'YTickLabel',[]);
        xlabel('Touch delay from pole onset (ms)','color','r')
        %         sc1.SizeData = .01;
        box off
        %         xlim([0, 1].*LIMIT_maxKappa_TO_ABS_MAX);
        xlim([0, RemoveTouchDelaysGreaterThan]);
        %% equal bins -- will remove certain bins becasue of distribution of repeat numbers
        [spkCount, TfromPole,edges] = binslin(Sorted1(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, TfromPole);
        %% regular bins
        % % %         [n,edges,bin] = histcounts(Sorted1(:), numBins)
        % % %         tuneCur = [];
        % % %         spkCount = {};
        % % %         TfromPole = {};
        % % %         for tmp1 = 1:numBins
        % % %             TfromPole{tmp1, 1} = Sorted1(bin==tmp1);
        % % %             spkCount{tmp1, 1} = tuningCurve(bin==tmp1);
        % % %             tuneCur(tmp1, 1) = nanmean(tuningCurve(bin==tmp1));
        % % %         end
        
        %%
        
        
        subplot('position',pos1{2})
        
        
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
        %% heatmap for pole position
        
        subplot('position',pos1{3})
        
        PP = C.meta.motorPosition(segments(:, 4));
        PP = PP-min(PP(:));
        [spkCount2, PP2,edges] = binslin(PP(:), KSpk', 'equalN', numBinsPoleLoc);
        [PolebinsTouchInds, ~ ,~] = binslin(PP(:), segments(:, 1), 'equalN', numBinsPoleLoc);
        tmp1 = cellfun(@(x) nanmean(x, 1), spkCount2, 'UniformOutput', false);
        heat1 =cell2mat(tmp1);
        heat1 = smoothmat(heat1', smoothByLOC)'
        imagescnan(heat1)
        %%
        %% touch
        theta1 = (C.S_ctk(1, :, :));
        thetaMean = cellfun(@(x) nanmean(theta1(x)), PolebinsTouchInds);
        %%
        
        xticklabels(xticks-find(extract2plot ==0)+1);
        
%         tmp1 = intersect(1:length(thetaMean{k}), cellfun(@str2num, yticklabels));
        yticklabels(round(thetaMean));
        ylabel('theta (degrees)'); xlabel('Time from touch (ms)')
        %% pole up response
        subplot('position',pos1{4})
        hold on
        Psig = 1000*nanmean(V{1, k}.sig, 2);
        plot(V{1, k}.plotRange, Psig, '-k')
        try
        plot(V{1, k}.plotRange(V1.OGsigExtract), Psig(V1.OGsigExtract), '-b')
        catch
        end
        ylabel('Spikes per sec'); xlabel('Time from pole onset (ms)')
        ylim([0, max(ylim)]);
    end
end

%%

