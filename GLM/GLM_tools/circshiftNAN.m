function [outMat] = circshiftNAN(inputMat, shiftBy, varargin)

if nargin>2 && varargin{1} == 2
    inputMat = inputMat';
end
outMat = circshift(inputMat, shiftBy);
if shiftBy>0
    outMat(1:shiftBy, :) = nan;
elseif shiftBy<0
    if size(outMat, 1)+1+shiftBy<=0
        outMat = nan(size(inputMat));
    else
        outMat(end+1+shiftBy:end, :) = nan;
    end
end
if nargin>2 && varargin{1} == 2
    outMat = outMat';
end