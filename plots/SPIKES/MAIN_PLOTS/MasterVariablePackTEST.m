
%%
%% HeatMapSelectivityDepth
%% make heat map of selectivity for each stimuli and map it across depth
% (signal - BL)/ std(BL)

%% preloaded structs from
% % % 
% % % % POLE signifTestWithCurvSortingPole2ONSET_LAT.m
% % % latencyStructPole
% % % poleStruct
% % % 
% % % % TOUCH signifTestWithCurvSortingONSET_LAT.m
% % % latencyStructTouch
% % % touchStruct
% % % % WHISKING ONSET  whiskingOnsetResponse.m
% % % %C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\whiskingOnsetResponse
% % % latencyStructW_ONSET
% % % W_ONSETStruct

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
%%

touchStruct.pvalsAll

%%

sigCells = [latencyStructTouch.proRetTouchSignif, latencyStructPole.proRetTouchSignif,...
    latencyStructW_ONSET.proRetTouchSignif ];
%%
IE = 4;
touchStruct.pvalsAll{iters, IE}
%%
getAll = {'1' '2' '1' '2' ':'};
L = length(U);
VarsL = size(sigCells,2);
PtestL = size(touchStruct.pvalsAll,1);
masterMat = nan(L, VarsL, 1);
% pro ret poleup poledown whiskingonsetFromSationary
strName = {'touchStruct' 'touchStruct' 'poleStruct' 'poleStruct' 'W_ONSETStruct'}
for k = 1: VarsL
    %
    eval(['masterMat(1:L, k, 1) =' strName{k} '.pvalsAll{1, 1}(:,' getAll{k} ');']) % pval Time 1
    eval(['masterMat(1:L, k, 2) =' strName{k}  '.pvalsAll{2, 1}(:,' getAll{k} ');']) % pval time 2
    eval(['masterMat(1:L, k, 3) =' strName{k}  '.pvalsAll{3, 1}(:,' getAll{k} ');']) % pval time 3
    eval(['masterMat(1:L, k, 4) =' strName{k}  '.pvalsAll{4, 1}(:,' getAll{k} ');']) % pval time 4
    % can use the below to figure out if increase or decrease
    eval(['masterMat(1:L, k, 11) =' strName{k} '.pvalsAll{1, 5}(:,' getAll{k} ');']) % sig - baseline Time 1
    eval(['masterMat(1:L, k, 12) =' strName{k}  '.pvalsAll{2, 5}(:,' getAll{k} ');']) % sig - baseline Time 2
    eval(['masterMat(1:L, k, 13) =' strName{k}  '.pvalsAll{3, 5}(:,' getAll{k} ');']) % sig - baseline Time 3
    eval(['masterMat(1:L, k, 14) =' strName{k}  '.pvalsAll{4, 5}(:,' getAll{k} ');']) % sig - baseline Time 4
    masterMat(1:L, 1:5, 31) = [latencyStructTouch.signalTimeIndex, latencyStructPole.signalTimeIndex, latencyStructW_ONSET.signalTimeIndex ];%which time period sig
    masterMat(1:L, 1:5, 32) = [latencyStructTouch.proRetTouchSignif, latencyStructPole.proRetTouchSignif, latencyStructW_ONSET.proRetTouchSignif ]; % at least one sig
    
    
    
end

%%
allSignals = [touchPRO(:) ,touchRET(:) ,poleUP(:) ,poleDOWN(:), W_ON(:) ];
for k = 1:numel(allSignals)
    allMeanSig{k} = nanmean(allSignals{k});
end
allMeanSig = reshape(allMeanSig, size(allSignals));
%%

timePeriods = cell(PtestL, 5);%timer periods (normally 1:25 25:50 and 0 :50)  BY type(pro ret pole up/down whisk)
timePeriods(1:PtestL, 1) = latencyStructTouch.allTimes;
timePeriods(1:PtestL, 2) = latencyStructTouch.allTimes;
timePeriods(1:PtestL, 3) = latencyStructPole.allTimes;
timePeriods(1:PtestL, 4) = latencyStructPole.allTimes;
timePeriods(1:PtestL, 5) = latencyStructW_ONSET.allTimes;

%%
zeroPoints =  [touchStruct.pvalsAll{1,4} ,touchStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4} ,poleStruct.pvalsAll{1,4},W_ON_ZERO ];


%% only look for peak in the significant regions BEOTCH

perc = 0.90;

% only sig cells
% only one of each type (only 1 pro or ret only one pole up or down) based on significantce I guess
smoothBy = 11;
PK = [];
for TYP = 1:size(masterMat, 2)
    BL = (-100:-20) + zeroPoints(TYP);
    SsigInd = (0:100) + zeroPoints(TYP);
    for CS = 1:size(masterMat, 1)
        if masterMat(CS, TYP, 32) % if cell was found to be significant
            Tsig = masterMat(CS, TYP, 31); %index of time found most significant
            S = allMeanSig{CS, TYP};% entire signal
            
            
            
            
            if smoothBy ~=1
                S = smooth(S, smoothBy, 'moving');
                S(1:smoothBy) = nan; S(end-smoothBy+1 :end) = nan;% nan out edge effects
            else
                S =S;
            end
            S = (S-nanmean(S(BL)))./std(S(BL));
% %             S = smooth(S, smoothBy);
%             sigSigTime = timePeriods{Tsig, TYP}; %time signal was most significant 
% %             sigSigTime = 1:80;
%             Ssig = S(zeroPoints(TYP)+sigSigTime);% significant portion
%             UPorDOWN(CS, TYP) =  masterMat(CS, TYP, 10+Tsig)>=0;%10 cause sig-BL starts at 11  1 is positive modiulation 0 is negative mod
%             if UPorDOWN(CS, TYP) %positive
%                 [~, PKtime] = nanmax(Ssig);
%                 PKtime = sigSigTime(PKtime) +zeroPoints(TYP);
%                 PK(CS, TYP) = PKtime;
%             else %negative
%                 [~, PKtime] = nanmin(Ssig);
%                 PKtime = sigSigTime(PKtime) +zeroPoints(TYP);
%                 PK(CS, TYP) = PKtime;
%             end


% %%
sigSigTime = timePeriods{Tsig, TYP}; %time signal was most significant
sigS = S(sigSigTime+zeroPoints(TYP));
[ s_S, s_ind] = sort(S);
if  UPorDOWN(CS, TYP) %positive
    %                 onsetIND= ceil(length(s_S).*perc);
    peakS =nanmax(sigS);
else
    %                 onsetIND = floor(length(s_S).*(1-perc));
    peakS =nanmin(sigS);
    
    
end
if abs(peakS>=5)
    onsetS = find(S(SsigInd)>=(2), 1) + zeroPoints(TYP)+ sigSigTime(1);
else
    modVal = 0.5;
    if  UPorDOWN(CS, TYP) %positive
        onsetS = find(S(SsigInd)>=(modVal*peakS), 1) + zeroPoints(TYP)+ sigSigTime(1);
        
    else
        onsetS = find(S(SsigInd)<=(modVal*peakS), 1) + zeroPoints(TYP)+ sigSigTime(1);
        
    end
end

% onsetPoint = s_S(onsetIND);
% 
% onsetPoint./  std(S(BL))
% timePoint = find(S(SsigInd)>=onsetPoint, 1) + zeroPoints(tmp);
PK(CS, TYP) = onsetS;



        else
            PK(CS, TYP) = nan;
        end
    end
end
%%%


TsigAll = masterMat(:, :, 31);
for k = 1:numel(TsigAll)
    tmp = masterMat(:,:, TsigAll(k));
    bestPvals(k) = tmp(k);
end
bestPvals = reshape(bestPvals, size(TsigAll));
bestPvals(isnan(bestPvals)) = 0;
bestTouchInd = 1+((bestPvals(:, 2) - bestPvals(:, 1)) <= 0);
bestPoleInd = 3+((bestPvals(:, 4) - bestPvals(:, 3)) <= 0);


LindBest = [];
for k = 1:45
    LindBest(k,1) = sub2ind(size(TsigAll), k ,bestTouchInd(k));
    LindBest(k,2) = sub2ind(size(TsigAll), k , bestPoleInd(k));
    LindBest(k,3) = sub2ind(size(TsigAll), k , 5);
end
%%%
close all
smoothBy = 11;
T_P_W = PK(LindBest);
allMeanSigSIG = allMeanSig(LindBest);
UPorDOWNbest = UPorDOWN(LindBest);
for k = 1:3% these are the 3 unique variables touch cue sound and whisking onsets
    %     if k == 3
    %         keyboard
    %     end
    
    allRespPos = [];
    allRespNeg = [];
    
    posInds = [];
    negInds = [];
    [sorted, inds] = sort(T_P_W(:,k));
    sorted = sorted(find(~isnan(sorted)));
    inds = inds(find(~isnan(sorted)));
    
    for kk = 1:length(inds)
        tmpSig =  allMeanSigSIG{inds(kk), k};
        
        if smoothBy ~=1
            tmpSig = smooth(tmpSig, smoothBy, 'moving');
            tmpSig(1:smoothBy) = nan; tmpSig(end-smoothBy+1 :end) = nan;% nan out edge effects
        else
            tmpSig =tmpSig;
        end
        
        
        signalsTOplot =(tmpSig-nanmin(tmpSig))./nanmax(tmpSig-nanmin(tmpSig));
        if max(signalsTOplot) ~= 1
            keyboard
        end
        %         UPorDOWNbest(inds, k) == 1
        if UPorDOWNbest(inds(kk), k) == 1
            allRespPos(:, end+1) = signalsTOplot;
            posInds(:, end+1) =  inds(kk);
        else
            allRespNeg(:, end+1) = signalsTOplot;
            negInds(:, end+1) =  inds(kk);
        end
    end
    Xtxt = -30;
    
    figure, imagesc(allRespPos');
    hold on
    %     xlim([-50 200]+200)
    for txtInd = 1:length(posInds)
        text( Xtxt,txtInd, num2str(posInds(txtInd)));
    end
    colorbar
    
    
    
    figure, imagesc(allRespNeg');
    hold on
    %     xlim([-50 200]+200)
    for txtInd = 1:length(negInds)
        text( Xtxt,txtInd, num2str(negInds(txtInd)));
    end
    colorbar
    
    %     keyboard
end









