Stime = {};
Strial = {};
TT = {};
trialLines = {};
Y2 = {};
hasAtLeastOneTrial = {};
for k = 1:length(U)
C = U{k} ;
TT{k} = getTrialTypes(C);

[ind1, ~]= find([TT{k}.hit; TT{k}.corrRej; TT{k}.falseAlarm; TT{k}.miss]');
hasAtLeastOneTrial{k} = (nansum([TT{k}.hit; TT{k}.corrRej; TT{k}.falseAlarm; TT{k}.miss]'));


tmp1 = cumsum(hasAtLeastOneTrial{k});

trialLines{k} = [[1, tmp1(1:end-1)]; [tmp1(2:end), length(ind1)]];
Y = squeeze(C.R_ntk);
Y2{k} = Y(:, ind1);
[Stime{k}, Strial{k}] = find(reshape(Y2{k}, [ C.t,length(ind1)]));
end
%%
smoothBy = 50;

crush
spout = SPmaker(2, 2);
theseCells  = 1:length(U);
spout2 = SPmaker(2, 2);
for k = theseCells
spout= SPmaker(spout);
plot(Stime{k}, Strial{k}, 'k.')
hold on
h = plot(zeros(size(trialLines{k})), trialLines{k});
title(k)
set(h, {'color'}, {[0 0 1]; [1 0 0]; [0 1 0]; [0 0 0]})
% be explicit wth the colot order [0 0 1]; [1 0 0]; [0 1 0]; [0 0 0] is b r g k





spout2= SPmaker(spout2);
C = U{k} ;
tmp1 = zeros(C.t, C.k);
tmp1(sub2ind(size(tmp1), Stime{k}, Strial{k})) = 1;
psth2plot = [...
smooth(1000*nanmean(tmp1(:, trialLines{k}(1):trialLines{k}(2)), 2), smoothBy)...
smooth(1000*nanmean(tmp1(:, trialLines{k}(3):trialLines{k}(4)), 2), smoothBy)...
smooth(1000*nanmean(tmp1(:, trialLines{k}(5):trialLines{k}(6)), 2), smoothBy)...
smooth(1000*nanmean(tmp1(:, trialLines{k}(7):trialLines{k}(8)), 2), smoothBy)...
];

hold on
h = plot(psth2plot);
title(k)
set(h, {'color'}, {[0 0 1]; [1 0 0]; [0 1 0]; [0 0 0]})
% be explicit wth the colot order [0 0 1]; [1 0 0]; [0 1 0]; [0 0 0] is b r g k


% keyboard
end
% fullscreen([], 1, 'all')
%%
% % %%
% % figure; plot(Stime,Strial , '.')
% % figure; plot(smooth(mean(Y, 2).*1000, 20))
% % 
% % 
% % 
% % 
% % %%
% % crush
% % x = 1:3;
% % y = [1 2 3; 42 40 34];
% % h = plot(x,y);
% % set(h, {'color'}, {[0.5 0.5 0.5]; [1 0 0]});
