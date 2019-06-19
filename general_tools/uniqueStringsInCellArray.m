function Y = uniqueStringsInCellArray(inCell)
%{
% this will give the inds for each cell from each animal
     inCell = cellfun(@(x) x.details.mouseName, U, 'UniformOutput',false);
     Y = uniqueStringsInCellArray(inCell)
%}
inCellU = unique(inCell);
indsForEachMouse = [];
for k = 1:length(inCellU)
    tmp = cell2mat(cellfun(@(x) strcmp(inCellU{k}, x), inCell , 'UniformOutput', false));
    indsForEachMouse(:,k) = tmp(:);
end
[Y.row ,Y.col ] = find(indsForEachMouse);
Y.linInds = indsForEachMouse;
Y.uniqueStrings = inCellU;
end

