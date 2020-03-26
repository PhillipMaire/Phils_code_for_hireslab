%% signifTestWithCurvSortingONSET_LAT
% function signifTestWithCurvSortingONSET_LAT(U)
%% signifTestWithCurvSortingONSET_LAT.m
%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
% % % % plotRange = -200:200;
% % % % toPlotAllTouch = nan( length(U), length(plotRange), 2); % 2 for protraction then retraction
% % % % smoothBy = 20;
% % % % percentLow = 0.2; % softer (sometimes mismatched) touches
% % % % percentHigh = 1;% harder touches
% % % % % for percents = 1:9
% % % % %     percentLow = percentLow+.1;
% % % % %     percentHigh = percentHigh+.1
% % % %   poleMaskTime = 0:200;


%% OUTPUT THAT WE CARE ABOUT
%%     proRetTouchSignif   allTouchSignif   percentAllSig
REDO_FIND_VAR = true;
cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\DATA_TO_LOAD')

if REDO_FIND_VAR
    theseCells =  1:length(U);
    
    percentLow = 0.2; % softer (sometimes mismatched) touches
    percentHigh = 1;% harder touches
    plotRange = -200:200;
    toPlotAllTouch = nan( length(theseCells), length(plotRange), 2); % 2 for protraction then retraction
    plotOnlyFirstTouch = false
    poleMaskTime = 0:1;
    for cellStep = theseCells
        
        
        %%
        disp(num2str(cellStep))
        cellTMP = U{cellStep};
        %% make maske for pole up and down
        
        makeLinInds = ((0:cellTMP.k -1) .* cellTMP.t)';
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
        if plotOnlyFirstTouch
            touchLateOnset = touchFirstOnset(1); % plot only the first touches
        end
        allTouches = unique([touchFirstOnset; touchLateOnset]);
        
        
        touchFirstOFF = find(squeeze(cellTMP.S_ctk(9+1,:,:))==1);
        touchLateOFF = find(squeeze(cellTMP.S_ctk(12+1,:,:))==1);
        %     touchLateOnset = touchFirstOnset(1); % plot only the first touches
        allTouchesOFF = unique([touchFirstOFF; touchLateOFF]);
        %%
        allTouches = selectTouchesBasedOnCurvePercentile(cellTMP, allTouches, percentLow, percentHigh);
        %%
        % trials = ceil(allTouches./4000);
        % % % %     touchTimes = mod(allTouches, 4000);
        touchMaskInd = (allTouches + (plotRange));
        trialTimeToMatch = find(plotRange==0);
        % get the trial numbers
        touchMaskIndTrial = ceil(touchMaskInd./cellTMP.t);
        % subtract the trial number from the trial numbers at the '0' point
        % represented at trialToMatch (where the trial the touch happened in)
        touchMaskIndTrial = touchMaskIndTrial - touchMaskIndTrial(:,trialTimeToMatch);
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
        phase1 = (phase(touchMaskInd(:,trialTimeToMatch-10)));
        proInds = phase1<0;
        retInds = ~proInds;
        protractionTouches(proInds) =1;
        retractionTouches(retInds) =1;
        
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
    cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\DATA_TO_LOAD')
    
    nameVar = [strcat(datestr(now,'yymmdd_HHMM')), '_touchVariables'];
%     save(nameVar,'theseCells', 'plotRange', 'toPlotAllTouch', 'allTouchPro', 'allTouchRet')
end
%%
smoothBy = 10
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = theseCells
    
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
    %
    axis tight
    xlim([plotRange(1) plotRange(end)])
        xlim([-50 100])
    %     keyboard
    tmpAXIS = gca;
    %     tmpAXIS.YLim(1) = 0 ;
end

%%
% saveLoc = 'C:\Users\maire\Dropbox\HIRES_LAB\SAVED_VARIABLES\touch\touchMapAllTouchesCurve\';
% saveNameString = 'touchesProThenRet_';
% percentName = [num2str(percentLow),'_' ,  num2str(percentHigh )];
% save([saveLoc, saveNameString, percentName, '.mat'], 'allTouchRet', 'allTouchPro')
%%
reallyEarly = 8:25;
smallEarly = 0:25;
smallLate = 25:50;
largeLate = 50:100;
allTimes = {reallyEarly, smallLate, largeLate}
% % % large = 0:100; % NO GOOD no cells is this the best for and significant
BLtime = -101:-1;
trialTimeToMatch = find(plotRange==0);
BLtime = BLtime+trialTimeToMatch ;
%% get t tests
pvalsAll={};
for timeTests = 1:length(allTimes)
    pvals = ones(max(theseCells), 2).*9999;
    subplotMakerNumber = 1; subplotMaker
    % set(0,'defaultAxesFontSize',10)
    
    signalTime =allTimes{timeTests};
    diffSigBase = [];
    
    
    signalTime = signalTime+trialTimeToMatch;
    for proret2step = 1:2
        for cellStep = theseCells
            disp(num2str(cellStep));
            if  proret2step ==1
                proTouch =(allTouchPro{cellStep});
            else
                proTouch =(allTouchRet{cellStep});
            end
            proTouchBL = nanmean(proTouch(:, BLtime), 2);
            proTouchSIG = nanmean(proTouch(:, signalTime), 2);
            
            
            [~, p] = ttest2(proTouchBL,proTouchSIG);
            disp(num2str(p))
            %             figure, plot(nanmean(proTouch, 1))
            
            subplotMakerNumber = 2; subplotMaker
            if proret2step ==1
                toPlotPro = toPlotAllTouch(cellStep, :, 1);
            else
                toPlotPro = toPlotAllTouch(cellStep, :, 2);
                
            end
            
            toPlotPro(isnan(toPlotPro)) = 0;
            toPlotPro = smooth(toPlotPro, smoothBy);
            proPlot = plot(plotRange,toPlotPro, 'b');
            proPlot.Color = [proPlot.Color, 1];
            
            
            
            tmp = [xlim, ylim];
            text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
            %     keyboard
            pvals(cellStep, proret2step) = p ;
            diffSigBase(cellStep, proret2step) = (nanmean(nanmean(proTouch(:, signalTime))) - nanmean(nanmean(proTouch(:, BLtime))));
            if tmp(4)<1
                ylim([0 1])
            else
                ylim([0 tmp(4)])
            end
        end
    end
    
    
    %%
    
    pvalsAll{end+1, 1} = pvals;
    pvalsAll{end, 2} = BLtime;
    pvalsAll{end, 3} = signalTime;
    pvalsAll{end, 4} = trialTimeToMatch;
    pvalsAll{end, 5} = diffSigBase;
    
    
end
%%
pvalsAll2 = [];
heightOfPvalsArray = size(pvalsAll, 1);
for k = 1:heightOfPvalsArray
    pvalsAll2(1:size(pvalsAll{1}, 1), 1:2, k) = pvalsAll{k}
end

[minPvals, signalTimeIndex] = nanmin(pvalsAll2,[], 3)

minPvals(isnan(minPvals)) = 99999; %make sure nans are not classified as significant
proRetTouchSignif = minPvals<0.01;% ret and pro touch sig test

allTouchSignificant = (mean(proRetTouchSignif, 2))>0
percentAllSig = mean(allTouchSignificant) % percent of responsive either ret or pro

%% now we can plot all together
% cellNumberPROandRET = [];
latencyStructTouch = struct;
PLOT_WHERE_ONSET_IS = false
latencyCell = {};
cellIndex = {};
minOnsetTime = 7;
close all
onsetSDthresh = 1.5;
inArowMinForOnset = 2;
plotRange2 = -100:100;
matchTimeStart = find(plotRange2==0);
[outputVarAll] = SPmaker(2, heightOfPvalsArray);
smoothBy = 10;
BLindex = 50+1 :matchTimeStart;% minus 20 becasue sometimes signal leaks into before touch region
for proret2step = 1:2 % 1 is pro 2 is ret
    for k = 1:heightOfPvalsArray
        signalTimeSelection = signalTimeIndex == k ;
        selectedCellsAndTraces = find(signalTimeSelection(:, proret2step) .* proRetTouchSignif(:, proret2step));
        [outputVarAll] = SPmaker(outputVarAll);
        for kk = 1:length(selectedCellsAndTraces) % cells that are sig modulated by at least one test
            cellStep2 = selectedCellsAndTraces(kk);
            
            cellIndex{kk, k,proret2step} = cellStep2;
            if proret2step ==1
                toPlotPro = toPlotAllTouch(cellStep2, :, 1);
            else
                toPlotPro = toPlotAllTouch(cellStep2, :, 2);
                
            end
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
                startEndLengthOF_signal = [0 0 0];
            end
            startEndLengthOF_signal = startEndLengthOF_signal(startEndLengthOF_signal(:,3)>=inArowMinForOnset, :);
            if isempty(startEndLengthOF_signal)
                latencyCell{kk, k,proret2step} = nan;
            else
                latencyCell{kk, k,proret2step} = startEndLengthOF_signal(1) -matchTimeStart;%%### -1 here cause ...
            end
            toPlotPro = smooth(toPlotPro, smoothBy);
            proPlot = plot(plotRange2,toPlotPro);
            hold on
            
            proPlot.Color = [proPlot.Color, 1];
            proPlot.LineWidth = 1.3;
            
            if PLOT_WHERE_ONSET_IS
                try
                    tmp = latencyCell{kk, k,proret2step};
                    
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

%%

latencyStructTouch. latency = latencyCell;
latencyStructTouch. cellIndexForUarray = cellIndex;
latencyStructTouch.proRetTouchSignif = proRetTouchSignif;
latencyStructTouch.details = ':, :, 1 is protraction :,:,2 is retraction'
latencyStructTouch.minPvals = minPvals;
latencyStructTouch.signalTimeIndex = signalTimeIndex;
latencyStructTouch.allTimes = allTimes;
latencyStructTouch.matchTimeStart = matchTimeStart;
latencyStructTouch.BLindex = BLindex;
save('latencyStructTouch', 'latencyStructTouch')

touchStruct = struct;
touchStruct.toPlotAllTouch = toPlotAllTouch;


touchStruct.allTouchRet = allTouchRet;
touchStruct.allTouchPro =allTouchPro;
touchStruct.pvalsAll = pvalsAll;
touchStruct.PVAL_notes = 'rows are different time tests colums are pvals, BLindex, SignalIndex, zeroPoint';
save('touchStruct', 'touchStruct')
%%
% %%
%
% pvalsAllSameSigs = sigMat(:, 1:3) + sigMat(:, 4:6)
%
% %%
% allPmat =  pvalsAll{k, 1}';
% for k = 2:size(pvalsAll, 1)
%
%     allPmat(:, end+1) = pvalsAll{k,1};
%
% end
% sigMat = (allPmat<0.05)
% sigmat2 = sum(sigMat, 2)
% %%
%
% keyboard
% % saveLoc = ['C:\Users\maire\Documents\GitHub\Phils_code_for_hireslab\plots\SPIKES\New folder\vArrayBuilderMats\touch\'];
% saveLoc = ['/Users/phillipmaire/Dropbox/HIRES_LAB/FIGURES/S2/Touch/proTrac'];
% % saveLoc = ['\'];
%
% generalName = ['touch_percent_', num2str(percentLow), '_to_', num2str(percentHigh)] ;
% mkdir(saveLoc)
%
% %
% save([saveLoc, generalName, 'VAR'], 'allTouchRet', 'allTouchPro', 'toPlotRet', 'toPlotPro')
%
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [1, 0, 1, 1]);
%
% filename =  [saveLoc, generalName];
% savefig([filename, '.fig'])
% saveas(gcf,[filename,'.png'],'png')
%
%
%
% % end
%
%



