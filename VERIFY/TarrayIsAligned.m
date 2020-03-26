%%
crush
pinDecTime = [];
motorPos = [];
vidBar = [];
for k = 1:length(T.trials)
motorPos(k) = T.trials{k}.behavTrial.motorPosition;

pinDecTime(k) = T.trials{k}.behavTrial.pinAscentOnsetTime;
if ~isempty(T.trials{k}.whiskerTrial)
tmp1 = T.trials{k}.whiskerTrial.barPos;
vidBar(k, 1:2) = tmp1(1, 2:3);
else
    vidBar(k, 1:2) = [nan, nan];
end
end
%
polePos2 = (vidBar(:,1)-nanmin(vidBar(:,1))) ./ max((vidBar(:,1)-nanmin(vidBar(:,1))));
vidXbar2 = (motorPos-nanmin(motorPos)) ./ max((motorPos-nanmin(motorPos)));

figure;scatter(vidXbar2(:), polePos2(:))



%% plot poles and find outliers 
figure;
% scatter(polePos2, vidXbar2, 'k.');
[outliers1 inds1 ]= sort((vidXbar2(:)-polePos2(:)));
hist(outliers1, 100)
%%
TF = isoutlier(outliers1, 'ThresholdFactor', 5);
figure
hold on 

scatter(polePos2(TF), vidXbar2(TF), 'ro');
scatter(polePos2(~TF), vidXbar2(~TF), 'go')
%%
% now get the correct trials for 
trialNums_TMP = numBehavTrials(trialNums_TMP);
trialNums_TMP = trialNums_TMP(c1);

% and bars
vidNumNames = allBarNameNums(b1);
%% remove outliers if you want (after getting the correct trials) 
vidNumNames = vidNumNames(~TF) ;% remove ouliers
trialNums_TMP = trialNums_TMP(~TF) ;% remove ouliers
%%

T.trials{255}