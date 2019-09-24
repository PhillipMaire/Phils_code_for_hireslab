%% bin data
crush
binSize = 20;
C.k = 150;
DM.y = DM.y(:);
DM.y = DM.y(1:C.k*C.t);
DM.x = DM.x(1:C.k*C.t, :);





DM.Y3 = (sum(reshape(DM.y(:), binSize, []), 1))';
DM.X3 = squeeze(nanmean(reshape(DM.x, binSize, [], size(DM.x,2)), 1));
% DM.X3 = [ones(size(DM.X3, 1), 1), DM.X3];


%% bin data
binSize = 20;

DM.Y3 = (sum(reshape(DM.y(:), binSize, []), 1))';
DM.X3 = squeeze(nanmean(reshape(DM.x, binSize, [], size(DM.x,2)), 1));
% DM.X3 = [ones(size(DM.X3, 1), 1), DM.X3];
%% trim
smoothBy = 10;
figure;plot(smooth(mean(reshape(DM.y, [], C.k), 2), smoothBy))

%%
DM.X3 = meanNorm(DM.X3, 'dm');
%% select the time period of the session you want to model
range1 =  1:4000;
range1 = unique(ceil(range1./binSize));

%% splitData
perc2model = .7;
DM.tomodel = randsample(C.k, round(C.k.*perc2model));
DM.toTest = setdiff(1:C.k , DM.tomodel);

DM.Xreshaped = reshape(DM.X3, C.t./binSize, C.k, size(DM.X3, 2));
DM.Xreshaped = DM.Xreshaped(range1, :, :);
DM.X2model = reshape(DM.Xreshaped(:, DM.tomodel, :), [], size(DM.X3, 2));
DM.X2test = reshape(DM.Xreshaped(:, DM.toTest, :), [], size(DM.X3, 2));



DM.Yreshaped = reshape(DM.Y3, [], C.k);
DM.Yreshaped = DM.Yreshaped(range1, :, :);
DM.Y2model = DM.Yreshaped(:, DM.tomodel);
DM.Y2test = DM.Yreshaped(:, DM.toTest);
% DM.Y2test = meanNorm(DM.Y2test);
%% remove all nans

[DM.X2model, DM.Y2model, DM.XY2model_inds] = nanRemove(DM.X2model, DM.Y2model);
[DM.X2test, ~, DM.XY2test_inds] = nanRemove(DM.X2test, DM.Y2test);
%%
toPlot = DM.X2model(1:2*C.t./binSize, :);
figure;imagesc(toPlot )

%%

tic
cv_mod4 = cvglmnet(DM.X2model, DM.Y2model, 'poisson');
timeItTook = toc
pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
pBullet.pushNote([],'model',['finished in ', num2str(timeItTook), ' sec'])

%%
% close all
modLocation = find(cv_mod4.lambda ==cv_mod4.lambda_1se);
betas = cv_mod4.glmnet_fit.beta(:,  modLocation);
predictions = exp([DM.X2test]*betas);
[predictions] = replaceNANs(predictions, DM.XY2test_inds.nanRows, DM.XY2test_inds.keepRows);

predictions2 = exp(cvglmnetPredict(cv_mod4, [DM.X2test], cv_mod4.lambda_1se));
[predictions2] = replaceNANs(predictions2, DM.XY2test_inds.nanRows, DM.XY2test_inds.keepRows);

predictions3 = exp(cvglmnetPredict(cv_mod4, [DM.X2test], cv_mod4.lambda(end)));
[predictions3] = replaceNANs(predictions3, DM.XY2test_inds.nanRows, DM.XY2test_inds.keepRows);

% see how well the mean response fits the actual PSTH

figure;hold on; plot(smooth(nanmean(DM.Y2test, 2), 1))
% tmp9 = poissrnd(reshape(predictions,size(DM.Y2test) ));
% plot(nanmean(tmp9, 2))
% tmp9 = poissrnd(reshape(predictions2,size(DM.Y2test) ));
% plot(nanmean(tmp9, 2))
plot(nanmean(reshape(predictions2, size(DM.Y2test)), 2))
plot(nanmean(reshape(predictions, size(DM.Y2test)), 2))
% plot(nanmean(reshape(predictions3, size(DM.Y2test)), 2))
% ylim([0, 2])
%%
cv_mod4.glmnet_fit.dev(modLocation)
cv_mod4.glmnet_fit.dev(end)

%%
crush
tmp1 = reshape(predictions2, size(DM.Y2test));
% find(isoutlier(tmp1(:)))
% tmp1(tmp1>1) = 1;
figure;imagesc(meanNorm(tmp1'));
colorbar
% caxis([min(tmp1(:)), max(tmp1(:))])
% tmp1 = reshape(predictions3, size(DM.Y2test));
% figure;imagesc(meanNorm(tmp1'));
figure;imagesc(DM.Y2test');
%%
[spky, spkx] = find(DM.Y2test')
figure;plot(spkx, spky, '.')
tmp9 = poissrnd(reshape(predictions2,size(DM.Y2test) ));
[spky, spkx] = find(tmp9')
figure;plot(spkx, spky, '.')
%%
figure;imagesc(tmp9')
figure;imagesc(DM.Y2test')

%%

numberInEachCategory =DM.numInEachLabel;
labelInEachCategory = DM.label;
timePoints = DM.timePoints;
plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
%% plot trial by trial comparison
tmp9 = (reshape(predictions2,size(DM.Y2test) ));
close all
randSamp = randsample(size(tmp9, 2), size(tmp9, 2));
figure;
smoothBy = 20;
for k = 1:C.k
    plot(smooth(DM.Yreshaped(:, randSamp(k)), smoothBy))
    hold on
    plot(smooth(tmp9(:, randSamp(k)), smoothBy))
    ylim([0, 2])
    hold off
    waitForEnterPress
end



%%

% mod4 = glmnet(X2model, Y2model(:), 'poisson');

%%
glmnetPlot(mod4)
%%
% whats the problem?
% When I multipley the weights by the DM, i get a similar in shape but dissimilar in magnitude of
% the average response over all trials. interestingly the cvglmnetpredict function matches the
% actual data.




%%
CVpred = cvglmnetPredict(cv_mod4, DM.X3);
test1 = exp(CVpred);
%%
tic
options.alpha = cv_mod4.lambda_1se;
mod2 = glmnet(DM.X3, DM.Y3, 'poisson', options)
toc
%%
Y3hat = glmnetPredict(mod2, DM.X3, cv_mod4.lambda_1se, 'response');
Y3hat = reshape(Y3hat, [], C.k);
figure;imagesc(Y3hat')
r = poissrnd(Y3hat);
figure;imagesc(r')

figure;plot(mean(r'))
%%


%% plost PSTH
figure;plot( mean(DM.Yreshaped, 2))
hold on
plot(mean(r, 2))


%% plot trial by trial comparison

close all
randSamp = randsample(C.k, C.k);
figure;
smoothBy = 20;
for k = 1:C.k
    plot(smooth(DM.Yreshaped(:, randSamp(k)), smoothBy))
    hold on
    plot(smooth(r(:, randSamp(k)), smoothBy))
    ylim([0, 2])
    hold off
    waitForEnterPress
end
%%

bumpsOffset = 0;
allBumps = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps, bumpsOffset)
sig = P_on;
[convolvedMAT_all] = convolveSigWithBumps(allBumps, sig);