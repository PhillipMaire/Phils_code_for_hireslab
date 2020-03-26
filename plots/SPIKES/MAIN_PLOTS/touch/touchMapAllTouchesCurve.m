%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
crush
clearvars -except U u U2
plotRange = -200:200;
toPlotAllTouch = nan( length(U), length(plotRange), 2); % 2 for protraction then retraction

percentLow = 0.2; % softer (sometimes mismatched) touches
percentHigh = 1;% harder touches
% for percents = 1:9
%     percentLow = percentLow+.1;
%     percentHigh = percentHigh+.1

getOnlyFirstTouch = false
touchType = 'onset';
poleMaskTime = 0:1;

for cellStep = 1:length(U)
    
    
    %%
    disp(num2str(cellStep))
    cellTMP = U{cellStep};
    %% make maske for pole up and down
    
    [poleMask]  = MASK_pole(cellTMP, poleMaskTime, poleMaskTime);
    %%
    [allTouches, segments] = GET_touches(cellTMP, touchType, getOnlyFirstTouch);
    %%
    allTouches = selectTouchesBasedOnCurvePercentile(cellTMP, allTouches, percentLow, percentHigh);
    %%
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
    
    
    %%
    phase = squeeze(cellTMP.S_ctk(5,:,:));
    protractionTouches = nan(size(touchMaskInd,1) ,1);
    retractionTouches = protractionTouches; % make both nans
    phase1 = (phase(touchMaskInd(:,trialToMatch-10)));
    proInds = phase1<0;
    retInds = ~proInds;
    protractionTouches(proInds) =1;
    retractionTouches(retInds) =1;
    %% sort out the pro and ret trouches, gets rid of some becasue velocity is too low to indentify which is which
    %       velocity = squeeze(cellTMP.S_ctk(2,:,:));
    %     protractionTouches = nan(size(touchMaskInd,1) ,1);
    %     retractionTouches = protractionTouches; % make both nans
    %     timeForVelDet = -25:-5; %assume that 0 is the event start choose tie to calculate the velocity of the touch
    %     timeIndex = trialToMatch + timeForVelDet -1;
    %     velocityTest1 = nanmedian(velocity(touchMaskInd(:,timeIndex)),2);
    %     test1 = velocityTest1>0;
    %     test2 = velocityTest1<0;
    %     velocityTest2 = nanmean(velocity(touchMaskInd(:,timeIndex)),2);
    %     test3 = velocityTest2>0;
    %     test4 = velocityTest2<0;
    %
    %     testPRO = test1+test3;
    %     testRET = test2 +test4;
    %     indexPro = find(testPRO > 0);
    %     indexRet = find(testRET > 0);
    %     protractionTouches(indexPro) =1;
    %     retractionTouches(find(isnan(protractionTouches))) =1;
    
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
%%%


smoothBy = 6;

subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = 1:length(U)
    
    subplotMakerNumber = 2; subplotMaker
    
    
    toPlotRet = toPlotAllTouch(cellStep, :, 2);
    toPlotRet(isnan(toPlotRet)) = 0;
    toPlotRet = smooth(toPlotRet, smoothBy);
    retPlot = plot(plotRange,toPlotRet, 'r');
    hold on
    retPlot.Color = [retPlot.Color, 0.7];
    
    
    toPlotPro = toPlotAllTouch(cellStep, :, 1);
    toPlotPro(isnan(toPlotPro)) = 0;
    toPlotPro = smooth(toPlotPro, smoothBy);
    proPlot = plot(plotRange,toPlotPro, 'b');
    proPlot.Color = [proPlot.Color, 0.4];
    
    axis tight
    xlim([plotRange(1) plotRange(end)])
    xlim([-25 75])
    %     keyboard
    tmpAXIS = gca;
    %     tmpAXIS.YLim(1) = 0 ;
end

%%
saveLoc = 'C:\Users\maire\Dropbox\HIRES_LAB\SAVED_VARIABLES\touch\touchMapAllTouchesCurve\';
saveNameString = 'touchesProThenRet_JONS1';
percentName = [num2str(percentLow),'_' ,  num2str(percentHigh )];
save([saveLoc, saveNameString, percentName, '.mat'], 'allTouchRet', 'allTouchPro')
%% get t tests
subplotMakerNumber = 1; subplotMaker
% set(0,'defaultAxesFontSize',10)
trialToMatch = find(plotRange==0);
signalTime =21:50
BLtime = -30:-1;
pvals = [];

BLtime = BLtime+trialToMatch ;
signalTime = signalTime+trialToMatch;
for cellStep = 1:length(U)
    disp(num2str(cellStep));
    
    proTouch =(allTouchPro{cellStep});
    proTouchBL = nanmean(proTouch(:, BLtime), 2);
    proTouchSIG = nanmean(proTouch(:, signalTime), 2);
    
    % h = ttest2(toPlotRet(BLtime),toPlotRet(signalTime))
    [~, p] = ttest2(proTouchBL,proTouchSIG);
    disp(num2str(p))
    
    
       subplotMakerNumber = 2; subplotMaker
    toPlotPro = toPlotAllTouch(cellStep, :, 1);
    toPlotPro(isnan(toPlotPro)) = 0;
    toPlotPro = smooth(toPlotPro, smoothBy);
    proPlot = plot(plotRange,toPlotPro, 'b');
    proPlot.Color = [proPlot.Color, 1];
    
    
    
    tmp = [xlim, ylim];
    text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
%     keyboard
    pvals(cellStep) = p ;
end


%%
pvalsAll = {};
pvalsAll{end+1, 1} = pvals; 
pvalsAll{end, 2} = BLtime; 
pvalsAll{end, 3} = signalTime; 
pvalsAll{end, 4} = trialToMatch; 
%%


%%
allPmat =  pvalsAll{1, 1}';
for k = 2:size(pvalsAll, 1)
    
allPmat(:, end+1) = pvalsAll{k,1};
    
end
sigMat = (allPmat<0.05)
sigmat2 = sum(sigMat, 2)
pvalsAllSameSigs = sigMat(:, 1:3) + sigMat(:, 4:6) 
%%

keyboard
% saveLoc = ['C:\Users\maire\Documents\GitHub\Phils_code_for_hireslab\plots\SPIKES\New folder\vArrayBuilderMats\touch\'];
saveLoc = ['/Users/phillipmaire/Dropbox/HIRES_LAB/FIGURES/S2/Touch/proTrac'];
% saveLoc = ['\'];

generalName = ['touch_percent_', num2str(percentLow), '_to_', num2str(percentHigh)] ;
mkdir(saveLoc)

%
save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')

set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);

filename =  [saveLoc, generalName];
savefig([filename, '.fig'])
saveas(gcf,[filename,'.png'],'png')



% end





