function [y] = smoothmat(x, smoothBy)
y = nan(size(x));
for k = 1:size(x, 2)
    %     y(:, k) = smooth(x(:, k), smoothBy);
    y(:, k) = nanfastsmooth(x(:, k), smoothBy,1,0);
end

y = smoothEdgesNan(y, smoothBy);% nans out the edges that dont have full samples. 