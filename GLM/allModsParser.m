
%load('Y:\tmpForTransfer\PHILS_GLM_CODE\modSaves\allModels 190919_1219.mat')


BF = DM.basisFuncs
allModelsEachCell = {};
betas = [];
dev = [];
lambda= [];
allDevs = [];
for mods1 = 1:length(allModels)
    tmpCell = allModels{mods1};
    if ~isempty(tmpCell)
        
        for k = 1:length(tmpCell.models)
            modLoc = tmpCell.models{k}.modLoc;
            betas(:, k) = tmpCell.models{k}.model.glmnet_fit.beta(:, modLoc);
            dev(k) = tmpCell.models{k}.model.glmnet_fit.dev(modLoc);
            lambda(k) = tmpCell.models{k}.model.glmnet_fit.lambda(modLoc);
            
        end
        allModelsEachCell{mods1}.betas = betas;
        allModelsEachCell{mods1}.dev = dev;
        allModelsEachCell{mods1}.lambda = lambda;
        %         disp(mods1)
        allDevs(1, mods1) = round(mods1);
        allDevs(2, mods1) = (mean(dev));
    end
end

%%
[sorted1, inds1] = sort(allDevs(2, :))
allDevs(2, inds1)
%%
figure;
hold on
tmp1 = plot(betas)

plot( median(betas, 2), '--k')
%%
cellStep = 20;
crush
%% BETA PLOTTER
%% min
[mins1, loc1] = nanmin(abs(allModelsEachCell{cellStep}.betas), [], 2);
% loc1 = loc1+((0:length(loc1)-1).*length(allModels{cellStep}.models));
loc1 = sub2ind(size(allModelsEachCell{cellStep}.betas), 1:length(loc1), loc1(:)');
betas = allModelsEachCell{cellStep}.betas(loc1)
numberInEachCategory = allModels{cellStep}.numInEachLabel;
labelInEachCategory = allModels{cellStep}.label;
timePoints = allModels{cellStep}.timePoints;
% plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
plotBetasWithBasis(betas, DMsettings)
%% mean

betas = nanmean(allModelsEachCell{cellStep}.betas, 2);
numberInEachCategory = allModels{cellStep}.numInEachLabel;
labelInEachCategory = allModels{cellStep}.label;
timePoints = allModels{cellStep}.timePoints;
% plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
plotBetasWithBasis(betas, DMsettings)

%% median

betas = nanmedian(allModelsEachCell{cellStep}.betas, 2);
numberInEachCategory = allModels{cellStep}.numInEachLabel;
labelInEachCategory = allModels{cellStep}.label;
timePoints = allModels{cellStep}.timePoints;
% plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
plotBetasWithBasis(betas, DMsettings)

%%
%% need to have the cell size for the trials and total time
lengthSig = 4000;
devAll = [];
for cellStep = 1:length(allModels)
    C = allModels{cellStep};
    if~isempty(C)
        R.pred = [];
        R.testY = [];
        R.testInds = [];
        for modK = 1:length(C.models)
            M = C.models{modK};
            A0 = M.model.glmnet_fit.a0(M.modLoc);
            betas = M.model.glmnet_fit.beta(:, M.modLoc);
            Xreshaped = reshape(C.X, lengthSig./C.binSize, [], size(C.X, 2));
            Yreshaped = reshape(C.Y, lengthSig./C.binSize, []);
            testX = reshape(Xreshaped( :, M.toTest , :), [] , size(Xreshaped, 3));
            testY = Yreshaped(:, M.toTest);
            pred = exp([ones(size(testX, 1), 1), testX]* [A0; betas]);
            pred = reshape(pred, lengthSig./C.binSize, []);
            R.pred = [R.pred, pred];
            R.testY = [R.testY, testY];
            R.testInds = [R.testInds , M.toTest];
            
            
            [xNANS, ~] = find(isnan(pred(:)));
            [yNANS, ~] = find(isnan(testY(:)));
            D.nanRows = unique([xNANS(:); yNANS(:)]);
            D.keepRows = setdiff(1:size(pred, 1), D.nanRows);
            u = pred(D.keepRows, :);
            y = testY(D.keepRows, :);
            [devAll(modK, cellStep)] = devExplainedPoisson(y, u);
        end
        
        [~, Uinds] = unique(R.testInds);
        R.testY = R.testY(:, Uinds);
        R.pred = R.pred(:, Uinds);
        corrVal(cellStep) = nancorr(R.testY(:), R.pred(:));
        
        [~, respInds] = sort(nanmean(R.pred, 1));
        %         respInds = 1:size(R.pred, 2);
        %         [~, respInds] = sort(Uinds);
        
        
        thresh1 = 1.5
        predPlot = R.pred(:, respInds)';
        predPlot(predPlot>thresh1) = thresh1;
        predPlot = meanNorm(predPlot);
        figure;imagesc(predPlot)
        
        actualPlot = R.testY(:, respInds)';
        actualPlot = meanNorm(actualPlot);
        figure; imagesc(actualPlot)
        
        figure; hold on
        plot(smooth(nanmean(testY, 2), 1))
        plot(nanmedian(pred, 2))
        tmp1 = devAll(:, cellStep);
        tmp1(isinf(tmp1)) = nan;
        tmp1 = round(nanmean(tmp1), 3);
        tmp2 = ylim;
        text( 140, tmp2(2)*.8, ['Dev Explained ', num2str(tmp1)]) ;
        text( 140, tmp2(2)*.7, ['Correlation ', num2str(round(corrVal(cellStep), 2))]) ;
        
        [mins1, loc1] = nanmin(abs(allModelsEachCell{cellStep}.betas), [], 2);
        % loc1 = loc1+((0:length(loc1)-1).*length(allModels{cellStep}.models));
        loc1 = sub2ind(size(allModelsEachCell{cellStep}.betas), 1:length(loc1), loc1(:)');
        betas = allModelsEachCell{cellStep}.betas(loc1)
        numberInEachCategory = allModels{cellStep}.numInEachLabel;
        labelInEachCategory = allModels{cellStep}.label;
        timePoints = allModels{cellStep}.timePoints;
        %         plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
        plotBetasWithBasis(betas, DMsettings)
        
        disp(allDevs(2, cellStep))
        
        disp(tmp1);
        keyboard
        close all
    end
end
%%

devAllSaved = devAll;
devAllSaved(isinf(devAllSaved)) = nan;
devAllSavedMean = nanmean(devAllSaved, 1);

figure;plot(corrVal, devAllSavedMean, '*k')
ylabel('Deviance Explained')
xlabel('Correlation')

%%
cd('C:\Users\maire\Dropbox\HIRES_LAB\PHIL\presentations\Lab meeting 190919 problems with behavior, targeting S2 and GLM models so far')
svName = {'betas' 'psth' 'real' 'predicted'}
for i = 1:4
    sdf(gcf, 'default18')
    % dateString1 = datestr(now,'yymmdd_HHMM');
    hold on
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf, [svName{i}, '_', num2str(cellStep),'.svg'])
    close
end

















