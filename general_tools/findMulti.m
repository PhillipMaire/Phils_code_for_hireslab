function inds = findMulti(toFind, X)


inds = {};
for k = 1:length(toFind)
inds{k} = find(X== toFind(k)); 
end