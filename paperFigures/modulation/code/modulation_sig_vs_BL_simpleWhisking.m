
%%

% tuningCurveAMP{k} =squeeze(cellfun(@(x) nanmean(x), Whisk.binnedSpikes(3, k, :)));
% MI_amp(k) =(nanmin(tuningCurveAMP{k})-nanmax(tuningCurveAMP{k}))./...
%     (nanmin(tuningCurveAMP{k})+nanmax(tuningCurveAMP{k}));
%%
upperThresh = 5;
lowerThresh = 2.5;
whiskSIG = cellfun(@(x) squeeze(x.S_ctk(3, :, :))>upperThresh  , U, 'UniformOutput', false);
whiskBL = cellfun(@(x) squeeze(x.S_ctk(3, :, :))<lowerThresh  , U, 'UniformOutput', false);
%% times for masks
touch_M = [0:200];
P_UP_M = 0:300;
P_down_M = 0:300;
amp = [] ;
%% mask names
threshTtest = 0.05
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:4)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
maskyExtraSettings = [{''} {''}  {''} {''}];
allWhiskingVar = {};
SEM1 = [];
for k = theseCells(:)'
    C = U{k};
    [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    allWhiskingVar{k}.SIG  = spikes(whiskSIG{k});
    allWhiskingVar{k}.SIG = allWhiskingVar{k}.SIG(~isnan(allWhiskingVar{k}.SIG));
    allWhiskingVar{k}.BL  = spikes(whiskBL{k});
    allWhiskingVar{k}.BL = allWhiskingVar{k}.BL(~isnan(allWhiskingVar{k}.BL));
    allWhiskingVar{k}.semSIG =( nanstd( allWhiskingVar{k}.SIG )) / (sqrt( length( allWhiskingVar{k}.SIG)));
    allWhiskingVar{k}.semBL =( nanstd( allWhiskingVar{k}.BL )) / (sqrt( length( allWhiskingVar{k}.BL)));
    [~, allWhiskingVar{k}.Ttest] = ttest2(allWhiskingVar{k}.SIG, allWhiskingVar{k}.BL);
end
%%
crush
isSigInd = cellfun(@(x) x.Ttest<threshTtest, allWhiskingVar);
isNOTsig = find(~isSigInd);
isSigInd = find(isSigInd);
whiskBLmean = cellfun(@(x) nanmean(x.BL), allWhiskingVar);
whiskSIGmean = cellfun(@(x) nanmean(x.SIG), allWhiskingVar);
errSIG = cellfun(@(x) x.semSIG, allWhiskingVar);
errBL = cellfun(@(x) x.semBL, allWhiskingVar);
figure;hold on
e = errorbar(whiskBLmean, whiskSIGmean, -errSIG, errSIG, -errBL, errBL, 'LineStyle','none');
e.Color = 'k';
e.CapSize = 0;
e.LineWidth = 1.5


h2 = plot( whiskBLmean(isNOTsig), whiskSIGmean(isNOTsig), 'ko');
try
catch
    h2.MarkerFaceColor = 'w';
end
h1 = plot( whiskBLmean(isSigInd), whiskSIGmean(isSigInd), 'ko');
try
    h1.MarkerFaceColor = 'k';
catch
end
% errorbar(whiskBLmean, whiskSIGmean, errSIG, 'LineStyle','none', 'LineSpec', 'k');


%
% errorbar(whiskBLmean, whiskSIGmean, errSIG, 'LineStyle','none')
% errorbar(whiskBLmean, whiskSIGmean, errBL(:), 'horizontal', 'LineStyle','none');



axis tight
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
equalAxes
plot(xlim,ylim, '--k')
%% labels
ylabel(sprintf('whisking > %1.1f', upperThresh))
xlabel(sprintf('whisking < %1.1f', lowerThresh))

%
% %%
% sig1 = []; BL = [];tuningCurveAMP = [];MI_amp = [];tuningCurveAMP = {};
% for kk = 1:size(V, 1)
%     for k = 1:size(V, 2)
%         tuningCurveAMP{k} =squeeze(cellfun(@(x) nanmean(x), Whisk.binnedSpikes(3, k, :)));
%         MI_amp(k) =(nanmin(tuningCurveAMP{k})-nanmax(tuningCurveAMP{k}))./...
%             (nanmin(tuningCurveAMP{k})+nanmax(tuningCurveAMP{k}));
%         if V{kk, k}.ModDirection > 0
%             ind1 = V{kk, k}.E;
%         elseif V{kk, k}.ModDirection < 0
%             ind1 = V{kk, k}.I;
%         end
%         sig = nanmean(V{kk, k}.sig, 2);
%         sig1(kk, k) = 1000*nanmean(sig(ind1));
%         BL(kk, k) = 1000*nanmean(V{kk, k}.BL(:));
%     end
% end
% %%
%
%
% %%
% crush
% [SPout] = SPmaker(2, 2);
%
%
% plots1 = {};
% allSigs = {};
% allBLs = {};
% for k = 1:size(sig1, 1)
%     [SPout] = SPmaker(SPout);
%
%     thisVar = cellfun(@(x) x.isSig, V);
%     isSig = find(thisVar(k, :));
%     isNot_Sig = find(~thisVar(k, :));
%     allSigs{end+1} = sig1(k, isNot_Sig);
%     allBLs{end+1} = BL(k, isNot_Sig);
%     plot(BL(k, isNot_Sig), sig1(k, isNot_Sig), 'ko')
%     allSigs{end+1} = sig1(k, isSig);
%     allBLs{end+1} = BL(k, isSig);
%     hold on
%     plots1{end+1} = plot(BL(k, isSig), sig1(k, isSig), 'ko');
%     plots1{end}.MarkerFaceColor = 'k';
%     axis tight
%     set(gca, 'XScale', 'log')
%     set(gca, 'YScale', 'log')
%     equalAxes
%     plot(xlim,ylim, '--k')
% end
%
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
%
%
%
% legend([plots1{1}, plots1{2}, plots1{3}, plots1{4}] , {'pole up' 'pole down' 'touch' 'whisking amp'})
% %{
% figure;hold on
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% plotSymbols = {'s' 'o' '*'};
% color1 = {'r' 'b' 'g'}
% plots1 = {};
% allSigs = {};
% allBLs = {};
% for k = 1:size(sig1, 1)
%     thisVar = cellfun(@(x) x.isSig, V);
%     isSig = find(thisVar(k, :));
%     isNot_Sig = find(~thisVar(k, :));
%     allSigs{end+1} = sig1(k, isNot_Sig);
%     allBLs{end+1} = BL(k, isNot_Sig);
%     plot(BL(k, isNot_Sig), sig1(k, isNot_Sig), ['k', plotSymbols{k}])
%     allSigs{end+1} = sig1(k, isSig);
%     allBLs{end+1} = BL(k, isSig);
%     plots1{end+1} = plot(BL(k, isSig), sig1(k, isSig), [color1{k}, plotSymbols{k}]);
% end
%
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
% lims = [xlim; ylim]
% ylim([min(lims(:)), max(lims(:))]);
% xlim([min(lims(:)), max(lims(:))]);
% plot(xlim,ylim, '--k')
%
% legend([plots1{1}, plots1{2}, plots1{3}, plots1{4}] , {'pole up' 'pole down' 'touch' 'whisking amp'})
% %}
% %%
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
%
%
% %}
