function [x] = nansmooth(x, smoothBy, varargin)
% you might be looking for smoothTrimEdges
if all(size(x) == size(x(:)))

NanInd = isnan(x);
x(NanInd) = 0;
x = reshape(smooth(x(:), smoothBy), size(x));
x(NanInd) = nan;
elseif nargin == 3 && strcmpi(varargin{1}, 'mat')
    newX = nan(size(x));
    for k = 1: size(x, 2)
    [newX(:, k)] = nansmooth(x(:, k), smoothBy, varargin);
    end
    x = newX;
else
   error('must be vecorized, try using ''mat'' as 3rd input. it will operate along the 1st dimention') 
end