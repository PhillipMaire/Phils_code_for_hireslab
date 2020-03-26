function [binNum, notSigInds, pvalsOfnotSigInds, SigInds, pvalsOfSigInds] = ...
    multcompare_findPointsAroundBinnum(binNum, comparison, sigVal)


tmp1 = find(comparison(:, 1:2)== binNum);
[i1, i2] = ind2sub(size(comparison(:, 1:2)), tmp1);
i3 = abs(i2-2)+1;%2s to 1s and 1s to 2s

notSigIndsTMP = find(~(comparison(i1, 6)<sigVal));
goodOlInds = sub2ind(size(comparison), i1(notSigIndsTMP) , i3(notSigIndsTMP));
notSigInds = sort([comparison( goodOlInds)]);
pvalsOfnotSigInds = comparison(i1(notSigIndsTMP), 6);

SigIndsTMP = find(~(comparison(i1, 6)>=sigVal));
goodOlInds = sub2ind(size(comparison), i1(SigIndsTMP) , i3(SigIndsTMP));
SigInds = sort([comparison( goodOlInds)]);
pvalsOfSigInds = comparison(i1(SigIndsTMP), 6);

end