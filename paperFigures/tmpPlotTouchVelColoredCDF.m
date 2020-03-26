%%
crush

%%
spout = SPmaker(1, 3);

numCols =101
tmpCol = (gray(numCols));
% colVec =linspace(-2.5, 2.5 ,numCols) ;
colVec =linspace(0, 2.5 ,numCols) ;
for k = 1:length(sortedVel)
    
    
    spout = SPmaker(spout);
   
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    ax1 = gca;
    ax1;hold on
    ax1_pos = get(ax1,'Position');
    axes('Position',ax1_pos,...
        'XAxisLocation','top',...
        'yaxislocation','right','Color','none');hold on
    hold on
    
    [a1, a2] = min(abs(abs(sortedVel{k}(:)') - colVec(:)));
    
    clinep(sortedVel{k}, 1:length(sortedVel{k}), ones(size(sortedVel{k})), (tmpCol(a2)), 5)
%     plot( sortedVel{k}, 1:length(sortedVel{k}))
    axis tight
    
    ax1 = gca;
    ax1;hold on
    ax1_pos = get(ax1,'Position');
    axes('Position',ax1_pos,...
        'XAxisLocation','bottom',...
        'yaxislocation','left','Color','none');hold on
    
     [x1, y1] = find(sortedRastCell{k});
    scatter(x1-find(extractRange==0),y1,   'k.')
    
     axis tight
    xlim([rastXlims(1), rastXlims(end)]);
    
%     spout = SPmaker(spout)
%     i1 = imagesc(flip(abs(sortedVel{k}')))
%    

     colormap(turbo(101))
    
end
%%

%%
crush
spout = SPmaker(1, 1);
TPval = .1;
numCols =1001;
Tset = turbo(numCols);
% Tset = flip(brewermap(numCols, 'RdPu'));
tmpCol = (gray(numCols));
% tmpCol(:, end+1) = TPval;
% colVec =linspace(-2.5, 2.5 ,numCols) ;
colVec =linspace(0, LIMIT_VEL_TO_ABS_MAX ,numCols);
FcolResPeriod = [0 0 1];%[0.383942324363185,0.0160730786986721,0.456038937478105]
p2 = {};
for k = 1%:length(sortedVel)
    
    
    spout = SPmaker(spout);
  

%%
      hold on
     [x1, y1] = find(sortedRastCell{k});
    scatter(x1-find(extractRange==0),y1,   'k.')
    set(gca, 'Color','none')
     axis tight
    xlim([rastXlims(1), rastXlims(end)]);
    hold on 
    %%
   %%
        y1 = ylim;
      x1 = Twin{k};
p = fill([x1(1), x1(end), x1(end), x1(1)], [y1(1), y1(1), y1(2), y1(2)], 'r');
set(p, 'EdgeColor', 'none', 'FaceColor', FcolResPeriod)

box off
% set(gca,'XTick',[], 'YTick',[])
set(gca, 'TickLength',[0 0])
    set(gca, 'Color','none')

    %%
    set(gca,'YTickLabel',[]);
%     set(gca,'XTickLabel',[]);
    ax1 = gca;
    ax1;
    ax1_pos = get(ax1,'Position');
    axes('Position',ax1_pos,...
        'xcolor','r',...
        'XAxisLocation','top',...
        'yaxislocation','right','Color','none');hold on
    hold on
    
    [a1, a2] = min(abs(abs(sortedVel{k}(:)') - colVec(:)));
      
%     spout = SPmaker(spout);

      p2{k} = clinep(sortedVel{k}, 1:length(sortedVel{k}), ones(size(sortedVel{k})), (tmpCol(a2)), 5);
     set(p2{k},'FaceAlpha',1, 'EdgeAlpha',1, 'FaceVertexAlphaData', 1)
    axis tight
    set(gca,'YTickLabel',[]);
        xlabel('Pretouch velocity','color','r')
    set(gca, 'Color','none')

    %%
box off
% set(gca,'XTick',[], 'YTick',[])
set(gca, 'TickLength',[0 0])
     colormap(gcf, Tset(min(a2):max(a2), :)); %make suure the axes 
%  colormap(turbo(1000))
 
      xlim([-1, 1].*LIMIT_VEL_TO_ABS_MAX);
     


end
%%

imageData = screencapture(varargin)
%%

%%

saveas(gcf, ['test', '_,.svg'])

%%
% axes.SortMethod='ChildOrder'
fn = 'test2'
export_fig([fn, '.eps'], '-depsc', '-painters', '-r1200', '-transparent')
fix_eps_fonts([fn, '.eps'], 'Arial')

%%
        saveFigAllTypes('test', spout.mainFig, 'C:\Users\maire\Downloads')

%%
p2{1}.EdgeAlpha
p2{2}.EdgeAlpha
p2{3}.EdgeAlpha


 set(p2{1},'FaceAlpha',1, 'EdgeAlpha',.1, 'FaceVertexAlphaData', 0)


%%
%%
% supLabel_ALL('Pre-touch velocity dependent responses','Time (ms)','pole down response',[])