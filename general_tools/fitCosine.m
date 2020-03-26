function [fitX, fitY] = fitCosine(y, varargin)
% varargin{1} are the x values otherwise just does length
% varargin{2} is to set the contrians of only one full cycle if set to true 
y = y(:);
if nargin == 1
    x = (1:length(y))';
else
    x = varargin{1}(:);
end

yMAX = max(y);
yMIN = min(y);
yRANGE = (yMAX-yMIN);                               % Range of ‘y’
yz = y-yMAX+(yRANGE/2);
zeroX = x(yz(:) .* circshift(yz(:),[1 0]) <= 0);     % Find zero-crossings
period1 = 2*mean(diff(zeroX));                     % Estimate period
yOffset = mean(y);                               % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);    % Function to fit
if nargin >2 && varargin{2} == true
    fit = @(b,x)  b(1).*(sin(2*pi*x./(2*pi) + 2*pi/b(3))) + b(4);    % Function to fit
end
fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
s = fminsearch(fcn, [yRANGE;  period1;  -1;  yOffset])   ;                    % Minimise Least-Squares
xp = linspace(min(x),max(x));
fitX = xp;
fitY = fit(s,xp);