function [SEM, mean1, BINS, VARy] = eventsSTA(varIN,segs, BINS, varargin)

if ~iscell(BINS{1})
    if nargin>= 4
        subSet = varargin{1};
        segs = segs(subSet, :);
        [~, BINS, ~] = cellfun(@(x) intersect(subSet, x), BINS, 'UniformOutput', false);
    end
    T_VAR = varIN(segs(:, 1));
    B_VAR = cellfun(@(x) T_VAR(x), BINS, 'UniformOutput', false);
    SEM = cellfun(@(x) nanstd(x)/sqrt(length(x)),B_VAR );
    VARy = cellfun(@(x) var(normalize(x, 'range')),B_VAR );
    mean1 = cellfun(@(x) nanmean(x), B_VAR);
elseif iscell(BINS{1})
    SEM = {};
    VARy = {};
    mean1 = {};
    %     segs = reshape(segs(:, 1), [], length(BINS));
    segs = repmat(segs(:, 1), length(BINS) );
    
    BINS2 = BINS;
    if nargin>= 4
        subSet = varargin{1};
        segs = segs(subSet, :);
        for k = 1:length(BINS2)
            [~, BINS2{k}, ~] = cellfun(@(x) intersect(subSet, x), BINS{k}, 'UniformOutput', false);
        end
    end
    for k = 1:length(BINS2)
        T_VAR = varIN(segs(:, k));
        tmp1 = BINS2{k};
        B_VAR = cellfun(@(x) T_VAR(x), tmp1, 'UniformOutput', false);
        SEM{k} = cellfun(@(x) nanstd(x)/sqrt(length(x)),B_VAR );
        VARy{k} = cellfun(@(x) var(x),B_VAR );
        mean1{k} = cellfun(@(x) nanmean(x), B_VAR);
    end
end
