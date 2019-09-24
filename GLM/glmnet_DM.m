%%
% load('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_181027_2358.mat')
%%
cellStep = 12
C = U{cellStep} ;
[trialTypes, trialTypeNames] = UtrialType(U);
%% spike raster
%{
Y = squeeze(C.R_ntk);
[Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
figure; plot(Stime,Strial , '.')
figure; plot(smooth(mean(Y, 2), 20))
%}
% Columns 1 through 7
% {'thetaAtBase'}    {'velocity'}    {'amplitude'}    {'setpoint'}    {'phase'}    {'deltaKappa'}    {'M0Adj'}
% Columns 8 through 12
% {'FaxialAdj'}    {'firstTouchOnset'}    {'firstTouchOffset'}    {'firstTouchAll'}    {'lateTouchOnset'}
% Columns 13 through 16
% {'lateTouchOffset'}    {'lateTouchAll'}    {'PoleAvailable'}    {'beamBreakTimes'}
%% DM 
DM = struct;
DM.x = [];
DM.y = squeeze(C.R_ntk);DM.y =DM.y(:);
DM.timePoints = [];
DM.label = {};
DM.numInEachLabel = [];
%%
%%
[DM] = shiftSigWithDM(squeeze(C.S_ctk(1, :, :)), -30:10:30, DM, 'Theta'); 
[DM] = shiftSigWithDM(squeeze(C.S_ctk(2, :, :)), -30:10:30, DM, 'velocity'); 
[DM] = shiftSigWithDM(squeeze(C.S_ctk(3, :, :)), -30:10:30, DM, 'amplitude'); 
[DM] = shiftSigWithDM(squeeze(C.S_ctk(4, :, :)), -30:10:30, DM, 'setpoint'); 
[DM] = shiftSigWithDM(squeeze(C.S_ctk(5, :, :)), -30:10:30, DM, 'phase') ;
[DM] = shiftSigWithDM(squeeze(C.S_ctk(6, :, :)), -30:10:30, DM, 'deltaKappa') ;
[DM] = shiftSigWithDM(squeeze(C.S_ctk(7, :, :)), -30:10:30, DM, 'M0Adj'); 
[DM] = shiftSigWithDM(squeeze(C.S_ctk(8, :, :)), -30:10:30, DM, 'FaxialAdj'); 
%###########################
%###########################
%% set Variable 
varName = 'firstTouchOnset';

widthBumps = 30;
lengthSig = 4000;
intervalsOfBumps = 15;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset)
% convolve
firstTouch = squeeze(C.S_ctk(9, :, :));
firstTouch(isnan(firstTouch)) = 0;
[convolvedMAT_all] = convolveSigWithBumps(allBumps, firstTouch); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%###########################
%###########################
%% set Variable 
varName = 'lateTouchOnset';

widthBumps = 30;
lengthSig = 4000;
intervalsOfBumps = 15;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset)
% convolve
allLateTouches = squeeze(C.S_ctk(12, :, :));
allLateTouches(isnan(allLateTouches)) = 0;
[convolvedMAT_all] = convolveSigWithBumps(allBumps, allLateTouches); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%###########################
%###########################
%% set Variable 
varName = 'PoleOnset';

widthBumps = 30;
lengthSig = 4000;
intervalsOfBumps = 15;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset)
% convolve
poleOnset = zeros(C.t, C.k);
poleOnset(C.meta.poleOnset(:)'+(0:C.k-1).*4000) = 1;
[convolvedMAT_all] = convolveSigWithBumps(allBumps, poleOnset); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%###########################
%###########################
%% set Variable 
varName = 'PoleOffset';

widthBumps = 30;
lengthSig = 4000;
intervalsOfBumps = 15;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset)
% convolve
poleOffset = zeros(C.t, C.k);
INDS = C.meta.poleOffset(:)'+(0:C.k-1).*4000;
INDS = intersect(INDS, 1:numel(poleOffset));
poleOffset(INDS) = 1;
[convolvedMAT_all] = convolveSigWithBumps(allBumps, poleOffset); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%###########################
%###########################

%% set Variable 
varName = 'answerLickHIT';
totalLicks = 2;
varName = [varName,' ', num2str(totalLicks), ' licks'];
answerLicksCell ={};
answerLicks = zeros(C.t, C.k);
for k = 1:length(C.meta.poleOnset)
    tmp1 = C.meta.beamBreakTimes{k}(C.meta.beamBreakTimes{k}>C.meta.samplingPeriodTime{k}(end));
    tmp1 = tmp1(tmp1<=C.t);
    if length(tmp1)>totalLicks
        tmp1 = tmp1(1:totalLicks);
    end
   answerLicksCell{k} =  tmp1;
   answerLicks(answerLicksCell{k} , k) = 1;
end
answerLickHIT = answerLicks.*trialTypes{cellStep}.hit(:)';
%%
widthBumps = 100;
lengthSig = 4000;
intervalsOfBumps = 50;
numBumps = 6;
bumpsOffset = -100;
[DM] = bumpConvUpdateDM(varName, answerLickHIT, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM)
%%
[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps);
% convolve
[convolvedMAT_all] = convolveSigWithBumps(allBumps, answerLickHIT,widthBumps,  bumpsOffset); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%% set Variable 
varName = 'answerLickFA';
varName = [varName,' ', num2str(totalLicks), ' licks'];

answerLick_FA = answerLicks.*trialTypes{cellStep}.falseAlarm(:)';

% convolve
[convolvedMAT_all] = convolveSigWithBumps(allBumps, answerLick_FA); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%% set Variable
varName = 'earlyLicksAfterPoleHitTrials';
msPastOnset = 70;
varName = [varName,' ', num2str(msPastOnset), 'ms'];
earlyLicksCell ={};
earlyLicksAfterPole = zeros(C.t, C.k);
for k = 1:length(C.meta.poleOnset)
    tmp1 = C.meta.beamBreakTimes{k}(C.meta.beamBreakTimes{k}>(C.meta.poleOnset(k)+msPastOnset));
    tmp1 = tmp1(tmp1<=C.t);
    if length(answerLicksCell{k})>0
        tmp1 = tmp1(tmp1<answerLicksCell{k}(1));
    end
    earlyLicksCell{k} =  tmp1;
    earlyLicksAfterPole(earlyLicksCell{k} , k) = 1;
end

earlyLicksAfterPoleHIT = earlyLicksAfterPole.*trialTypes{cellStep}.hit(:)';

widthBumps = 100;
lengthSig = 4000;
intervalsOfBumps = 50;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset);
% convolve
[convolvedMAT_all] = convolveSigWithBumps(allBumps, earlyLicksAfterPoleHIT); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
%% set Variable 
varName = 'earlyLicksAfterPoleFA_Trials';
varName = [varName,' ', num2str(msPastOnset), 'ms'];

earlyLicksAfterPoleFA = earlyLicksAfterPole.*trialTypes{cellStep}.falseAlarm(:)';
[convolvedMAT_all] = convolveSigWithBumps(allBumps, earlyLicksAfterPoleFA); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];

%% set Variable
varName = 'allOtherLicksHIT';

allOtherLicksCell ={};
allOtherLicks = zeros(C.t, C.k);
for k = 1:length(C.meta.poleOnset)
    tmp1 = setdiff(C.meta.beamBreakTimes{k}, [earlyLicksCell{k}; answerLicksCell{k}]);
    tmp1 = tmp1(tmp1<=C.t);
    tmp1 = tmp1(tmp1>=1);
    allOtherLicksCell{k} =  tmp1;
    allOtherLicks(allOtherLicksCell{k} , k) = 1;
end

allOtherLicksHIT = allOtherLicks.*trialTypes{cellStep}.hit(:)';

widthBumps = 100;
lengthSig = 4000;
intervalsOfBumps = 50;
numBumps = 4;
bumpsOffset = 0;

[allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset);
% convolve
[convolvedMAT_all] = convolveSigWithBumps(allBumps, allOtherLicksHIT); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];

%% set Variable 
varName = 'allOtherLicks_FA';

allOtherLicks_FA = allOtherLicks.*trialTypes{cellStep}.falseAlarm(:)';
[convolvedMAT_all] = convolveSigWithBumps(allBumps, allOtherLicks_FA); 
%% set up DM 
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, convolvedMAT_all];
DM.timePoints = [DM.timePoints, timeShifts];
DM.numInEachLabel = [DM.numInEachLabel, numBumps];
% %% add trial numbers 
% varName = 'trialNum';
% trialNum = repmat(1:C.k, C.t, 1);
% trialNum = trialNum(:);
% %%
% DM.label = {DM.label{:}, varName};
% DM.x = [DM.x, trialNum];
% DM.timePoints = [DM.timePoints, 0];
% DM.numInEachLabel = [DM.numInEachLabel, 1];
%% add trial numbers 
varName = 'BLfiringRate';
trialNum = repmat(1:C.k, C.t, 1);
trialNum = trialNum(:);
reshapedY = reshape(DM.y, C.t, C.k);
BLfiringRate = mean(reshapedY(1:200, :));
BLfiringRate = BLfiringRate(trialNum)';

%%
DM.label = {DM.label{:}, varName};
DM.x = [DM.x, BLfiringRate(:)];
DM.timePoints = [DM.timePoints, 0];
DM.numInEachLabel = [DM.numInEachLabel, 1];















%%
%###########################
%###########################

%###########################
%###########################









%{
TOO ADD
- ALL OTHER LICKS 
- LARGE WHISK ONSETS 




%}






% C.meta.poleOnset
% C.meta.poleOffset
% C.meta.beamBreakTimes
% C.meta.answerLickTime
% C.meta.trialType
% C.meta.trialCorrect