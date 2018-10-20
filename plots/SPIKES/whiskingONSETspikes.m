%% pole onset vs whisk onset for only trials where whis onset was determineds
smoothFactor = 5;

preTIME = 50;
postTIME = 50;

signalTIME = -preTIME:postTIME;
subplotMakerNumber = 1; subplotMaker

for cellStep = 1:length(U)
    subplotMakerNumber = 2; subplotMaker
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
    meanWHISKspikes = smooth(meanWHISKspikes, smoothFactor);
    meanPOLEspikes = smooth(meanPOLEspikes, smoothFactor);
    
    
    
    plot(signalTIME, meanWHISKspikes.*1000, 'r-');
    hold on
    plot(signalTIME, meanPOLEspikes.*1000, 'b-');
    
    
    tmpFIG = gcf;
    textPosition = tmpFIG.CurrentAxes.YLim(2);
    
    ylim([0, textPosition]);
    text(-preTIME+(preTIME.*.1), textPosition.*.9, num2str(length(onsets)));
    grid on
    
    
end
%%
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
filename =  [num2str(cellStep), 'ALL whisk aligned and pole aligned redWHISK bluePOLE smooth 5' ];
saveas(gcf,filename,'png')
savefig(filename)
close all hidden

