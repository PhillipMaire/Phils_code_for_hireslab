function [] = textNumArray(x, y, nums) 
% uses text to plot numbers at each pair of x and y;
%{
figure;
plot(1:20, rand(20, 4)+(1:4))
x = zeros(1, 4);
y = 1:4;0
nums = rand(1, 4)
textNumArray(x, y+.5, nums) 
%}

x = x(:);
y = y(:);
nums = nums(:);
if ~all(([length(x), length(y)] ./ length(nums))==1)
   error('all arrays must be the same size') 
end


for k = 1:length(x)
    
    text(x(k), y(k), num2str(nums(k)));
    hold on
end

