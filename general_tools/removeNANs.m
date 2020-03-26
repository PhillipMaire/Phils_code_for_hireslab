function [x, goodInds, varargout] = removeNANs(x, dim1, varargin)
% dim1 = 1 to remove all columns with nan dim1 = 2 to remove all rows with nan
if ~iscell(x)
    goodInds = find(~isnan(mean(x, dim1)));
    if dim1 ==1
        x = x(:, goodInds);
    elseif dim1 == 2
        x = x(goodInds, :);
    else
        error('bad')
    end
    
elseif iscell(x)
    
    allSizeInDim = [];
    for k = 1:length(x)
        allSizeInDim(k) = size(x{k}, setdiff([1, 2], dim1));
    end
    if ~all(allSizeInDim == allSizeInDim(1))
        error('dimension mismatch ')
    else
        allToNan = [];
        for k = 1:length(x)
            allToNan = [allToNan(:);   find(isnan(mean(x{k}, dim1)))];
        end
        goodInds = setdiff(1:size(x{1}, setdiff([1, 2], dim1)), allToNan);
        for k = 1:length(x)
            if dim1 == 1
                x{k} =  x{k}(:, goodInds)
            elseif dim1==2
                x{k} =  x{k}(goodInds, :)
            else
                error('bad')
            end
        end
    end
else
    error('bad')
end
if nargin==3 && strcmpi(varargin{1}, 'mat')
    for k = 1:length(x)
    varargout{k} = x{k};
    end
    
end