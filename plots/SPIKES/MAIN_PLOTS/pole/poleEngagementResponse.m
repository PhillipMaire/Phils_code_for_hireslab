%% look at the pole up and pole down responses without touches and then look acros different
%% trials to see how the performace changes across the performace region
%% uses licking as the indicator not performance
%% PoleResponseAcrossPerformance



% polePlotType = 2

cellStepMAT = 1:length(U)
for poleTypesIter = 1:2
    plotRange = -100:200;
    %     toPlotAllPoles = nan(length(U), length(plotRange));
    rangeRemoveTouch = -50:4000;
    nameCell = { 'poleUP' 'poleDown'};
    
    for cellStep = cellStepMAT
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
        touchFirstOnset = find(squeeze(cellTMP.S_ctk(9,:,:))==1);
        %         allTouches = unique([touchFirstAll; touchLateALL]);
        allTouches = touchFirstOnset;
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
        poleD = reshape(poleD, [numel(poleD), 1]);%make sure the array is vertical
        trials = ceil(allTouches./4000);
        
        poleInds = (poleD + (plotRange));
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
        
        touchMask = touchMask(poleInds); % 0's are touches
        allpoles = spikes(poleInds);
        allpoles(makeTheseNans) = nan; % block out go over trial or under trail
        allpoles(find(touchMask==0)) = nan;%block out touches
        allpolesCell{poleTypesIter, cellStep} = allpoles;
        
        %%
        % % % % % % trialTypestruct.go = cellTMP.meta.trialType==1;%all trials that are go
        % % % % % % trialTypestruct.nogo = cellTMP.meta.trialType==0;%all trials that are nogo
        % % % % % % trialTypestruct.correct = cellTMP.meta.trialCorrect==1;
        % % % % % % trialTypestruct.incorrect = cellTMP.meta.trialCorrect==0;
        % % % % % % trialTypestruct.lick = (trialTypestruct.go.*trialTypestruct.correct)+(trialTypestruct.nogo.*trialTypestruct.incorrect);
        % % % % % % trialTypestruct.nolick =trialTypestruct.lick==0;
        % % % % % % trialTypestruct.hit = (trialTypestruct.go.*trialTypestruct.correct);
        % % % % % % trialTypestruct.corrRej=(trialTypestruct.nogo.*trialTypestruct.correct);
        % % % % % % trialTypestruct.falseAlarm = trialTypestruct.nogo.*trialTypestruct.incorrect;
        % % % % % % trialTypestruct.miss = trialTypestruct.go.*trialTypestruct.incorrect;
        [TT] = getTrialTypes(cellTMP);
        
        %         inputArray = TT.correct;
        inputArray = TT.miss;
        greaterOrLessThan = 0 ;% 1 is greater than set val 0 is less than
        PerfSET = 0.20 ;% performance to find
        getPerfRegion
        badPerfs{cellStep} = performaceRegionMat;
        PerfSETNameing{1} = PerfSET;
        greaterOrLessThan = 1 ;% 1 is greater than set val 0 is less than
        PerfSET = 0.4 ;% performance to find
        getPerfRegion
        goodPerfs{cellStep} = performaceRegionMat;
        PerfSETNameing{2} = PerfSET;
        %         greaterOrLessThan = 0 ;% 1 is greater than set val 0 is less than
        %         PerfSET = 0.6 ;% performance to find
        %         smoothByVal = 10 ; % keep this pretty low don't go up to like 50 or 100
        %         maxSkipVal = 5;
        %         minSkipvalue = 3;
        %         smoothPerf = smooth(inputArray , smoothByVal);
        %         trialNums = 1:1:length(smoothPerf);
        % %         figure
        % %         bar(smoothPerf, 5)
        %         if greaterOrLessThan == 1
        %             indsPerf = find(smoothPerf>=PerfSET);
        %         elseif greaterOrLessThan == 0
        %             indsPerf = find(smoothPerf<=PerfSET);
        %         else
        %             error('')
        %         end
        %         contIndsPerf = indsPerf'-(1:length(indsPerf));
        %         [startNums , indsForStart,~] = unique(contIndsPerf);
        %         indsForEnd = indsForStart(2:end)-1;
        %         indsForEnd(end+1) = length(indsPerf);
        %
        %         indsOfPerf = [indsPerf(indsForStart), indsPerf(indsForEnd)];
        %         indsOfPerf2 = indsOfPerf;
        %         lengthEach  = indsOfPerf(:, 2) - indsOfPerf(:, 1);
        %         skippedBy = (indsOfPerf(2:end, 1) - indsOfPerf(1:end-1, 2))-1;
        %
        %         skipedByMinInds =skippedBy<=maxSkipVal;
        %         minLengthToCombine = lengthEach>=minSkipvalue;
        %         combineTheseInds = find(skipedByMinInds.*minLengthToCombine(1:end-1));
        %         for testIter = flip(1:length(combineTheseInds))
        %             indsOfPerf(combineTheseInds(testIter), 2) = indsOfPerf(combineTheseInds(testIter)+1, 2);
        %             indsOfPerf(combineTheseInds(testIter), 2) = indsOfPerf(combineTheseInds(testIter)+1, 2);
        %         end
        %         keepInds = setdiff(1:size(indsOfPerf,1), combineTheseInds+1);
        %         indsOfPerf =  indsOfPerf(keepInds, :);
        %         lengthEach  = indsOfPerf(:, 2) - indsOfPerf(:, 1);
        %         performaceRegionMat{cellStep} = [indsOfPerf,lengthEach];
        %
        %
        %%
        toPlotpole2 = nanmean(allpoles);
        toPlotAllPoles{poleTypesIter, cellStep}  = toPlotpole2;
        toPlotpoleAllCell{poleTypesIter, cellStep} = allpoles;
        %         test = toPlotAllPoles(poleTypesIter, cellStep, :);test(:)
        %         keyboard
    end
end
%%

% close all

set(0,'defaultAxesFontSize',10)
smoothBy = 30;
minTrialsNeededToPlot = 20;
for poleTypesIter = 1:2
    subplotMakerNumber = 1; subplotMaker
    for cellStep = cellStepMAT
        tmp = goodPerfs{cellStep};
        [maxGood, indMax] = max(tmp(:,3));
        perfRegionGOOD = tmp(indMax,1:2);
        tmp = badPerfs{cellStep};
        [maxBad, indMax] = max(tmp(:,3));
        perfRegionBAD = tmp(indMax,1:2);
        
        
        toPlotpole = toPlotpoleAllCell{poleTypesIter, cellStep};
        if isnan(perfRegionGOOD(1)) || minTrialsNeededToPlot>maxGood
            toPlotPoleGood = nan(size(toPlotpole,2), 1);
        else
            toPlotPoleGood = nanmean(toPlotpole(perfRegionGOOD(1):perfRegionGOOD(end), :), 1);
            toPlotPoleGood = smooth(toPlotPoleGood, smoothBy);
            toPlotPoleGood = toPlotPoleGood- nanmean(toPlotPoleGood(1:trialToMatch));
        end
        if isnan(perfRegionBAD(1))|| minTrialsNeededToPlot>maxBad
            toPlotPoleBad = nan(size(toPlotpole,2), 1);
        else
            toPlotPoleBad = nanmean(toPlotpole(perfRegionBAD(1):perfRegionBAD(end), :), 1);
            toPlotPoleBad = smooth(toPlotPoleBad, smoothBy);
            toPlotPoleBad = toPlotPoleBad- nanmean(toPlotPoleBad(1:trialToMatch));
        end
        
        %             toPlotpole = toPlotAllPoles{poleTypesIter, cellStep};
        
        subplotMakerNumber = 2; subplotMaker
        
        polePlot = plot(plotRange,toPlotPoleGood, 'g-');
        hold on
        polePlot = plot(plotRange,toPlotPoleBad, 'r-');
        %             polePlot.Color = [polePlot.Color, 0.7];
        
        axis tight
        xlim([plotRange(1) plotRange(end)])
        %     keyboard
        tmpAXIS = gca;
        %         tmpAXIS.YLim(1) = 0 ;
        
    end
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
    %%
        
        saveLoc = ['C:\Users\maire\Documents\PLOTS\pole\engagementModulation\'];
            settingsName = ['badMax_', num2str(PerfSETNameing{1}),' goodMin' num2str(PerfSETNameing{2})];
        generalName = ['', nameCell{poleTypesIter}] ;
        mkdir(saveLoc)
        saveName = [saveLoc, generalName,' ', settingsName];
        %%
        save([saveName, 'VARS'], 'allpolesCell', 'toPlotAllPoles')
    
    
        %%
            
        %     generalName = ['all pole aligned'] ;
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
        filename =  [saveLoc, generalName];
        saveas(gcf,filename,'png')
        savefig(filename)
    
end







