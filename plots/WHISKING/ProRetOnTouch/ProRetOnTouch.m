close all
%% protraction retraction whisking using phase show whisking traces s
plotRange = -200:200;
toPlotAllTouch = nan( length(U), length(plotRange), 2); % 2 for protraction then retraction
smoothBy = 10;
subplotMakerNumber = 1; subplotMaker
for cellStep = 1:length(U)
    
    subplotMakerNumber = 2; subplotMaker
    %%
    disp(num2str(cellStep))
    cellTMP = U{cellStep};
    %% make maske for pole up and down
    poleMaskTime = 0:150;
    makeLinInds = ((0:cellTMP.k -1) .* 4000)';
    makeLinInds = repmat(makeLinInds, [1, length(poleMaskTime)]);
    poleU = ((cellTMP.meta.poleOnset)'+poleMaskTime);
    poleD = ((cellTMP.meta.poleOffset)'+poleMaskTime);
    poleU(find(poleU >cellTMP.t)) = cellTMP.t;
    poleD(find(poleD >cellTMP.t)) = cellTMP.t;
    poleU = poleU +makeLinInds;
    poleD = poleD +makeLinInds;
    
    poleMask = ones(cellTMP.t, cellTMP.k);
    poleMask(poleD) = nan;
    poleMask(poleU) = nan;
    %%
    touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
    touchLateOnset = touchFirstOnset(1); % plot only the first touches
    allTouches = unique([touchFirstOnset; touchLateOnset]);
    % trials = ceil(allTouches./4000);
    % % % %     touchTimes = mod(allTouches, 4000);
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
    spikes = spikes.*poleMask;
    
    
    
    %% sort out the pro and ret trouches, gets rid of some becasue velocity is too low to indentify which is which
    velocity = squeeze(cellTMP.S_ctk(2,:,:));
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
    %     indexRet = find(testRET > 0);
    protractionTouches(indexPro) =1;
    retractionTouches(find(isnan(protractionTouches))) =1;
    
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
    
    
    
    %%
    theta = squeeze(cellTMP.S_ctk(1,:,:));
    thetaTouches = theta(touchMaskInd);
    %%% sort out the pro and ret trouches, gets rid of some becasue velocity is too low to indentify which is which
    phase = squeeze(cellTMP.S_ctk(5,:,:));
    protractionTouches = nan(size(touchMaskInd,1) ,1);
    retractionTouches = protractionTouches; % make both nans
    phase1 = (phase(touchMaskInd(:,trialToMatch-10)));
    proInds = phase1<0;
    retInds = ~proInds;
    %%%
    thetaTouches = thetaTouches - thetaTouches(:, 200+[0]);% push to 0
    %
    % close all
    %     figure
    plot(thetaTouches(proInds, :)', 'color', [0 0 1 .1])
    hold on
    plot(thetaTouches(retInds, :)', 'color', [1 0 0 .1])
    
    
    axis tight
    xlim([-50 50]+200)
end
%%
keyboard
saveLoc = ['C:\Users\maire\Documents\PLOTS\TOUCHES\whiskingPro-blue-ret-red\'];
    generalName = 'thetaPro-blue-sortedByPhase';
    mkdir(saveLoc)
    
    filename = [saveLoc, generalName];

    %%
    %     keyboard
    %     generalName = ['all pole aligned'] ;
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);

    saveas(gcf,filename,'png')
    savefig(filename)