
%% first spike during event of interest
% close all hidden
subplotMakerNumber = 1; subplotMaker
ylimSET = [-.1 .1];
xlimSET = [0 100];
numBinsSET = 20;
modifyValue = xlimSET(1);
plotOnlyFirstTouch = false
xlimSET_BL = [-xlimSET(2) 0];
% xlimSET_BL = [-400 -100];
% % % modSPKrateFOR_BL =  length(xlimSET_BL(1):xlimSET_BL(end))./ length(xlimSET(1):xlimSET(end))
modifyValue_BL = xlimSET_BL(1);
selectedData = 1;
for cellStep = 1:length(U)
    disp(num2str(cellStep))
    subplotMakerNumber = 2; subplotMaker
    spikesTMP = squeeze(U{cellStep}.R_ntk);
    %%
    cellTMP = U{cellStep};
    if selectedData == 1
    poleONSETS = cellTMP.meta.poleOnset;
    trials = 1:length(poleONSETS);
    elseif selectedData ==2
    touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
    if plotOnlyFirstTouch
        touchLateOnset = touchFirstOnset(1); % plot only the first touches
    end
    allTouches = unique([touchFirstOnset; touchLateOnset]);
    trials = ceil(allTouches./4000);
    allTouches  = mod(allTouches, 4000);
    poleONSETS = allTouches;
    end
    
%     poleONSETS = allTouches;
    %%
    firstSpikes = [];
    for k = 1:length(trials)
        indexVar = trials(k);
        eventStartTime = poleONSETS(k) + modifyValue;
        firstSpikesTMP = find(spikesTMP(eventStartTime:end, indexVar), 1);
        if isempty(firstSpikesTMP)
            firstSpikes(k) = nan;
        else
            firstSpikes(k) = firstSpikesTMP+modifyValue;
        end
    end
    
    edgesForHist = linspace(xlimSET(1),xlimSET(2),numBinsSET);
    
    %     [tmpHISTn xOfHist] = hist(firstSpikes, edgesForHist);
    %     percentOfTotal = tmpHISTn./length(firstSpikes);
    %     tmpBAR1 = bar(xOfHist(1:end-1), percentOfTotal(1:end-1), 'b');
    %     %     tmpBAR1.EdgeColor = tmpBAR1.FaceColor;
    %     hold on
    %%
    
    
    firstSpikes_BL = [];
    for k = 1:length(trials)
        indexVar = trials(k);
        eventStartTime_BL = poleONSETS(k) + modifyValue_BL;
        firstSpikesTMP_BL = find(spikesTMP(eventStartTime_BL:end, indexVar), 1);
        if isempty(firstSpikesTMP_BL)
            firstSpikes_BL(k) = nan;
        else
            firstSpikes_BL(k) = firstSpikesTMP_BL+modifyValue_BL;
        end
    end
    
    edgesForHist_BL = linspace(xlimSET_BL(1),xlimSET_BL(2),numBinsSET);
    
    [tmpHISTn_BL xOfHist_BL] = hist(firstSpikes_BL, edgesForHist_BL);
    tmpHISTn_BL(end)= 0; %we dont need to know how many are after the baseline it is meaningless
    %     percentOfTotal_BL = tmpHISTn_BL./length(firstSpikes_BL);
    %     tmpBAR1 = bar(xOfHist_BL(1:end-1), percentOfTotal_BL(1:end-1), 'y');
    
    
    [tmpHISTn xOfHist] = hist(firstSpikes, edgesForHist);
    percentOfTotal = (tmpHISTn-tmpHISTn_BL)./length(firstSpikes);
    tmpBAR1 = bar(xOfHist(1:end-1), percentOfTotal(1:end-1), 'b');
    %     tmpBAR1.EdgeColor = tmpBAR1.FaceColor;
    hold on
    
    
    
    %%
    numWithNoWhisk =sum(isnan(firstSpikes))./length(firstSpikes);
    xPosForNoWhisk = xOfHist(2)-xOfHist(1);
    
    
    tmpBAR2 =  bar(  xlimSET(1)-xPosForNoWhisk, numWithNoWhisk, 'r');
    tmpBAR2.BarWidth = 7;
    
    tmpBAR3 =  bar(  xOfHist(end), percentOfTotal(end), 'g');
    tmpBAR3.BarWidth = 7;
    %     tmpBAR2.EdgeColor = tmpBAR2.FaceColor;
    xlimSET2 = [];
    xlimSET2(1) = xlimSET(1) - xPosForNoWhisk.*2;
    xlimSET2(2) = xlimSET(2) + xPosForNoWhisk.*2;
    xlim(xlimSET2)
    ylim(ylimSET)
    grid on
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    %    keyboard
end

keyboard
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
filename =  [num2str(cellStep), '_1st_spkAfterPole_less_timeBeforePole_60BINS' ];
saveas(gcf,filename,'png')
savefig(filename)

close all hidden






