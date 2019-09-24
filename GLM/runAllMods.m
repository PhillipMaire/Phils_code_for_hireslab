%%
% load('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_181027_2358.mat')
%%
goodOcells = [36    29    20     6     1    16    14    17     5    18]
allModels = {};
[trialTypes, trialTypeNames] = UtrialType(U);
load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\WHISKING\whiskingOnset\OnsetsALL_CELLS_190917')
allWhiskingOnsets = cellfun(@(x) x.linIndsONSETS, OnsetsALL_CELLS, 'UniformOutput', false);

if ~exist('allWhiskingOnsets')
    error('allWhiskingOnsets doesnt exist')
end
parfor cellStep = 1:length(U)
    crush
    C = U{cellStep} ;
    Y = squeeze(C.R_ntk);
    tmp1 = nanmean(Y(:)).*1000;
    if tmp1>1
        %% spike raster
        %{
Y = squeeze(C.R_ntk);
[Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
figure; plot(Stime,Strial , '.')
figure; plot(smooth(mean(Y, 2), 20))
        %}
        %% DM
        DM = struct;
        DM.x = [];
        DM.y = squeeze(C.R_ntk);
        DM.y =DM.y(:);
        DM.timePoints = [];
        DM.label = {};
        DM.numInEachLabel = [];
        %%
        %%
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(1, :, :)), -60:20:200, DM, 'Theta');
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(2, :, :)), -60:20:200, DM, 'velocity');
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(3, :, :)), -60:20:200, DM, 'amplitude');
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(4, :, :)), -60:20:200, DM, 'setpoint');
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(5, :, :)), -60:20:200, DM, 'phase') ;
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(6, :, :)), -60:20:200, DM, 'deltaKappa') ;
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(7, :, :)), -60:20:200, DM, 'M0Adj');
        [DM] = shiftSigWithDM(squeeze(C.S_ctk(8, :, :)), -60:20:200, DM, 'FaxialAdj');
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
        
        [DM] = bumpConvUpdateDM(varName, firstTouch, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
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
        
        [DM] = bumpConvUpdateDM(varName, allLateTouches, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
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
        
        [DM] = bumpConvUpdateDM(varName, poleOnset, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
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
        
        [DM] = bumpConvUpdateDM(varName, poleOffset, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
        
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
        [DM] = bumpConvUpdateDM(varName, answerLickHIT, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
        %% set Variable
        varName = 'answerLickFA';
        varName = [varName,' ', num2str(totalLicks), ' licks'];
        answerLick_FA = answerLicks.*trialTypes{cellStep}.falseAlarm(:)';
        
        [DM] = bumpConvUpdateDM(varName, answerLick_FA, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM)
        
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
        
        [DM] = bumpConvUpdateDM(varName, earlyLicksAfterPoleHIT, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
        %% set Variable
        varName = 'earlyLicksAfterPoleFA_Trials';
        varName = [varName,' ', num2str(msPastOnset), 'ms'];
        
        earlyLicksAfterPoleFA = earlyLicksAfterPole.*trialTypes{cellStep}.falseAlarm(:)';
        
        [DM] = bumpConvUpdateDM(varName, earlyLicksAfterPoleFA, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM)
        
        
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
        
        [DM] = bumpConvUpdateDM(varName, allOtherLicksHIT, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
        
        %% set Variable
        varName = 'allOtherLicks_FA';
        
        allOtherLicks_FA = allOtherLicks.*trialTypes{cellStep}.falseAlarm(:)';
        [DM] = bumpConvUpdateDM(varName, allOtherLicks_FA, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        %% set Variables
        varName = 'AllWhiskingOnsets';
        whiskingOnsets = zeros(C.t, C.k);
        whiskingOnsets(allWhiskingOnsets{cellStep}) = 1;
        
        
        widthBumps = 50;
        lengthSig = 4000;
        intervalsOfBumps = 25;
        numBumps = 10;
        bumpsOffset = -100;
        
        [DM] = bumpConvUpdateDM(varName, whiskingOnsets, widthBumps, lengthSig , intervalsOfBumps, numBumps,bumpsOffset,  DM);
        
        %% BL firing rate as a predictor
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
        
        
        
        %% bin data
        DM.binSize = 20;
        
        DM.Y3 = (sum(reshape(DM.y(:), DM.binSize, []), 1))';
        DM.X3 = squeeze(nanmean(reshape(DM.x, DM.binSize, [], size(DM.x,2)), 1));
        % DM.X3 = [ones(size(DM.X3, 1), 1), DM.X3];
        %% trim
        %         smoothBy = 10;
        %         figure;plot(smooth(mean(reshape(DM.y, [], C.k), 2), smoothBy))
        
        %%
        DM.X3 = meanNorm(DM.X3, 'dm');
        %% select the time period of the session you want to model
        range1 =  1:4000;
        range1 = unique(ceil(range1./DM.binSize));
        tic
        for iterateModel = 1:10
            %% splitData
            DM.perc2model = .7;
            if round(C.k.*DM.perc2model) > 200
                DM.perc2model = 200./C.k;
            end
            
            DM.tomodel = randsample(C.k, round(C.k.*DM.perc2model));
            DM.toTest = setdiff(1:C.k , DM.tomodel);
            
            DM.Xreshaped = reshape(DM.X3, C.t./DM.binSize, C.k, size(DM.X3, 2));
            DM.Xreshaped = DM.Xreshaped(range1, :, :);
            DM.X2model = reshape(DM.Xreshaped(:, DM.tomodel, :), [], size(DM.X3, 2));
            DM.X2test = reshape(DM.Xreshaped(:, DM.toTest, :), [], size(DM.X3, 2));
            
            
            
            DM.Yreshaped = reshape(DM.Y3, [], C.k);
            DM.Yreshaped = DM.Yreshaped(range1, :, :);
            DM.Y2model = DM.Yreshaped(:, DM.tomodel);
            DM.Y2test = DM.Yreshaped(:, DM.toTest);
            % DM.Y2test = meanNorm(DM.Y2test);
            %% remove all nans
            
            [DM.X2model, DM.Y2model, DM.XY2model_inds] = nanRemove(DM.X2model, DM.Y2model);
            [DM.X2test, ~, DM.XY2test_inds] = nanRemove(DM.X2test, DM.Y2test);
            %%
            toPlot = DM.X2model(1:2*C.t./DM.binSize, :);
            figure;imagesc(toPlot )
            
            %%
            
            
            DM.model = cvglmnet(DM.X2model, DM.Y2model, 'poisson');
            allModels{cellStep}.models{iterateModel}.model  = DM.model;
            allModels{cellStep}.models{iterateModel}.tomodel  = DM.tomodel;
            allModels{cellStep}.models{iterateModel}.toTest  = DM.toTest;
            allModels{cellStep}.models{iterateModel}.modLoc = find(DM.model.lambda ==DM.model.lambda_1se);
            %         allModels{iterateModel, cellStep} = DM;
        end
        allModels{cellStep}.perc2model = DM.perc2model;
        allModels{cellStep}.timePoints = DM.timePoints;
        allModels{cellStep}.binSize = DM.binSize;
        allModels{cellStep}.Y = DM.Y3;
        allModels{cellStep}.X = DM.X3;
        allModels{cellStep}.label = DM.label;
        allModels{cellStep}.numInEachLabel = DM.numInEachLabel;

        
        
        
        
        
        timeItTook = toc
        pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
        pBullet.pushNote([],'model',['finished cell ', num2str(cellStep), ' in ', num2str(timeItTook), ' sec'])
        
        DM.modLocation = find(DM.model.lambda ==DM.model.lambda_1se);
        
        
    end
end


%%



