function [outArray] = colonMulti(A1, A2, varargin)
% get all the numbers between 2 vectors
% so ...
% [outArray] = colonMulti([1 90 4]', [5, 100, 10]') (arrays must be linearized)
% will give you ...
%      1
%      2
%      3
%      4
%      5
%     90
%     91
%     92
%     93
%     94
%     95
%     96
%     97
%     98
%     99n
%    100
%      4
%      5
%      6
%      7
%      8
%      9
%     10
A1 = A1(:);
A2 = A2(:);
if nargin == 2
    outArray = nan(sum(1+A2-A1), 1);
    tmp1 = [0; cumsum(1+A2-A1)];
    for k = 1:length(A1(:))
        b = A1(k):A2(k);
        outArray(tmp1(k)+1:tmp1(k+1)) =   b(:);
    end
elseif nargin ==3 && strcmpi(varargin{1}, 'cell')
    outArray = cell(length(A1), 1);
    %     tmp1 = [0; cumsum(1+A2-A1)];
    for k = 1:length(A1(:))
        b = A1(k):A2(k);
        outArray{k} =   b(:);
    end
    
end





