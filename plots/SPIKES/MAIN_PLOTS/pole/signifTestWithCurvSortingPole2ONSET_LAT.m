%% signifTestWithCurvSortingPole2ONSET_LAT
% function signifTestWithCurvSortingPole2ONSET_LAT(U)


REDO_FIND_VAR = true;


%%
if REDO_FIND_VAR
    theseCells = 1:length(U);
    allpolesCell = {};
    
    for poleTypesIter = 1:2
        plotRange = -200:200;
        
        toPlotAllPoles = nan(length(U), length(plotRange));
        rangeRemoveTouch = -10:200;
        nameCell = { 'poleUP' 'poleDown'};
        
        for cellStep = theseCells
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
            keyboard
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
    cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\DATA_TO_LOAD')
    nameVar = [strcat(datestr(now,'yymmdd_HHMM')), '_poleVariables'];
%     save(nameVar,'allpolesCell', 'plotRange', 'theseCells', 'rangeRemoveTouch', 'plotRange')
end
%%
addForDelay = 30;% shifts the period to test significance
% reallyEarly = 8:20 + addForDelay;
smallEarly = (0:25) + addForDelay;
smallLate = (25:50)+addForDelay;
largeLate = (50:100) +addForDelay;
allTimes = { smallEarly, smallLate , largeLate}
% % % large = 0:100; % NO GOOD no cells is this the best for and significant
BLtime = -50:-1;
trialTimeToMatch = find(plotRange==0);
BLtime = BLtime+trialTimeToMatch ;
smoothBy = 10;
%% get t tests
% subplotMakerNumber = 1; subplotMaker
% set(0,'defaultAxesFontSize',10)pvalsAll={};
pvalsAll={};
allPoleTracesNanMean = [];
for timeTests = 1:length(allTimes)
    
    signalTime =allTimes{timeTests};
    pvals = ones(max(theseCells), 2).*9999;
    diffSigBase = [];
    
    
    
    signalTime = signalTime+trialTimeToMatch;
    for poleUpDownStep = 1:2
        subplotMakerNumber = 1; subplotMaker
        for cellStep = theseCells
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
            allPoleTracesNanMean(cellStep,1:length(toPlotPro), poleUpDownStep) = toPlotPro;
            
            toPlotPro(isnan(toPlotPro)) = 0;
            toPlotPro = smooth(toPlotPro, smoothBy);
            proPlot = plot(plotRange,toPlotPro, 'b');
            proPlot.Color = [proPlot.Color, 1];
            
            
            
            tmp = [xlim, ylim];
            text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
            %     keyboard
            pvals(cellStep, poleUpDownStep) = p ;
            diffSigBase(cellStep, poleUpDownStep) = (nanmean(proTouchSIG) - nanmean(proTouchBL));
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
    pvalsAll{end, 5} = diffSigBase;
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
latencyStructPole = struct;
PLOT_WHERE_ONSET_IS = false
latencyCellPole = {};
cellIndex = {};
minOnsetTime = 7;
close all
onsetSDthresh = 2.5;
inArowMinForOnset = 2;
plotRange2 = -100:200;
matchTimeStart = find(plotRange2==0);
[outputVarAll] = SPmaker(2, heightOfPvalsArray);

BLindex = 50+1 :matchTimeStart;% minus 20 becasue sometimes signal leaks into before touch region


% offsetVal = [20, 4]
offsetVal = [0, 0]


% xlimits = [-20 200];
% subplotMakerNumber=1; subplotMaker_2by3
smoothBy = 10;
% BLindex = 1:find(plotRange2==0)-20;% minus 20 becasue sometimes signal leaks into before touch region
for poleUpDownStep = 1:2 % 1 is pro 2 is ret
    for k = 1:heightOfPvalsArray
        signalTimeSelection = signalTimeIndex == k ;
        selectedCellsAndTraces = find(signalTimeSelection(:, poleUpDownStep) .* proRetTouchSignif(:, poleUpDownStep));
        [outputVarAll] = SPmaker(outputVarAll);
        
        for kk = 1:length(selectedCellsAndTraces) % cells that are sig modulated by at least one test
            cellStep2 = selectedCellsAndTraces(kk);
            disp(num2str(cellStep2));
            cellIndex{kk, k,poleUpDownStep} = cellStep2;
            % % %     if  proret2step ==1
            % % %         proTouch =(allTouchPro{kk});
            % % %     else
            % % %         proTouch =(allTouchRet{kk});
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
            
            % % % %
            % % % %             toPlotPro = smooth(toPlotPro, smoothBy);
            % % % %             toPlotPro = toPlotPro(plotRange2+ trialTimeToMatch);
            % % % %             toPlotPro = toPlotPro./ std(toPlotPro(BLindex));% zscored
            % % % %             %     toPlotPro = zscore(toPlotPro);
            % % % %             toPlotPro = toPlotPro-mean(toPlotPro(BLindex));
            % % % %             proPlot = plot(plotRange2,toPlotPro);
            toPlotPro = toPlotPro(plotRange2+ trialTimeToMatch);
            toPlotPro = toPlotPro./ std(toPlotPro(BLindex));% zscored
            %     toPlotPro = zscore(toPlotPro);
            toPlotPro = toPlotPro-mean(toPlotPro(BLindex));
            %% find latency
            latency = find(abs(toPlotPro)>onsetSDthresh);
            latency =  latency(find(latency>matchTimeStart+minOnsetTime));
            if ~isempty(latency)
                startEndLengthOF_signal = findInRow(latency);
            else
                startEndLengthOF_signal = [0 0 0]; %make nan later
            end
            startEndLengthOF_signal = startEndLengthOF_signal(startEndLengthOF_signal(:,3)>=inArowMinForOnset, :);
            if isempty(startEndLengthOF_signal)
                latencyCellPole{kk, k,poleUpDownStep} = nan;
            else
                latencyCellPole{kk, k,poleUpDownStep} = startEndLengthOF_signal(1) -matchTimeStart - offsetVal(poleUpDownStep);%%### -1 here cause ...
            end
            
            
            
            toPlotPro = smooth(toPlotPro, smoothBy);
            %             keyboard
            
            proPlot = plot(plotRange2,toPlotPro);
            hold on
            
            proPlot.Color = [proPlot.Color, 1];
            proPlot.LineWidth = 1.3;
            
            %             keyboard
            % % %
            % % %         tmp = [xlim, ylim];
            % % %         text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
            % % %     %     keyboard
            % % %         pvals(kk, proret2step) = p ;
            % % %         if tmp(4)<1
            % % %             ylim([0 1])
            % % %         else
            % % %            ylim([0 tmp(4)])
            % % %         end
            if PLOT_WHERE_ONSET_IS
                try
                    close all
                    tmp = latencyCellPole{kk, k,poleUpDownStep};
                    figure
                    %             keyboard
                    proPlot = plot(plotRange2,toPlotPro);
                    hold on
                    
                    proPlot.Color = [proPlot.Color, 1];
                    proPlot.LineWidth = 1.3;
                    plot(tmp, toPlotPro(tmp+matchTimeStart), '*r')
                catch
                end
                disp(tmp)
                keyboard
                hold off
            end
        end
    end
    
end
% keyboard

%
%%
latencyStructPole. latency = latencyCellPole;
latencyStructPole. cellIndexForUarray = cellIndex;
latencyStructPole.proRetTouchSignif = proRetTouchSignif;
latencyStructPole.details = ':, :, 1 is poleUp :,:,2 is poleDown';
latencyStructPole.minPvals = minPvals;
latencyStructPole.signalTimeIndex = signalTimeIndex;
latencyStructPole.allTimes = allTimes;
latencyStructPole.matchTimeStart = matchTimeStart;
latencyStructPole.BLindex = BLindex;
    cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\DATA_TO_LOAD')

save('latencyStructPole', 'latencyStructPole')




poleStruct = struct;
poleStruct.allpolesCell = allpolesCell;

poleStruct.notes = 'allpolesCell is cells by 2 (1 is poleup 2 is poledown)';
poleStruct.allPoleTracesNanMean = allPoleTracesNanMean;
poleStruct.pvalsAll = pvalsAll;
poleStruct.PVAL_notes = 'rows are different time tests colums are pvals, BLindex, SignalIndex, zeroPoint';
save('poleStruct', 'poleStruct')










%
% %%
% keyboard
% subplotMakerNumber = 1; subplotMaker
% set(0,'defaultAxesFontSize',10)
% smoothBy = 10;
% for cellStep = 1:length(U)
%     toPlotpole = toPlotAllPoles(cellStep, :);
%     subplotMakerNumber = 2; subplotMaker
%     toPlotpole = smooth(toPlotpole, smoothBy);
%     polePlot = plot(plotRange,toPlotpole, 'k');
%     hold on
%     polePlot.Color = [polePlot.Color, 0.7];
%
%     axis tight
%     xlim([plotRange(1) plotRange(end)])
%     %     keyboard
%     tmpAXIS = gca;
%     %     tmpAXIS.YLim(1) = 0 ;
%
% end
% %%
% %     keyboard
% saveLoc = ['C:\Users\maire\Documents\PLOTS\pole\'];
% generalName = ['', nameCell{poleTypesIter}] ;
% mkdir(saveLoc)
%
% saveName = [saveLoc, generalName];
% %%
% save([saveName, 'VARS'], 'allpolesCell', 'toPlotAllPoles')
%
%
% %%
% %     keyboard
% %     generalName = ['all pole aligned'] ;
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
% filename =  saveName;
% saveas(gcf,filename,'png')
% savefig(filename)
%

