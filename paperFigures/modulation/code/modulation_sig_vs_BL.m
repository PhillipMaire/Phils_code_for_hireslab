% % %%
% % load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\191014_1504_allCellsTouch.mat')
% % load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\191014_1504_pole.mat')
% % load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\191014_1504_V.mat')
% % load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\OnsetsALL_CELLS_190917.mat')
% % load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\191014_1551_Whisk.mat')
%%

% tuningCurveAMP{k} =squeeze(cellfun(@(x) nanmean(x), Whisk.binnedSpikes(3, k, :)));
% MI_amp(k) =(nanmin(tuningCurveAMP{k})-nanmax(tuningCurveAMP{k}))./...
%     (nanmin(tuningCurveAMP{k})+nanmax(tuningCurveAMP{k}));
%% whisking tuning curve based tuning
notSigWindow = 8:40;

sig1 = []; BL = [];tuningCurveAMP = [];MI_amp = [];tuningCurveAMP = {};
semSIG = [] ; semBL = [];
for kk = 1:3
    for k = 1:size(V, 2)
        tuningCurveAMP{k} =squeeze(cellfun(@(x) nanmean(x), Whisk.binnedSpikes(3, k, :)));
        MI_amp(k) =(nanmin(tuningCurveAMP{k})-nanmax(tuningCurveAMP{k}))./...
            (nanmin(tuningCurveAMP{k})+nanmax(tuningCurveAMP{k}));
        if V{kk, k}.ModDirection > 0
            ind1 = V{kk, k}.Efirst;
        elseif V{kk, k}.ModDirection < 0
            ind1 = V{kk, k}.Ifirst;
        elseif V{kk, k}.ModDirection == 0
            ind1 = find(V{kk, k}.plotRange == notSigWindow(1));
            ind1 = ind1:ind1+length(notSigWindow)-1;
        end
        sig = nanmean(V{kk, k}.sig, 2);
        semSIG(kk, k) = sem(reshape(V{kk, k}.sig(ind1, :), [], 1));
        semBL(kk, k) = sem(reshape(V{kk, k}.BL, [], 1));
        sig1(kk, k) = nanmean(sig(ind1));
        BL(kk, k) = nanmean(V{kk, k}.BL(:));
    end
end

%%
crush
% [SPout] = SPmaker(2, 2);
setTo= 10.^-2./1000;
sig1(sig1<=setTo) = setTo;
BL(BL<=setTo) = setTo;

plots1 = {};
allSigs = {};
allBLs = {};
titles1 = {'Pole up modulated neurons' 'Pole down modulated neurons' 'Touch modulated neurons'}
xlimSET = {[10.^-2 10^3] [10.^-1 10.^2] [10.^-3 10.^2]};
xlimSET = {[10.^-2 10^3] [10.^-2 10.^3] [10.^-2 10.^3]};

h = {};
for k = 1:size(sig1, 1)
    %     [SPout] = SPmaker(SPout);
    h{k} = figure;    hold on
    
    
    thisVar = cellfun(@(x) x.isSig, V);
    isSig = find(thisVar(k, :));
    isNot_Sig = find(~thisVar(k, :));
    allSigs{end+1} = sig1(k, isNot_Sig);
    
    e = errorbar(1000*BL(k, :), 1000*sig1(k, :), 1000*-semSIG(k, :), 1000*semSIG(k, :), 1000*-semBL(k, :), 1000*semBL(k, :), 'LineStyle','none');
    % change the error bars that go negtive to the limits of the plot to show the actual error
    % instead of what it would do which is leaving it blank
    %     keyboard
    %
    %     e.YNegativeDelta(e.YNegativeDelta+ e.YData <0) = -(e.YData(e.YNegativeDelta+ e.YData <0))+xlimSET{k}(1);
    %     e.XNegativeDelta(e.XNegativeDelta+ e.XData <0) = -(e.XData(e.XNegativeDelta+ e.XData <0))+xlimSET{k}(1);
    
    
    e.Color = 'k';
    e.CapSize = 0;
    e.LineWidth = 1.5
    
    allBLs{end+1} = BL(k, isNot_Sig);
    plots1{end+1} = plot(1000*BL(k, isNot_Sig), 1000*sig1(k, isNot_Sig), 'ko')
    allSigs{end+1} = sig1(k, isSig);
    allBLs{end+1} = BL(k, isSig);
    plots1{end+1} = plot(1000*BL(k, isSig), 1000*sig1(k, isSig), 'ko');
    
    
    try
    catch
        plots1{end}.MarkerFaceColor = 'k';
    end
    try
    catch
        plots1{end-1}.MarkerFaceColor = 'w';
    end
    
    xlim(xlimSET{k});
    ylim(xlimSET{k})
    
    set(gca, 'XScale', 'log')
    set(gca, 'YScale', 'log')
    equalAxes
    axis square
    plot(xlim,ylim, '--k')
    % labels
    xlabel(sprintf('Spikes/sec Baseline'));
    ylabel(sprintf('Spikes/sec Signal'));
    
    legend([plots1{end}, plots1{end-1}], 'Significant', 'Insignificant', 'Location', 'northwest')
    title(titles1{k})
    %     keyboard
    fixErrorBarsOnLogLogPlot(e)
    tmp1 = yticklabels;
    yticklabels(['0'; tmp1(2:end)])
    tmp1 = xticklabels;
    xticklabels(['0'; tmp1(2:end)])
end

%%
if saveOn
    saveNames = {'pole up modulation' 'pole down modulation' 'Touch modulation'}
    for k = 1:length(h)
        cd(saveDir)
        fullscreen(h{k})
        fn = [saveNames{k}, '_', dateString1];
        saveFigAllTypes(fn, h{k}, saveDir, 'modulation_sig_vs_BL.m');
    end
    winopen(saveDir)
end
%%
% iSig = find(Whisk.allMods(3, :)>Whisk.mod2beat(3,:));
% isNot_Sig = find(~(Whisk.allMods(3, :)>Whisk.mod2beat(3,:)));
% sig2 = 1000*cellfun(@max, tuningCurveAMP);
% BL2 = 1000*cellfun(@min, tuningCurveAMP);
% allSigs{end+1} = sig2(isNot_Sig);
% allBLs{end+1} = BL2(isNot_Sig);
% plot(BL2(isNot_Sig), sig2(isNot_Sig), 'k+')
% allSigs{end+1} = sig2(isSig);
% allBLs{end+1} = BL2(isSig);
% plots1{end+1}= plot(BL2(isSig), sig2(isSig), 'm+');



% legend([plots1{1}, plots1{2}, plots1{3}, plots1{4}] , {'pole up' 'pole down' 'touch' 'whisking amp'})
%{
figure;hold on
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plotSymbols = {'s' 'o' '*'};
color1 = {'r' 'b' 'g'}
plots1 = {};
allSigs = {};
allBLs = {};
for k = 1:size(sig1, 1)
    thisVar = cellfun(@(x) x.isSig, V);
    isSig = find(thisVar(k, :));
    isNot_Sig = find(~thisVar(k, :));
    allSigs{end+1} = sig1(k, isNot_Sig);
    allBLs{end+1} = BL(k, isNot_Sig);
    plot(BL(k, isNot_Sig), sig1(k, isNot_Sig), ['k', plotSymbols{k}])
    allSigs{end+1} = sig1(k, isSig);
    allBLs{end+1} = BL(k, isSig);
    plots1{end+1} = plot(BL(k, isSig), sig1(k, isSig), [color1{k}, plotSymbols{k}]);
end

iSig = find(Whisk.allMods(3, :)>Whisk.mod2beat(3,:));
isNot_Sig = find(~(Whisk.allMods(3, :)>Whisk.mod2beat(3,:)));
sig2 = 1000*cellfun(@max, tuningCurveAMP);
BL2 = 1000*cellfun(@min, tuningCurveAMP);
allSigs{end+1} = sig2(isNot_Sig);
allBLs{end+1} = BL2(isNot_Sig);
plot(BL2(isNot_Sig), sig2(isNot_Sig), 'k+')
allSigs{end+1} = sig2(isSig);
allBLs{end+1} = BL2(isSig);
plots1{end+1}= plot(BL2(isSig), sig2(isSig), 'm+');
lims = [xlim; ylim]
ylim([min(lims(:)), max(lims(:))]);
xlim([min(lims(:)), max(lims(:))]);
plot(xlim,ylim, '--k')

legend([plots1{1}, plots1{2}, plots1{3}, plots1{4}] , {'pole up' 'pole down' 'touch' 'whisking amp'})
%}
%%
% signifSig = allSigs(2:2:length(allSigs));
% signifBL = allBLs(2:2:length(allBLs));
%
% d = {};
% negInds = {};
% numBins = 30;
% maxDist = [];
% for k = 1:length(allSigs)
%     [d{k}, negInds{k}] = point_to_line([allBLs{k}(:), allSigs{k}(:), zeros(size(allSigs{k}(:)))], [0 0 0], [1 1 0]);
%     d{k} = d{k}.*negInds{k}(:, 3);
% end
% edges = linspace(floor(min(cellfun(@min, d))), ceil(max(cellfun(@max, d))), numBins+1);
% [SPout] = SPmaker(4, 2);
% nameCell = {'pole up' 'pole down' 'touch' 'whisking amp';...
%     'pole up SIG' 'pole down SIG' 'touch SIG' 'whisking amp SIG'};
% % nameCell = [nameCell;nameCell]
% for k = 1:length(d)
%     [SPout] = SPmaker(SPout);
%     toPlotBars = histc(d{k}, edges);
%     bar(round(edges), toPlotBars);
%     title(nameCell(k))
%     %     SPout.mainFig.CurrentAxes.XScale = 'log';
%     %     SPout.mainFig.CurrentAxes.YScale = 'log';
% end
% %{
% plot the distance mfrom the wqual dotted line and make a histogram of each such that it shows where
% the sigfinicant points are modulated


%}
