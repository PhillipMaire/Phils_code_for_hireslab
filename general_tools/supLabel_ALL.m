function [Axes, FigH] = supLabel_ALL(title1, xax, yax, yax2, varargin)
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
Axes = cell(4, 1);
FigH = cell(4, 1);

if ~isempty(xax)
    [Axes{2}, FigH{2}] =  suplabel(xax, 'x');
end
if ~isempty(yax)
    [Axes{3}, FigH{3}] =  suplabel(yax, 'y');
end
if ~isempty(yax2)
    [Axes{4}, FigH{4}] =  suplabel(yax2, 'yy');
end

if ~isempty(title1)
    [Axes{1}, FigH{1}] = suplabel(title1, 't');
end
