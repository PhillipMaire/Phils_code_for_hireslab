%% VennDiagramSelectivityDepth
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
W_ON_ZERO = latencyStructW_ONSET.matchTimeStart;
W_ON_SigTimes = latencyStructW_ONSET.allTimes(latencyStructW_ONSET.signalTimeIndex);






%%  touch
close all
% latencyStructTouch.minPvals
sigTouch = latencyStructTouch.proRetTouchSignif;
tmp  = sum(sigTouch, 1);
touchPRO = tmp(1);
touchRET = tmp(2);
touchBOTH  = sum(sigTouch(:,1).*sigTouch(:,2));
figure
[H, S] = venn([touchPRO touchRET], [touchBOTH])
%%



%% pole 
sigPole = latencyStructPole.proRetTouchSignif;
tmp  = sum(sigPole, 1);
poleUP = tmp(1);
poleDOWN = tmp(2);
poleBOTH  = sum(sigPole(:,1).*sigPole(:,2));
figure
[H, S] = venn([poleUP poleDOWN], [poleBOTH])

%% touch pole whisking 
%%     c = {'r', 'g', 'b'};   
figure
touchTMP = (sum(sigTouch, 2)>0);
sigW_ON = latencyStructW_ONSET.proRetTouchSignif;
poleTMP = (sum(sigPole, 2)>0);

A = [touchTMP, sigW_ON, poleTMP];
% [i12 i13 i23 i123]

i12 = sum(A(:,1).*A(:,2));
i13 = sum(A(:,1).*A(:,3));
i23 = sum(A(:,2).*A(:,3));
i123 = sum(A(:,1).*A(:,2).*A(:,3));

[H, S] =venn([sum(touchTMP), sum(sigW_ON), sum(poleTMP)], [i12 i13 i23 i123],'FaceAlpha',{.5})

%%

sigALL = [sigTouch,sigPole];

sigALL2 = double(sigALL);
for k = 1:4
    tmp = find(sigALL2(:,k));
sigALL2(tmp, k) = 2.^(k+1)
end
%%


tmp = sum(sigALL2,2)
unique(tmp)



% 
% 
% 
% 
% 
% %% get the depths
% for cellStep = 1:length(U)
%     cellTMP = U{cellStep};
%     cellDepth(cellStep) = cellTMP.details.depth;
% end
% [sortedDepth indDepth] = sort(cellDepth);
% %% package variable to run them all together
% allSignals = {touchPRO ,touchRET ,poleUP ,poleDOWN };
% zeroPoints =  {touchStruct.pvalsAll{1,4} ,touchStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4} };
% sigTimeALL = {touchSigTimes(:,1) ,touchSigTimes(:,2) ,poleSigTimes(:,1) ,poleSigTimes(:,2) };
% BLindexALL =  {touchStruct.pvalsAll{1,2} ,touchStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2} ,poleStruct.pvalsAll{1,2} };
% 
% 
% %% run them all together
% %% zeroed signal divided by  SD(BL)
% selectivityIndex2 = [];
% timeIndexs = {};
% smoothBy = 11;
% BLtime2 = -100:-20;
% shiftSignal = 7;
% endsignaldetect = 75
% for sigs = 1:length(allSignals)
%     sig = allSignals{sigs};
%     sigZero = zeroPoints{sigs};
%     BLindex = BLindexALL{sigs}-1;
%     sigTime = sigTimeALL{sigs};
%     for cellStep = 1:size(poleUP,2)
%         %         sigTimeTMP = sigTime{cellStep}+sigZero;
%         sigTMP = sig(:, cellStep);
%         BLsignal = sigTMP(BLtime2+sigZero);
%         baseline = nanmean(BLsignal);
%         sigTMPs = smooth(sigTMP, smoothBy, 'moving');
%         sigTMPs(1:smoothBy) = nan; sigTMPs(end-smoothBy+1 :end) = nan;% nan out edge effects
%         
%         [maxNum maxInd] = nanmax(sigTMPs(sigZero+shiftSignal:endsignaldetect+sigZero));
%         [minNum minInd] = nanmin(sigTMPs(sigZero+shiftSignal:endsignaldetect+sigZero));
%         maxMinMat = [maxNum  minNum; maxInd minInd];
%         [~, ind] = max(abs([maxNum, minNum] - baseline));
%         
%         signalSignificant=maxMinMat(1, ind);
%         
%         %         figure, plot(sigTMPs)
%         
%         
%         selectivityIndex2(cellStep, sigs) = (signalSignificant - baseline) ./ std(BLsignal);
%     end
% end
% infINDs  = find(selectivityIndex2 == inf);
% selectivityIndex2(infINDs) = 0;
% selectivityIndex2(infINDs) = max(selectivityIndex2(:))
% selectivityIndex2(isnan(selectivityIndex2)) = 0;
% %%%
% figure, imagesc(selectivityIndex2)
% %%
% limitSD = 2;
% selectivityIndex3 = selectivityIndex2;
% selectivityIndex3(selectivityIndex3>limitSD) = limitSD;
% selectivityIndex3(selectivityIndex3<-limitSD) = -limitSD;
% 
% %  [sortedDepth indDepth]
% selectivityIndex3 = selectivityIndex3(indDepth, :);
% figure, imagesc(selectivityIndex3)
% % colormap(parula)
% % tmp = colorbar;
% % tmp.Limits = [-limitSD limitSD];
% %%
% 
% posVals = brewermap(60, 'Reds');
% posVals = posVals(1:end-17, :);
% 
% negVals = brewermap(60, 'Blues');
% negVals = negVals(1:end-7, :);
% 
% negVals = flip(negVals);
% myMap = [negVals; posVals]
% %%%
% %%
% % myMap = brewermap(51, 'RdBu')
% 
% %%%
% [sorted index] = sort(selectivityIndex3(:, 4))
% 
% %%%
% selectivityIndex4 = selectivityIndex3(index, :);
% %% FINAL 
% close all
% figure
% % dummy = plot(1,1, '+');
% % hold on 
% tmp = imagesc(selectivityIndex3)
% % delete(dummy)
% colormap(myMap)
% hold on 
% tmp = colorbar;
% tmp.Limits = [-limitSD limitSD];
% tmp = [xlim];
% xlim([tmp(1)-1 tmp(2)+1]);
% tmp2 = [ylim];
% ylim([tmp(1)-10 tmp2(2)+10]);
% tmp = [xlim];
% tmp2 = [ylim];
% % plot(tmp(1), tmp2(1), tmp(2), tmp2(1),tmp(1), tmp2(2),tmp(2), tmp2(2), '+');
% plot(tmp, tmp2, '*')
% % %% plot depth????
% hold on 
% %% FINAL  BARS FOR PLOT
% cellsY = 1:size(selectivityIndex3, 1);
% cellsX = ones(length(cellsY), 1) - 0.55;
% min(sortedDepth)
% max(sortedDepth)
% minVal = 450;
% maxVal = 1250;
% % sortedDepth2 = ((sortedDepth-minval)./ (maxVal-minval)).* length(cellsY);
% %
% figure
% cellsY =(((cellsY-min(cellsY))./ (max(cellsY)-min(cellsY))).*(maxVal-minVal))+minVal;
% for k = 1:length(cellsY)
%     plot([cellsX(k), cellsX(k)-1.9] ,[-cellsY(k),  -sortedDepth(k)] , '-k')
%     hold on 
% end
% % axis tight
% 
% %%
% %%
% %%
% 
% 
% 
% %% entire signal of the significant portion so if time = 0-25 is the best significant time then take that entire time and divide by BL
% selectivityIndex = [];
% timeIndexs = {};
% for sigs = 1:length(allSignals)
%     sig = allSignals{sigs};
%     sigZero = zeroPoints{sigs};
%     BLindex = BLindexALL{sigs}-1;
%     sigTime = sigTimeALL{sigs};
%     for cellStep = 1:size(poleUP,2)
%         sigTimeTMP = sigTime{cellStep}+sigZero;
%         sigTMP = sig(:, cellStep);
%         signalSignificant=nanmean(sigTMP(sigTimeTMP));
%         baseline = nanmean(sigTMP(BLindex));
%         selectivityIndex(cellStep, sigs) = (signalSignificant - baseline) ./ (baseline);
%     end
% end
% 
% 
% 
% 



