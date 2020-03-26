function [inds, sortedMat] = sortMulti(x, order1)
% operating on the 1st dimension. order1 is a vector of index from the most
% important to leaset important sorting order of the matrix
%{
tmp1 = round(rand(10, 2)*2);
tmp1 = [1,1;1,2;1,1;2,2;1,1;2,2;2,1;2,2];
[inds, sortedMat] = sortMulti(tmp1, [1, 2]);
figure; imagesc(tmp1)
figure; imagesc(sortedMat)
%}
order1 = flip(order1);
x2 = x;
for k = 1:length(order1)
    if k == 1
        [s(:, k), i(:, k)] = sort(x(:, order1(k)));
        x2 = x2(i(:, k), :);
    else
        [s(:, k), i(:, k)] = sort(x2(:, order1(k)));
        i(:, k)= i(i(:, k), k-1);
        x2 = x(i(:, k), :);
    end
end
inds = i(:, end);
sortedMat = x(inds , :);
