function limSetMaxAndRound(axisSet, roundTO)
% this function simply puts the nearest number above the max number in units of roundTO so that you
% have 3 numbers -A 0 and +A where A is dtermined by the data and roundTO 
% a cell with a string containing x and/or containing y to set that axis 
% roundTO - 1 for round to nearest integer, .1 to nearest .1, min is .1, etc
if contains(axisSet, 'y')
    set(gca, 'YLimSpec', 'Tight');
    tmp1 = ceil((1./roundTO)*max(abs(ylim)))/(1./roundTO);
    
    %     tmp1(tmp1>1) = 1;
    ylim([-tmp1 tmp1]);
    yticks([-tmp1 0 tmp1]);
end
if contains(axisSet, 'x')
    set(gca, 'XLimSpec', 'Tight');
    tmp1 = ceil((1./roundTO)*max(abs(xlim)))/(1./roundTO);
    %     tmp1(tmp1>1) = 1;
    xlim([-tmp1 tmp1]);
    xticks([-tmp1 0 tmp1]);
end