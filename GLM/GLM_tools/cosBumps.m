function [allBumps, timeShifts] = cosBumps(widthBumps,lengthSig , intervalsOfBumps, numBumps)
t = linspace(-pi, pi, widthBumps);
x = (cos(t)+1)./2;
bumpOne = [x(:); zeros(lengthSig-length(x), 1)];
allBumps = bumpOne;
for k = 1:numBumps-1
    allBumps = [allBumps, circshift(bumpOne, intervalsOfBumps*k)] ;
end
% bumpsOffset = 0;
% allBumps = circshift(allBumps , -widthBumps./2);
% if nargin>4
%     bumpsOffset = varargin{1};
%     allBumps = circshift(allBumps , bumpsOffset);
% end

timeShifts = cumsum(repmat(intervalsOfBumps, [1, numBumps]));% + bumpsOffset;