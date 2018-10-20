%% This uses the filter to align to the stimulus 
%% so if your filter starts with pole up then the pole up 
%% signal will what the added and subtracted numbers are based on 


startMeasureSIG = 10; endMeasureSIG = 60; 
startMeasureBASE = -60; endMeasureBASE = -10; 
% TMPselectedResponse = selectedRespTT{k};
for iterFindStart = 1:size(mainFilter,2)
    startStim(iterFindStart) = find(mainFilter(:,iterFindStart)==1,1);
    
    TMPpostResponse(:,iterFindStart) = allSpikes(startStim(iterFindStart)+startMeasureSIG:startStim(iterFindStart)+endMeasureSIG, iterFindStart);
    TMPpreResponse(:,iterFindStart) = allSpikes(startStim(iterFindStart)+startMeasureBASE:startStim(iterFindStart)+endMeasureBASE, iterFindStart);
end
meanBASEforTTest = mean(TMPpreResponse, 1);
meanRESPforTTest = mean(TMPpostResponse, 1);

[h, probOfSigDiff] = ttest(meanBASEforTTest, meanRESPforTTest);


%%

sigMean = mean(meanRESPforTTest);
basMean = mean(meanBASEforTTest);

sigSTD = std(meanRESPforTTest);
basSTD = std(meanBASEforTTest);

nSIG = length(meanRESPforTTest);
nBAS = length(meanBASEforTTest);

weltchesTtest = ...
    (sigMean - basMean)./...
    sqrt((sigSTD)./(nSIG) + (basSTD)./(nBAS))



%%

