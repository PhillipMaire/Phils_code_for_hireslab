function [allMods2] = BS_modulaion_continious_variables(numIterations,spikes, binIndex, permMat)
%{
numIterations, number of bootstrap iterations
spikes, LINEARIZED spikes 
binIndex, Actual real bin index 

%}
INbins = unique(binIndex);
%  [permMat] = randPermMat(numel(spikes), numIterations);
Means = nan(numIterations , length(INbins));
bin2 = binIndex(permMat);
binnedSpikes = cell(length(INbins), 1);
tic
for k = 1:length(INbins)
    [i, ~] = find(bin2 == INbins(k));
    binnedSpikes{k} = reshape(spikes(i), [], numIterations);
    Means(:, k)  = nanmean(binnedSpikes{k});
end
toc
Means = Means';
allMods2 = (nanmax(Means) - nanmin(Means))./(nanmax(Means)+nanmin(Means));