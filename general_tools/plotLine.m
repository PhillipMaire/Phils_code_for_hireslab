function [out1] = plotLine(plotLineNum, varargin)
out1 = {};


if nargin == 0
    sprintf('%s\n%s\n%s\n%s\n%s\n%s\n', ...
        'Enter a vector with any combination of 1, 2, 3 and/or 4',...
        '1 --> / (Y = X) is diag bottom left to top right ',...
        '2 --> -- is Y = 0 line',...
        '3 --> | is X = 0 line',...
        '4 --> \ (Y = X) is diag top left to bottom right (line 1 flipped)',...
        '2nd input can be a fig handle otherwise it uses GCF',...
        'use ''cellfun(@(x) delete(x), out1)'', to delete the lines if you want to make new lines'...
        )
    return
end

if nargin >=2
    h = varargin{1};
else
    h = gcf;
end
figure(h)
hold on



if any(ismember(plotLineNum,1))
    x1 = xlim;
    y1 = ylim;
    if strcmpi(h.CurrentAxes.XScale, 'log')
        x1(x1<0) = 0;
    end
    if strcmpi(h.CurrentAxes.YScale, 'log')
        y1(y1<0) = 0;
    end
    out1{1} = plot([min(y1) max(x1)], [ min(y1) max(x1)], '--k' ,'HandleVisibility','off');
    %     set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    %      set(get(get(out1{1},'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    xlim(x1);
    ylim(y1);
end
if any(ismember(plotLineNum,2))
    out1{2} =   plot([xlim'], [zeros(2, 1)], 'k--' ,'HandleVisibility','off');
end
if any(ismember(plotLineNum,3))
    out1{3} =  plot([zeros(2, 1)], [ylim'], 'k--' ,'HandleVisibility','off');
    
end
if any(ismember(plotLineNum,4))
    x1 = xlim;
    y1 = ylim;
    if strcmpi(h.CurrentAxes.XScale, 'log')
        x1(x1<0) = 0;
    end
    if strcmpi(h.CurrentAxes.YScale, 'log')
        y1(y1<0) = 0;
    end
    out1{4} = plot([min(y1) max(x1)], -[ min(y1) max(x1)], '--k' ,'HandleVisibility','off');
    xlim(x1);
    ylim(y1);
end
