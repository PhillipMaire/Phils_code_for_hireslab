
%%
%% HeatMapSelectivityDepth
%% make heat map of selectivity for each stimuli and map it across depth
% (signal - BL)/ std(BL)

%% preloaded structs from

% POLE signifTestWithCurvSortingPole2ONSET_LAT.m
latencyStructPole
poleStruct

% TOUCH signifTestWithCurvSortingONSET_LAT.m
latencyStructTouch
touchStruct
% WHISKING ONSET  whiskingOnsetResponse.m
%C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\whiskingOnsetResponse
latencyStructW_ONSET
W_ONSETStruct

%% Touches
touchPRO = touchStruct.allTouchPro;
touchRET = touchStruct.allTouchRet;
touchZERO = latencyStructTouch.matchTimeStart;
touchSigTimes = latencyStructTouch.allTimes(latencyStructTouch.signalTimeIndex);

%% Pole
poleUP = poleStruct.allpolesCell(:,1)';
poleDOWN = poleStruct.allpolesCell(:,2)';
poleZERO = latencyStructPole.matchTimeStart;
poleSigTimes = latencyStructPole.allTimes(latencyStructPole.signalTimeIndex);
%% whisking onset
W_ON = W_ONSETStruct.allWhiskOnsets;
W_ON_ZERO = W_ONSETStruct.pvalsAll{1, 4};
W_ON_SigTimes = latencyStructW_ONSET.allTimes(latencyStructW_ONSET.signalTimeIndex);
%% get the depths
for cellStep = 1:length(U)
    cellTMP = U{cellStep};
    cellDepth(cellStep) = cellTMP.details.depth;
end

degreeChnage = 10; %base degree is 37 for my recordings and


[sortedDepth indDepth] = sort(cellDepth);
sortedDepth = sortedDepth';
correctedCellDepth = (cosd(degreeChnage).*sortedDepth);
correctedCellDepth = round(correctedCellDepth);
sortedDepth = correctedCellDepth;
%% package variable to run them all together
allSignals = {touchPRO ,touchRET ,poleUP ,poleDOWN, W_ON };
zeroPoints =  {touchStruct.pvalsAll{1,4} ,touchStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4},W_ON_ZERO };
sigTimeALL = {touchSigTimes(:,1) ,touchSigTimes(:,2) ,poleSigTimes(:,1) ,poleSigTimes(:,2), W_ON_SigTimes };
% BLindexALL =  {touchStruct.pvalsAll{1,2} ,touchStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2},W_ONSETStruct.pvalsAll{:} };
%% Pvalues and significant neurons
% for iters = 1:3
% sigCells{1, iters} =  ([touchStruct.pvalsAll{iters,1},poleStruct.pvalsAll{iters,1} ,W_ONSETStruct.pvalsAll{iters,1}' ]);
% sigCells{2, iters} =  ([touchStruct.pvalsAll{iters,2}(:),poleStruct.pvalsAll{iters,2}(:) ,W_ONSETStruct.pvalsAll{iters,2}(:) ]);
%
% end

for iters = 1:3
    tmp1 = {touchStruct.pvalsAll{iters,1}(:,1),touchStruct.pvalsAll{iters,1}(:,2),...
        poleStruct.pvalsAll{iters,1}(:,1),poleStruct.pvalsAll{iters,1}(:,2) ,W_ONSETStruct.pvalsAll{iters,1}' };
    tmp2 = {touchStruct.pvalsAll{iters,2},touchStruct.pvalsAll{iters,2},...
        poleStruct.pvalsAll{iters,2},poleStruct.pvalsAll{iters,2},W_ONSETStruct.pvalsAll{iters,2} };
    tmp3 = {touchStruct.pvalsAll{iters,3},touchStruct.pvalsAll{iters,3},...
        poleStruct.pvalsAll{iters,3},poleStruct.pvalsAll{iters,3},W_ONSETStruct.pvalsAll{iters,3} };
    PvalsALL{1, iters} = tmp1;% pvalues 
    PvalsALL{2, iters} = tmp2;% Bl period
    PvalsALL{3, iters} = tmp3;
    % sigCells{2, iters} =  ([touchStruct.pvalsAll{iters,2}(:),poleStruct.pvalsAll{iters,2}(:) ,W_ONSETStruct.pvalsAll{iters,2}(:) ]);
    
end
%%
sigCells = [latencyStructTouch.proRetTouchSignif, latencyStructPole.proRetTouchSignif, latencyStructW_ONSET.proRetTouchSignif ];
sigTimePeriod = [latencyStructTouch.signalTimeIndex, latencyStructPole.signalTimeIndex, latencyStructW_ONSET.signalTimeIndex ];

% latencyStructTouch
% latencyStructPole
% latencyStructW_ONSET
%% latencies
latInds = {latencyStructTouch.cellIndexForUarray(:,:, 1),latencyStructTouch.cellIndexForUarray(:,:, 2),...
    latencyStructPole.cellIndexForUarray(:,:, 1),  latencyStructPole.cellIndexForUarray(:,:, 2), latencyStructW_ONSET.cellIndexForUarray(:)};

latenciesTMP = {latencyStructTouch.latency(:,:, 1),latencyStructTouch.latency(:,:, 2),...
    latencyStructPole.latency(:,:, 1),  latencyStructPole.latency(:,:, 2), latencyStructW_ONSET.latency(:)};
latencies = [];
for iters = 1:5
    Lind = cell2mat(latInds{iters}(:));
    L = cell2mat(latenciesTMP{iters}(:));
    latencies(1:length(U), iters) = nan(size(U));
    latencies(Lind, iters) = L;
end
%%
tmp = cell2mat((latencyStructTouch.cellIndexForUarray(:)));
sort(tmp)
numel(unique(tmp))


%% run them all together
%% zeroed signal divided by  SD(BL)
selectivityIndex2 = [];
timeIndexs = {};
smoothBy =8; % for finding peak 
smoothByPlot = 5; % for plot 
BLtime2 = -100:-20;
shiftSignal = 5; % just what we use to test significance
endsignaldetect = 75;
for sigs = 1:length(allSignals)
    sig = allSignals{sigs};
    sigZero = zeroPoints{sigs};
    %     BLindex = BLindexALL{sigs}-1;
    %     sigTime = sigTimeALL{sigs};
    for cellStep = 1:size(sig,2)
%                 sigTimeTMP = sigTime{cellStep}+sigZero;
        sigTMP = sig{:, cellStep};
        sigTMP = nanmean(sigTMP, 1);
        
%         binSize = 5;
%         height1 = floor(length(sigTMP)./binSize);
%          sigForBin = reshape(sigTMP(1:binSize.*height1), [height, binSize]);
%             sigForBin = nanmean(sigForBin, 2)
        
        
        BLsignal = sigTMP(BLtime2+sigZero);
        baseline = nanmean(BLsignal);
        if smoothBy ~=1
            sigTMPs = smooth(sigTMP, smoothBy, 'moving');
            sigTMPs(1:smoothBy) = nan; sigTMPs(end-smoothBy+1 :end) = nan;% nan out edge effects
        else
            sigTMPs =sigTMP;
        end
        
        
        % sigTMPs = sigTMPmean;
        
        sigIndex = sigZero+shiftSignal:endsignaldetect+sigZero;
        [maxNum maxInd] = nanmax(sigTMPs(sigIndex));
        [minNum minInd] = nanmin(sigTMPs(sigIndex));
        maxMinMat = [maxNum  minNum; maxInd minInd];
        [~, ind] = max(abs([maxNum, minNum] - baseline));
        
        
        
        signalSignificant=maxMinMat(1, ind);
        peakTimeInd = sigIndex(maxMinMat(2, ind));
        %         figure, plot(sigTMPs)
        allPeakTimes(cellStep, sigs) = peakTimeInd;
        if ind == 1
            directionOfMod(cellStep, sigs) = 1;
            
            
            
        else
            directionOfMod(cellStep, sigs) = -1;
        end
        sigTMP2 = smooth(sigTMP, smoothByPlot);
        signalsTOplot{cellStep, sigs} =(sigTMP2-nanmin(sigTMP2))./nanmax(sigTMP2-nanmin(sigTMP2));
        
        % signalsTOplot{cellStep, sigs}(signalsTOplot{cellStep, sigs}>1) = 1;
        
        selectivityIndex2(cellStep, sigs) = (signalSignificant - baseline) ./ std(BLsignal);
        
        %          hold off
        %         plot(sigTMPs)
        %         keyboard
    end
    %     [AllpeakTimesSorted(:, sigs) , AllpeakIndsSorted(:, sigs)] = sort(allPeakTimes(:, sigs));
    
end
infINDs  = find(selectivityIndex2 == inf);
selectivityIndex2(infINDs) = 0;
selectivityIndex2(infINDs) = max(selectivityIndex2(:))
selectivityIndex2(isnan(selectivityIndex2)) = 0;
%%%
figure, imagesc(directionOfMod)
figure, imagesc(selectivityIndex2)
sum(sigCells)
%%

% PvalsALL
close all
allResp = []
for k = 1:size(sigCells,2)
    useTheseCells = find(~isnan(latencies(:,k)));
    signalsTOplot2 = signalsTOplot(useTheseCells);
    allPeakTimes2 = allPeakTimes(useTheseCells);
    directionOfMod2 = directionOfMod(useTheseCells);
    [ccc, fff] = sort(allPeakTimes2);
    for kk =1:length(useTheseCells)
        indTMP = fff(kk);
        resp = signalsTOplot2{indTMP}
        if directionOfMod2(indTMP) == -1
            allResp(:, end+1) = resp;
        end
    end
    figure, imagesc(allResp');
    hold on
    xlim([-50 200]+200)
    colorbar
    
    keyboard
    allResp = []
    %     keyboard
    % AllpeakIndsSorted2 = AllpeakIndsSorted(useTheseCells);
    
    
    
end
%%



%% am worried that the peak sand significant portion will not be consistant
% PvalsALL
close all
allResp = []
smoothBy = 11;
for k = 1:size(sigCells,2)
    useTheseCells = find(sigCells(:,k));
    sigTimePeriodTMP = sigTimePeriod(useTheseCells);
    signalsTOplot2 = signalsTOplot(useTheseCells);
    allPeakTimes2 = allPeakTimes(useTheseCells);
    directionOfMod2 = directionOfMod(useTheseCells);
    [ccc, fff] = sort(allPeakTimes2);
    for kk =1:length(useTheseCells)
        indTMP = fff(kk);
        resp = signalsTOplot2{indTMP}
        if directionOfMod2(indTMP) == 1
            allResp(:, end+1) = resp;
        end
    end
    figure, imagesc(allResp');
    hold on
%     xlim([-50 200]+200)
    colorbar
    
%     keyboard
    allResp = []
    %     keyboard
    % AllpeakIndsSorted2 = AllpeakIndsSorted(useTheseCells);
    
    
    
end
%%

% % % % 
% % % % %%
% % % % limitSD = 2;
% % % % selectivityIndex3 = selectivityIndex2;
% % % % selectivityIndex3(selectivityIndex3>limitSD) = limitSD;
% % % % selectivityIndex3(selectivityIndex3<-limitSD) = -limitSD;
% % % % 
% % % % %  [sortedDepth indDepth]
% % % % selectivityIndex3 = selectivityIndex3(indDepth, :);
% % % % figure, imagesc(selectivityIndex3)
% % % % % colormap(parula)
% % % % % tmp = colorbar;
% % % % % tmp.Limits = [-limitSD limitSD];
% % % % %%
% % % % 
% % % % posVals = brewermap(60, 'Reds');
% % % % posVals = posVals(1:end-17, :);
% % % % 
% % % % negVals = brewermap(60, 'Blues');
% % % % negVals = negVals(1:end-7, :);
% % % % 
% % % % negVals = flip(negVals);
% % % % myMap = [negVals; posVals]
% % % % %%%
% % % % %%
% % % % % myMap = brewermap(51, 'RdBu')
% % % % 
% % % % %%%
% % % % [sorted index] = sort(selectivityIndex3(:, 4))
% % % % 
% % % % %%%
% % % % selectivityIndex4 = selectivityIndex3(index, :);
% % % % %% FINAL
% % % % close all
% % % % figure
% % % % % dummy = plot(1,1, '+');
% % % % % hold on
% % % % tmp = imagesc(selectivityIndex3)
% % % % % delete(dummy)
% % % % colormap(myMap)
% % % % hold on
% % % % tmp = colorbar;
% % % % tmp.Limits = [-limitSD limitSD];
% % % % tmp = [xlim];
% % % % xlim([tmp(1)-1 tmp(2)+1]);
% % % % tmp2 = [ylim];
% % % % ylim([tmp(1)-10 tmp2(2)+10]);
% % % % tmp = [xlim];
% % % % tmp2 = [ylim];
% % % % % plot(tmp(1), tmp2(1), tmp(2), tmp2(1),tmp(1), tmp2(2),tmp(2), tmp2(2), '+');
% % % % plot(tmp, tmp2, '*')
% % % % % %% plot depth????
% % % % hold on
% % % % %% FINAL  BARS FOR PLOT
% % % % cellsY = 1:size(selectivityIndex3, 1);
% % % % cellsX = ones(length(cellsY), 1) - 0.55;
% % % % min(sortedDepth)
% % % % max(sortedDepth)
% % % % minVal = 450;
% % % % maxVal = 1250;
% % % % % sortedDepth2 = ((sortedDepth-minval)./ (maxVal-minval)).* length(cellsY);
% % % % %
% % % % figure
% % % % cellsY =(((cellsY-min(cellsY))./ (max(cellsY)-min(cellsY))).*(maxVal-minVal))+minVal;
% % % % for k = 1:length(cellsY)
% % % %     plot([cellsX(k), cellsX(k)-1.9] ,[-cellsY(k),  -sortedDepth(k)] , '-k')
% % % %     hold on
% % % % end
% % % % hold on
% % % % axis tight
% % % % ax = gca;
% % % % properties(ax)
% % % % ax.TickDir = 'out'
% % % % tmp = ylim
% % % % ylim([-1260 9900])
% % % % %%
% % % % %%
% % % % %%
% % % % 
% % % % 
% % % % 
% % % % % % % % %% entire signal of the significant portion so if time = 0-25 is the best significant time then take that entire time and divide by BL
% % % % % % % % selectivityIndex = [];
% % % % % % % % timeIndexs = {};
% % % % % % % % for sigs = 1:length(allSignals)
% % % % % % % %     sig = allSignals{sigs};
% % % % % % % %     sigZero = zeroPoints{sigs};
% % % % % % % %     BLindex = BLindexALL{sigs}-1;
% % % % % % % %     sigTime = sigTimeALL{sigs};
% % % % % % % %     for cellStep = 1:size(poleUP,2)
% % % % % % % %         sigTimeTMP = sigTime{cellStep}+sigZero;
% % % % % % % %         sigTMP = sig(:, cellStep);
% % % % % % % %         signalSignificant=nanmean(sigTMP(sigTimeTMP));
% % % % % % % %         baseline = nanmean(sigTMP(BLindex));
% % % % % % % %         selectivityIndex(cellStep, sigs) = (signalSignificant - baseline) ./ (baseline);
% % % % % % % %     end
% % % % % % % % end
% % % % 
% % % % 
% % % % 
% % % % 
% % % % 
% % % % 
% % % % 
