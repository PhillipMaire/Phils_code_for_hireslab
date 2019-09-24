%%
% load('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_181027_2358.mat')
%%
% C = U{1} ;
%%
if filesep == '/'
load('/Users/phillipmaire/Dropbox/HIRES_LAB/PHIL/GLMscripts/MyFirstGLM/Cell_6.mat')
elseif filesep == '\'
load('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\GLMscripts\MyFirstGLM\Cell_6.mat');
end
% make Y
Y = squeeze(C.R_ntk);
% bin cell C
getMean  = false;
binSize = 1; 
C = binAsingleCell(C, binSize);
Y = squeeze(C.R_ntk);
Y = Y*binSize;
%% spike raster
%{
[Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
figure; plot(Stime,Strial , '.')
figure; plot(smooth(mean(Y, 2), 20))
%}
%% trim time from start to end in units of ms*binSize
Tval = [1:4000];
DM.Yind = [ 25 25]; %first spike indice in reference to the DM.winS
Y = Y(Tval, :);
%% get vairables for the design matrix

theseVars = [ 3 4];
% 3 is amp 4 is setpoint 

% DM.winS = {  1:50:101, 1:50:101, 1:50:101, 1:50:101, 1:50:101,} ;% window size for each variable. Always start with 1!!!
DM.winS = {1:10:50 1:10:50} ;% window size for each variable. Always start with 1!!!
if ~isequal(length(theseVars), length(DM.winS), length(DM.Yind))
    error('arrays must be the same size')
end
%%% %%%%%%********???????? do you perform mean normalization on each trial of each estimator or on the entire 
%%% estimator array (say for example all of amplitude formalized by max(amp(:)) and not max(amp). the later yielding an array of numbers 
DM.Xa = {};
Xb = [];
for k = theseVars
    Xvar = squeeze(C.S_ctk(k, :, :));
%     Xvar = Xvar(Tval, :);
    Xvar = (Xvar-nanmean(Xvar))./ (nanmax(Xvar) - nanmin(Xvar));
    DM.Xa{end+1} = Xvar;
    Xb = [Xb, Xvar];
end
C.meta.poleOnset
C.meta.poleOffset
C.meta.beamBreakTimes
C.meta.answerLickTime
C.meta.trialType
C.meta.trialCorrect


figure, imagesc(Xb)
%% ...
close all
shiftBy = [];
shiftByMin = [];
shiftByMax = [];
for k = 1:length(DM.winS)
    shiftByMin(k) = min(DM.winS{k}- DM.Yind(k));
    shiftByMax(k) = max(DM.winS{k}- DM.Yind(k));
end
Smin = min(shiftByMin);
Smax = max(shiftByMax);
C.t2 = 1-Smin:C.t-Smax;
YtrialIndsUsed1 = max(DM.Yind):max(DM.Yind)+length(C.t2)-1; % these are the indices for the spikes
YtrialIndsUsed = repmat(YtrialIndsUsed1(:), [C.k, 1]);
addInd =   (0:C.k-1) .* ones(length(C.t2)  , 1);
addInd = addInd(:) *C.t;
YtrialIndsUsed = YtrialIndsUsed+addInd;
Y2 = Y;
%% touch variable 

allTouchOnsets = [find(C.S_ctk(9, :, :)==1); find(C.S_ctk(12, :, :)==1)];
tmp1 = zeros(C.t, C.k);
tmp1(allTouchOnsets) = 1;
allTouchOnsets = tmp1;
%% make cosine bumps
close all
widthBumps = 50;
lengthSig = 4000
intervalsOfBumps = 25;
numBumps = 8;

t = linspace(-pi, pi, widthBumps);
x = (cos(t)+1)./2;
bumpOne = [x(:); zeros(lengthSig-length(x), 1)];
allBumps = bumpOne;
for k = 1:numBumps-1
    
   allBumps = [allBumps, circshift(bumpOne, intervalsOfBumps*k)] ;
    
end
%% touches with raised cosine bumps 
convolvedMAT_all_touches = [];
for kk= 1:size(allBumps, 2)
    convolvedMAT = [];
    for k = 1:size(allTouchOnsets, 2)
        convolvedMAT(:, k) = conv(allTouchOnsets(:, k), allBumps(:,kk));
        
        
    end
    convolvedMAT = convolvedMAT(1:4000,:);
    convolvedMAT_all_touches(:, kk) = convolvedMAT(:);
end

convolvedMAT_all_touches = (convolvedMAT_all_touches-nanmean(convolvedMAT_all_touches))./...
    (nanmax(convolvedMAT_all_touches) - nanmin(convolvedMAT_all_touches));
figure;imagesc(convolvedMAT)
%% make cosine bumps
close all
widthBumps = 80;
lengthSig = 4000
intervalsOfBumps = 40;
numBumps = 6;

t = linspace(-pi, pi, widthBumps);
x = (cos(t)+1)./2;
bumpOne = [x(:); zeros(lengthSig-length(x), 1)];
allBumps = bumpOne;
for k = 1:numBumps-1
    
   allBumps = [allBumps, circshift(bumpOne, intervalsOfBumps*k)] ;
    
end
%% add reward licks for first X licks after reward lick
% basic idea here would be to split the FA licks and HIT licks ans make those two seperate variables
% and hit them with some fairly wide basis functions for reward. say 350 ms
numLicksIncludingAnswerLIck = 99;
allAnsLIcks = {};
ansLicksMAT = zeros(C.t, C.k);
for k = 1:C.k
    ansLicks = C.meta.beamBreakTimesCell{k}(C.meta.beamBreakTimesCell{k}>=C.meta.answerLickTime(k));
    if length(ansLicks)>numLicksIncludingAnswerLIck
        ansLicks = ansLicks(1:numLicksIncludingAnswerLIck);
    end
    allAnsLIcks{k} = ansLicks;
    ansLicksMAT(ansLicks, k) = 1;
end
%% licks with raised cosine bumps 
convolvedMAT_all_licks = [];
for kk= 1:size(allBumps, 2)
    convolvedMAT = [];
    for k = 1:size(ansLicksMAT, 2)
        convolvedMAT(:, k) = conv(ansLicksMAT(:, k), allBumps(:,kk));
        
        
    end
    convolvedMAT = convolvedMAT(1:4000,:);
    convolvedMAT_all_licks(:, kk) = convolvedMAT(:);
end

convolvedMAT_all_licks = (convolvedMAT_all_licks-nanmean(convolvedMAT_all_licks))./...
    (nanmax(convolvedMAT_all_licks) - nanmin(convolvedMAT_all_licks));
figure;imagesc(convolvedMAT)
%% pole triggers
addTO = 0:C.t:(C.k-1).*C.t;
tmp1 = zeros(size(allTouchOnsets));
tmp1(C.meta.poleOnset(:)+addTO(:)) = 1;
P_on = tmp1;
tmp1 = zeros(size(allTouchOnsets));
tmp2 = C.meta.poleOffset(:);
tmp2(tmp2>4000) = nan;
inds = tmp2+addTO(:);
inds = inds(~isnan(inds));
tmp1(inds) = 1;
P_off = tmp1;
%% make cosine bumps for pole triggers
close all
widthBumps = 20;
lengthSig = 4000;
intervalsOfBumps = 10;
numBumps = 8;

t = linspace(-pi, pi, widthBumps);
x = (cos(t)+1)./2;
bumpOne = [x(:); zeros(lengthSig-length(x), 1)];
allBumps = bumpOne;
for k = 1:numBumps-1
    
   allBumps = [allBumps, circshift(bumpOne, intervalsOfBumps*k)] ;
    
end
figure;plot(allBumps)
%% convolve all the bumps
convolvedMAT_all_poleUp = [];
for kk= 1:size(allBumps, 2)
    convolvedMAT = [];
    for k = 1:size(P_on, 2)
        convolvedMAT(:, k) = conv(P_on(:, k), allBumps(:,kk));
        
        
    end
    convolvedMAT = convolvedMAT(1:4000,:);
    convolvedMAT_all_poleUp(:, kk) = convolvedMAT(:);
end
convolvedMAT_all_poleUp = (convolvedMAT_all_poleUp-nanmean(convolvedMAT_all_poleUp))./...
     (nanmax(convolvedMAT_all_poleUp) - nanmin(convolvedMAT_all_poleUp));
figure;imagesc(convolvedMAT)
%%
convolvedMAT_all_poleDown = [];
for kk= 1:size(allBumps, 2)
    convolvedMAT = [];
    for k = 1:size(P_off, 2)
        convolvedMAT(:, k) = conv(P_off(:, k), allBumps(:,kk));
        
        
    end
    convolvedMAT = convolvedMAT(1:4000,:);
    convolvedMAT_all_poleDown(:, kk) = convolvedMAT(:);
end
convolvedMAT_all_poleDown = (convolvedMAT_all_poleDown-nanmean(convolvedMAT_all_poleDown))./...
     (nanmax(convolvedMAT_all_poleDown) - nanmin(convolvedMAT_all_poleDown));
figure;imagesc(convolvedMAT)

%% combine the pole up downa dn touches 
X_PoleAndTouches = [convolvedMAT_all_touches,convolvedMAT_all_poleUp, convolvedMAT_all_poleDown, convolvedMAT_all_licks];
numberInEachCategory =[5, 5, 8, 8, 8, 6 ];
labelInEachCategory = {'Amplitude', 'Setpoint', 'Touches', 'Pole up', 'Pole down', 'Licks'};
%% is trials by time and thus correspond to spikes(:) (in a column)
tic

% maxMat = C.t*C.k;
Xd = [];
for k = 1:length(DM.Xa)
    winS = DM.winS{k};
    Yind = DM.Yind(k);
    Xb = DM.Xa{k};
    Ks = size(Xb, 2);
    Ts = size(Xb,1);
    %     addNans =  nan(abs(Smin), size(Xb, 2));
    %     Xb = [addNans; Xb];
    indDM = repmat(winS+shiftByMin(k)-1, [Ts, 1]);
    spacingVal = winS(end) - winS(1);
    indDM = indDM + (0:size(indDM,1)-1)';% index mat for single trial
    indDM = indDM(Tval, :);
    addInd =   (0:Ks-1) .* ones(size(indDM,1)  , 1);
    addInd = (addInd(:) .* ones(1, length(winS)))*(C.t);% creat a matrix to help make the lin in index for the design matrix index
    
    [R1, C1] = find(indDM <1); % indexes less than on
    [R2, C2] =find(indDM >C.t); %indexes greater than the max time in Xb matrix
    R3 = [R1; R2];
    C3 = [C1; C2];

    R3 = R3 + (0:Ks-1)*size(indDM, 1);
    C3 = repmat(C3, [1, Ks]);
    
    % remT =sum(indDM>C.t, 2)~=0;
    % indDM(remT, :) = nan;
    %     max(max(indDM))
    %     min(min(indDM))
    
    indDM = repmat(indDM, [ C.k,1 ]) ; % index for all trials before adding lin ind modifier
    indDM = indDM +addInd; % final index matrix to make the design matrix
    linearInd = sub2ind(size(indDM), R3, C3);
    indDM(linearInd(:)) = 1;%temporary;
    %     goodInds = find(~isnan(nanmean(indDM, 2)));
    %     indDM = indDM(goodInds,:);
    Xc = Xb(indDM);% a C.t*C.k by sum of lengths of all of
    if getMean
        for kk = 1:spacingVal-1
             Xctmp = Xb(indDM+kk);
        end
        Xc = Xc/spacingVal;
    end
    
    Xc(linearInd(:)) = 0;
    Xd = [Xd, Xc];
end
toc
figure, imagesc(Xd(1:3*length(Tval), :));

%%
%% replace NANs with a number
X = Xd;
X(isnan(X)) = 0;

%% add the touches and poles 

X = [X, X_PoleAndTouches];

figure;plot(X(4001:8000, :));
figure;imagesc(X(4001:8000, :));
%%
% %% remove all rows with NAN
% remNans = find(~isnan(mean(Xd, 2)));
% 
% X = reshape(Xd(remNans, :), [],size(Xd, 2));
% Y2 = Y2(remNans);

Y2 = Y(:);
Xcov = (X'*X);
% Xcov = (X'*X)./(size(X, 1)-1);
Xsta = X'*Y2(:);
Khat = inv(Xcov) * Xsta;
figure; plot(Khat)
Yhat = X*Khat;
%% whiten the data 
 %%
 tmp = sum(Y2(:));
wsta = Xcov\(Xsta*tmp);
figure;plot(wsta./norm(wsta))
hold on 
plot(Xsta./norm(Xsta))
WKhat = inv(Xcov) * wsta;
 WYhat = X*wsta;
 %%
 plot(smooth(wsta./norm(wsta), 4, 'moving'), '--')
 
% whitened STA
% % % ta = (Xdsgn'*Xdsgn)\sta*nsp;
% % % % or equivalently inv(Xdsgn'*Xdsgn)*(Xdsgn'*sps)

%%
%{
    tic
    Kpoisson = glmfit(X, Y2, 'Poisson');
    toc
    YhatPoisson = [ones(size(X, 1), 1),X]*Kpoisson;
%}
%%
%%
% figure; plot(Kpoisson)
%% plot STA where the spike is at time = 0

figure, imagesc(Xcov)
figure
hold on
tmp2 = [];
for k = 1:length(DM.winS)
    tmp2(k) = length(DM.winS{k});
end
tmp2 = [ 0, cumsum(tmp2)]
for k = 1:length(tmp2)-1
    Ytmp = Xsta(tmp2(k)+1:tmp2(k+1));
    line1 = plot(DM.winS{k}-DM.Yind(k), Ytmp) ;
    hold on
    colors1{k} = line1.Color;
end
legend(C.varNames{theseVars})
%{
for k = 1:length(tmp2)-1
    Ytmp2 = wsta(tmp2(k)+1:tmp2(k+1));
    line2 = plot(DM.winS{k}-DM.Yind(k), Ytmp2) ;
    line2.Color = colors1{k};
    line2.LineStyle = '--';
end
legend(C.varNames{theseVars})
%}
%% plot spikes

[Stime, Strial] = find(reshape(Y2, [],C.k));
figure; plot(Stime,Strial , '.');
%% spikes heatmap
Y3 = smooth(Y2, round( 100/binSize), 'moving');
tmp = sort(Y3);
tmp = tmp(round(0.95*length(Y3)));
Y3(Y3>tmp) = tmp;
figure;imagesc(flip((reshape(Y3,[] ,C.k))'))
%% gaussian heatmap
% [Stime, Strial] = find(reshape(Y2, [],C.k));
% figure; plot(Stime,Strial , '.');
yhatMAT = reshape(Yhat, [],C.k);
yhatMAT2 = (1:C.k)+ yhatMAT;
figure;imagesc(yhatMAT')
%% gaussian heatmap WHITEN
% [Stime, Strial] = find(reshape(Y2, [],C.k));
% figure; plot(Stime,Strial , '.');
WyhatMAT = reshape(WYhat, [],C.k);
yhatMAT2 = (1:C.k)+ WyhatMAT;
figure;imagesc(WyhatMAT')
%% poisson heatmap 
%{
 yhatMATpoiss = reshape(YhatPoisson, [],C.k);
 yhatMAT2 = (1:C.k)+ yhatMATpoiss;
 figure;imagesc(yhatMATpoiss')
%}
%% plot PSTH of real and each model 
yhatMAT = reshape(Yhat, [],C.k);
tmp1 =meanNorm(mean(reshape(Y2, [],C.k),2));

figure; 
plot(tmp1)
% plot(smooth(tmp1, 3))
hold on 
plot(meanNorm(mean(yhatMAT,2)))

%  plot(meanNorm(mean(WyhatMAT,2)))
%{
plot(meanNorm(nanmean(ratepred_pGLM, 2)));

%}
%%
tmp1


% plot(meanNorm(mean(yhatMATpoiss,2)+2.1))
%% add ones to compute the STA 
% Updated design matrix
Xdsgn = X;
Xdsgn2 = [ones(size(Xdsgn, 1),1), Xdsgn]; % just add a column of ones
%%
% Compute whitened STA
tmp = sum(Y2(:));
MLwts = (Xdsgn2'*Xdsgn2)\(Xdsgn2'*Y2);% this is just the LS regression formula
const = MLwts(1); % the additive constant
wsta2 = MLwts(2:end); % the linear filter part
figure; plot(wsta2)

% Now redo prediction (with offset)
%%
sppred_lgGLM2 = const + Xdsgn*wsta2;

mse2 = mean((Y2-sppred_lgGLM2).^2)
%%
close all
PupTIMESamp = meanNorm(Xdsgn(:, 6) .* Xdsgn(:,23));
tmp1 = [Xdsgn(:, [3, 8, 11,20, 28, 37])];
tmp1 = Xdsgn;
pGLMwts = glmfit(tmp1,Y2,'poisson', 'constant', 'on');
pGLMconst = pGLMwts(1);
pGLMfilt = pGLMwts(2:end);
% Compute predicted spike rate on training data
ratepred_pGLM = exp(pGLMconst + tmp1*pGLMfilt);

ratepred_pGLM = reshape(ratepred_pGLM,  [], C.k);
figure; imagesc(ratepred_pGLM')
%%
realSpikes = reshape(Y2, [],C.k);
tmp1 =meanNorm(mean(realSpikes, 2));
figure; 
plot(smooth(tmp1, 10))
% plot(smooth(tmp1, 3))
hold on 
plot(meanNorm(nanmean(ratepred_pGLM, 2)));
%%

sampInds = randsample( C.k, 10);
glmFits = ratepred_pGLM(:, sampInds);
actualSpikes = realSpikes(:, sampInds);
figure
for k = 1:size(glmFits, 2)
    hold off
    plot(smooth(actualSpikes(:, k), 1))
     hold on
     plot(glmFits(:, k))
   
    waitForEnterPress
    
end

%%
Cmat = [];
N = 100; 
thresholdA = linspace(0, 1, N);
for iter = 1:N
    tmp = double(Yhat>thresholdA(iter));
    Cmat = [Cmat, confusionmat(double(Y2>0),tmp)];
    disp(iter)
end

%
for k = 1:N
    disp(k)
    Cmat2 = Cmat(:,[1,2]+(2*(k-1)));
    TN = Cmat2(1, 1); % CR
    FP = Cmat2(1, 2) ; %FA
    FN = Cmat2(2, 1) ;% miss
    TP = Cmat2(2, 2);%% hit
    numerator = ((TP*TN) - (FP*FN));
    denom = sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
    MCC = numerator./denom;
    allMCC(k) = MCC;
end
figure; plot(allMCC); ylim([0 1])
