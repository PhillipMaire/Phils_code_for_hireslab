%% arythang
% parpool(4)
allModels = {};
minNumWorkers = 2;

% % % % load('Y:\tmpForTransfer\PHILS_GLM_CODE\U_181027_2358.mat')
theseCells = 1:length(U);
load('Y:\tmpForTransfer\PHILS_GLM_CODE\cells2run.mat')
theseCells = cells2run;
theseCells = theseCells(1:floor(length(theseCells)./1.5))


dateString = datestr(now,'yymmdd_HHMM');
saveForTmp1Models = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\GLMs\tmpSavesForGLMmodels';
saveForTmp1Models = [saveForTmp1Models, '_', dateString];


dateString1 = datestr(now,'yymmdd_HHMM');
load('Y:\tmpForTransfer\PHILS_GLM_CODE\OnsetsALL_CELLS_190917.mat')
allWhiskingOnsets = cellfun(@(x) x.linIndsONSETS, OnsetsALL_CELLS, 'UniformOutput', false);
if ~exist('allWhiskingOnsets')
    error('allWhiskingOnsets doesnt exist')
end

cellsThanHaveRun = nan(size(U));


[trialTypes, trialTypeNames] = UtrialType(U);

modelRunName = 'buildDM_001 simple model 2 basisFunctionForTouches_entireTrial_5msBIN';
try
    U = msAndRoundUarray(U, 'ms');
catch
end
mkdir(saveForTmp1Models)
cd(saveForTmp1Models)
numModelsRunTotal = length(dir)-2;
for cellStepTMP = 1:length(theseCells)
    cellStep = theseCells(cellStepTMP);
    if isnan(cellsThanHaveRun(cellStepTMP))
        C = U{cellStep};
        
        Y = squeeze(C.R_ntk);
        tmp1 = nanmean(Y(:)).*1000;
        if tmp1>1
            
            tic
            [DM, DMsettings] = buildDM_001(U, OnsetsALL_CELLS, trialTypes, cellStep);
            %% randomly select data to model
            perc2model = .7;
            limitModelTrialNumsTo = 300;
            msRangeToModel = 1:4000;
            
            DMsettings.perc2model = perc2model;
            DMsettings.limitModelTrialNumsTo = limitModelTrialNumsTo;
            DMsettings.msRangeToModel{cellStepTMP} = msRangeToModel; % make it this way incase want to model like after pole up
            % which varies from cell to cell
            DMsettings.theseCells = theseCells;
            DMsettings.binSize = DM.binSize;
            DMsettings.Y = DM.Y3;
            DMsettings.X = DM.X3;
            DMsettings.label = DM.label;
            DMsettings.numInEachLabel = DM.numInEachLabel;
            save(['tmp_cell_', num2str(cellStep)],'_DMsettings')

            parfor iterateModel = 1:10
                
                [DM] = sampleDMandY(perc2model, limitModelTrialNumsTo,msRangeToModel, C, DM);
                
                %%
                glmNetOptions = struct;
                glmNetOptions.alpha= .95
                % glmnetSet
                
                
                DM.model = cvglmnet(DM.X2model, DM.Y2model, 'poisson', glmNetOptions);
                
                DM.modLoc = find(DM.model.lambda ==DM.model.lambda_1se);
                % to save just the important parts
                save(['tmp_cell_', num2str(cellStep), '_modRunNum_', num2str(iterateModel)],'-struct',...
                    'model','tomodel','toTest','modLoc','perc2model')
                
                
                
            end
            
            p = gcp;
            if p.NumWorkers<=minNumWorkers
                while numModelsRunTotal
                
            end
            timeItTook = toc
            pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
            pBullet.pushNote([],'model',['finished cell ', num2str(cellStep), ' in ', num2str(timeItTook), ' sec'])
            cellsThanHaveRun(cellStepTMP) = 1;
        end
    else
        pause(5)
    end
end

try
    cd('Y:\tmpForTransfer\PHILS_GLM_CODE\modSaves')
catch
end
save([modelRunName, ' allModels ', dateString1], 'allModels', 'DM', 'theseCells')


