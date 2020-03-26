function L1 = plotColorLine(x, y, co)
%{
co = tmpCol(a2, :);
x = sortedVel{k};
y = 1:length(sortedVel{k});
%}

co = co(1:end-1, :);
x = x(:)'; y = y(:)';

x = [x(1:end-1);x(2:end)];
y = [y(1:end-1);y(2:end)];

% 
% 
% 
% % figure
% tmp1 = gcf
% set(tmp1,'defaultAxesColorOrder',co);
set(gcf,'defaultAxesColorOrder',co);
set(gca,'defaultAxesColorOrder',co);
ax = gca;
ax.ColorOrder = co;
L1 = plot(x, y, 'LineJoin', 'chamfer');
