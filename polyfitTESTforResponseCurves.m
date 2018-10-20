%%     polyfitTESTforResponseCurves

% %% TESTING AREA
% dataTMPsmooth = smooth(dataTMP, 30);
% S = stepinfo(dataTMPsmooth)
% 
% %%
% hold off
% figure(2);plot(dataToPlotY)
% hold on
%%

polyNum = 4;
dataToPlotY = selectedRespMeanPlotTT{k}';
dataToPlotYnoNans = dataToPlotY(find(~isnan(dataToPlotY)));
dataToPlotX = 1:length(dataToPlotYnoNans);
[p,S,mu] = polyfit(dataToPlotX, dataToPlotYnoNans,polyNum);

% [coeffs,S,mu] = polyfit(dataTMPsmooth',1:length(dataTMPsmooth),polyNum);
[f1, delta] = polyval(p,dataToPlotX, S, mu);
% rSquaredSingle =  corrcoef(whiskerMat4);
% rSquared(isTracedCounter) = rSquaredSingle(3);


dataToPlotY(find(~isnan(dataToPlotY))) = f1; % add nans back on
plot(1:length(dataToPlotY),dataToPlotY,'k--');