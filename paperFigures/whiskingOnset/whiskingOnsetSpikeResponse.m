%% whisking onset plot spike response

load('C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\paperFigures\variablesToLoad\OnsetsALL_CELLS_190917.mat')
%{
limits1 = -1:400;
poleString = 'poleUP';
C = U{1}
[latency1, poleOnsetTriggeredWhiskingLatency] = getPoleTriggeredWhiskingOnsets(C, limits1, poleString)
%}
%% times for masks
touch_M = [0:100];
P_UP_M = 0:400;
P_down_M = 0:400;
amp = [] ;
% mask names
remLowerThan = 20;
varNames = masky;
varNames = varNames(1:4)
rangeOfMask = [{touch_M} {P_UP_M} {P_down_M}, {amp}]
maskyExtraSettings = [{''} {''}  {''} {''}];
 %{
        I plot mask with spikes...
        tmp1 = zeros(C.t, C.k);tmp1(allMask) = 1;spikes = find(squeeze(C.R_ntk));tmp1(spikes) = 2;figure;imagesc(tmp1); colorbar
    %}
%%

plotRange = -50:75;
allOnsetSpikes = {};
for k = 1:length(OnsetsALL_CELLS)
    C = OnsetsALL_CELLS{k};
    onsets = C.linIndsONSETS;
    C = U{k};
     [allMask, maskDetails] = masky(varNames, rangeOfMask, C, remLowerThan, maskyExtraSettings);
    [timeInds, ~, makeTheseNans] = getTimeAroundTimePoints(onsets, plotRange, C.t, 'removenans');
    spikes = squeeze(C.R_ntk);
    spikes(allMask) = nan;
    allOnsetSpikes{k} = spikes(timeInds);
end

[SPout] = SPmaker(5, 9);
for k = 1:length(allOnsetSpikes)
    [SPout] = SPmaker(SPout);
    plot(plotRange, 1000*nanmean(allOnsetSpikes{k}, 2), 'k-');
end
%%

figure;imagescnan(allOnsetSpikes{k});
figure;imagescnan(removeNANs(allOnsetSpikes{k}, 1));