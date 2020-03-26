function [mat] = smoothEdgesNan(mat, smoothBy)
% operates along the first dimension simply nans out the edges of a smoothed mat
try
    mat(1:smoothBy-1, :) = nan;
    mat(end-smoothBy+1:end, :) = nan;
catch
    warning('returning nans')
    mat = nan(size(mat));
end

%  YOU MIGHT B LOOKING FOR THIS FUNCTION -- smoothTrimEdges