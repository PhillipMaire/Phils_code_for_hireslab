

%% whiskingOnsetResponse


% function whiskingOnsetResponse(U)
%% OUTPUT THAT WE CARE ABOUT
%%     proRetTouchSignif   allTouchSignif   percentAllSig
REDO_FIND_VAR = true; 

if REDO_FIND_VAR
    theseCells =   1:length(U);

allWhiskOnsets = {};
plotTestSWITCH = 0;
plotRange = -200:200;
toPlotAllOnset =[]; 
[OnsetsALL_CELLS] = AllWhiskingOnsetTimes(U, theseCells);
poleMaskTime = -10:200;
touchMaskTime = -20:200;
for cellStep = theseCells
    disp(num2str(cellStep))
    cellTMP = U{cellStep};
    onsetTMP = OnsetsALL_CELLS{cellStep};
    spikes = squeeze(cellTMP.R_ntk) .* 1000;
    onLinInds = onsetTMP.linIndsONSETS;
    %%
    
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
    
    allTouches = unique([touchFirstOnset; touchLateOnset]);
    
%     keyboard
    
    touchMaskInd = (allTouches + (touchMaskTime));
    trialToMatch = find(touchMaskTime==0);
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
    touchMask(touchMaskInd) = nan;
    
    
    spikes = spikes.*poleMask.* touchMask;
    
    
    linTrace = (plotRange)' + onLinInds(:)';
    
    toPlot = spikes(linTrace);
    if plotTestSWITCH
        tmp = nanmean(toPlot,2);
        figure
        plot(smooth(tmp, 10, 'moving'))
        spikesTest = spikes;
        
        tmp = ones(size(spikes));
        tmp(linTrace) = 3000;
        spikesTest = spikesTest+tmp;
        spikesTest(isnan(spikesTest)) = 2000;
        figure
        imagesc(spikesTest)
        close all
    end
    toPlot = toPlot';
    allWhiskOnsets{cellStep} = toPlot;
    toPlotMean = nanmean(allWhiskOnsets{cellStep}, 1);
    toPlotAllOnset(cellStep, :) = toPlotMean;
    
end


% nameVar = [strcat(datestr(now,'yymmdd_HHMM')), '_poleVariables'];
% save(nameVar,'allpolesCell', 'plotRange', 'theseCells', 'rangeRemoveTouch', 'plotRange')

%  nameVar = [strcat(datestr(now,'yymmdd_HHMM')), '_whiskerVariables'];
% save(nameVar,'allWhiskOnsets', 'toPlotAllOnset', 'OnsetsALL_CELLS', 'theseCells', 'plotRange')
end
%%
smoothBy = 10
subplotMakerNumber = 1; subplotMaker
set(0,'defaultAxesFontSize',10)
for cellStep = theseCells
    
    subplotMakerNumber = 2; subplotMaker
    
    
    toPlotMean = toPlotAllOnset(cellStep, :);
    toPlotMean(isnan(toPlotMean)) = 0;
    toPlotMean = smooth(toPlotMean, smoothBy);
    retPlot = plot(plotRange,toPlotMean, 'k');
    hold on
    retPlot.Color = [retPlot.Color, 1];
    
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
reallyEarly = 8:20;
smallEarly = 0:25;
smallLate = 25:50;
largeLate = 50:100;
allTimes = {reallyEarly,smallEarly, smallLate , largeLate}
% % % large = 0:100; % NO GOOD no cells is this the best for and significant
BLtime = -101:-20;
trialTimeToMatch = find(plotRange==0);
BLtime = BLtime+trialTimeToMatch ;
%% get t tests
pvalsAll={};
for timeTests = 1:length(allTimes)
    pvals = ones(max(theseCells), 1).*9999;
    % subplotMakerNumber = 1; subplotMaker
    % set(0,'defaultAxesFontSize',10)
    
    signalTime =allTimes{timeTests};
    
    diffSigBase = [];
    
    signalTime = signalTime+trialTimeToMatch;
  subplotMakerNumber = 1; subplotMaker

  
  
        for cellStep = theseCells
            
            disp(num2str(cellStep));
            
                W_ON =(allWhiskOnsets{cellStep});
       
            W_ON_BL = nanmean(W_ON(:, BLtime), 2);
            W_ON_SIG = nanmean(W_ON(:, signalTime), 2);
            
            
            [~, p] = ttest2(W_ON_BL,W_ON_SIG);
            disp(num2str(p))
            
            
            subplotMakerNumber = 2; subplotMaker
          
                toPlotPro = toPlotAllOnset(cellStep, :);
            
            
            toPlotPro(isnan(toPlotPro)) = 0;
            toPlotPro = smooth(toPlotPro, smoothBy);
            proPlot = plot(plotRange,toPlotPro, 'b');
            proPlot.Color = [proPlot.Color, 1];
            
            
            
            tmp = [xlim, ylim];
            text(tmp(1),tmp(3) ,[num2str(round(p, 5))])
            %     keyboard
            pvals(cellStep) = p ;
            diffSigBase(cellStep) = (nanmean(W_ON_SIG) - nanmean(W_ON_BL));
            if tmp(4)<1
                ylim([0 1])
            else
                ylim([0 tmp(4)])
            end
        end
    
    
    
    %
    
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
    pvalsAll2(theseCells, 1, k) = pvalsAll{k}
end

[minPvals, signalTimeIndex] = nanmin(pvalsAll2,[], 3)

minPvals(isnan(minPvals)) = 99999; %make sure nans are not classified as significant
proRetTouchSignif = minPvals<0.01;% ret and pro touch sig test

allTouchSignificant = (mean(proRetTouchSignif, 2))>0
percentAllSig = mean(allTouchSignificant) % percent of responsive either ret or pro

%% now we can plot all together
% cellNumberPROandRET = [];
latencyStructW_ONSET = struct;
PLOT_WHERE_ONSET_IS = false;
latencyCell = {};
cellIndex = {};
minOnsetTime = 7;
close all
onsetSDthresh = 1.5;
inArowMinForOnset = 2;
plotRange2 = -100:100;
matchTimeStart = find(plotRange2==0);
[outputVarAll] = SPmaker(1, heightOfPvalsArray);
smoothBy = 30;
BLtime = -100:-20;
BLindex = BLtime+matchTimeStart ;
% BLindex = BLtime;


    for k = 1:heightOfPvalsArray
        signalTimeSelection = signalTimeIndex == k ;
        selectedCellsAndTraces = find(signalTimeSelection(:) .* proRetTouchSignif(:));
       [outputVarAll] = SPmaker(outputVarAll);
        for kk = 1:length(selectedCellsAndTraces) % cells that are sig modulated by at least one test
            cellStep2 = selectedCellsAndTraces(kk);
            
            cellIndex{kk, k} = cellStep2;
          
            toPlotPro = toPlotAllOnset(cellStep2, :);
            %             keyboard
            %     if find(isnan(toPlotPro))
            %     keyboard
            %     end
            %     toPlotPro(isnan(toPlotPro)) = 0;
            
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
                latencyCell{kk, k} = nan;
            else
                latencyCell{kk, k} = startEndLengthOF_signal(1) -matchTimeStart;%%### -1 here cause ...
            end
            %%
            toPlotPro = smooth(toPlotPro, smoothBy);
              proPlot = plot(plotRange2,toPlotPro);
            hold on
            
            proPlot.Color = [proPlot.Color, 1];
            proPlot.LineWidth = 1.3;
            if PLOT_WHERE_ONSET_IS
                try
                    tmp = latencyCell{kk, k};
                    
                    plot(tmp, toPlotPro(tmp+matchTimeStart), '*r')
                catch
                end
                disp(tmp)
%                 keyboard
                hold off
            end
        end
    end

%%
%%     proRetTouchSignif   allTouchSignif   percentAllSig
allTouchSignificant


latencyStructW_ONSET.latency = latencyCell;
latencyStructW_ONSET.cellIndexForUarray = cellIndex;
latencyStructW_ONSET.proRetTouchSignif = proRetTouchSignif;
latencyStructW_ONSET.details = ':, :, 1 is protraction :,:,2 is retraction';
latencyStructW_ONSET.minPvals = minPvals;
latencyStructW_ONSET.signalTimeIndex = signalTimeIndex;
latencyStructW_ONSET.allTimes = allTimes;
latencyStructW_ONSET.matchTimeStart = matchTimeStart;
latencyStructW_ONSET.BLindex = BLindex;
save('latencyStructW_ONSET', 'latencyStructW_ONSET')

W_ONSETStruct = struct;
W_ONSETStruct.toPlotAllOnset = toPlotAllOnset';


W_ONSETStruct.allWhiskOnsets = allWhiskOnsets;
% W_ONSETStruct.allTouchPro =allTouchPro;
W_ONSETStruct.pvalsAll = pvalsAll;
W_ONSETStruct.PVAL_notes = 'rows are different time tests colums are pvals, BLindex, SignalIndex, zeroPoint';
save('W_ONSETStruct', 'W_ONSETStruct')
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



























