%% pole onset vs whisk onset for only trials where whis onset was determineds
smoothFactor = 1;


baslinePeriod = -250:-50;% aligned variable (whisking onset ot pole up)

baslinePeriod = baslinePeriod+preTIME+1;
preTIME = 250;
postTIME = 200;
xlimSET = [-75 75];
ylimSET = [-10 10];
signalTIME = -preTIME:postTIME;
% subplotMakerNumber = 1; subplotMaker

spkForStimThresh = 2.5 ./1000;
close all hidden
allTogetherPOLE = figure(100);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
allTogetherWHISK = figure(101);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
for cellStep = 1:length(U)
    %     subplotMakerNumber = 2; subplotMaker
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
    if singleMeanPOLE>= spkForStimThresh
        

        
        %%% for calculating the Zscored response
        BASLINEstdWHISK = std(meanWHISKspikes(baslinePeriod));
        BASLINEstdPOLE = std(meanPOLEspikes(baslinePeriod));
        BASELINEmeanWHIKS = mean((meanWHISKspikes(baslinePeriod)));
        BASELINEmeanPOLE = mean((meanPOLEspikes(baslinePeriod)));
        ZSCOREDmeanWHISKspikes = (meanWHISKspikes-BASELINEmeanWHIKS)./BASLINEstdWHISK ;
        ZSCOREDmeanPOLEspikes = (meanPOLEspikes-BASELINEmeanPOLE)./BASLINEstdPOLE ;
        
        
        ZSCOREDmeanWHISKspikes = smooth(ZSCOREDmeanWHISKspikes, smoothFactor);
        ZSCOREDmeanPOLEspikes = smooth(ZSCOREDmeanPOLEspikes, smoothFactor);
        
        
        
        figure(101);
        hold on
        onlyPlotTheseInds = ((xlimSET(1):xlimSET(2)) + preTIME)';
        tmpPLOT = plot(signalTIME(onlyPlotTheseInds), ZSCOREDmeanWHISKspikes(onlyPlotTheseInds), 'r-');
        tmpPLOT.Color = [tmpPLOT.Color 0.5];
        ylim(ylimSET);
        xlim(xlimSET);
        
        
        
        
        
        figure(100);
        hold on
        tmpPLOT = plot(signalTIME(onlyPlotTheseInds), ZSCOREDmeanPOLEspikes(onlyPlotTheseInds), 'b-');
        tmpPLOT.Color = [tmpPLOT.Color 0.5];
        ylim(ylimSET);
        xlim(xlimSET);
        %     axis tight
        %     fixAxisScale
        %     tmpFIG = gcf;
        %     textPosition = tmpFIG.CurrentAxes.YLim(2);
        
        %
        %     ylim([0, textPosition]);
        %     keyboard
        
        xlim(xlimSET);
        %     textPosition = tmpFIG.CurrentAxes.YLim(2);
        
        %     relitiveSubplotSize = length(tmpFIG.CurrentAxes.YLim(1):tmpFIG.CurrentAxes.YLim(2))-1;
        %     relitiveSubplotSize = relitiveSubplotSize./12;
        %     text(xlimSET(1)+(length(xlimSET(1):xlimSET(2)).*.28), textPosition + abs(textPosition.*0.2), ['n=' num2str(length(onsets))]);
        %     text(xlimSET(1)+(length(xlimSET(1):xlimSET(2)).* 0.35), textPosition + relitiveSubplotSize, ['n=' num2str(length(onsets))]);
        grid on
    end
    
end
%%
% figure; plot(sort(allPOLEmeans).*1000,1:length(allPOLEmeans),  'k.')
% set(gca, 'YScale', 'log')
% BASED ON THIS AROUND 0.4 SPD/S AND BELOW ARE TOO LOW TO CLASSIFY
keyboard
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
filename =  [num2str(cellStep), 'P_aligned ZSCORE smooth ', num2str(smoothFactor) ' cropped' ];
saveas(gcf,filename,'png')
savefig(filename)
% close all hidden

