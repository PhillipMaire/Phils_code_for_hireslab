function colormapPlot(newDefaultColors, h)
if ~(exist('h', 'var') && ishandle(h))
    h = gcf;
end
lineCell = h.Children.Children;

Lcol = size(newDefaultColors, 1);
C1 = 0;
for k = 1:length(lineCell)
    l =     lineCell(1);
    if (ischar(l.Color) && (strcmpi(l.Color, 'w') || strcmpi(l.Color, 'white'))) ...
            || ...
            all(l.Color(1:3) == [0, 0, 0])% is color is white then skip
    else
        C1 = C1+1;
        if C1 == Lcol+1
            C1 = 1;
        end
        newC = newDefaultColors(C1, :);
        if ischar(l.Color)
            colT = newC;
        else % keep the transparency
            colT = l.Color;
            colT(1:length(newC)) = newC;
            
        end
        
        
        h.Children.Children(k).Color = colT
    end
    
    
end