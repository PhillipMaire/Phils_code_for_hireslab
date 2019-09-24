%{

winopen(saveForTmp1Models)



dateString = datestr(now,'yymmdd_HHMM');



leftToRun = 1;

counter1 = 0;
triggerParForEnd = 1;
while true
counter1 = counter1+1;
    delete(gcp('nocreate'))
    try
        poissonGLM
    catch
    end    
    if sum(leftToRun(:)) == 0;
        triggerParForEnd = 0 ;
    end
    pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
    pBullet.pushNote([],'model!',['failed ',num2str(counter1) , ' times'])
end


pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
pBullet.pushNote([],'WE DONE',['finished all cells'])





%}
%% get dowload location this is for the parallel core fail hack
userDir = winqueryreg('HKEY_CURRENT_USER',['Software\Microsoft\Windows\CurrentVersion\' 'Explorer\Shell Folders'],'Personal');
userDir = strrep(userDir, 'Documents', 'Downloads');
userDir = [userDir, filesep, 'tmpForParForTrickery'];
mkdir(userDir);
delete(userDir);
mkdir(userDir);
%%
modelRunName = 'buildDM_001 simple model 2 basisFunctionForTouches_entireTrial_5msBIN';

minNumWorkers = 2;
numTimesToRunModel = 10;
% % % % load('Y:\tmpForTransfer\PHILS_GLM_CODE\U_181027_2358.mat')
%only run these cells
% theseCells = 1:length(U);
load('Y:\tmpForTransfer\PHILS_GLM_CODE\cells2run.mat')
theseCells = cells2run;
theseCells = theseCells(1:floor(length(theseCells)./1.5))


saveForTmp1Models = 'C:\Users\maire\Dropbox\HIRES_LAB\PHIL\Data\GLMs\tmpSavesForGLMmodels';
saveForTmp1Models = [saveForTmp1Models, '_', dateString];

[trialTypes, trialTypeNames] = UtrialType(U);
load('Y:\tmpForTransfer\PHILS_GLM_CODE\OnsetsALL_CELLS_190917.mat')
allWhiskingOnsets = cellfun(@(x) x.linIndsONSETS, OnsetsALL_CELLS, 'UniformOutput', false);
if ~exist('allWhiskingOnsets')
    error('allWhiskingOnsets doesnt exist')
end



cellsThanHaveRun = nan(size(U));
try
    U = msAndRoundUarray(U, 'ms');
catch
end
mkdir(saveForTmp1Models)
cd(saveForTmp1Models)

modsRanAlready = dir('*_modRunNum_*');
numModelsRunTotal = length(modsRanAlready);

leftToRun = ones(length(theseCells), numTimesToRunModel);

for k = 1:size(modsRanAlready, 1)
    S = modsRanAlready(k).name;
    tmp1 = strfind(S, '_');
    dim1 = str2num(S(tmp1(2)+1:tmp1(3)-1));
    tmp2 = strfind(S, '.');
    dim2 = str2num(S(tmp1(4)+1:tmp2(1)-1));
    leftToRun(dim1, dim2) = 0;
    
    
end

[dim1, dim2] = find(leftToRun);
theseCells = intersect(theseCells, unique(dim1));

if sum(leftToRun(:)) == 0;
    triggerParForEnd = 0 ;
end
for cellStepTMP = 1:length(theseCells)
    cellStep = theseCells(cellStepTMP);
    ModelItersToRun = dim2(find(dim1==cellStep));
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
            save(['tmp_cell_', num2str(cellStep), '_DMsettings'], 'DMsettings')
            
            parfor iterateModel = ModelItersToRun(:)'
                
                [DM2] = sampleDMandY(perc2model, limitModelTrialNumsTo,msRangeToModel, C, DM);
                
                %
                glmNetOptions = struct;
                glmNetOptions.alpha= .95;
                % glmnetSet
                
                
                DM2.model = cvglmnet(DM2.X2model, DM2.Y2model, 'poisson', glmNetOptions);
                
                DM2.modLoc = find(DM2.model.lambda ==DM2.model.lambda_1se);
                % to save just the important parts
                keepFields = {'model' 'tomodel' 'toTest' 'modLoc' 'perc2model'};%remove allbut these fields
                DM2 = rmfield(DM2,setdiff(fieldnames(DM2), keepFields));
                parForSaveGLM(['tmp_cell_', num2str(cellStep), '_modRunNum_', num2str(iterateModel)], DM2)
                
                
%                 parallelHackForGLMnet(minNumWorkers, userDir,numModelsRunTotal);
                
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



