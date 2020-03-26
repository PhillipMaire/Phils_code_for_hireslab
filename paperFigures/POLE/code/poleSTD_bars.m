%% only plot 'good' touches based on curature. can look at jsut high curve touches too.


% % % [fList,pList] = matlab.codetools.requiredFilesAndProducts('poleSTD.m')

pole = {};
crush
% dateString1 = datestr(now,'yymmdd_HHMM');
plotRange = -40:100;
% binSize = 5;
prePoleBL = -30:-1;


removeSpikesInSignalLessThan = 0.5;


[SPout] = SPmaker(5, 9);
[SPout2] = SPmaker(5, 9);

smoothBy = 1;
multPLotBy = 1000;
numInARow = 5;% only keep segments g
stdThresh =  1.960;  % 1.645 is the 95th percentile; 1.960 is the 97.5th
alpha1 = 0.05;
numOfBootsToStrap = 1000;

minNumberOfValuesPerBin = 50;

% title1 = sprintf(['smooth %d, numInARow %d'], smoothBy, numInARow);
%% times for masks
touch_M = 0:100;
P_UP_M = [];
P_down_M = [];
amp = [] ;
WhiskOnset = [];
%% make sure whisking onset is in the U array
% load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\OnsetsALL_CELLS_190917.mat')
% edit AllWhiskingOnsetTimes
for k = 1:length(U)
    U{k}.whiskOnset = OnsetsALL_CELLS{k};
end
%% mask names
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:5)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}, {WhiskOnset}]
maskyExtraSettings = [{''} {''} {''} {'>5'} {''}];
%%
CI_Alpha = 0.05;
%%
for cellStep = 1:length(U)
    %%
    disp(num2str(cellStep))
    C = U{cellStep};
    %% make maske for pole up and down
    [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    %{
        I plot mask with spikes...
        tmp1 = zeros(C.t, C.k);tmp1(allMask) = 1;spikes = find(squeeze(C.R_ntk));tmp1(spikes) = 2;figure;imagesc(tmp1); colorbar
    %}
    %% get index for extracting time of interest
    poleOffset = C.meta.poleOffset;
    poleOffset(poleOffset>C.t) = nan;
    [poleUPextract, poleUP_makeTheseNans] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), plotRange, C.t);
    [poleDOWNextract, poleDOWN_makeTheseNans] = getTimeAroundTimePoints(poleOffset+(0:C.t: (length(poleOffset)-1).*C.t), plotRange, C.t);
    
    
%     ceil(poleDOWNextract(plotRange==0, :)./C.t)
    
    
    [prePoleRegionUP, makeTheseNansPrePoleUP] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), prePoleBL, C.t);
    [prePoleRegionDOWN, makeTheseNansPrePoleDOWN] = getTimeAroundTimePoints(poleOffset+(0:C.t: (length(poleOffset)-1).*C.t), prePoleBL, C.t);
    
    %% get spikes and apply the mask
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    %% get the times of interest
    UPSpikes = spikes(poleUPextract);
    UPSpikes(poleUP_makeTheseNans) = nan;
    UPSpikes(sum(~isnan(UPSpikes), 2)<minNumberOfValuesPerBin, :) = nan;
    
    
    DOWNSpikes = spikes(poleDOWNextract);
    DOWNSpikes(poleDOWN_makeTheseNans) = nan;
    DOWNSpikes(sum(~isnan(DOWNSpikes), 2)<minNumberOfValuesPerBin, :) = nan;
    
    
    UP_BL_Spikes = spikes(prePoleRegionUP);
    UP_BL_Spikes(makeTheseNansPrePoleUP) = nan;
    UP_BL_Spikes(sum(~isnan(UP_BL_Spikes), 2)<minNumberOfValuesPerBin, :) = nan;
    
    DOWN_BL_Spikes = spikes(prePoleRegionDOWN);
    DOWN_BL_Spikes(makeTheseNansPrePoleDOWN) = nan;
    DOWN_BL_Spikes(sum(~isnan(DOWN_BL_Spikes), 2)<minNumberOfValuesPerBin, :) = nan;
    
    %%
    [SPout] = SPmaker(SPout);
    y = nanmean(UPSpikes, 2);
    y = nansmooth(y, smoothBy);
    plot(plotRange, multPLotBy*y, 'k-');
    hold on ;
    axis tight
    xlim([plotRange(1), plotRange(end)])
    UP_BL_Spikes2 = nansmooth(nanmean(UP_BL_Spikes, 2), smoothBy);
    std1 =stdThresh.*( nanstd( UP_BL_Spikes2(:) ));
    plot([xlim;xlim]', multPLotBy*(nanmean(UP_BL_Spikes(:))+[std1, std1; -std1, -std1]'), '--g');
    highlightInds1 = [];
    segsExcite = [];
    try
        [~, matOut] = findInARowFINAL(y>(nanmean(UP_BL_Spikes(:))+std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        segsExcite = matOut;
        [highlightInds1] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds1),multPLotBy* y(highlightInds1), 'b.');
    catch
    end
    highlightInds2 = [];
    try
        [~, matOut] = findInARowFINAL(y<(nanmean(UP_BL_Spikes(:))-std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        segsExcite = [segsExcite;matOut];
        [highlightInds2] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds2), multPLotBy*y(highlightInds2), 'r.');
    catch
    end
    if multPLotBy*nanmean(UPSpikes(:))<=removeSpikesInSignalLessThan || multPLotBy*nanmean(UP_BL_Spikes(:))<=0
        set(gca,'Color',[.5 .5 .5])
    end
    title(sprintf('BL %0.2f SIG %0.2f', multPLotBy*nanmean(UP_BL_Spikes(:)), multPLotBy*nanmean(UPSpikes(:))))
    %%
    pole{cellStep}.up.BL = UP_BL_Spikes;
    pole{cellStep}.up.SIG = UPSpikes;
    pole{cellStep}.up.plotRange = plotRange;
    pole{cellStep}.up.sigEcite = highlightInds1;
    pole{cellStep}.up.sigInhibit = highlightInds2;
    pole{cellStep}.up.isTooLowSPK = multPLotBy*nanmean(UPSpikes(:))<=removeSpikesInSignalLessThan|| multPLotBy*nanmean(UP_BL_Spikes(:))<=0;
    %% plot based poisson CI this is not good because any CI are bad in this situation
    %     [lambdahat, lambdaci] = poissfit(UP_BL_Spikes(~isnan(UP_BL_Spikes)), alpha1);
    %     plot(multPLotBy.*[xlim;xlim]', multPLotBy.*[lambdaci, lambdaci]', 'r-')
    %% boot the straps
    %     UP_BL_Spikes = UP_BL_Spikes(:, ~isnan(nanmean(UP_BL_Spikes, 1)));%remove all completely naned out BL regions
    %     booty =sort(nanmean(UP_BL_Spikes( reshape(randsample(numel(UP_BL_Spikes), ...
    %         size(UP_BL_Spikes, 2).*numOfBootsToStrap, true), [], numOfBootsToStrap))));
    %     bootLims(1) = booty(ceil((1-alpha1)*length(booty))+1);
    %     bootLims(2) = booty(floor(alpha1*length(booty))-1);
    %     plot([xlim;xlim]', multPLotBy*([bootLims(1), bootLims(1); bootLims(2), bootLims(2)]'), '--b');
    %
    %%
    
    [SPout2] = SPmaker(SPout2);
    y = nanmean(DOWNSpikes, 2);
    y = nansmooth(y, smoothBy);
    
    plot(plotRange, multPLotBy*y , 'k-');
    hold on ;
    axis tight
    xlim([plotRange(1), plotRange(end)])
    DOWN_BL_Spikes2 = nansmooth(nanmean(DOWN_BL_Spikes, 2), smoothBy);
    std1 =stdThresh.*( nanstd( DOWN_BL_Spikes2(:) ));
    plot([xlim;xlim]', multPLotBy*(nanmean(DOWN_BL_Spikes(:))+[std1, std1; -std1, -std1]'), '--g');
    highlightInds1 = [];
    try
        [~, matOut] = findInARowFINAL(y>(nanmean(DOWN_BL_Spikes(:))+std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        
        [highlightInds1] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds1),multPLotBy* y(highlightInds1), 'b.');
    catch
    end
    highlightInds2 = [];
    try
        [~, matOut] = findInARowFINAL(y<(nanmean(DOWN_BL_Spikes(:))-std1));
        matOut =  matOut(matOut(:, end)>=numInARow, :);
        [highlightInds2] = colonMulti(matOut(:, 3), matOut(:, 4));
        plot(plotRange(highlightInds2), multPLotBy*y(highlightInds2), 'r.');
    catch
    end
    %%
    if multPLotBy*nanmean(DOWNSpikes(:))<=removeSpikesInSignalLessThan || multPLotBy*nanmean(DOWN_BL_Spikes(:))<=0
        set(gca,'Color',[.5 .5 .5])
    end
    title(sprintf('BL %0.2f SIG %0.2f', multPLotBy*nanmean(DOWN_BL_Spikes(:)), multPLotBy*nanmean(DOWNSpikes(:))))
    %%
    pole{cellStep}.down.BL = DOWN_BL_Spikes;
    pole{cellStep}.down.SIG = DOWNSpikes;
    pole{cellStep}.down.plotRange = plotRange;
    pole{cellStep}.down.sigEcite = highlightInds1;
    pole{cellStep}.down.sigInhibit = highlightInds2;
    pole{cellStep}.down.isTooLowSPK = multPLotBy*nanmean(DOWNSpikes(:))<=removeSpikesInSignalLessThan|| multPLotBy*nanmean(DOWN_BL_Spikes(:))<=0;
    %% plot based poisson CI this is not good because any CI are bad in this situation
    %     [lambdahat, lambdaci] = poissfit(DOWN_BL_Spikes(~isnan(DOWN_BL_Spikes)), alpha1);
    %     plot(multPLotBy.*[xlim;xlim]', multPLotBy.*[lambdaci, lambdaci]', 'r-')
    
    %% boot the straps
    %     DOWN_BL_Spikes = DOWN_BL_Spikes(:, ~isnan(nanmean(DOWN_BL_Spikes, 1)));%remove all completely naned out BL regions
    %     booty =sort(nanmean(DOWN_BL_Spikes( reshape(randsample(numel(DOWN_BL_Spikes), ...
    %         size(DOWN_BL_Spikes, 2).*numOfBootsToStrap, true), [], numOfBootsToStrap))));
    %     bootLims(1) = booty(ceil((1-alpha1)*length(booty))+1);
    %     bootLims(2) = booty(floor(alpha1*length(booty))-1);
    %     plot([xlim;xlim]', multPLotBy*([bootLims(1), bootLims(1); bootLims(2), bootLims(2)]'), '--b');
    
    %%
    % % % % % % % % % % % % % % % % %     [~, sizeCI1] = philsCIs(UP_BL_Spikes(:) ,CI_Alpha, size(UP_BL_Spikes, 2));
    % % % % % % % % % % % % % % % % %     plot([xlim;xlim]', 1000*(nanmean(UP_BL_Spikes(:))+[sizeCI1, sizeCI1; -sizeCI1, -sizeCI1]'), '--b');
    % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % %     [~, sizeCI2] = philsCIs(UP_BL_Spikes(:) ,CI_Alpha, size(UP_BL_Spikes, 2));
    % % % % % % % % % % % % % % % % %     plot([xlim;xlim]', 1000*(nanmean(DOWN_BL_Spikes(:))+[sizeCI2, sizeCI2; -sizeCI2, -sizeCI2]'), '--r');
    % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % %     tmp1 =     y1>((nanmean(UP_BL_Spikes(:))+sizeCI1)*1000) |  y1<((nanmean(UP_BL_Spikes(:))-sizeCI1)*1000);
    % % % % % % % % % % % % % % % % %     plot(plotRange(tmp1), -ones(sum(tmp1), 1), '.b')
    % % % % % % % % % % % % % % % % %     tmp2 =     y2>((nanmean(DOWN_BL_Spikes(:))+sizeCI2)*1000) |  y2<((nanmean(DOWN_BL_Spikes(:))-sizeCI2)*1000);
    % % % % % % % % % % % % % % % % %     plot(plotRange(tmp2), -ones(sum(tmp2), 2), '.r')
    
    
    %     keyboard
end

%%



% sdf(gcf, 'default18')
% fullscreen
%%

if saveOn
    fullscreen(SPout.mainFig)
    fn = ['poleUPresponse_', dateString1];
    saveFigAllTypes(fn, SPout.mainFig, saveDir, 'poleSTD.m');
    fullscreen(SPout2.mainFig)
    fn = ['poleDOWNresponse_', dateString1];
    saveFigAllTypes(fn, SPout2.mainFig, saveDir, 'poleSTD.m');
end


% % 
% % 
% % %% save figures
% % 
% % 
% % fullscreen(SPout.mainFig)
% % saveas(SPout.mainFig, ['UP',saveName,  dateString1, '.svg'])
% % %    close(SPout.mainFig)
% % fullscreen(SPout2.mainFig)
% % saveas(SPout2.mainFig, ['DOWN',saveName, dateString1,  '.svg'])
% % %    close(SPout2.mainFig)
% % save([saveName, dateString1], saveName)
% % cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
% % % revivescript(funcString)
% % 
% % 
% % %%
% % 
% % % %{
% % saveName = 'pole_minSpkPerSecThreshold_STD'
% % dateString1 = datestr(now,'yymmdd_HHMM');
% % cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
% % eval([saveName,    '= hibernatescript(''poleSTD.m'');'    ])
% % cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\POLE')
% % fullscreen(SPout.mainFig)
% % SPout.mainFig.Name = eval(saveName);
% % fig2svg(['UP',saveName,  dateString1, '.svg'], SPout.mainFig)
% % %    close(SPout.mainFig)
% % fullscreen(SPout2.mainFig)
% % fig2svg(['DOWN',saveName,  dateString1, '.svg'], SPout2.mainFig)
% % SPout.mainFig.Name = eval(saveName);
% % %    close(SPout2.mainFig)
% % save([saveName, dateString1], saveName)
% % cd('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures')
% % % revivescript(funcString)
% % 
% % 
% % %}
