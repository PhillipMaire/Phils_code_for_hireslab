%%
% load('Z:\Users\Phil\Data\Characterization\S2BadContacts2\U_181027_2358.mat')
%%
cellStep = 6
C = U{cellStep} ;
[trialTypes, trialTypeNames] = UtrialType(U);
%% spike raster
%{
Y = squeeze(C.R_ntk);
[Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
figure; plot(Stime,Strial , '.')
figure; plot(smooth(mean(Y, 2), 20))
%}
% DM2 = struct;
% DM2.x = [];
% DM2.y = squeeze(C.R_ntk);DM2.y =DM2.y(:);
% DM2.timePoints = [];
% DM2.label = {};
% DM2.numInEachLabel = [];
% 
% DM2.x = (squeeze(C.S_ctk(1, :, :)));
%%
%   Columns 1 through 7
%     {'thetaAtBase'}    {'velocity'}    {'amplitude'}    {'setpoint'}    {'phase'}    {'deltaKappa'}    {'M0Adj'}
%   Columns 8 through 12
%     {'FaxialAdj'}    {'firstTouchOnset'}    {'firstTouchOffset'}    {'firstTouchAll'}    {'lateTouchOnset'}
%   Columns 13 through 16
%     {'lateTouchOffset'}    {'lateTouchAll'}    {'PoleAvailable'}    {'beamBreakTimes'}
allVars = reshape(permute(C.S_ctk, [2, 3, 1]), C.t*C.k, 16);
tmp1 = isnan(allVars);
tmp1(:, [1:8, 15]) = 0;
allVars(tmp1) = 0;
%%
trim2Xtrials = 150;
%%
binSize = 20;
y = squeeze(C.R_ntk);
y = y(:);
y = y(1:C.t.*trim2Xtrials);
Y2 = (sum(reshape(y(:), binSize, []), 1))';

allVars = allVars(1:C.t.*trim2Xtrials, :);
allVarsShaped  = reshape(allVars, binSize, [], size(allVars,2));
DM2 = [];
DM2 = [DM2, squeeze(nanmean(allVarsShaped(:,:,  1:8), 1))];
DM2 = [DM2, squeeze(nansum(allVarsShaped(:,:,  [9:10, 12:13, 16]), 1))];

%%
shifts = [-1 0 1];
DM3 = [] ;
for kk = 1:size(DM2, 2)
    sig = DM2(:, kk);
    for k = 1:length(shifts)
        tmp1 = circshiftNAN(sig, shifts(k));
        DM3  = [DM3 , tmp1(:)];
    end
end
%%

% DM3 = DM3([1:]
DM3 = meanNorm(DM3, 'dm');
%% select the time period of the session you want to model
range1 =  1:4000;
range1 = unique(ceil(range1./binSize));


%% splitData


C.k = trim2Xtrials;

perc2model = .7;
tomodel = randsample(C.k, round(C.k.*perc2model));
toTest = setdiff(1:C.k , tomodel);

Xreshaped = reshape(DM3, C.t./binSize, C.k, size(DM3, 2));
Xreshaped = Xreshaped(range1, :, :);
X2model = reshape(Xreshaped(:, tomodel, :), [], size(DM3, 2));
X2test = reshape(Xreshaped(:, toTest, :), [], size(DM3, 2));
% X2model = meanNorm(X2model, 'dm');
% x2test = meanNorm(X2test, 'dm');

Yreshaped = reshape(Y2, [], C.k);
Yreshaped = Yreshaped(range1, :, :);
Y2model = Yreshaped(:, tomodel);
Y2test = Yreshaped(:, toTest);
% Y2test = meanNorm(Y2test);
%% remove all nans

[X2model, Y2model, XY2model_inds] = nanRemove(X2model, Y2model);
[X2test, ~, XY2test_inds] = nanRemove(X2test, Y2test);
%%
toPlot = X2model(1:C.t./binSize, :);
figure;imagesc(toPlot )

%%

tic
cv_mod5 = cvglmnet(X2model, Y2model, 'poisson');
timeItTook = toc
pBullet = Pushbullet('o.LLzZkkdcd6WN8MG5HyQjFDsCCSmRBAzw')
pBullet.pushNote([],'model',['finished in ', num2str(timeItTook), ' sec'])

%%

% close all
modLocation = find(cv_mod5.lambda ==cv_mod5.lambda_1se);
betas = cv_mod5.glmnet_fit.beta(:,  modLocation);
predictions = exp([X2test]*betas);
[predictions] = replaceNANs(predictions, XY2test_inds.nanRows, XY2test_inds.keepRows);

predictions2 = exp(cvglmnetPredict(cv_mod5, [X2test], cv_mod5.lambda_1se));
[predictions2] = replaceNANs(predictions2, XY2test_inds.nanRows, XY2test_inds.keepRows);

predictions3 = exp(cvglmnetPredict(cv_mod5, [X2test], cv_mod5.lambda(end)));
[predictions3] = replaceNANs(predictions3, XY2test_inds.nanRows, XY2test_inds.keepRows);

% see how well the mean response fits the actual PSTH

figure;hold on; plot(smooth(nanmean(Y2test, 2), 1))
% tmp9 = poissrnd(reshape(predictions,size(Y2test) ));
% plot(nanmean(tmp9, 2))
% tmp9 = poissrnd(reshape(predictions2,size(Y2test) ));
% plot(nanmean(tmp9, 2))
plot(nanmean(reshape(predictions2, size(Y2test)), 2))
plot(nanmean(reshape(predictions, size(Y2test)), 2))
% plot(nanmean(reshape(predictions3, size(Y2test)), 2))
% ylim([0, 2])
%%
cv_mod5.glmnet_fit.dev(modLocation)
%%
crush
tmp1 = reshape(predictions2, size(Y2test));
figure;imagesc(meanNorm(tmp1'));
% tmp1 = reshape(predictions3, size(Y2test));
% figure;imagesc(meanNorm(tmp1'));
toPlot = reshape(smooth(Y2test, 3), size(Y2test));
figure;imagesc(toPlot');
%%
[spky, spkx] = find(Y2test')
figure;plot(spkx, spky, '.')
tmp9 = poissrnd(reshape(predictions2,size(Y2test) ));
[spky, spkx] = find(tmp9')
figure;plot(spkx, spky, '.')
%%

numberInEachCategory =numInEachLabel;
labelInEachCategory = label;
timePoints = timePoints;
plotBetas(betas, numberInEachCategory, labelInEachCategory, timePoints)
%% plot trial by trial comparison
tmp9 = (reshape(predictions2,size(Y2test) ));
close all
randSamp = randsample(size(tmp9, 2), size(tmp9, 2));
figure;
smoothBy = 20;
for k = 1:C.k
    plot(smooth(Yreshaped(:, randSamp(k)), smoothBy))
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
CVpred = cvglmnetPredict(cv_mod5, X3);
test1 = exp(CVpred);
%%
tic
options.alpha = cv_mod5.lambda_1se;
mod2 = glmnet(X3, Y3, 'poisson', options)
toc
%%
Y3hat = glmnetPredict(mod2, X3, cv_mod5.lambda_1se, 'response');
Y3hat = reshape(Y3hat, [], C.k);
figure;imagesc(Y3hat')
r = poissrnd(Y3hat);
figure;imagesc(r')

figure;plot(mean(r'))
%%


%% plost PSTH
figure;plot( mean(Yreshaped, 2))
hold on
plot(mean(r, 2))


%% plot trial by trial comparison

close all
randSamp = randsample(C.k, C.k);
figure;
smoothBy = 20;
for k = 1:C.k
    plot(smooth(Yreshaped(:, randSamp(k)), smoothBy))
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