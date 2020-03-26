%%

numBins = 2;
minNumberOfValuesPerBin = 20;
% use the trialEvents to determine the pole down and the pole up of the next trial to determine the
% the length of time between the trials to determine if the pole response is correlated with the
% expectation of the pole onset (for example if it occurs earlier less of a resoonse and later with
% more anticipation a greater response)
% make sure to put the trial events in the Uarray if they are not already there.
timeBetweenPoleOnset  = {};
Inds = {};
timeBetween = {};
sigPup = {};
sigPdown = {};
edges = {};
meanBins = {};
for k = 1:length(U)
    %     k = 1
    C = U{k};
    T = C.meta.trialEvents;
    
    poleOnset = cellfun(@(x) x(find(x==41, 1, 'first'), 3), T);
    poleOffset = cellfun(@(x) x(find(x==48, 1, 'first'), 3), T);
    
    timeBetweenPoleOnset{k} = poleOnset(2:end) - poleOffset(1:end-1);
    timeBetweenPoleOnset{k} = [nan, timeBetweenPoleOnset{k}];
    
    [Inds{k}, timeBetween{k},edges{k}]=binslin(timeBetweenPoleOnset{k}(:), (1:C.k)', 'equalN', numBins);
    
    for kk = 1:numBins
        
        sigPup{k, kk} = pole{k}.up.SIG(:, Inds{k}{kk});
        sigPup{k, kk}(:, sum(~isnan(sigPup{k, kk}), 2)<minNumberOfValuesPerBin) = nan;
        
        sigPdown{k, kk} = pole{k}.down.SIG(:, Inds{k}{kk});
        sigPdown{k, kk}(:, sum(~isnan(sigPdown{k, kk}), 2)<minNumberOfValuesPerBin) = nan;
        meanBins{k, kk} = nanmean(timeBetween{k}{kk});
    end
    % figure;
    % cdfplot(timeBetweenPoleOnset{k})
end

%%
crush
tmp1 = brewermap(11, 'RdYlGn');
colors1 = tmp1(1:numBins, :);

smoothBy = 20
spout = SPmaker(5, 9);
spout2 = SPmaker(5, 9);
for k = 1:length(U)
    
    
    spout = SPmaker(spout);
    hold on
    spout2 = SPmaker(spout2);
    hold on
imtoPlot = [];
    for kk = 1:numBins
        figure(spout.mainFig)
        toPlot = nanmean(sigPup{k, kk}, 2);
        toPlot = smooth(toPlot, smoothBy, 'moving');
        toPlot = smoothEdgesNan(toPlot, smoothBy);
        plot(pole{k}.up.plotRange , 1000*toPlot, 'color', colors1(kk, :));
        imtoPlot(kk, 1:length(toPlot)) = toPlot;
%         figure(spout2.mainFig)
%         toPlot = nanmean(sigPdown{k, kk}, 2);
%         toPlot = smooth(toPlot, smoothBy, 'moving');
%         toPlot = smoothEdgesNan(toPlot, smoothBy);
%         plot(pole{k}.down.plotRange , 1000*toPlot, 'color', colors1(kk, :));
%         keyboard
    end
    figure(spout2.mainFig)
    imagescnan(imtoPlot);
%     keyboard    
end

