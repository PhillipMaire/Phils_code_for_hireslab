%% in this version i changed so that low velocity touches aren't ignored ( normally ignored
%% becasue the direction of the touch can't be determined)
plotRange = -200:200;
toPlotAllTouch = nan( length(U), length(plotRange), 2); % 2 for protraction then retraction
smoothBy = 30;
for cellStep = 1:length(U)
    disp(num2str(cellStep))
    cellTMP = U{cellStep};
    touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(cellTMP.S_ctk(12,:,:))==1);
    % % % % % % %           touchLateOnset = touchFirstOnset(1); % plot only the first touches
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
    %     indexRet = find(testRET > 0);
    protractionTouches(indexPro) =1;
    retractionTouches(find(isnan(protractionTouches))) =1;
    
    %%
    
    %%
    toPlot = spikes(touchMaskInd);
    toPlot(makeTheseNans) = nan;
    allTouchRet{cellStep} = toPlot.*retractionTouches;
    allTouchPro{cellStep} = toPlot.*protractionTouches;
    test2= find(~isnan(nanmean( allTouchRet{cellStep}, 2)));
    allTouchRet{cellStep} =  allTouchRet{cellStep}(test2, :);
    test2= find(~isnan(nanmean( allTouchPro{cellStep}, 2)));
    allTouchPro{cellStep} =  allTouchPro{cellStep}(test2, :);
    %
    %     toPlotRet = nanmean(allTouchRet{cellStep});
    %     toPlotPro = nanmean(allTouchPro{cellStep});
    %     toPlotRet = nanmean(toPlot.*retractionTouches);
    %     toPlotPro = nanmean( toPlot.*protractionTouches);
    %     toPlotAllTouch(cellStep, :, 1) = toPlotPro;
    %     toPlotAllTouch(cellStep, :, 2) = toPlotRet;
    allTouchesHeatALL{cellStep}  = [allTouchPro{cellStep};nan(20, size(allTouchPro{cellStep}, 2));  allTouchRet{cellStep} ];
end

winToLook = 100; % ms
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = 1:length(U)
    disp(num2str(cellStep))
    allTouchesHeat = allTouchesHeatALL{cellStep} ;
    subplotMakerNumber = 2; subplotMaker
    for smoothStep = 1:size(allTouchesHeat,1)
        allTouchesHeat(smoothStep,:) = smooth(allTouchesHeat(smoothStep,:),smoothBy);
        
    end
    relativeMax = (allTouchesHeat);
    relativeMax = relativeMax(:);
    relativeMax = relativeMax(~isnan(relativeMax));
     relativeMax = relativeMax(relativeMax~=0);
     relativeMax = sort(relativeMax(:));
     if ~isempty(relativeMax)
    relativeMax2 = round(relativeMax(ceil(length(relativeMax(:)).* .95)));
     else
         relativeMax2 =1;
     end
%     test5 = nanmean(allTouchesHeat(:, trialToMatch:trialToMatch+winToLook), 2);
    [~, indexSort] =     sort(nanmean(allTouchesHeat(:, trialToMatch:trialToMatch+winToLook),2));
    allTouchesHeat(allTouchesHeat>=relativeMax2) =  max(allTouchesHeat(:));
    allTouchesHeat2 = (allTouchesHeat(:) - min(allTouchesHeat(:))) / ( max(allTouchesHeat(:)) - min(allTouchesHeat(:)));
    allTouchesHeat2 = reshape(allTouchesHeat2, size(allTouchesHeat));
    allTouchesHeat2 = allTouchesHeat2(indexSort, :);
    imagesc(log(allTouchesHeat2))
    xlim([-50 100]+200);
end

keyboard
% % % % % subplotMakerNumber = 1; subplotMaker
% % % % % set(0,'defaultAxesFontSize',10)
% % % % % for cellStep = 1:length(U)
% % % % %
% % % % %     subplotMakerNumber = 2; subplotMaker
% % % % %
% % % % %
% % % % %     toPlotRet = toPlotAllTouch(cellStep, :, 2);
% % % % %
% % % % %
% % % % %
% % % % %     toPlotRet = smooth(toPlotRet, smoothBy);
% % % % %     retPlot = plot(plotRange,toPlotRet, 'r');
% % % % %     hold on
% % % % %     retPlot.Color = [retPlot.Color, 0.7];
% % % % %
% % % % %
% % % % %     toPlotPro = toPlotAllTouch(cellStep, :, 1);
% % % % %     toPlotPro = smooth(toPlotPro, smoothBy);
% % % % %     proPlot = plot(plotRange,toPlotPro, 'b');
% % % % %     proPlot.Color = [proPlot.Color, 0.4];
% % % % %
% % % % %     axis tight
% % % % %     xlim([plotRange(1) plotRange(end)])
% % % % %     xlim([-50 50])
% % % % %     %     keyboard
% % % % %     tmpAXIS = gca;
% % % % %     %     tmpAXIS.YLim(1) = 0 ;
% % % % % end
% % % % % %  keyboard
saveLoc = ['C:\Users\maire\Documents\GitHub\Phils_code_for_hireslab\plots\SPIKES\New folder\vArrayBuilderMats\touch\'];
saveLoc = ['\'];
generalName = ['red ret blue pro axis tight'] ;
generalName = ['red ret blue pro axis tight'] ;
mkdir(saveLoc)

%%
save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')



set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);

filename =  [saveLoc, generalName];
saveas(gcf,filename,'png')
savefig(filename)








