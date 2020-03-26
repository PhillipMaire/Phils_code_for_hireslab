%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
crush
%%
varName = 'Phase';
varNum = 5;
edges = -pi:.5:pi;
edges(1) = -inf;
edges(end) = inf;
% %%
% varName = 'deltaKappa';
% varNum = 6;
% edges = -.3:.001:.3;
% edges(1) = -inf;
% edges(end) = inf;
%% for the best lagshift based on correlation
shiftBy = [-500, 500]; %need to figure out how to make the max lag different for different directions
%% times for masks
P_UP_M = 0:50;
P_down_M = 0:50;
touch_M = 0:50;

for cellStep = theseCells(:)'
    %%
    disp(num2str(cellStep))
    C = U{cellStep};
    %% make custom masks
    %% make mask for pole up and down
    [poleUP_linInds, poleUP_masktrials, poleUP_maskTimes] = mask(C.meta.poleOnset, ...
        P_UP_M,               C.t, C.k);
    [poleDOWN_linInds, poleDOWN_masktrials, poleDOWN_maskTimes] = mask(C.meta.poleOffset, ...
        P_down_M,               C.t, C.k, [], 'trialTime');
    %% make touch masks
    [allTouches, segments, protractionTouches] = GET_touches(C, 'all', false);
    [touchMask_linInds, touchMask_masktrials, touchMask_maskTimes] = mask(allTouches , ...
        touch_M,               C.t, C.k, [], 'trialTime');
    %% combine masks
    allMask = unique([poleUP_linInds(:);poleDOWN_linInds(:); touchMask_linInds(:)]);
    %{
    tmp1 =zeros(C.t, C.k);
    tmp1(allMask)= 1;
    tmp1(find(squeeze(C.R_ntk))) = 2;
    figure;imagesc(tmp1');
    
    %}
    %% calculate and or selcet lagshift putting nans where needed
    var1CUT = squeeze(C.S_ctk(varNum,:,:));
    var1CUT = var1CUT(1:end-shiftBy(end), :);
    var1CUT = var1CUT(-shiftBy(1)+1:end, :);
    
    spikesCUT = squeeze(C.R_ntk) .* 1000;
    spikesCUT = spikesCUT(1:end-shiftBy(end), :);
    spikesCUT = spikesCUT(-shiftBy(1)+1:end, :);
    
    [c, lags] = xcorr(var1CUT(:), spikesCUT(:), shiftBy(1));
    [~,I] = max(abs(c));
    timeDiff = lags(I);
    %%
    spikes = squeeze(C.R_ntk) .* 1000;
    spikes(allMask) = nan;
    var1 = squeeze(C.S_ctk(varNum,:,:));
    
    [n,edges,bin] = histcounts(var1, edges);
    %
    
%     INbins = unique(bin);
%     INbins = setdiff(INbins, 0);
    INbins = 1:length(edges)-1;
    Means = [];
    SEM = [];
    for k = 1:length(INbins)
        binnedSpikes = spikes(bin == INbins(k));
        SEM(k) = nanstd(binnedSpikes)/sqrt(length(binnedSpikes));
        Means(k)  = nanmean(binnedSpikes);
    end
    figure;
    plot(edges(INbins) , Means, 'k-');
    hold on;
    plot(edges(INbins) , Means+SEM, 'k--');
    plot(edges(INbins), Means-SEM, 'k--');
    %%
    spikes = squeeze(C.R_ntk) .* 1000;
    spikes(allMask) = nan;
    spikes = circshiftNAN(spikes, timeDiff);

    Means = [];
    SEM = [];
    for k = 1:length(INbins)
        binnedSpikes = spikes(bin == INbins(k));
        SEM(k) = nanstd(binnedSpikes)/sqrt(length(binnedSpikes));
        Means(k)  = nanmean(binnedSpikes);
    end
    plot(edges(INbins) , Means, 'r-');
    plot(edges(INbins) , Means+SEM, 'r--');
    plot(edges(INbins), Means-SEM, 'r--');
    title(timeDiff)
%     keyboard
end
