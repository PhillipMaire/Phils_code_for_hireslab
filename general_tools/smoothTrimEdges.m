function y = smoothTrimEdges(x, smoothBy)

y = smooth(x, smoothBy);

y(1:smoothBy-1, :) = nan;
y(end-smoothBy+2:end, :) = nan;