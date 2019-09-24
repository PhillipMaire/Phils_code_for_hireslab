function [DM, DMsettings] = buildDM(U, OnsetsALL_CELLS, trialTypes, cellStep)
%{

% % % % load('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_181027_2358.mat')


load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\WHISKING\whiskingOnset\OnsetsALL_CELLS_190917')
[trialTypes, trialTypeNames] = UtrialType(U);

cellStep = 1;
[DM, DMsettings] = buildDM(U, OnsetsALL_CELLS, trialTypes, cellStep)

%}
C = U{cellStep};
try
    U = msAndRoundUarray(U, 'ms')
catch
end
allModels = {};
allWhiskingOnsets = cellfun(@(x) x.linIndsONSETS, OnsetsALL_CELLS, 'UniformOutput', false);

Y = squeeze(C.R_ntk);
tmp1 = nanmean(Y(:)).*1000;
if tmp1>1 % only run cells with SPK/s greater than this number
    
    
    %% spike raster
    %{

    %}
    %% initializeDM
    DM = initializeDM(C);
    %%
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(1, :, :)), -200:40:200, DM, 'Theta');
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(2, :, :)), -200:40:200, DM, 'velocity');
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(3, :, :)), -200:40:200, DM, 'amplitude');
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(4, :, :)), -200:40:200, DM, 'setpoint');
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(5, :, :)), -200:40:200, DM, 'phase') ;
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(6, :, :)), -200:40:200, DM, 'deltaKappa') ;
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(7, :, :)), -200:40:200, DM, 'M0Adj');
    [DM] = shiftSigWithDM(squeeze(C.S_ctk(8, :, :)), -200:40:200, DM, 'FaxialAdj');
    %###########################
    %###########################
    %% set Variable
    varName = 'firstTouchOnset';
    firstTouch = squeeze(C.S_ctk(9, :, :));
    firstTouch(isnan(firstTouch)) = 0;
    
    widthBumps = 20;
    lengthSig = 4000;
    intervalsOfBumps = 10;
    numBumps = 10;
    bumpsOffset = -20;
    
    [DM] = bumpConvUpdateDM(varName, firstTouch, widthBumps, ...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    %###########################
    %###########################
    %% set Variable
    varName = 'firstTouchOnsetLONG';
    firstTouch = squeeze(C.S_ctk(9, :, :));
    firstTouch(isnan(firstTouch)) = 0;
    
    widthBumps = 100;
    lengthSig = 4000;
    intervalsOfBumps = 50;
    numBumps = 10;
    bumpsOffset = -100;
    
    [DM] = bumpConvUpdateDM(varName, firstTouch, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %###########################
    %###########################
    %% set Variable
    varName = 'lateTouchOnset';
    allLateTouches = squeeze(C.S_ctk(12, :, :));
    allLateTouches(isnan(allLateTouches)) = 0;
    
    widthBumps = 20;
    lengthSig = 4000;
    intervalsOfBumps = 10;
    numBumps = 10;
    bumpsOffset = -20;
    
    [DM] = bumpConvUpdateDM(varName, allLateTouches, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %###########################
    %###########################
    %% set Variable
    varName = 'lateTouchOnsetLONG';
    allLateTouches = squeeze(C.S_ctk(12, :, :));
    allLateTouches(isnan(allLateTouches)) = 0;
    
    widthBumps = 100;
    lengthSig = 4000;
    intervalsOfBumps = 50;
    numBumps = 10;
    bumpsOffset = -100;
    
    [DM] = bumpConvUpdateDM(varName, firstTouch, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %###########################
    %###########################
    %% set Variable
    varName = 'PoleOnset';
    poleOnset = zeros(C.t, C.k);
    poleOnset(C.meta.poleOnset(:)'+(0:C.k-1).*4000) = 1;
    
    widthBumps = 30;
    lengthSig = 4000;
    intervalsOfBumps = 15;
    numBumps = 8;
    bumpsOffset = -30;
    
    [DM] = bumpConvUpdateDM(varName, poleOnset, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    %###########################
    %###########################
    %% set Variable
    varName = 'PoleOnsetLONG';
    poleOnset = zeros(C.t, C.k);
    poleOnset(C.meta.poleOnset(:)'+(0:C.k-1).*4000) = 1;
    
    widthBumps = 100;
    lengthSig = 4000;
    intervalsOfBumps = 50;
    numBumps = 8;
    bumpsOffset = -100;
    
    [DM] = bumpConvUpdateDM(varName, poleOnset, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %###########################
    %###########################
    %% set Variable
    varName = 'PoleOffset';
    poleOffset = zeros(C.t, C.k);
    INDS = C.meta.poleOffset(:)'+(0:C.k-1).*4000;
    INDS = intersect(INDS, 1:numel(poleOffset));
    poleOffset(INDS) = 1;
    
    widthBumps = 30;
    lengthSig = 4000;
    intervalsOfBumps = 15;
    numBumps = 8;
    bumpsOffset = -30;
    
    [DM] = bumpConvUpdateDM(varName, poleOffset, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    %###########################
    %###########################
    %% set Variable
    varName = 'PoleOffsetLONG';
    poleOffset = zeros(C.t, C.k);
    INDS = C.meta.poleOffset(:)'+(0:C.k-1).*4000;
    INDS = intersect(INDS, 1:numel(poleOffset));
    poleOffset(INDS) = 1;
    
    widthBumps = 100;
    lengthSig = 4000;
    intervalsOfBumps = 50;
    numBumps = 8;
    bumpsOffset = -100;
    
    [DM] = bumpConvUpdateDM(varName, poleOnset, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    
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
    numBumps = 12;
    bumpsOffset = -200;
    [DM] = bumpConvUpdateDM(varName, answerLickHIT, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %% set Variable
    varName = 'answerLickFA';
    varName = [varName,' ', num2str(totalLicks), ' licks'];
    answerLick_FA = answerLicks.*trialTypes{cellStep}.falseAlarm(:)';
    
    [DM] = bumpConvUpdateDM(varName, answerLick_FA, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
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
    numBumps = 12;
    bumpsOffset = -200;
    
    [DM] = bumpConvUpdateDM(varName, earlyLicksAfterPoleHIT, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    %% set Variable
    varName = 'earlyLicksAfterPoleFA_Trials';
    varName = [varName,' ', num2str(msPastOnset), 'ms'];
    
    earlyLicksAfterPoleFA = earlyLicksAfterPole.*trialTypes{cellStep}.falseAlarm(:)';
    
    [DM] = bumpConvUpdateDM(varName, earlyLicksAfterPoleFA, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    
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
    numBumps = 12;
    bumpsOffset = -200;
    
    [DM] = bumpConvUpdateDM(varName, allOtherLicksHIT, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    
    %% set Variable
    varName = 'allOtherLicks_FA';
    
    allOtherLicks_FA = allOtherLicks.*trialTypes{cellStep}.falseAlarm(:)';
    [DM] = bumpConvUpdateDM(varName, allOtherLicks_FA, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    %% set Variables
    varName = 'AllWhiskingOnsets';
    whiskingOnsets = zeros(C.t, C.k);
    whiskingOnsets(allWhiskingOnsets{cellStep}) = 1;
    
    
    widthBumps = 50;
    lengthSig = 4000;
    intervalsOfBumps = 25;
    numBumps = 10;
    bumpsOffset = -100;
    
    [DM] = bumpConvUpdateDM(varName, whiskingOnsets, widthBumps,...
        lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
    
    
    %% BL firing rate as a predictor
    varName = 'BLfiringRate';
    trialNum = repmat(1:C.k, C.t, 1);
    trialNum = trialNum(:);
    reshapedY = reshape(DM.y, C.t, C.k);
    BLfiringRate = mean(reshapedY(1:200, :));
    BLfiringRate = BLfiringRate(trialNum)';
    
    DM.label = {DM.label{:}, varName};
    DM.x = [DM.x, BLfiringRate(:)];
    DM.timePoints = [DM.timePoints, 0];
    DM.numInEachLabel = [DM.numInEachLabel, 1];
    DM.basisFuncs = [DM.basisFuncs, {1}];
    DM.bumpOffset = [DM.bumpOffset,0];
    DM.bumpWidth = [DM.bumpWidth, 1];
    
    %% bin data
    DM.binSize = 20;
    
    DM.Y3 = (sum(reshape(DM.y(:), DM.binSize, []), 1))';
    DM.X3 = squeeze(nanmean(reshape(DM.x, DM.binSize, [], size(DM.x,2)), 1));
    DM.X3 = meanNorm(DM.X3, 'dm');
    
    [DMsettings] = updateDMsettings(DM);
    
    
end
