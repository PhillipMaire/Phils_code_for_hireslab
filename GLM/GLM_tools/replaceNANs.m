function [whole1] = replaceNANs(reduced1, nanRows, keepRows)
whole1 = nan(size(reduced1, 1)+length(nanRows), size(reduced1, 2));
whole1(keepRows, :) = reduced1;










