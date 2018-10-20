%%

hold on 
phaseVar = squeeze(U{cellStep}.S_ctk(5, :, :));
ampVar =squeeze(U{cellStep}.S_ctk(3, :, :));
thetaVar =      squeeze(U{cellStep}.S_ctk(1, :, :));
eval(['phaseVar = nanmean(shiftToZero( phaseVar .* U{cellStep}.filters.filters.', mainFilterName, '),2);']);
eval(['ampVar = nanmean(shiftToZero( ampVar .* U{cellStep}.filters.filters.', mainFilterName, '),2);']);
eval(['thetaVar = nanmean(shiftToZero( thetaVar .* U{cellStep}.filters.filters.', mainFilterName, '),2);']);
%%
thetaVar = abs(min(thetaVar)) + thetaVar;
thetaVar = thetaVar - min(thetaVar);
thetaVar = 9.*thetaVar ./ (max(thetaVar));
thetaVar = thetaVar+.5;
thetaVar = smooth(thetaVar ,SMOOTHfactor);
% thetaVar = [nan(addToBeginningOfPlot,1); thetaVar ];
% figure;
% plot((phaseVar(:,:),2))
% hold on
% plot((ampVar(:,:),2))
plot(thetaVar, 'g-');
xlimVar = 130;
xlim([-20 xlimVar]);
xticks(-20:20:xlimVar);
grid;
%%
