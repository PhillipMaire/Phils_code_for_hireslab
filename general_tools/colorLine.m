function sc1 = colorLine(x1, y1, tmpCol)


colVec =linspace(0, LIMIT_VEL_TO_ABS_MAX ,numCols);


x2 = linspace(min(x1), max(x1), interpBY);
y2 = interp1(x1, y1,x2,'linear');
[a1, a2] = min(abs(abs(x2(:)') - colVec(:)));


sc1 = scatter(x2,y2 ,[], tmpCol(a2, :));
set(sc1, 'MarkerEdgeColor', 'flat', 'MarkerFaceColor', 'none', 'LineWidth', 3+pi);
% set 3+pi so that stroke is unique and you can select all the points by stroke similarity ;)