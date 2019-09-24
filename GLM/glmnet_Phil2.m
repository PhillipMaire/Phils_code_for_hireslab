

%% bin data 
binSize = 10;
Y3 = (sum(reshape(Y2, binSize, []), 1))';
X3 = squeeze(mean(reshape(X, binSize, [], size(X,2)), 1));
%% trim 
smoothBy = 10;
figure;plot(smooth(mean(reshape(Y2, [], C.k), 2), smoothBy))


%%
range1 =  1:4000;
range1 = unique(ceil(range1./binSize));

%% splitData
tomodel = randsample(C.k, round(C.k.*.7));
toTest = setdiff(1:C.k , tomodel);

Xreshaped = reshape(X3, C.t./binSize, C.k, size(X3, 2));
Xreshaped = Xreshaped(range1, :, :);
X2model = reshape(Xreshaped(:, tomodel, :), [], size(X3, 2));
x2test = reshape(Xreshaped(:, toTest, :), [], size(X3, 2));
% X2model = meanNorm(X2model, 'dm');
% x2test = meanNorm(x2test, 'dm');


Yreshaped = reshape(Y3, [], C.k);
Yreshaped = Yreshaped(range1, :, :);
y2model = Yreshaped(:, tomodel);
y2test = Yreshaped(:, toTest);
% y2test = meanNorm(y2test);
%%
tic
cv_mod4 = cvglmnet([ones(size(X2model, 1) , 1), X2model], y2model(:), 'poisson');
toc

%%
% close all
betas = cv_mod4.glmnet_fit.beta(:,  find(cv_mod4.lambda ==cv_mod4.lambda_1se));
predictions = exp([ones(size(x2test, 1) , 1),x2test]*betas);
predictions2 = exp(cvglmnetPredict(cv_mod4, [ones(size(x2test, 1) , 1),x2test], cv_mod4.lambda_1se));
predictions3 = exp(cvglmnetPredict(cv_mod4, [ones(size(x2test, 1) , 1),x2test], cv_mod4.lambda(end)));
% see how well the mean response fits the actual PSTH 

figure;hold on; plot(smooth(mean(y2test, 2), 1))
% tmp9 = poissrnd(reshape(predictions,size(y2test) ));
% plot(mean(tmp9, 2))
% tmp9 = poissrnd(reshape(predictions2,size(y2test) ));
% plot(mean(tmp9, 2))
plot(mean(reshape(predictions2, size(y2test)), 2))
plot(mean(reshape(predictions, size(y2test)), 2))
plot(mean(reshape(predictions3, size(y2test)), 2))
%%

numberInEachCategory =[5, 5, 8, 8, 8, 6 ];
labelInEachCategory = {'Amplitude', 'Setpoint', 'Touches', 'Pole up', 'Pole down', 'Licks'};
plotBetas(betas, numberInEachCategory, labelInEachCategory)

%%

mod4 = glmnet(X2model, y2model(:), 'poisson');

%%
glmnetPlot(mod4)
%%
% whats the problem?
% When I multipley the weights by the DM, i get a similar in shape but dissimilar in magnitude of
% the average response over all trials. interestingly the cvglmnetpredict function matches the
% actual data. 




%%
CVpred = cvglmnetPredict(cv_mod4, X3);
test1 = exp(CVpred);
%%
tic
options.alpha = cv_mod4.lambda_1se;
mod2 = glmnet(X3, Y3, 'poisson')
toc
%%
Y3hat = glmnetPredict(mod2, X3, cv_mod4.lambda_1se, 'response');
Y3hat = reshape(Y3hat, [], C.k);
figure;imagesc(Y3hat')
%%

r = poissrnd(Y3hat);
figure;imagesc(r')

figure;plot(mean(r'))
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