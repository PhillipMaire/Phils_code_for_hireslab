%%
% polePlotType = 2
stepThroughUarray = 1:2%:length(U)
%%
allpolesCell = {};
for poleTypesIter = 1:2
    plotRange = -200:200;
   
    toPlotAllPoles = nan(length(U), length(plotRange));
    rangeRemoveTouch = -300:200;
    nameCell = { 'poleUP' 'poleDown'};
    
    for cellStep = stepThroughUarray
        clc
        disp(num2str(cellStep))
        %%
        cellTMP = U{cellStep};
        spikes = squeeze(cellTMP.R_ntk) .* 1000;
        %%
        %% next block out touches
        %% base this on the phase, if a touch occured, then remove the period 1/2 phase before and after the touch to
        %% remove the entire cycle surroudn this touch
        %% actually just going to do the easy way and block out like 50 ms before and after
        
        touchFirstAll = find(squeeze(cellTMP.S_ctk(14,:,:))==1);
        touchLateALL = find(squeeze(cellTMP.S_ctk(11,:,:))==1);
        allTouches = sort([touchFirstAll; touchLateALL]);
        % trials = ceil(allTouches./4000);
        
        touchMaskInd = (allTouches + (rangeRemoveTouch));
        trialToMatch = find(rangeRemoveTouch==0);
        % get the trial numbers
        touchMaskIndTrial = ceil(touchMaskInd./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented at trialToMatch (where the trial the touch happened in)
        touchMaskIndTrial = touchMaskIndTrial - touchMaskIndTrial(:,trialToMatch);
        %find only the ones that are the same trial the touch was extracted from
        touchMaskIndTrial = find(touchMaskIndTrial==0);
        % keep only the ind that are in that same trial
        touchMaskInd = touchMaskInd(touchMaskIndTrial);
        touchMask = ones(size(spikes));
        touchMask(touchMaskInd) = 0;
        %%
        
        
        if poleTypesIter == 1
            poleD = cellTMP.meta.poleOnset;
        elseif poleTypesIter ==2
            poleD = cellTMP.meta.poleOffset;
        else
            error('not valid input number')
        end
        
        poleD(poleD>cellTMP.t) = nan;
        if numel(poleD) ~= cellTMP.k
            error('for some reason the pole down doesnt match length of trials, this should never happen but this is here just incase')
        end
        poleD = poleD + ((0:cellTMP.k-1).*cellTMP.t);
        poleD =  poleD(:);% reshape(poleD, [numel(poleD), 1]);%make sure the array is vertical       poleD(:);%
        trials = ceil(allTouches./4000);
        
        poleInds = (poleD(:) + (plotRange(:)'));
        poleInds(find(isnan(poleD)), :) =  nan;
         trialToMatch = find(plotRange==0);
        % get the trial numbers
        poleIndTrial = ceil(poleInds./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented as trialToMatch (where the trial the event happened in)
        poleIndTrial = poleIndTrial - poleIndTrial(:,trialToMatch);
        %find only the ones that are the same trial the touch was extracted from
        makeTheseNans = find(poleIndTrial~=0);
        %find any valid index (here just the first one we find that is valid)
        tempReplaceForIndexToNAN = find(poleIndTrial==0, 1);
        % thie is only temporary. because of edge problems which include going out of index range
        % and include running off into the next trial we are going to replace these all with nans later
        % for now make sure that they index without erroring out
        poleInds(makeTheseNans) = poleInds(tempReplaceForIndexToNAN);
        % keep only the ind that are in that same trial
        
        
        %%
        
        %     [~, removeIndex, ~] = intersect(poleInds, touchMaskInd);
        
        touchMask = touchMask(poleInds); % 0's are spikes
        allpoles = spikes(poleInds);
        allpoles(makeTheseNans) = nan; % block out go over trial or under trail
        allpoles(find(touchMask==0)) = nan;%block out touches
        allpolesCell{cellStep, poleTypesIter} = allpoles;
        toPlotpole2 = nanmean(allpoles);
        toPlotAllPoles(cellStep, 1:length(plotRange))  = toPlotpole2;
        
    end
    
end
%%
allpolesCell2 = allpolesCell;
%%
smallEarly = (0:25) +25;
smallLate = (25:50)+25;
largeLate = (50:100) +25;
allTimes = {smallEarly, smallLate , largeLate}
% % % large = 0:100; % NO GOOD no cells is this the best for and significant
BLtime = -101:-1;

BLtime = BLtime+trialTimeToMatch ;
%% get t tests
% subplotMakerNumber = 1; subplotMaker
% set(0,'defaultAxesFontSize',10)pvalsAll={};
pvalsAll={};
for timeTests = 1:length(allTimes)
trialTimeToMatch = find(plotRange==0);
signalTime =allTimes{timeTests};



signalTime = signalTime+trialTimeToMatch;
for poleUpDownStep = 1:2
    subplotMakerNumber = 1; subplotMaker
    for cellStep = stepThroughUarray
        disp(num2str(cellStep));
        %         if  poleUpDownStep ==1
        poleTrace = allpolesCell{cellStep,poleUpDownStep };
        %         else
        %             poleTrace =(allTouchRet{cellStep});
        %         end
        proTouchBL = nanmean(poleTrace(:, BLtime), 2);
        proTouchSIG = nanmean(poleTrace(:, signalTime), 2);
        
        
        [~, p] = ttest2(proTouchBL,proTouchSIG);
        disp(num2str(p))
        
        
        subplotMakerNumber = 2; subplotMaker
        %         if poleUpDownStep ==1
        %             toPlotPro = toPlotAllTouch(cellStep, :, 1);
        %         else
        %             toPlotPro = toPlotAllTouch(cellStep, :, 2);
        %
        %         end
        toPlotPro = allpolesCell{cellStep, poleUpDownStep};
        toPlotPro = nanmean(toPlotPro, 1);
        
        toPlotPro(isnan(toPlotPro)) = 0;
        toPlotPro = smooth(toPlotPro, smoothBy);
        proPlot = plot(plotRange,toPlotPro, 'b');
        proPlot.Color = [proPlot.Color, 1];
        
        
        
        tmp = [xlim, ylim];
        text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
        %     keyboard
        pvals(cellStep, poleUpDownStep) = p ;
        if tmp(4)<1
            ylim([0 1])
        else
            ylim([0 tmp(4)])
        end
    end
end

%%%

    pvalsAll{end+1, 1} = pvals;
    pvalsAll{end, 2} = BLtime;
    pvalsAll{end, 3} = signalTime;
    pvalsAll{end, 4} = trialTimeToMatch;
end
%%
%%
heightOfPvalsArray = size(pvalsAll, 1);
pvalsAll2 = [];
for k = 1:heightOfPvalsArray
    pvalsAll2(1:size(pvalsAll{1}, 1), 1:size(pvalsAll{1}, 2), k) = pvalsAll{k}
end

[minPvals, signalTimeIndex] = nanmin(pvalsAll2,[], 3)

minPvals(isnan(minPvals)) = 99999; %make sure nans are not classified as significant
proRetTouchSignif = minPvals<0.01;% ret and pro touch sig test

allTouchSignificant = (mean(proRetTouchSignif, 2))>0
percentAllSig = mean(allTouchSignificant) % percent of responsive either ret or pro

%%


%% now we can plot all together
close all
plotRange2 = -100:200;
xlimits = [-20 200];
subplotMakerNumber=1; subplotMaker_2by3
smoothBy = 30;
BLindex = 1:find(plotRange2==0)-20;% minus 20 becasue sometimes signal leaks into before touch region
for poleUpDownStep = 1:2 % 1 is pro 2 is ret 
    for k = 1:heightOfPvalsArray
        signalTimeSelection = signalTimeIndex == k ;
        selectedCellsAndTraves = find(signalTimeSelection(:, poleUpDownStep) .* proRetTouchSignif(:, poleUpDownStep));
        xlim(xlimits)
        subplotMakerNumber=2; subplotMaker_2by3
        for cellStep = 1:length(selectedCellsAndTraves) % cells that are sig modulated by at least one test
            cellStep2 = selectedCellsAndTraves(cellStep);
            disp(num2str(cellStep2));
            % % %     if  proret2step ==1
            % % %         proTouch =(allTouchPro{cellStep});
            % % %     else
            % % %         proTouch =(allTouchRet{cellStep});
            % % %     end
            % % %     proTouchBL = nanmean(proTouch(:, BLtime), 2);
            % % %     proTouchSIG = nanmean(proTouch(:, signalTime), 2);
            % % %
            % % %
            % % %     [~, p] = ttest2(proTouchBL,proTouchSIG);
            % % %     disp(num2str(p))
            % % %
            
            %     subplotMakerNumber = 2; subplotMaker
            %     if find(isnan(toPlotPro))
            %     keyboard
            %     end
            %     toPlotPro(isnan(toPlotPro)) = 0;
             toPlotPro = nanmean(allpolesCell{cellStep2, poleUpDownStep});
            
            
            toPlotPro = smooth(toPlotPro, smoothBy);
            toPlotPro = toPlotPro(plotRange2+ trialTimeToMatch);
            toPlotPro = toPlotPro./ std(toPlotPro(BLindex));% zscored
            %     toPlotPro = zscore(toPlotPro);
            toPlotPro = toPlotPro-mean(toPlotPro(BLindex));
            proPlot = plot(plotRange2,toPlotPro);
            hold on
            
            proPlot.Color = [proPlot.Color, 1];
            proPlot.LineWidth = 1.3;
            
            % % %
            % % %         tmp = [xlim, ylim];
            % % %         text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
            % % %     %     keyboard
            % % %         pvals(cellStep, proret2step) = p ;
            % % %         if tmp(4)<1
            % % %             ylim([0 1])
            % % %         else
            % % %            ylim([0 tmp(4)])
            % % %         end
        end
        xlim(xlimits)
        axis tight
%         set(gca, 'YScale', 'log')
    end
end

%%
axis tight
%%
ylim([-10 10])
%%


















%%
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
smoothBy = 10;
for cellStep = 1:length(U)
    toPlotpole = toPlotAllPoles(cellStep, :);
    subplotMakerNumber = 2; subplotMaker
    toPlotpole = smooth(toPlotpole, smoothBy);
    polePlot = plot(plotRange,toPlotpole, 'k');
    hold on
    polePlot.Color = [polePlot.Color, 0.7];
    
    axis tight
    xlim([plotRange(1) plotRange(end)])
    %     keyboard
    tmpAXIS = gca;
    %     tmpAXIS.YLim(1) = 0 ;
    
end
%%
%     keyboard
saveLoc = ['C:\Users\maire\Documents\PLOTS\pole\'];
generalName = ['', nameCell{poleTypesIter}] ;
mkdir(saveLoc)

saveName = [saveLoc, generalName];
%%
save([saveName, 'VARS'], 'allpolesCell', 'toPlotAllPoles')


%%
%     keyboard
%     generalName = ['all pole aligned'] ;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
filename =  saveName;
saveas(gcf,filename,'png')
savefig(filename)


