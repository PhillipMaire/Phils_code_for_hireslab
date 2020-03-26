%% pole onset vs whisk onset for only trials where whis onset was determineds
smoothFactor = 1;
simpleSpikeRate = true

baslinePeriod = -250:-50;% aligned variable (whisking onset ot pole up)


preTIME = 250;
postTIME = 200;
baslinePeriod = baslinePeriod+preTIME+1;
xlimSET = [-75 75];
signalTIME = -preTIME:postTIME;
% % subplotMakerNumber = 1; subplotMaker
close all hidden
cellStoPlot = [1 6 10 14 15 16 17 18 20 23 29];
for cellStep = cellStoPlot%1:length(U)
% %     subplotMakerNumber = 2; subplotMaker
figure
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    spikes = squeeze(U{cellStep}.R_ntk);
    onsets = U{cellStep}.whiskerOnset;
    poleONSETS = U{cellStep}.meta.poleOnset;
    spikesShiftedWHISK = [];
    spikesShiftedPOLE = [];
    for k = 1:length(onsets)
        onsetTMP  = onsets(k);
        poleONSETStmp = poleONSETS(k);
        if ~isnan(onsetTMP)
            indexForSpikes = signalTIME+onsetTMP;
            spikesShiftedWHISK(1:preTIME+postTIME+1, k) = spikes(indexForSpikes, k);
            indexForSpikes = signalTIME+poleONSETStmp;
            spikesShiftedPOLE(1:preTIME+postTIME+1, k) = spikes(indexForSpikes, k);
        end
    end
    
    
    meanWHISKspikes = mean(spikesShiftedWHISK, 2);
    meanPOLEspikes = mean(spikesShiftedPOLE, 2);
    singleMeanWHISK = mean(meanWHISKspikes);
    singleMeanPOLE = mean(meanPOLEspikes);
    allPOLEmeans(cellStep) = singleMeanPOLE;
    
    meanWHISKspikes = smooth(meanWHISKspikes, smoothFactor);
    meanPOLEspikes = smooth(meanPOLEspikes, smoothFactor);
    
    %%% for calculating the Zscored response
    BASLINEstdWHISK = std(meanWHISKspikes(baslinePeriod));
    BASLINEstdPOLE = std(meanPOLEspikes(baslinePeriod));
    BASELINEmeanWHIKS = mean((meanWHISKspikes(baslinePeriod)));
    BASELINEmeanPOLE = mean((meanPOLEspikes(baslinePeriod)));
    if ~simpleSpikeRate
    ZSCOREDmeanWHISKspikes = (meanWHISKspikes-BASELINEmeanWHIKS)./BASLINEstdWHISK ;
    ZSCOREDmeanPOLEspikes = (meanPOLEspikes-BASELINEmeanPOLE)./BASLINEstdPOLE ;
    else
        ZSCOREDmeanWHISKspikes = meanWHISKspikes.*1000;
        ZSCOREDmeanPOLEspikes = meanPOLEspikes.*1000;
    end
    
    
    onlyPlotTheseInds = ((xlimSET(1):xlimSET(2)) + preTIME)';
    tmpPLOT = plot(signalTIME(onlyPlotTheseInds), ZSCOREDmeanWHISKspikes(onlyPlotTheseInds), 'r-');
    %     tmpPLOT.Color = [tmpPLOT.Color 0.5];
    tmpPLOT.LineWidth = 2;
    hold on
    tmpPLOT = plot(signalTIME(onlyPlotTheseInds), ZSCOREDmeanPOLEspikes(onlyPlotTheseInds), 'b-');
    tmpPLOT.Color = [tmpPLOT.Color 1];
    tmpPLOT.LineWidth = 2;
    set(gca,'fontsize',18)
    %     axis tight
    fixAxisScale
    tmpFIG = gcf;
    textPosition = tmpFIG.CurrentAxes.YLim(2);
    
    %
    %     ylim([0, textPosition]);
    %     keyboard
    
    xlim(xlimSET);
    textPosition = tmpFIG.CurrentAxes.YLim(2);
    
    relitiveSubplotSize = length(tmpFIG.CurrentAxes.YLim(1):tmpFIG.CurrentAxes.YLim(2))-1;
    relitiveSubplotSize = relitiveSubplotSize./12;
    %     text(xlimSET(1)+(length(xlimSET(1):xlimSET(2)).*.28), textPosition + abs(textPosition.*0.2), ['n=' num2str(length(onsets))]);
    text(xlimSET(1)+(length(xlimSET(1):xlimSET(2)).* 0.35), textPosition + relitiveSubplotSize, ['n=' num2str(length(onsets))]);
%     grid on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, .4, .6]);
    
end
%%
% figure; plot(1:length(allPOLEmeans), sort(allPOLEmeans).*1000, 'k.')
% set(gca, 'YScale', 'log')
keyboard
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, .4, .6]);
filename =  [num2str(cellStep), 'W&P aligned ZSCORE redWHISK bluePOLE smooth 5 cropped' ];
saveas(gcf,filename,'png')
savefig(filename)
% close all hidden


