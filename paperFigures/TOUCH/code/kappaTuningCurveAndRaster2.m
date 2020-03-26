%%

extractRange = -400:100;
extractMaxKap = -25:60;
numBins = 12;

spdim1 = 1;
spdim2 = 2;
spout = SPmaker(spdim1, spdim2);
TwinSize = 1:50;

% color line
numCols =1001;
interpBY = 50000; % for scatter color line interp
LIMIT_maxKappa_TO_ABS_MAX = .1
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
        [~, segments, ~, ~, ~] = GET_touches(C, 'all', false);
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
        Tcell =  colonMulti(segments(:, 1), segments(:, 2), 'cell');
        Kap = squeeze(C.S_ctk(6, :, :));
        Kap(isnan(Kap)) = 0;
        [seg] = findInARow(Kap~=0, C.t);
        for kk = 1:size(seg, 1) % correcting for the change in kapp subtracting out the first number in each >0 segment
            Kap(seg(kk, 1):seg(kk, 2)) = Kap(seg(kk, 1):seg(kk, 2)) - Kap(seg(kk, 1));
        end
        Spk = squeeze(C.R_ntk);
        
        kapExtract = cellfun(@(x) Kap(x), Tcell, 'UniformOutput', false);
        %         rangeKappa = cellfun(@(x) range(x), kapExtract);
        absMaxKappa = cellfun(@(x) nanmax(abs(x)), kapExtract);
        
        absMaxKappaINDS = cellfun(@(x) find(absMaxKappa(x) == abs(kapExtract{x}), 1, 'first'), num2cell(1:length(kapExtract)));
        maxDeltaKappa = cellfun(@(x) kapExtract{x}(absMaxKappaINDS(x)), num2cell(1:length(kapExtract)));
        
        maxDeltaTrialTimeInd = cellfun(@(x) Tcell{x}(absMaxKappaINDS(x)), num2cell(1:length(Tcell)));
        [maxDeltaKappaS, Sind] = sort(maxDeltaKappa);
        maxDeltaTrialTimeInd = maxDeltaTrialTimeInd(Sind);
        absMaxKappaINDS = absMaxKappaINDS(Sind);
        %% make the raster
        % % %         extract around max kappa point
        % %         [MaxKapExtr, MaxKapExtr_makeTheseNans] = getTimeAroundTimePoints(maxDeltaTrialTimeInd, extractMaxKap, C.t);
        %         % extract from touch onset
        [MaxKapExtr, MaxKapExtr_makeTheseNans] = getTimeAroundTimePoints(segments(Sind, 1), extractMaxKap, C.t);
        KSpk = Spk(MaxKapExtr);
        KSpk(MaxKapExtr_makeTheseNans) = nan;
        [X1, y1] = find(KSpk>0);
        spout = SPmaker(spout);
        scatter(X1+extractMaxKap(1), y1, 'k.');
        axis tight
        
        [~, ~, win1] = intersect(Twin{k}, extractMaxKap)
        tuningCurve = 1000*(nansum(KSpk(win1, :))./length(Twin{k}));
        %         figure;plot(smooth(tuningCurve, 100))
        % imagesc(KSpk)     BASED ON THIS I SHOULD EXTRACT THE TOUCHES FROM TOUCH ONSET...
        %% set up axis
        xlabel('Time from touch (ms)')
        set(gca, 'TickLength',[0 0])
        set(gca, 'Color','none')
        set(gca,'YTickLabel',[]);
        hp = squareTransparent([Twin{k}(1), Twin{k}(end)], ylim, .3, 3);% 3 to make sure it covers all data
        set(hp, 'EdgeColor', 'none', 'FaceColor', 'c')
        ax1 = gca;
        ax1_pos = get(ax1,'Position');
        axes('Position',ax1_pos,...
            'xcolor','r',...
            'XAxisLocation','top',...
            'yaxislocation','right','Color','none');hold on
        hold on
        %% prepping colorline
        x1 = maxDeltaKappaS;
        y1 = 1:length(maxDeltaKappaS);
        x2 = linspace(min(x1), max(x1), interpBY);
        [~, keepInds] = unique(x1);
        y2 = interp1(x1(keepInds), y1(keepInds),x2,'linear');
        [~, a2] = min(abs(abs(x2(:)') - colVec(:)));
        %%
        sc1 = scatter(x2,y2 ,[], tmpCol(a2, :));
        axis tight
        
        set(sc1, 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', 'none', 'LineWidth', .15264)
        
        set(gca,'YTickLabel',[]);
        xlabel('Max delta kappa of touch (degrees)','color','r')
        %         sc1.SizeData = .01;
        box off
        xlim([-1, 1].*LIMIT_maxKappa_TO_ABS_MAX);
        %% equal bins
        [spkCount, kapDist,edges] = binslin(maxDeltaKappaS(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, kapDist);
        spout = SPmaker(spout);
        %         plot(tuneCur, kapVals, '-k')
        
        
        yTrials2plot = round(edgesBetween(cumsum([1; cellfun(@(x) length(x), kapDist)])));
        CIset = [];
        CIsize = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
        end
        [hl, hp] = boundedline(tuneCur, yTrials2plot, CIsize(:), 'k-',  'orientation', 'horiz', 'transparency', 1);
        hl.Color = 'b'
        xlim([0, max(xlim)])
        xlabel('Spikes/Sec')
%         ylabel('Max delta kappa at touch (degrees)')
        set(gca, 'TickLength',[0 0])
        set(gca, 'Color','none')
        set(gca,'YTickLabel',[]);
        %%
        
        tmpCB = colorbar();
        caxis([0, LIMIT_maxKappa_TO_ABS_MAX]);
        colormap(tmpCol)
        test1 = 1
    end
end

%%

