function [] = fixPLotTicks(x)
%{
1 xlabels
2 ylabels
3 ticks on  

%}


if x(1)
 set(gca,'XTickLabel',[]);
end

if x(2)
 set(gca,'YTickLabel',[]);
end

if x(3)
 set(gca, 'TickLength',[0 0])
end




