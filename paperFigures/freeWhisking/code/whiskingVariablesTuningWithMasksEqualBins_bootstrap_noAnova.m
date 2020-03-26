%% load('Y:\tmpForTransfer\PHILS_GLM_CODE\U_181027_2358.mat')
%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
tic
% % % % clearvars -except U
% dateString1 = datestr(now,'yymmdd_HHMM');
crush
allModsBS = {};
allMods = [];
theseVars = [1 2 3 4 5];
% theseCells =1:length(U);
Means = [];
SEM = [];
edgesPLOT = {};
binnedSpikes = {};
INbins = {};
numIterationsForBootStrap = 100;
varName = {};
binIndex = {};
fitCOSINE = true;
Whisk = struct;
%% load old bootstrapped stuff to make sure it isnt slow
load('C:\Users\maire\Downloads\tmpsave\191003_0912_allModsBS.mat')
redoBootstrap = true;

%% make a large random perm mat at the begining to make sampling random numbers easier
tic
if redoBootstrap
    allMatSizes = []
    for tmp1 = 1:length(theseCells)
        cellStep = theseCells(tmp1);
        allMatSizes(cellStep) = U{cellStep}.t.*U{cellStep}.k;
    end
    permMat = rand(max(allMatSizes), numIterationsForBootStrap);toc
end
%%
for varTypeTMP = 1:length(theseVars)
    varNum = theseVars(varTypeTMP);
    
    %%
    if varNum ==1
        varName{varNum} = 'Theta';
        svName = varName{varNum};
        %     edges = -50:10:80;
        %     edgesPLOT = edges;
        %     edges(1) = -inf;
        %     edges(end) = inf;
    elseif varNum ==2
        varName{varNum} = 'Velocity';
        svName = varName{varNum};
    elseif varNum ==3
        varName{varNum} = 'amplitude';
        svName = varName{varNum};
    elseif varNum ==4
        varName{varNum} = 'setpoint';
        svName = varName{varNum};
    elseif varNum ==5
        varName{varNum} = 'Phase';
        svName = varName{varNum};
        %     edges = -pi:.5:pi;
        %     edgesPLOT = edges;
        %     edges(1) = -inf;
        %     edges(end) = inf;
    elseif varNum ==6
        % % % % %     varName{varNum} = 'deltaKappa';
        % % % % %     edges = -.3:.01:.3;
        % % % % %     edgesPLOT = edges;
        % % % % %     edges(1) = -inf;
        % % % % %     edges(end) = inf;
    elseif varNum ==7
    elseif varNum ==8
    end
    
    %% for the best lagshift based on correlation
    %     shiftBy = [-500, 500]; %need to figure out how to make the max lag different for different directions
    
    %% times for masks
    touch_M = 0:50;
    P_UP_M = 0:50;
    P_down_M = 0:50;
    amp = 0 ;
    %% mask names
    remLowerThan = 20;
    varNames = masky;
    varNames = varNames(1:4)
    rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
    maskyExtraSettings = [{''} {''}  {''} {'<2.5'}];
    BLperiodNonWhiskingNumAmp = 2.5;
    %% set up subplot maker
    [SPout] = SPmaker(5,9);
    %%
    
    minMultiComp = [];
    for cellStepTMP = 1:length(theseCells)
        cellStep = theseCells(cellStepTMP);
        %%
        disp(num2str(cellStep))
        C = U{cellStep};
        %% make custom masks
        [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
        %     segs = findInARow(setdiff(1:(C.t .* C.k), allMask), C.t);
        % shortInds = find(segs(:, 3)<remLowerThan);
        %{
        I plot mask with spikes...
        tmp1 = zeros(C.t, C.k);tmp1(allMask) = 1;spikes = find(squeeze(C.R_ntk));tmp1(spikes) = 2;figure;imagesc(tmp1); colorbar
        %}
        %%
        spikes = squeeze(C.R_ntk);
        spikes(allMask) = nan;
        var1 = squeeze(C.S_ctk(varNum,:,:));
        var1(allMask) = nan;
        [spikes, var1,edges]=binslin(var1(:), spikes(:), 'equalN', 10);
        var1= cell2mat(var1);
        [~,~,binIndex{varNum, cellStep}] = histcounts(var1, edges);
        spikes = cell2mat(spikes);
        
        INbins{varNum} = 1:length(edges)-1;
        
        for k = 1:length(INbins{varNum})
            binnedSpikes{varNum, cellStep, k} = spikes(binIndex{varNum, cellStep} == INbins{varNum}(k));
            edgesPLOT{varNum, cellStep}(k) = nanmean(var1(binIndex{varNum, cellStep} == INbins{varNum}(k)));
            binnedSpikes{varNum, cellStep, k} = binnedSpikes{varNum, cellStep, k}(~isnan(binnedSpikes{varNum, cellStep, k}));
            SEM(varNum, cellStep, k) = nanstd(binnedSpikes{varNum, cellStep, k})/sqrt(length(binnedSpikes{varNum, cellStep, k}));
            Means(varNum, cellStep, k)  = nanmean(binnedSpikes{varNum, cellStep, k});
        end
        %         edgesPLOT{varNum, cellStep} = edgesPLOTtmp;
        allMods(varNum, cellStep) = (nanmax(Means(varNum, cellStep, :)) - nanmin(Means(varNum, cellStep, :)))./...
            (nanmax(Means(varNum, cellStep, :))+nanmin(Means(varNum, cellStep, :)));
        
        if redoBootstrap
            tic
            [~, permMat2] = sort(permMat(1:numel(spikes), 1:numIterationsForBootStrap));% by creating the random matrix in the begining this
            % savesw a shit tone of time random is still random
            [allModsBS{varNum, cellStep}] = BS_modulaion_continious_variables...
                (numIterationsForBootStrap,spikes, binIndex{varNum, cellStep}, permMat2);
            toc
        end
        
        
    end
end
toc


%%################################################
%%################################################
%%################################################
%%################################################
%% save it
if redoBootstrap
    cd('C:\Users\maire\Downloads\tmpsave')
    save([dateString1, '_allModsBS'], 'allModsBS', 'maskDetails')
end
%% plot it
%%################################################
%%################################################
%%################################################
%%################################################
%% statistics
sigVal = 0.05;
mod2beat = [];
%% this plots one variable from each cell onto a single plot and used the bootstrap method to
% determine if the ModIndex is significant greater than set statistic above
h = {};
xlabelCell = {'angle in degrees' 'units distance/units time' ...
    'angle in degrees' 'angle in degrees' 'Radians (phase)'}
SPout = {};
for varTypeTMP = 1:length(theseVars)
    varNum = theseVars(varTypeTMP);
    [SPout{varTypeTMP}] = SPmaker(5,9);
    for cellStepTMP = 1:length(theseCells)
        cellStep = theseCells(cellStepTMP);
        
        tmp1 = sort(allModsBS{varNum, cellStep});
        mod2beat(varNum, cellStep) = tmp1(ceil(length(tmp1).*(1-sigVal)));
        color1 = 'k';
        if  allMods(varNum, cellStep)>mod2beat(varNum, cellStep)
            color1 = 'r';
        end
        [SPout{varTypeTMP}] = SPmaker(SPout{varTypeTMP});
        hold on;
        plot(edgesPLOT{varNum, cellStep} , squeeze(Means(varNum, cellStep , :)) .* 1000, [color1, 'o']);
        if fitCOSINE == true && varNum == 5% only for phase
            [fitX, fitY] = fitCosine(squeeze(Means(varNum, cellStep , :)).* 1000, edgesPLOT{varNum, cellStep}, true);
            plot(fitX, fitY, 'm-');
            % % %             bins1 = cell2mat(squeeze(binnedSpikes(varNum, cellStep, :)));
            % % %             [fitX, fitY] = fitCosine(bins1, edgesPLOT{varNum, cellStep}(binIndex{varNum, cellStep}));
            % % % %             [fitX, fitY] = fitCosine(smooth(spikes, 10), var1);
            % % %             plot(fitX, fitY*1000, 'm-');
        end
        hold on;
        plot(edgesPLOT{varNum, cellStep} ,(squeeze(Means(varNum, cellStep , :))+    ...
            squeeze(SEM(varNum, cellStep , :))) .* 1000, 'k--');
        plot(edgesPLOT{varNum, cellStep}, (squeeze(Means(varNum, cellStep , :))-    ...
            squeeze(SEM(varNum, cellStep , :))) .* 1000, 'k--');
        axis tight
        
    end
    % keyboard
    suptitle(varName{varNum});
    suplabel(xlabelCell{varNum}, 'x');
    suplabel('Spikes/Sec', 'y');
    
end
%%################################################
%%################################################
%%################################################
%%################################################
% keyboard
Whisk.allModsBS = allModsBS;
Whisk.binnedSpikes = binnedSpikes;
Whisk.SEM = SEM;
Whisk.edgesPLOT = edgesPLOT;
Whisk.mod2beat = mod2beat;
Whisk.allMods = allMods;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
% Whisk.allModsBS = allModsBS;
%%
%{
% plot the BL x values for each variable for each cell (all cells plotted together for each variable
varNumTMP_IND  = 2; % this is the ind pay attention
figure
tmp1 = (cell2mat(edgesPLOT))';
tmp1 = reshape(tmp1,[10, 45, numel(tmp1)./(45*10)]) ;

hold on ;plot(squeeze(tmp1(:, 16, varNumTMP_IND)));
%}
%%
%% statistics
sigVal = 0.05;
mod2beat = [];
%% this plots one variable from each cell onto a single plot and used the bootstrap method to
% determine if the ModIndex is significant greater than set statistic above

[SPout2] = SPmaker(5,9);
colorPat = {'k' 'b' 'g' 'y' 'm'}
for cellStepTMP = 1:length(theseCells)
    cellStep = theseCells(cellStepTMP);
    [SPout2] = SPmaker(SPout2);
    
    for varTypeTMP = 1:length(theseVars)
        varNum = theseVars(varTypeTMP);
        tmp1 = sort(allModsBS{varNum, cellStep});
        mod2beat(varNum, cellStep) = tmp1(ceil(length(tmp1).*(1-sigVal)));
        symb1 = '--';
        if  allMods(varNum, cellStep)>mod2beat(varNum, cellStep)
            symb1 = '-';
        end
        
        y2plot = squeeze(Means(varNum, cellStep , :));
        y2plot = y2plot - min(y2plot);
        plot(normalize(edgesPLOT{varNum, cellStep}, 'range') ,  y2plot.* 1000, [colorPat{varNum}, symb1]);
        hold on;
        %         plot(edgesPLOT{varNum, cellStep} ,(squeeze(Means(varNum, cellStep , :))+    ...
        %             squeeze(SEM(varNum, cellStep , :))) .* 1000, 'k--');
        %         plot(edgesPLOT{varNum, cellStep}, (squeeze(Means(varNum, cellStep , :))-    ...
        %             squeeze(SEM(varNum, cellStep , :))) .* 1000, 'k--');
        axis tight
    end
    
end
suptitle('All Variables min spike rate subtracted');
suplabel('normalized units for each variable', 'x');
suplabel('Spikes/Sec', 'y');
legend(varName(~cellfun(@isempty, varName)))
%%
if saveOn
    saveNames = [varName];
    for k = 1:length(SPout)
        cd(saveDir)
        fullscreen(SPout{k}.mainFig)
        fn = [saveNames{k}, '_', dateString1];
        saveFigAllTypes(fn, SPout{k}.mainFig, saveDir, 'whiskingVariablesTuningWithMasksEqualBins_bootstrap_noAnova.m');
    end
    fullscreen(SPout2.mainFig)
    fn = ['allVars_', dateString1];
    saveFigAllTypes(fn, SPout2.mainFig, saveDir, 'whiskingVariablesTuningWithMasksEqualBins_bootstrap_noAnova.m');
    winopen(saveDir)
end

%%














