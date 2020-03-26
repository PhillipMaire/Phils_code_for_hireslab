function ind = quadrentsInds(x, y)
y1 = y<0;
x1 = x>0;
% x = phaseMean;
% y = ampMean;
try
    [c,cm,ind,per] = confusion(y1, x1);
    
    
catch
    
   ind = {};
    
    ind{2, 2} = find(y1 & x1 );
    ind{1, 2} = find(~y1 & x1 );
    ind{2, 1} = find(y1 & ~x1 );
    ind{1,1} = find(~y1 & ~x1 );
    
    
end