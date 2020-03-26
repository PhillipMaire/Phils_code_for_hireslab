function brewColorIndsView(tmpColor)
figure;
imagesc(1:size(tmpColor, 1))
hold on 
colormap(tmpColor)
