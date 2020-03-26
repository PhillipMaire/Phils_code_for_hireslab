%% pole location tuning params
crush
numBinsPoleLoc = 10;
smoothByLOC = 10;
%%
extractRange = -400:601;
extract2plot = -300:600;
numBins = 8;

spdim1 = 2;
spdim2 = 3;
spout = SPmaker(spdim1, spdim2);
TwinSize = 1:50;
% color line
% numCols =1001;
% interpBY = 50000; % for scatter color line interp
LIMIT_maxKappa_TO_ABS_MAX = 1000
RemoveTouchDelaysGreaterThan = 1000
% tmpCol = turbo(numCols);
% colVec =linspace(0, LIMIT_maxKappa_TO_ABS_MAX ,numCols);
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
        [~, segments, ~, ~, ~] = GET_touches(C, 'all', true);
        if limT2<size(segments, 1) %if we need to limit the size so to make everything visibly comparible
            sampInds = sort(randsample(size(segments, 1), limT2));
        else
            sampInds = 1:size(segments, 1);
        end
        segments = segments(sampInds , :);
        
        segments = segments(segments(:, 7)==1, :);% only protraction touches
        Ton = segments(:, 5);
        Pup = C.meta.poleOnset(segments(:, 4));
        Ton = Ton(:)- Pup(:);
        Spk = squeeze(C.R_ntk);
        
        [Extract1, Extract1_makeTheseNans] = getTimeAroundTimePoints(segments(:, 1), extract2plot, C.t);
        KSpk = Spk(Extract1);
        KSpk(Extract1_makeTheseNans) = nan;
        
        [Sorted1, Sinds] = sort(Ton);
        remGreaterThan = Sorted1>RemoveTouchDelaysGreaterThan;
        Sorted1 = Sorted1(~remGreaterThan);
        Sinds = Sinds(~remGreaterThan);
        segments = segments(Sinds, :);
        KSpk = KSpk(:, Sinds);
        
        
        %% make the raster
        [~, ~, win1] = intersect(Twin{k}, extract2plot)
        tuningCurve = 1000*(nansum(KSpk(win1, :))./length(Twin{k}));
        
        %% equal bins -- will remove certain bins becasue of distribution of repeat numbers
        [spkCount, TfromPole,edges] = binslin(Sorted1(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, TfromPole);
        %%
        
        spout = SPmaker(spout);
        hold on
        Xlab = round(cellfun(@(x) nanmedian(x), TfromPole));
        
        yTrials2plot = round(edgesBetween([1; cumsum(cellfun(@(x) length(x), TfromPole))]))
        CIset = [];
        CIsize = [];
        SEM = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
            SEM(kk, 1) = std(spkCount{kk})/sqrt(length(spkCount{kk}));
        end
        
        [hl, hp] = boundedline(Xlab, tuneCur, SEM(:), ...
            'k-',  'orientation', 'vert', 'transparency', 1);
        hl.Color = 'b'
        ylim([0, max(ylim)])
        ylabel('Spikes/Sec')
        
        %         xticks(yTrials2plot);
        %         xticklabels(Xlab)
        %         xtickangle(90)
        xlabel('touch delay from pole trigger (ms)')
        set(gca, 'Color','none')
        %% #####################################
        
        
        Dkap = GetRealKappa(C);
        Tcell =  colonMulti(segments(:, 1),segments(:, 1)+Twin{k}(end) -7, 'cell');% only use up
        % to the point where the defined touch period ends minus the min time an event could occur
        
        kapExtract = cellfun(@(x) Dkap(x), Tcell, 'UniformOutput', false);
        %         rangeKappa = cellfun(@(x) range(x), kapExtract);
        absMaxKappa = cellfun(@(x) nanmax(abs(x)), kapExtract);
        
        absMaxKappaINDS = cellfun(@(x) find(absMaxKappa(x) == abs(kapExtract{x}), 1, 'first'), num2cell(1:length(kapExtract)));
        maxDeltaKappa = cellfun(@(x) kapExtract{x}(absMaxKappaINDS(x)), num2cell(1:length(kapExtract)));
        
        maxDeltaTrialTimeInd = cellfun(@(x) Tcell{x}(absMaxKappaINDS(x)), num2cell(1:length(Tcell)));
        [maxDeltaKappaS, Sind] = sort(maxDeltaKappa);
        maxDeltaTrialTimeInd = maxDeltaTrialTimeInd(Sind);
        absMaxKappaINDS = absMaxKappaINDS(Sind);
        KSpk2 = KSpk(:, Sind);
        tuningCurve = 1000*(nansum(KSpk2(win1, :))./length(Twin{k}));
        
        %% equal bins -- will remove certain bins becasue of distribution of repeat numbers
        [spkCount, maxKapBin,edges] = binslin(maxDeltaKappaS(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, maxKapBin);
        %%
        
        spout = SPmaker(spout);
        hold on
        Xlab = (cellfun(@(x) nanmedian(x), maxKapBin));
        
        yTrials2plot = round(edgesBetween([1; cumsum(cellfun(@(x) length(x), maxKapBin))]))
        CIset = [];
        CIsize = [];
        SEM = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
            SEM(kk, 1) = std(spkCount{kk})/sqrt(length(spkCount{kk}));
        end
        
        [hl, hp] = boundedline(Xlab, tuneCur, SEM(:), ...
            'k-',  'orientation', 'vert', 'transparency', 1);
        hl.Color = 'b'
        ylim([0, max(ylim)])
        ylabel('Spikes/Sec')
        xlabel('max delta kappa')
        set(gca, 'Color','none')
        
        %% #####################################
        
        
        theta1 = squeeze(C.S_ctk(1, :, :));
        thetaAtTouch = theta1(segments(:, 1));
        [maxDeltaKappaS, Sind] = sort(thetaAtTouch);
        maxDeltaTrialTimeInd = maxDeltaTrialTimeInd(Sind);
        absMaxKappaINDS = absMaxKappaINDS(Sind);
        KSpk2 = KSpk(:, Sind);
        tuningCurve = 1000*(nansum(KSpk2(win1, :))./length(Twin{k}));
        
        %% equal bins -- will remove certain bins becasue of distribution of repeat numbers
        [spkCount, maxKapBin,edges] = binslin(maxDeltaKappaS(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, maxKapBin);
        %%
        
        spout = SPmaker(spout);
        hold on
        Xlab = (cellfun(@(x) nanmedian(x), maxKapBin));
        
        yTrials2plot = round(edgesBetween([1; cumsum(cellfun(@(x) length(x), maxKapBin))]))
        CIset = [];
        CIsize = [];
        SEM = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
            SEM(kk, 1) = std(spkCount{kk})/sqrt(length(spkCount{kk}));
        end
        
        [hl, hp] = boundedline(Xlab, tuneCur, SEM(:), ...
            'k-',  'orientation', 'vert', 'transparency', 1);
        hl.Color = 'b'
        ylim([0, max(ylim)])
        ylabel('Spikes/Sec')
        xlabel('theta at touch')
        set(gca, 'Color','none')
        
        %% #################AMP####################
        
        
        theta1 = squeeze(C.S_ctk(3, :, :));
        thetaAtTouch = theta1(segments(:, 1));
        [maxDeltaKappaS, Sind] = sort(thetaAtTouch);
        maxDeltaTrialTimeInd = maxDeltaTrialTimeInd(Sind);
        absMaxKappaINDS = absMaxKappaINDS(Sind);
        KSpk2 = KSpk(:, Sind);
        tuningCurve = 1000*(nansum(KSpk2(win1, :))./length(Twin{k}));
        
        %% equal bins -- will remove certain bins becasue of distribution of repeat numbers
        [spkCount, maxKapBin,edges] = binslin(maxDeltaKappaS(:), tuningCurve(:), 'equalN', numBins);
        tuneCur = cellfun(@(x) nanmean(x), spkCount);
        kapVals = cellfun(@nanmedian, maxKapBin);
        %%
        
        spout = SPmaker(spout);
        hold on
        Xlab = (cellfun(@(x) nanmedian(x), maxKapBin));
        
        yTrials2plot = round(edgesBetween([1; cumsum(cellfun(@(x) length(x), maxKapBin))]))
        CIset = [];
        CIsize = [];
        SEM = [];
        for kk = 1:length(spkCount)
            [CIset(kk, 1:2), CIsize(kk)] = philsCIs(spkCount{kk} ,CI_Alpha, length(spkCount{kk}));
            SEM(kk, 1) = std(spkCount{kk})/sqrt(length(spkCount{kk}));
        end
        
        [hl, hp] = boundedline(Xlab, tuneCur, SEM(:), ...
            'k-',  'orientation', 'vert', 'transparency', 1);
        hl.Color = 'b'
        ylim([0, max(ylim)])
        ylabel('Spikes/Sec')
        xlabel('amplitude at touch')
        set(gca, 'Color','none')
        
        tmp1 = gcf;
        allYlims = [];
        for kk = 1:length(tmp1.Children)
            tmp2 = tmp1.Children(kk);
            allYlims(kk) = ceil(max(tmp2.YLim));
        end
        maxY = max(allYlims);
        for kk = 1:length(tmp1.Children)
            tmp1.Children(kk).YLim(2) = maxY;
        end
        
        suptitle(['Cell num ', num2str(k)])
        %%
        
        
        %%
        spout = SPmaker(spout);
        hold on
        
        AL = getFirstLickAfterPoleUp(C)
        hist(AL, 50)
        xlim([0, 2000])
        plot(nanmean(AL),1,  'r*')
        xlabel('first lick delay from pole onset (ms)')
        %%
        spout = SPmaker(spout);
        hold on
        
    end
end

%%

