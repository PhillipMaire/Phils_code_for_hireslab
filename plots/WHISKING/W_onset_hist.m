%% whisk onset time histogram 
%% look at onset times histogram
SP1 = 5; %subplot indice 1
SP2 = 9; %subplot indice 2
addToFigNum = 0;
saveCurrentVars = false;
allCounter = 0;
counter = SP1.*SP2;


% % % % % [N,edgesForHist] = histcounts(onsetsSHIFTED,6)
for cellStep = 1:length(U)
    xlimSet = [-75 180];
    edgesForHist = linspace(xlimSet(1),xlimSet(2),50);
    
    allCounter = allCounter+1;
    if counter == SP1.*SP2
        counter = 0 ;
        mainFig = figure(cellStep+100+addToFigNum);
        hold on
        
    end
    
    counter = counter +1;
    subplot(SP1, SP2, counter)

    
    onsets = U{cellStep}.whiskerOnset;
    poleONSETS = U{cellStep}.meta.poleOnset;
    onsetsSHIFTED = onsets-poleONSETS;
    
    [tmpHISTn xOfHist] = hist(onsetsSHIFTED, edgesForHist);
    
    tmpBAR1 = bar(xOfHist, tmpHISTn./length(onsets), 'b');
    %     tmpBAR1.EdgeColor = tmpBAR1.FaceColor;
    hold on
    numWithNoWhisk =sum(isnan(onsets))./length(onsets);
    xPosForNoWhisk = xOfHist(1) - (xOfHist(2)-xOfHist(1));
    
    
    tmpBAR2 =  bar(xPosForNoWhisk, numWithNoWhisk, 'r');
    tmpBAR2.BarWidth = 7;
    %     tmpBAR2.EdgeColor = tmpBAR2.FaceColor;
    xlimSet(1) = round(xPosForNoWhisk)-10;
    xlim(xlimSet)
    ylim([0 .35]);
    grid on
    
    
end
%%
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0, 1, 1]);
filename =  [num2str(cellStep), 'whiskOnsetALL_ylim_035' ];
saveas(gcf,filename,'png')
savefig(filename)
close all hidden