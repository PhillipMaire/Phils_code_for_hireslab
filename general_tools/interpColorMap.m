function [cmapOUT, colorSpacing] = interpColorMap(cmap , interpColNum, varargin)
% cmap --> x by 3 (or whatever size really) color matrix 
% interpColNum --> number of colors to interpret between each color point. colormap will be equal to
% (interpColNum.*size(cmap , 1)) - interpColNum + 1

% cmap = tmpCol(a2, :);
% interpColNum = 10;

% just linear interp. can adjust this. for example with a color matrix of 10by3, you could set this
% to be [1 5 10 15 20 25 30 40 100 500] and the last 2 colors would take up the majority of the map.
if nargin == 2
colorSpacing = 1:interpColNum:(size(cmap, 1).*interpColNum);
elseif nargin >=3 
    colorSpacing = varargin{1};
    %this variable must b a vector of same length as size(cmap, 1)
end


[X,Y] = meshgrid([1:size(cmap, 2)],[1:max(colorSpacing)]);  %// mesh of indices

cmapOUT = interp2(X(colorSpacing,:),Y(colorSpacing,:),cmap,X,Y); %// interpolate colormap


% %// some example figure
% colormap(cmapOUT) %// set color map
% figure(1)
% surf(peaks)
% colorbar