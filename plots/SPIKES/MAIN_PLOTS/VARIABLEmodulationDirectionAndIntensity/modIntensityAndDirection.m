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
touchPRO = (touchStruct.toPlotAllTouch(:,:,1))';
touchRET = (touchStruct.toPlotAllTouch(:,:,2))';
touchZERO = latencyStructTouch.matchTimeStart;
touchSigTimes = latencyStructTouch.allTimes(latencyStructTouch.signalTimeIndex);

%% Pole
poleUP = (poleStruct.allPoleTracesNanMean(:,:,1))';
poleDOWN = (poleStruct.allPoleTracesNanMean(:,:,2))';
poleZERO = latencyStructPole.matchTimeStart;
poleSigTimes = latencyStructPole.allTimes(latencyStructPole.signalTimeIndex);
%% whisking onset
W_ON = W_ONSETStruct.toPlotAllOnset;
W_ON_ZERO = W_ONSETStruct.pvalsAll{1, 4}
W_ON_SigTimes = latencyStructW_ONSET.allTimes(latencyStructW_ONSET.signalTimeIndex);
%% put all min P values in a matrix


minPvalsALL = [latencyStructTouch.minPvals ,latencyStructPole.minPvals, latencyStructW_ONSET.minPvals];
%% get the depths
for cellStep = 1:length(U)
    cellTMP = U{cellStep};
    cellDepth(cellStep) = cellTMP.details.depth;
end
[sortedDepth indDepth] = sort(cellDepth);
% indDepth = 1:45
%% is sig mat

isSigMat = [latencyStructTouch.proRetTouchSignif ,latencyStructPole.proRetTouchSignif, latencyStructW_ONSET.proRetTouchSignif];
isSigMat = isSigMat(indDepth, :);

%% package variable to run them all together
allSignals = {touchPRO ,touchRET ,poleUP ,poleDOWN, W_ON };
zeroPoints =  {touchStruct.pvalsAll{1,4} ,touchStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4},W_ON_ZERO };
sigTimeALL = {touchSigTimes(:,1) ,touchSigTimes(:,2) ,poleSigTimes(:,1) ,poleSigTimes(:,2), W_ON_SigTimes };
BLindexALL =  {touchStruct.pvalsAll{1,2} ,touchStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2},W_ONSETStruct.pvalsAll{:} };


%% run them all together
%% zeroed signal divided by  SD(BL)
testSpkRateBL =[]
testSpkRateSIG=[]
selectivityIndex2 = [];
lowSpikeMask = [];
timeIndexs = {};
smoothBy = 11;
BLtime2 = -100:-20;
shiftSignal = 7;
endsignaldetect = 200
for sigs = 1:length(allSignals)
    sig = allSignals{sigs};
    sigZero = zeroPoints{sigs};
    BLindex = BLindexALL{sigs}-1;
    sigTime = sigTimeALL{sigs};
    for cellStep = 1:size(poleUP,2)
        %         sigTimeTMP = sigTime{cellStep}+sigZero;
        sigTMP = sig(:, cellStep);
        BLsignal = sigTMP(BLtime2+sigZero);
        baseline = nanmean(BLsignal);
        sigTMPs = smooth(sigTMP, smoothBy, 'moving');
        sigTMPs(1:smoothBy) = nan; sigTMPs(end-smoothBy+1 :end) = nan;% nan out edge effects
        
        [maxNum maxInd] = nanmax(sigTMPs(sigZero+shiftSignal:endsignaldetect+sigZero));
        [minNum minInd] = nanmin(sigTMPs(sigZero+shiftSignal:endsignaldetect+sigZero));
        maxMinMat = [maxNum  minNum; maxInd minInd];
        [~, ind] = max(abs([maxNum, minNum] - baseline));
        
        signalSignificant=maxMinMat(1, ind);
        
        %         figure, plot(sigTMP)
        
        
        selectivityIndex2(cellStep, sigs) = (signalSignificant - baseline) ./ std(BLsignal);
        %         if
        %             lowSpikeMask(cellStep, sigs) = 0;
        %         else
        %            lowSpikeMask(cellStep, sigs) =  1;
        %         end
        testSpkRateBL (cellStep, sigs)= baseline;
        testSpkRateSIG (cellStep, sigs)= nanmean(sigTMP(sigZero+shiftSignal:endsignaldetect+sigZero));
        %         if cellStep == 7
        %             keyboard
        %         end
    end
end

 
% % % % % % %  isSigMat = isSigMat.*(lowSpikeMask);
infINDs  = find(selectivityIndex2 == inf);
selectivityIndex2(infINDs) = 0;
selectivityIndex2(infINDs) = max(selectivityIndex2(:))
% % % % % % % selectivityIndex2(isnan(selectivityIndex2)) = 0;

lowSpkThresh = .2
 lowSpikeMask =(testSpkRateBL>lowSpkThresh).*(testSpkRateSIG>lowSpkThresh);
 
 
 lowSpikeMask = lowSpikeMask(indDepth, :);

%%%
figure, imagesc(selectivityIndex2)
%%
limitSD = 5;
selectivityIndex3 = selectivityIndex2;
selectivityIndex3(selectivityIndex3>limitSD) = limitSD;
selectivityIndex3(selectivityIndex3<-limitSD) = -limitSD;

%  [sortedDepth indDepth]
selectivityIndex3 = selectivityIndex3(indDepth, :);
figure, imagesc(selectivityIndex3)
% colormap(parula)
% tmp = colorbar;
% tmp.Limits = [-limitSD limitSD];
%%

posVals = brewermap(60, 'Reds');
posVals = posVals(1:end-17, :);

negVals = brewermap(60, 'Blues');
negVals = negVals(1:end-7, :);

negVals = flip(negVals);
myMap = [negVals; posVals]
%%%
%%
% myMap = brewermap(51, 'RdBu')

%%%
[sorted index] = sort(selectivityIndex3(:, 4))

%%%
selectivityIndex4 = selectivityIndex3(index, :);
%% FINAL
close all
figure
% dummy = plot(1,1, '+');
% hold on
tmp = imagesc(selectivityIndex3)
% delete(dummy)
colormap(myMap)
hold on
tmp = colorbar;
tmp.Limits = [-limitSD limitSD];
tmp = [xlim];
xlim([tmp(1)-1 tmp(2)+1]);
tmp2 = [ylim];
ylim([tmp(1)-10 tmp2(2)+10]);
tmp = [xlim];
tmp2 = [ylim];
% plot(tmp(1), tmp2(1), tmp(2), tmp2(1),tmp(1), tmp2(2),tmp(2), tmp2(2), '+');
plot(tmp, tmp2, '*')
% %% plot depth????
hold on
%% FINAL  BARS FOR PLOT
cellsY = 1:size(selectivityIndex3, 1);
cellsX = ones(length(cellsY), 1) - 0.55;
min(sortedDepth)
max(sortedDepth)
minVal = 450;
maxVal = 1250;
% sortedDepth2 = ((sortedDepth-minval)./ (maxVal-minval)).* length(cellsY);
%
figure
cellsY =(((cellsY-min(cellsY))./ (max(cellsY)-min(cellsY))).*(maxVal-minVal))+minVal;
for k = 1:length(cellsY)
    plot([cellsX(k), cellsX(k)-1.9] ,[-cellsY(k),  -sortedDepth(k)] , '-k')
    hold on
end
axis tight
ax = gca;
properties(ax)
ax.TickDir = 'out'
%%


%%
close all
 selectivityIndex3 = selectivityIndex3.*lowSpikeMask
figure
lims1 = [-5 5]

thingToUse = minPvalsALL;


sig1 = isSigMat(:,1);
sig2 = isSigMat(:,2);
sigBoth = isSigMat(:,1).*isSigMat(:,2);
noSig = (sig1+sig2 == 0)


% % plot(selectivityIndex3(find(sig1),1), selectivityIndex3(find(sig1),2), 'bo')
% % hold on
% % plot(selectivityIndex3(find(sig2),1), selectivityIndex3(find(sig2),2), 'ro')
% % plot(selectivityIndex3(find(sigBoth),1), selectivityIndex3(find(sigBoth),2), 'go')
tmp = plot(selectivityIndex3(find(noSig),1), selectivityIndex3(find(noSig),2), 'ko')
tmp.MarkerSize = 5;
hold on
tmp = plot(selectivityIndex3(find(~noSig),1), selectivityIndex3(find(~noSig),2), 'ro')
tmp.MarkerSize = 5;

% 
% plot(selectivityIndex3(:,1).*sig2, selectivityIndex3(:,2).*sig2, 'ro')
% plot(selectivityIndex3(:,1).*sigBoth, selectivityIndex3(:,2).*sigBoth, 'go')
% plot(selectivityIndex3(:,1).*noSig, selectivityIndex3(:,2).*noSig, 'ko')

for k = -2:2
    plot([k k], lims1, 'k-')
    plot(lims1, [k k], 'k-')
end

%%

 selectivityIndex3 = selectivityIndex3.*lowSpikeMask
figure
lims1 = [-5 5]

thingToUse = minPvalsALL;

sig1 = isSigMat(:,3);
sig2 = isSigMat(:,4);
sigBoth = isSigMat(:,3).*isSigMat(:,4);
noSig = (sig1+sig2 == 0)


% % plot(selectivityIndex3(find(sig1),1), selectivityIndex3(find(sig1),2), 'bo')
% % hold on
% % plot(selectivityIndex3(find(sig2),1), selectivityIndex3(find(sig2),2), 'ro')
% % plot(selectivityIndex3(find(sigBoth),1), selectivityIndex3(find(sigBoth),2), 'go')
tmp = plot(selectivityIndex3(find(noSig),3), selectivityIndex3(find(noSig),4), 'ko')
tmp.MarkerSize = 5;
hold on
tmp = plot(selectivityIndex3(find(~noSig),3), selectivityIndex3(find(~noSig),4), 'bo')
tmp.MarkerSize = 5;

% 
% plot(selectivityIndex3(:,1).*sig2, selectivityIndex3(:,2).*sig2, 'ro')
% plot(selectivityIndex3(:,1).*sigBoth, selectivityIndex3(:,2).*sigBoth, 'go')
% plot(selectivityIndex3(:,1).*noSig, selectivityIndex3(:,2).*noSig, 'ko')

for k = -2:2
    plot([k k], lims1, 'k-')
    plot(lims1, [k k], 'k-')
end

%%
% % % 
% % % 
% % % [val ind] = sort(abs(selectivityIndex3(:,1) - .8))
% % % % %%
% % % % plot(selectivityIndex3(:,3), selectivityIndex3(:,4), 'ro')
% % % % grid on
% % % % 
% % % 
% % % 
% % % 
% % % 
