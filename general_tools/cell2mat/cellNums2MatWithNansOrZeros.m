%%
function [x]=cellNums2MatWithNansOrZeros(cellArrayOfNums, varargin)




n = max(cellfun(@length,cellArrayOfNums));
if nargin > 1
    if strcmp(lower(varargin{1}), 'nan')
        f = @(x) [x,nan(1,n-length(x))];
    elseif strcmp(lower(varargin{1}), 'zeros')
        f = @(x) [x,zeros(1,n-length(x))];
    else
        warning('string specified was not ''nan'' or ''zeros'' default to nan')
        f = @(x) [x,nan(1,n-length(x))];
    end
else
    f = @(x) [x,nan(1,n-length(x))];
end
cellArrayOfNumsPadded = cellfun(f,cellArrayOfNums,'UniformOutput',false);
x = cat(1,cellArrayOfNumsPadded{:});
end