function [hh] = labelALL(title1, xax, yax, yax2, varargin)
% tmp1 = struct2cell(whos)
% cellfun(@(x) isempty(x) , tmp1(2,:));
if nargin == 5
    if iscell(varargin{1})
        FigH = {};
        for k = 1:length(varargin{1})
            [Axes2, FigH2] = supLabel_ALL(title1, xax, yax, yax2, varargin{1}{k});
            Axes{k} = Axes2;
            FigH{k} = FigH2;
        end
        return
    elseif ishandle(varargin{1})
        h = varargin{1};
    end
else
    h = gcf;
    
end

figure(h);
hh = cell(4, 1);
FigH = cell(4, 1);

if exist('xax') && ~isempty(xax)
    [hh{2}] =  xlabel(xax);
end
if exist('yax') && ~isempty(yax)
    [hh{3}] =  ylabel(yax);
end
if exist('yax2') && ~isempty(yax2)
    [hh{4}] =  suplabel(yax2, 'yy');
end

if exist('title1') && ~isempty(title1)
    [hh{1}] = title(title1);
end