% calculates the difference in spiking for each touch
% crush
baysTest1 = [];
meanSPK = [];
spout = SPmaker(5, 9);
spout2 = SPmaker(5, 9);
spout3 = SPmaker(5, 9);
spkDiffs = {};
bin = {};
binFake = {};
sigALL = {};
fakeTouchInds = {};
% theseCells = [1 17 18]
for k = theseCells(:)'
    %     try
    C = U{k};
    T = V{3, k};
    
    T2 = getSignalRegionFromVarray(T, T.plotRange);
    segs = allCellsTouch{k}.segments;
    trigON = 0;
    
    
    if ~T.isSig
        [~, ~, T2.OGsigExtract] = intersect(8:20, T.plotRange);
        trigON = 1;
    end
    
    
    sigCount = nansum(T.sig(T2.OGsigExtract, :));
    
    tmp1 = find(T.plotRange==0);
    BLinds = (1+tmp1-length(T2.OGsigExtract)):tmp1;
    
    BLcount = nansum(T.sig(BLinds, :));
    
    edges1 = -4.5:1:4.5;
    [no,xo] = hist(sigCount-BLcount,edges1)
    [n,edges,bin{k}]  = histcounts(sigCount-BLcount, edges1);
    subtracted1 = n(1+ceil(length(n)./2):end) - flip(n(1:floor(length(n)./2)));
    
    spout3 = SPmaker(spout3);
    n = n./size(T.sig, 2);
    %%
    
    
    % only during pole up times
    % same lengths
    % make sure the limit is inside the 4000 length and not before the 1 length
    %%  fake touyches to compare the distributions
    numIters = 100;
    addTo = ((1:C.k)-1)*C.t;
    pDown = C.meta.poleOffset;
    pDown(pDown>C.t) = C.t;
    poleRangePeriods = colonMulti(C.meta.poleOnset+addTo, (pDown+addTo)- T2.OGsigExtract(end));
    %         T2.OGsigExtract
    tmp1 = randsample(length(poleRangePeriods),numIters*size(T.sig, 2), true);
    fakeTouches = poleRangePeriods(tmp1);
    [fakeTouchInds{k}, makeTheseNans] = getTimeAroundTimePoints(fakeTouches, T.plotRange, C.t);
    
    fakeTouchIndsALL{k} = fakeTouchInds{k};
    sig = C.R_ntk(fakeTouchInds{k});
    sig(makeTheseNans) = nan;
    sig = reshape(sig, size(sig, 1), size(T.sig, 2), numIters) ;
    sigCount = squeeze(nansum(sig(T2.OGsigExtract, :, :), 1));
    sigALL{k} = sig;
    tmp1 = find(T.plotRange==0);
    BLinds = (1+tmp1-length(T2.OGsigExtract)):tmp1;
    
    BLcount = squeeze(nansum(sig(BLinds, :, :), 1));
    
    n3 = [];
    for kk2 = 1:numIters
        [n2,~,bin2]  = histcounts(sigCount(:, kk2)-BLcount(:, kk2),edges1);
        binFake{k}{kk2} = bin2;
        n3(kk2,1:length(n2)) = n2./size(sig, 2);
    end
    hold on
    Xset = edgesBetween(edges);
    diff1 = n - n3;
    
    %     figure;plot(n);hold on
    %     plot(n3', 'r-')
    
    
    plot(Xset, diff1, '-', 'color', [.6 .6 .6 .4])
    if trigON == 0
        plot(Xset, nanmean(diff1), '.r', 'markersize', 20)
    elseif trigON == 1
        plot(Xset, nanmean(diff1), '.k', 'markersize', 20)
        
    end
    
    limSetMaxAndRound({'y'}, .01)
    limSetMaxAndRound({'x'}, 1)
    
    plotLine([2 3])
    
    sdkjfj = 1
end
%%
eachBin = (Xset-min(Xset)+1);
% fakeSegs = [];
% varNames = {'Theta (degrees)' 'amp (degrees)' 'setpoint (degrees)' 'maxDelta Kappa (degrees)' 'touch delay from pole onset (ms)' ...
%     'first touch delay from pole onset (ms)' 'touch length (ms)' '' '' }
varNames = {'Theta (degrees)' 'Velocity (degrees/sec)' 'amp (degrees)' 'setpoint (degrees)' 'Phase' 'maxDelta Kappa (degrees)' 'touch delay from pole onset (ms)' ...
    'first touch delay from pole onset (ms)' 'touch length (ms)' '' '' }
% yaxisLab = {'degrees' 'degrees' 'degrees' 'degrees' 'touch delay from pole onset(ms)' ...
%     'first touch delay from pole onset' 'touch length' '' '' }
VARy = {};
for k = theseCells(:)'
    spout = SPmaker(3, 3);
    
    %     try
    C = U{k};
    T = V{3, k};
    
    T2 = getSignalRegionFromVarray(T, T.plotRange);
    
    segs = allCellsTouch{k}.segments;
    %     fakeSegs(:, 1) = fakeTouchInds{k}(T.plotRange==0, :);
    %     fakeSegs(:, 2) = fakeSegs(:, 1)+ randsample(segs(:, 3) ,length(fakeSegs(:, 1) ) , true);
    
    realBins = findMulti(eachBin, bin{k});
    fakeBins = cellfun(@(x) findMulti(eachBin,x), binFake{k}, 'UniformOutput', false);
    
    
    %% theta
    theta1 = C.S_ctk(1, :, :);
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(theta1,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(theta1,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{1}); xlabel('change in spikes');
    %% vel
    theta1 = C.S_ctk(2, :, :);
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(theta1,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(theta1,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{2}); xlabel('change in spikes');
    %% amp
    theta1 = C.S_ctk(3, :, :);
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(theta1,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(theta1,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{3}); xlabel('change in spikes');
    %% setpoint
    theta1 = C.S_ctk(4, :, :);
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(theta1,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(theta1,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{4}); xlabel('change in spikes');
    %% phase
    theta1 = C.S_ctk(5, :, :);
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(theta1,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(theta1,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{5}); xlabel('change in spikes');
    %% max delta kappa
    [maxDeltaTrialTimeInd, maxDeltaKappa, Sind, absMaxKappaINDS, Tcell] ...
        = getMaxKappa(C, segs(:, 1), segs(:, 2));
    
    Dkap = GetRealKappa(C);
    
    [F_SEM, F_mean1]= eventsSTA(Dkap,maxDeltaTrialTimeInd(:), fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(Dkap,maxDeltaTrialTimeInd(:), realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{6}); xlabel('change in spikes');
    
    %% touch time
    TT = nan(size(C.R_ntk));
    TT(segs(:, 1)) = segs(:, 6)- C.meta.poleOnset(segs(:, 4))';
    %     segs2 = repmat(segs(:, 1), numIters );
    [F_SEM, F_mean1]= eventsSTA(TT,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(TT,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{7}); xlabel('change in spikes');
    % % % % %     %%
    % % % % %      spout = SPmaker(spout); ;
    % % % % % %     plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    % % % % % %     hold on
    % % % % %     shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    % % % % %     shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    % % % % %     xlim([min(Xset), max(Xset)])
    %% first touch time
    
    FTT = nan(size(C.R_ntk));
    FTT(segs(:, 1)) = segs(:, 5)- C.meta.poleOnset(segs(:, 4))';
    %     segs2 = repmat(segs(:, 1), numIters );
    
    [F_SEM, F_mean1]= eventsSTA(FTT,segs, fakeBins, find(segs(:, 8) ==1));
    [SEM, mean1, BINS_FT, VARy{end+1}] = eventsSTA(FTT,segs, realBins,find(segs(:, 8) ==1));
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{8}); xlabel('change in spikes');
    
    %% touch length
    TL = nan(size(C.R_ntk));
    TL(segs(:, 1)) = segs(:, 3);
    
    [F_SEM, F_mean1]= eventsSTA(TL,segs, fakeBins);
    [SEM, mean1, BINS, VARy{end+1}] = eventsSTA(TL,segs, realBins);
    F_mean2 = (cell2mat(F_mean1'))';
    F_SEM2 = (cell2mat(F_SEM'))';
    spout = SPmaker(spout);
    plot(repmat(Xset(:), [1, size(F_mean2, 2)]), F_mean2, '-', 'color', [.7 .7 .7 .3])
    hold on
    shadedErrorBar(Xset , nanmean(F_mean2, 2), nanmean(F_SEM2, 2),'lineProps',  'g-')
    shadedErrorBar(Xset , mean1, SEM,'lineProps',  'r-')
    xlim([min(Xset), max(Xset)])
    ylabel(varNames{9}); xlabel('change in spikes');
    
    
    
    %% num samples
    spout = SPmaker(spout);
    samps = cellfun(@(x) length(x), BINS_FT);
    [x, y, evalXaxis, evalYaxis] = logify(Xset, samps, 2)
    hPlot = plot(Xset, y, 'k.', 'markersize', 15)
    axis tight
    xlim([min(Xset), max(Xset)])
    ylim([0, max(ylim)])
    eval(evalYaxis)
    xlabel('samps 1st touch')
    %% num samples
    spout = SPmaker(spout);
    samps = cellfun(@(x) length(x), BINS);
    [x, y, evalXaxis, evalYaxis] = logify(Xset, samps, 2)
    hPlot = plot(Xset, y, 'k.', 'markersize', 15)
    axis tight
    xlim([min(Xset), max(Xset)])
    ylim([0, max(ylim)])
    eval(evalYaxis)
    xlabel('samps all other')
end
%%
% figure;
mat2 = reshape(cell2mat(VARy), [], length(VARy));
[min1, minInds] = min(mat2, [], 2)
varNames(minInds)'
