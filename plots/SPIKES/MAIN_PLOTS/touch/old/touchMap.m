%%
plotRange = -100:200;
toPlotAllTouch = nan( length(U), length(plotRange), 2); % 2 for protraction then retraction

for cellStep = 1:length(U)
    disp(num2str(cellStep))
    cellTMP = U{cellStep};
    touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
    % % %     touchLateOnset = touchFirstOnset(1); % plot only the first touches
    allTouches = sort([touchFirstOnset; touchLateOnset]);
    % trials = ceil(allTouches./4000);
    
    touchMaskInd = (allTouches + (plotRange));
    trialToMatch = find(plotRange==0);
    % get the trial numbers
    touchMaskIndTrial = ceil(touchMaskInd./cellTMP.t);
    % subtract the trial number from the trial numbers at the '0' point
    % represented at trialToMatch (where the trial the touch happened in)
    touchMaskIndTrial = touchMaskIndTrial - touchMaskIndTrial(:,trialToMatch);
    %find only the ones that are the same trial the touch was extracted from
    makeTheseNans = find(touchMaskIndTrial~=0);
    %find any valid index (here just the first one we find that is valid)
    tempReplaceForIndexToNAN = find(touchMaskIndTrial==0, 1);
    % thie is only temporarry. because of edge problems which include going out of index range
    % and include running off into the next trial we are going to replace these all with nans later
    % for now make sure that they index without erroring out
    touchMaskInd(makeTheseNans) = touchMaskInd(tempReplaceForIndexToNAN);
    % keep only the ind that are in that same trial
    
    spikes = squeeze(cellTMP.R_ntk) .* 1000;
    velocity = squeeze(cellTMP.S_ctk(2,:,:));
    
    %% sort out the pro and ret trouches, gets rid of some becasue velocity is too low to indentify which is which
    protractionTouches = nan(size(touchMaskInd,1) ,1);
    retractionTouches = protractionTouches; % make both nans
    timeForVelDet = -25:-5; %assume that 0 is the event start choose tie to calculate the velocity of the touch
    timeIndex = trialToMatch + timeForVelDet -1;
    velocityTest1 = nanmedian(velocity(touchMaskInd(:,timeIndex)),2);
    test1 = velocityTest1>0;
    test2 = velocityTest1<0;
    velocityTest2 = nanmean(velocity(touchMaskInd(:,timeIndex)),2);
    test3 = velocityTest2>0;
    test4 = velocityTest2<0;
    
    testPRO = test1+test3;
    testRET = test2 +test4;
    indexPro = find(testPRO > 0);
    indexRet = find(testRET > 0);
    protractionTouches(indexPro) =1;
    retractionTouches(indexRet) =1;

%%
    
    %%
    toPlot = spikes(touchMaskInd);
    toPlot(makeTheseNans) = nan;
    allTouchRet{cellStep} = toPlot.*retractionTouches;
    allTouchPro{cellStep} = toPlot.*protractionTouches;

    toPlotRet = nanmean(allTouchRet{cellStep});
    toPlotPro = nanmean(allTouchPro{cellStep});
    toPlotRet = nanmean(toPlot.*retractionTouches);
    toPlotPro = nanmean( toPlot.*protractionTouches);
    toPlotAllTouch(cellStep, :, 1) = toPlotPro;
    toPlotAllTouch(cellStep, :, 2) = toPlotRet;
end
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = 1:length(U)
    smoothBy = 10;
    subplotMakerNumber = 2; subplotMaker
    
    
    toPlotRet = toPlotAllTouch(cellStep, :, 2);
    toPlotRet = smooth(toPlotRet, smoothBy);
    retPlot = plot(plotRange,toPlotRet, 'r');
    hold on
    retPlot.Color = [retPlot.Color, 0.7];
    
    
    toPlotPro = toPlotAllTouch(cellStep, :, 1);
    toPlotPro = smooth(toPlotPro, smoothBy);
    proPlot = plot(plotRange,toPlotPro, 'b');
    proPlot.Color = [proPlot.Color, 0.4];
    
    axis tight
    xlim([plotRange(1) plotRange(end)])
    %     keyboard
    tmpAXIS = gca;
    %     tmpAXIS.YLim(1) = 0 ;
end
saveLoc = ['C:\Users\maire\Documents\PLOTS\touch\'];
generalName = ['red ret blue pro axis tight'] ;
mkdir(saveLoc)

%%
save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')



set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);

filename =  [saveLoc, generalName];
saveas(gcf,filename,'png')
savefig(filename)








