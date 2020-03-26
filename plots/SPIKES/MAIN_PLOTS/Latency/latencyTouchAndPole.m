%% preloaded structs from

% signifTestWithCurvSortingPole2ONSET_LAT.m
latencyStructPole

% signifTestWithCurvSortingONSET_LAT.m
latencyStructTouch

% WHISKING ONSET  whiskingOnsetResponse.m
%C:\Users\maire\Dropbox\HIRES_LAB\GitHub\Phils_code_for_hireslab\plots\SPIKES\MAIN_PLOTS\whiskingOnsetResponse
latencyStructW_ONSET
W_ONSETStruct
%%
plotData = [];
varOfInterest = latencyStructPole;
for k = 1: 2
    lat = varOfInterest.latency;
 
    lat = lat(:,:,k);
    tf = cellfun('isempty',lat) ;
    lat(tf) = {nan}   ;
    lat = cell2mat(lat(:));
    
    
    Cind = varOfInterest.cellIndexForUarray;
    Cind = Cind(:,:,k);
    tf = cellfun('isempty',Cind) ;
    Cind(tf) = {nan}   ;
    Cind = cell2mat(Cind(:));
    
    for cellStep = 1:length(U)
        cellTMP = U{cellStep};
        depth = cellTMP.details.depth;
        indexToLatencyArray = find(Cind == cellStep);
        if isempty(indexToLatencyArray) % doesnt have a latency
            plotData(cellStep, 1, k) = nan;
            plotData(cellStep, 2, k) = depth;
        else
            plotData(cellStep, 1, k) = lat(indexToLatencyArray);
            plotData(cellStep, 2, k) = depth;
        end
        
    end
    
    
end
%%
plotData2 = plotData;

% % poleUpLatencyUP = 20
% % poleUpLatencDown = 4
% % 
% % 
% % plotData2(:,1,1) =plotData2(:,1,1) - poleUpLatencyUP;
% % 
% % plotData2(:,1,2) =plotData2(:,1,2) - poleUpLatencDown;
%%



plotData2(isnan(plotData)) =0;

figure
plot(plotData2(:,1, 1),plotData2(:,2, 1)*-1, 'Ob')

%%



hold on
plot(plotData2(:,1, 2),plotData2(:,2, 2)*-1, 'Or')


% plotData3 = nanmin(plotData, [], 3);
% plotData3(isnan(plotData3)) =0;
% 
% 
% tmp = plot(plotData3(:,1),plotData3(:,2).*-1, '*g');
% 
% tmp.MarkerSize = 2
tmp = xlim;
xlim([-5 tmp(2)])

%% touch
maxLatVal = 60;

plotData3 = nanmin(plotData, [], 3);
plotData3(isnan(plotData3)) =0;
plotData3(plotData3(:,1)>maxLatVal) = 0
figure
plot(plotData3(:,1),plotData3(:,2).*-1, 'Ob')
tmp = xlim;
xlim([-10 tmp(2)])
%% pole
hold on 
plotData3 = nanmin(plotData, [], 3);
plotData3(isnan(plotData3)) =0;
plotData3(plotData3(:,1)>maxLatVal) = 0

plot(plotData3(:,1),plotData3(:,2).*-1, 'Or')
tmp = xlim;
xlim([-10 tmp(2)])


%%


xlim([-1 60])

















