%% got the data runnign through jons code

dir1 = 'C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster'
cd(dir1)
% load('ttwtheta.mat') % this is just in sampliung period
load('ttwtheta_pretouch.mat') % before first touch% %
% ttwtheta_pretouch = ttwtheta_pretouch([1:13, 15:16]) % ses 14 is bad
tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;2;2]
PlesionDays = find(tmp ==0)
postLesDays = find(tmp ==1)
postGoodPerf = find(tmp ==2)
%%
theseCells = 7:length(U)
all1 = []; all2 = []; all3 = [];
for k = theseCells
    SES = ttwtheta_pretouch{k};
    SES2 = SES(~isnan(SES));
    if any(PlesionDays == k)
        
        all1 = [all1(:); SES2(:)];
    elseif any(postLesDays == k)
        
        all2 = [all2(:); SES2(:)];
        
    elseif any(postGoodPerf == k)
        
        all3 = [all3(:); SES2(:)];
        
    end
    
    
end
%%
nInbin = {}
[nInbin{1}, edges] = hist(all1, linspace(0, 80, 41));
[nInbin{end+1}, edges] = hist(all2, edges);
[nInbin{end+1}, edges] = hist(all3, edges);
%%
figure;
colorCode = {'g', 'r', 'b'}
for k = 1:length(nInbin)
    tmp = bar(edges, normalize(nInbin{k}', 'norm'), 'FaceAlpha',.1, 'FaceColor', colorCode{k});
    tmp.EdgeAlpha = 0;
    hold on
    
end

%%
figure;
colorCode = {'g', 'r', 'b'}
clear p
for k = 1:length(nInbin)
    p{k, 1} = plot(edges, normalize(nInbin{k}', 'norm'), 'color', colorCode{k});
%     p{k, 2} = plot(edges, normalize(nInbin{k}', 'norm'), 'color', colorCode{k}, 'marker', '.', 'markerSize', 20)
    hold on
%     eval(['p', num2str(k), '=p{k};'])
end
%%
legend([p{1}, p{2}, p{3}],{'Pre-lesion','Post-lesion', 'Post-Lesion Recovery'} ,'FontSize',18, 'Location','northeast')
legend('boxoff')
sdf(gcf, 'default')
title1 = sprintf('Search strategy changes in the mouse which recovered')
title(title1,'FontSize',22)
xlabel('Whisker angle past decision boundary (degrees)')
ylabel('Proportion of whisks before touch')


tmp = gcf;
tmp.Position = [289,108,1497,918]

%%

cd('C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster')
dateString1 = datestr(now,'yymmdd_HHMM');
svName = 'degThetaPastDB_Search_strategy';
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])

saveas(gcf, [svName, '_', num2str(dateString1),'.png'])
saveas(gcf, [svName, '_', num2str(dateString1),'.eps'])
saveas(gcf, [svName, '_', num2str(dateString1),'.fig'])



% % for k = theseCells
% %     tmpU = U{k};
% %
% %     name1{k} = [tmpU.details.mouseName, '_', tmpU.details.sessionName];
% %     touchFirst = [];
% %     firstTouchArray = squeeze(tmpU.S_ctk(9, :, :));
% %     for FindTouch = 1:tmpU.k
% %         touchTime = find(firstTouchArray(:, FindTouch)==1, 1);
% %         if isempty(touchTime)
% %             touchFirst(FindTouch) = nan;
% %         else
% %             touchFirst(FindTouch) =touchTime ;
% %         end
% %     end
% % end
%%
figure
[SPo] = SPmaker(3, 5);
for k = 1:length(ttwtheta_pretouch)
    [SPo] = SPmaker(SPo);
    SES = ttwtheta_pretouch{k};
    if ~isempty(find(SES(:)<0))
        SES(find(SES(:)<0))
        keyboard
    end
    rangeTest(k) = range(SES(:))
    histogram(SES(~isnan(SES)))
    
    hold on
    plot(mean(SES(~isnan(SES))), 0, '*k')
    %    xlim([0 80])
    
    
end

%%
% figure
[SPo] = SPmaker(3, 5);
for k = 1:length(ttwtheta_pretouch)
    [SPo] = SPmaker(SPo);
    SES = ttwtheta_pretouch{k}(:,1);
    histogram(SES(~isnan(SES)))
    
    hold on
    plot(mean(SES(~isnan(SES))), 0, '*k')
    xlim([0 80])
    
    
end
%%

% figure
% [SPo] = SPmaker(3, 5);
for k = 1:length(ttwtheta_pretouch)
    %   [SPo] = SPmaker(SPo);
    SES = ttwtheta_pretouch{k};
    %   SES = ttwtheta_pretouch{k}(:,1);
    %   histogram(SES(~isnan(SES)))
    
    hold on
    plot(mean(SES(~isnan(SES))), k, '*k')
    plot(mean(SES(~isnan(SES(:,1)))), k, '*r')
    xlim([0 80])
    
    
end

%%
% tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;1;1]
% PlesionDays = find(tmp ==0)
% postLesDays = find(tmp ==1)
%%

for k = theseCells
    tmpU = U{k};
    
    name1{k} = [tmpU.details.mouseName, '_', tmpU.details.sessionName];
    touchFirst = [];
    firstTouchArray = squeeze(tmpU.S_ctk(9, :, :));
    for FindTouch = 1:tmpU.k
        touchTime = find(firstTouchArray(:, FindTouch)==1, 1);
        if isempty(touchTime)
            touchFirst(FindTouch) = nan;
        else
            touchFirst(FindTouch) =touchTime ;
        end
    end
end

%%
test1 = []
for k = 1:length(U)
    tmpU = U{k};
    test1(k,1:2)=tmpU.meta.ranges
end