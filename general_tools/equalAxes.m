function [] = equalAxes(varargin)
% set x and y to be equal if string 'same' is input then the negative and positive numbers will be
% the same magnitude 
if nargin>0 && ~isempty(varargin{1})
    h = varargin{1};
else
    h = gcf;
end
figure(h);
lims = [xlim; ylim];
ylim([min(lims(:)), max(lims(:))]);
xlim([min(lims(:)), max(lims(:))]);

if nargin >= 2 && strcmpi(varargin{2}, 'same')
    % make the positive and negative the same
    tmpY = max(abs(ylim));
    ylim([-tmpY, tmpY]);
    tmpX = max(abs(xlim));
    xlim([-tmpX, tmpX]);
    
end