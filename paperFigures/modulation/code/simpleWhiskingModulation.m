
%%
upperThresh = 5;
lowerThresh = 2.5;

%% times for masks
touch_M = [0:300];
P_UP_M = 0:300;
P_down_M = 0:300;
amp = [] ;
%% mask names
threshTtest = 1-.975;
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:4)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
maskyExtraSettings = [{''} {''}  {''} {''}];
allWhiskingVar = {};
SEM1 = [];
whiskSIG = cellfun(@(x) squeeze(x.S_ctk(3, :, :))>upperThresh  , U, 'UniformOutput', false);
whiskBL = cellfun(@(x) squeeze(x.S_ctk(3, :, :))<lowerThresh  , U, 'UniformOutput', false);
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
    tmp1 = nanmean(allWhiskingVar{k}.SIG - nanmean(allWhiskingVar{k}.BL));
    if tmp1==0
        allWhiskingVar{k}.ModDirection = 0;
    else
    allWhiskingVar{k}.ModDirection = ((tmp1>0)*2)-1; %turn into - 1 or 1
    end
end
%%
crush
isSigInd = cellfun(@(x) x.Ttest<threshTtest, allWhiskingVar);
isNOTsig = find(~isSigInd);
isSigInd = find(isSigInd);
whiskBLmean = cellfun(@(x) nanmean(x.BL), allWhiskingVar);
whiskSIGmean = cellfun(@(x) nanmean(x.SIG), allWhiskingVar);


setTo= 10.^-2./1000;
whiskSIGmean(whiskSIGmean<=setTo) = setTo;
whiskBLmean(whiskBLmean<=setTo) = setTo;

errSIG = cellfun(@(x) x.semSIG, allWhiskingVar);
errBL = cellfun(@(x) x.semBL, allWhiskingVar);
figure;hold on
e = errorbar(1000*whiskBLmean, 1000*whiskSIGmean, 1000*-errSIG, 1000*errSIG, 1000*-errBL, 1000*errBL, 'LineStyle','none');

e.Color = 'k';
e.CapSize = 0;
e.LineWidth = 1.5


h2 = plot( 1000*whiskBLmean(isNOTsig), 1000*whiskSIGmean(isNOTsig), 'ko');
try
catch
h2.MarkerFaceColor = 'w';
end
h1 = plot( 1000*whiskBLmean(isSigInd), 1000*whiskSIGmean(isSigInd), 'ko');
try
catch
h1.MarkerFaceColor = 'k';
end
% errorbar(whiskBLmean, whiskSIGmean, errSIG, 'LineStyle','none', 'LineSpec', 'k');


%
% errorbar(whiskBLmean, whiskSIGmean, errSIG, 'LineStyle','none')
% errorbar(whiskBLmean, whiskSIGmean, errBL(:), 'horizontal', 'LineStyle','none');



% axis tight
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
ylim([10.^-2 10.^3])
equalAxes
axis square
plotDiag
ylabel(sprintf('Spikes/sec whisking > %1.1f', upperThresh))
xlabel(sprintf('Spikes/sec whisking < %1.1f', lowerThresh))

legend([h1, h2], 'Significant', 'Insignificant', 'Location', 'northwest')
title('Whisking modulated neurons')
% change the error bars that go negtive to the limits of the plot to show the actual error
% instead of what it would do which is leaving it blank
e.YNegativeDelta(e.YNegativeDelta+ e.YData <0) = -(e.YData(e.YNegativeDelta+ e.YData <0))+min(ylim);
e.XNegativeDelta(e.XNegativeDelta+ e.XData <0) = -(e.YData(e.XNegativeDelta+ e.XData <0))+min(xlim);


 tmp1 = yticklabels;
 yticklabels(['0'; tmp1(2:end)])
  tmp1 = xticklabels;
 xticklabels(['0'; tmp1(2:end)])
%%
if saveOn
    cd(saveDir)
    fullscreen
    fn = ['simpleWhiskingMod_', dateString1];
    saveFigAllTypes(fn, [], saveDir, 'simpleWhiskingModulation.m');
    winopen(saveDir)
end





