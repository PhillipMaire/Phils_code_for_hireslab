%%
modLocation = [];
allDev = [];
for k = 1:length(allModels)
   if~isempty(allModels{k})
    modLocation(k) = find( allModels{k}.model.lambda == allModels{k}.model.lambda_1se);
    allDev(k) = allModels{k}.model.glmnet_fit.dev( modLocation(k));
   end
end
%%
[asdf, gh] =sort(allDev)
%%
cellStep = 29;
  C = U{cellStep} ;
cv_mod4 = allModels{cellStep}.model;
DM = allModels{cellStep};