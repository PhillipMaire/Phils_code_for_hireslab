%%
function [x]=cellNums2MatWithNansOrZeros2(cellArrayOfNums, varargin)
%THIS SHIT DONT WORK USE THE ORIGINAL ONE
%           cellArrayOfNums = beamBreakTimes;
n1 = cellfun(@numel,cellArrayOfNums);
%%%%%%%%%%%% cell in side cell cant get actual size how to fix????

[sortedN1, indN1] = sort(n1);
test11 = cellArrayOfNums{indN1(end)};

if iscell(test11)
   %wanted to put something here so that it would know if the cell is cell
   %of cells ect. but fugured out i dont want to spend my time on this 
elseif isnumeric(test11)
    
end
[maxHeight maxWidth] = size(cellArrayOfNums{indN1(end)});

tallTest = maxHeight>maxWidth;
wideTest = maxHeight<maxWidth;

test11 = cellArrayOfNums{indN1(end)};

n = max(cellfun(@length,cellArrayOfNums));
if nargin > 1
    if strcmp(lower(varargin{1}), 'nan')
        f = @(x) [x',nan(1,n-length(x))];
    elseif strcmp(lower(varargin{1}), 'zeros')
        f = @(x) [x',zeros(1,n-length(x))];
    else
        warning('string specified was not ''nan'' or ''zeros'' default to nan')
        f = @(x) [x',nan(1,n-length(x))];
    end
else
    f = @(x) [x',nan(1,n-length(x))];
end
cellArrayOfNumsPadded = cellfun(f,cellArrayOfNums,'UniformOutput',false);
x = cat(1,cellArrayOfNums{:});
end