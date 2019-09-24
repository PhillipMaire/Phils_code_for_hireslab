function [fitDevExplained] = devExplainedPoisson(real1, predicted1)
y = real1(:);
u = predicted1(:);
nullLogLikelihood = nansum(log(poisspdf(y,nanmean(y(:)))));
fullLogLikelihood = nansum(log(poisspdf(y,u)));
saturatedLogLikelihood = nansum(log(poisspdf(y,y)));
devianceFullNull = 2*(fullLogLikelihood - nullLogLikelihood);
fitDevExplained = 1 - (saturatedLogLikelihood - fullLogLikelihood)...
    /(saturatedLogLikelihood - nullLogLikelihood);
