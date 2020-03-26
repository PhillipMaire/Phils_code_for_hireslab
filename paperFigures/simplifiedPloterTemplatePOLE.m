%% only plot 'good' touches based on curature. can look at jsut high curve touches too.
crush
% dateString1 = datestr(now,'yymmdd_HHMM');
plotRange = -49:100;
binSize = 5;
prePoleBL = -50:-1;

getOnlyFirstTouch = false;
touchType = 'onset'; % onset offset all
allCellsTouch = {};
[SPout] = SPmaker(5, 9);
[SPout2] = SPmaker(5, 9);

smoothBy = 5;
%% times for masks
touch_M = 0:100;
P_UP_M = [];
P_down_M = [];
amp = [] ;
WhiskOnset = 0:200;
%% make sure whisking onset is in the U array
load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\OnsetsALL_CELLS_190917.mat')
% edit AllWhiskingOnsetTimes
for k = 1:length(U)
    U{k}.whiskOnset = OnsetsALL_CELLS{k};
end
%% mask names
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:5)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}, {WhiskOnset}]
maskyExtraSettings = [{''} {''} {''} {''} {''}];
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
    poleOffset = C.meta.poleOffset(C.meta.poleOffset<=C.t);
    [poleUPextract, poleUP_makeTheseNans] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), plotRange, C.t);
    [poleDOWNextract, poleDOWN_makeTheseNans] = getTimeAroundTimePoints(poleOffset+(0:C.t: (length(poleOffset)-1).*C.t), plotRange, C.t);
    
    
    
    [prePoleRegionUP, makeTheseNansPrePoleUP] = getTimeAroundTimePoints(C.meta.poleOnset+(0:C.t: (C.k-1).*C.t), prePoleBL, C.t);
    [prePoleRegionDOWN, makeTheseNansPrePoleDOWN] = getTimeAroundTimePoints(poleOffset+(0:C.t: (length(poleOffset)-1).*C.t), prePoleBL, C.t);
    
    %% get spikes and apply the mask
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    %% get the times of interest
    UPSpikes = spikes(poleUPextract);
    UPSpikes(poleUP_makeTheseNans) = nan;
    DOWNSpikes = spikes(poleDOWNextract);
    DOWNSpikes(poleDOWN_makeTheseNans) = nan;
    
    
    
    UP_BL_Spikes = spikes(prePoleRegionUP);
    UP_BL_Spikes(makeTheseNansPrePoleUP) = nan;
    DOWN_BL_Spikes = spikes(prePoleRegionDOWN);
    DOWN_BL_Spikes(makeTheseNansPrePoleDOWN) = nan;
    %% only protraction touches or retraction touches
    %     touchSpikes = touchSpikes(:, protractionTouches);
    % % %     %%
    % % %     allCellsTouch{cellStep}.protractionTouches = protractionTouches;
    % % %     allCellsTouch{cellStep}.touchSpikes = UPSpikes;
    % % %     allCellsTouch{cellStep}.segments = segments;
    % % %     allCellsTouch{cellStep}.poleUP_linInds = poleUP_linInds;
    % % %     allCellsTouch{cellStep}.poleDOWN_linInds = poleDOWN_linInds;
    % % %     allCellsTouch{cellStep}.t = C.t;
    % % %     allCellsTouch{cellStep}.k = C.k;
    %%
%     %      keyboard
%     [SPout2] = SPmaker(SPout2);
%     tmp1 = reshape(UPSpikes', size(UPSpikes, 2)*binSize, size(UPSpikes,1)/binSize);
%     
%     y1_a = 1000*nanmean(tmp1, 1);
%     plotRange2 = nanmean(reshape(plotRange(:), binSize, []));
%     bar(plotRange2, y1_a, 'b');
%     
%     hold on ;
%     
%     tmp1 = reshape(DOWNSpikes', size(DOWNSpikes, 2)*binSize, size(DOWNSpikes,1)/binSize);
%     y2_b = 1000*nanmean(tmp1, 1);
%     bar(plotRange2,y2_b , 'r');
%     axis tight
%     
%     %%
%     
%     
%     [~, sizeCI1] = philsCIs(nanmean(UP_BL_Spikes) ,CI_Alpha, size(UP_BL_Spikes, 2));
%     plot([xlim;xlim]', 1000*(nanmean(UP_BL_Spikes(:))+[sizeCI1, sizeCI1; -sizeCI1, -sizeCI1]'), '--b');
%     
%     [~, sizeCI2] = philsCIs(nanmean(DOWN_BL_Spikes) ,CI_Alpha, size(DOWN_BL_Spikes, 2));
%     plot([xlim;xlim]', 1000*(nanmean(DOWN_BL_Spikes(:))+[sizeCI2, sizeCI2; -sizeCI2, -sizeCI2]'), '--r');
    %%
%     tmp1 =     y1>((nanmean(UP_BL_Spikes(:))+sizeCI1)*1000) |  y1<((nanmean(UP_BL_Spikes(:))-sizeCI1)*1000);
%     plot(plotRange(tmp1), -ones(sum(tmp1), 1), '.b')
%     tmp2 =     y2>((nanmean(DOWN_BL_Spikes(:))+sizeCI2)*1000) |  y2<((nanmean(DOWN_BL_Spikes(:))-sizeCI2)*1000);
%     plot(plotRange(tmp2), -ones(sum(tmp2), 2), '.r')
    
    
    
    %%
    
    
    
    
    
    
    [SPout] = SPmaker(SPout);
    y = 1000*nanmean(UPSpikes, 2);
    y1 = smooth(y, smoothBy);
    plot(plotRange, y1, 'b-');
    hold on ;
    y = 1000*nanmean(DOWNSpikes, 2);
    y2 = smooth(y, smoothBy);
    plot(plotRange,y2 , 'r-');
    axis tight
    %%
    [~, sizeCI1] = philsCIs(UP_BL_Spikes(:) ,CI_Alpha, size(UP_BL_Spikes, 2));
    plot([xlim;xlim]', 1000*(nanmean(UP_BL_Spikes(:))+[sizeCI1, sizeCI1; -sizeCI1, -sizeCI1]'), '--b');
    
    [~, sizeCI2] = philsCIs(UP_BL_Spikes(:) ,CI_Alpha, size(UP_BL_Spikes, 2));
    plot([xlim;xlim]', 1000*(nanmean(DOWN_BL_Spikes(:))+[sizeCI2, sizeCI2; -sizeCI2, -sizeCI2]'), '--r');
    
    tmp1 =     y1>((nanmean(UP_BL_Spikes(:))+sizeCI1)*1000) |  y1<((nanmean(UP_BL_Spikes(:))-sizeCI1)*1000);
    plot(plotRange(tmp1), -ones(sum(tmp1), 1), '.b')
    tmp2 =     y2>((nanmean(DOWN_BL_Spikes(:))+sizeCI2)*1000) |  y2<((nanmean(DOWN_BL_Spikes(:))-sizeCI2)*1000);
    plot(plotRange(tmp2), -ones(sum(tmp2), 2), '.r')
    
    
    %     keyboard
end

%%


% keyboard
cd('C:\Users\maire\Downloads\tmpsave')
% sdf(gcf, 'default18')
fullscreen

%    saveas(gcf, ['Pole_UPblue_and95%_CI_', num2str(dateString1),'.svg'])
%    saveas(gcf, [svName, '_', num2str(dateString1),'EqualN.svg'])