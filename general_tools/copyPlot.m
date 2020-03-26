function [h2, FN] = copyPlot(h)

if strcmpi(h.Type, 'scatter')
FN = fieldnames(h);
FN = setdiff(FN, {'BeingDeleted', 'Annotation', 'Type'});
h2 = scatter(h.XData, h.YData);
for k = 1:length(FN)
  eval(['h2.',  FN{k}, ' = ','h.',  FN{k}, ';' ]);
end


else
    
   error('not unrecognized plot type pleae add it into the function') 
end