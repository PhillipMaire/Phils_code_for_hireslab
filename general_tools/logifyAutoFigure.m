function [evalAxis] = logifyAutoFigure(AxesesToLogify,base1, varargin)
%{
logifyAutoFigureTMP({'x', 'y'},2)
%}
if nargin>=3
    h = varargin{1};
else
    h = gcf;
end
changeLables = 1;
if nargin >=4 && varargin{2} == 1 % true false-> DO NOT relable tick labeles yet (the evalAxis will allow you to di ti later if you want
    % to change something or whatever or zoom in and then do it after changing something for some
    % reason) just use eval(evalAxis.X) to change the x axis for example
    changeLables = 0;
end
xt = [];
evalAxis.X = ['xt = get(gca, ''XTick''); set (gca, ''XTickLabel'', (-2*(xt<0) + 1).*(' num2str(base1) '.^abs(xt)));'];
evalAxis.Y = ['xt = get(gca, ''YTick''); set (gca, ''YTickLabel'', (-2*(xt<0) + 1).*(' num2str(base1) '.^abs(xt)));'];
evalAxis.Z = ['xt = get(gca, ''YTick''); set (gca, ''ZTickLabel'', (-2*(xt<0) + 1).*(' num2str(base1) '.^abs(xt)));'];
% negInd2 = -2*(xt<0) + 1;
d = h.Children.Children;
if ismember('x', lower(AxesesToLogify))
    for k = 1:length(d)
        d2 = d(k);
        xOUT = logWithNegs(d2.XData, base1);
        h.Children.Children(k).XData = xOUT;
    end
    if changeLables == 1
        eval(evalAxis.X);
    end
end

if ismember('y', lower(AxesesToLogify))
    for k = 1:length(d)
        d2 = d(k);
        yOUT = logWithNegs(d2.YData, base1);
        h.Children.Children(k).YData = yOUT;
    end
    if changeLables == 1
        eval(evalAxis.Y);
    end
end
if ismember('z', lower(AxesesToLogify))
    for k = 1:length(d)
        d2 = d(k);
        zOUT = logWithNegs(d2.ZData, base1);
        h.Children.Children(k).ZData = zOUT;
    end
    if changeLables == 1
        eval(evalAxis.Z);
    end
end
refresh
    function xOUT = logWithNegs(x2, base2)
%         if any(x2<-1.5)
%             keyboard
%         end
        zeroInd = abs(x2)<1;
        negInd = -2*(x2<0) + 1;
        xOUT = log(abs(x2))./log(base2);
        xOUT = (xOUT).*negInd;
        xOUT(zeroInd) = 0;
        
    end
end