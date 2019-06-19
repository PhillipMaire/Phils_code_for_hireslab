function [CI sizeCI] = philsCIs(x ,alpha)

upperVar = 1-(alpha./2);
lowerVar =1-upperVar;


SEM = std(x)/sqrt(length(x));               % Standard Error
ts = tinv([lowerVar upperVar ],length(x)-1);      % T-Score

CI = mean(x) + ts*SEM;
tmp = ts*SEM;
sizeCI = tmp(end);
end