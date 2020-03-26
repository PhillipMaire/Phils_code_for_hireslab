function [CI, sizeCI] = philsCIs(x ,alpha1, L)

upperVar = 1-(alpha1./2);
lowerVar =1-upperVar;


SEM = nanstd(x)/sqrt(L);               % Standard Error
ts = tinv([lowerVar upperVar ],L-1);      % T-Score

% x = icdf('Poisson',[lowerVar upperVar ], length(x)-1)

CI = nanmean(x) + ts*SEM;
tmp = ts*SEM;
sizeCI = tmp(end);
end