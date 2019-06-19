%%
%{
load('Z:\Users\Phil\Data\Behavior\LESION_EXPERIMENTS\UB_array_190407_1918.mat')


%}
%   C:\Users\maire\Dropbox\HIRES_LAB\PHIL\presentations\190305 lesion performance detection task
BL = (brewermap(17, 'Greens'));
BL = BL(end-13:end-2, :);
AL = flip(brewermap(17, 'Reds'));
AL = AL(2:14, :);

bestXnumberOfTrials = 1;
numBestTrials = 200;
smoothBY = 50;

close all

daysOfLesion = { '180207a', '190223a', '190227a' ,'180221a'};
% switchPoint = [4, 7, 9, 6]; %index of 1st day of lesion
switchPoint = [];
theseCells = [2 3]
Ps = struct; Ps.LP_go = {};Ps.LP_nogo = {};
for k = 1:length(theseCells)
    
    M =  UB{theseCells(k)};
    
    switchPoint(k) = find(contains(M(:,3), daysOfLesion{theseCells(k)}) ==1);
    set(gca, 'ColorOrder', BL(end-switchPoint(k)+1:end, :))
    addToEnd = 0;
    counter1 = 0;
    for kk = 1:length(M(:,1))
        sameDay =   find(contains(M(:,3),M{kk, 3}(1:6)));
        %         sameDay = find(~cellfun(@isempty, sameDay));
        S = M{kk};
        if kk == sameDay(1)
            correct1 = [1;diff(cell2mat((S.AnalysisSection_PercentCorrect)))>0];
            goTrialsTMP = S.SidesSection_previous_sides == 114;
            goTrials = goTrialsTMP(1:length(correct1))';
            licked1 = (goTrials(:).*correct1(:)) + (~goTrials(:).*~correct1(:));
            counter1 = counter1+1;
        else
            TMP_correct1 = [1;diff(cell2mat((S.AnalysisSection_PercentCorrect)))>0];
            TMP_goTrialsTMP = S.SidesSection_previous_sides == 114;
            TMP_goTrials = TMP_goTrialsTMP(1:length(TMP_correct1))';
            TMP_licked1 = (TMP_goTrials(:).*TMP_correct1(:)) + (~TMP_goTrials(:).*~TMP_correct1(:));
            correct1 = [correct1; TMP_correct1];
            goTrials = [goTrials; TMP_goTrials];
            licked1 = [licked1; TMP_licked1];
            
        end
        
        Ps.LP_go{k, 1}{counter1} = licked1(goTrials) ;
        Ps.LP_nogo{k, 1}{counter1} = licked1(~goTrials) ;
        Ps.Day{k, 1}{counter1} = M{kk, 3}(1:6);
        
        
        
    end
end
%% plotting
close all
figure;hold on ;

daysOfLesion = { '180207', '190223', '190227' ,'180221'};
alphVal = .2
markSiz = 400
ALL_BL_NG = [];
ALL_BL_GO = [];
ALL_AL_NG = [];
ALL_AL_GO = [];
for k = 1:length(theseCells)
    indexK = theseCells(k);
    
    switchPoint(k) = find( contains(Ps.Day{k, 1}, daysOfLesion{indexK}) ==1);
    
    for kk = 1:length(Ps.LP_nogo{k}) - 1 %for the control at the end of the trial
        LP_NG =  Ps.LP_nogo{k,1}{kk};
        LP_GO =  Ps.LP_go{k,1}{kk};
        if kk>=switchPoint(k)
            col2 = [1 0 0 alphVal];
            tmp = scatter([-5, 5], [nanmean(LP_NG),nanmean(LP_GO)],markSiz, 'filled', 'Marker', 'o','MarkerFaceAlpha',  alphVal , 'MarkerFaceColor', 'r')
            plot([-5, 5], [nanmean(LP_NG),nanmean(LP_GO)], 'color', col2);
            ALL_BL_NG = [ALL_BL_NG(:); LP_NG(:)];
            ALL_BL_GO = [ALL_BL_GO(:); LP_GO(:)];
                        
            
        else
            col2 = [0 1 0 alphVal];
            tmp = scatter([-5, 5], [nanmean(LP_NG),nanmean(LP_GO)],markSiz, 'filled', 'Marker', 'o','MarkerFaceAlpha',  alphVal , 'MarkerFaceColor', 'g')
            plot([-5, 5], [nanmean(LP_NG),nanmean(LP_GO)], 'color', col2);
            ALL_AL_NG =[ALL_AL_NG(:); LP_NG(:)]
            ALL_AL_GO = [ALL_AL_GO(:); LP_GO(:)]
            %             tmp = plot([-5, 5], [nanmean(LP_NG),nanmean(LP_GO)],'.','Color', col2 ,'markersize', 60 );
            %             tmp.Color = col2;
            %             tmp.MarkerEdgeColor = col2
            
        end
        
        
        
    end
    
end
sdf(gcf, 'bigNclear')
scatter([-5, 5], [nanmean(ALL_BL_NG),nanmean(ALL_BL_GO)],markSiz, 'filled', 'Marker', 'o' , 'MarkerFaceColor', 'r')
p2 = plot([-5, 5], [nanmean(ALL_BL_NG),nanmean(ALL_BL_GO)], 'color', [1 0 0], 'LineWidth', 5);
scatter([-5, 5], [nanmean(ALL_AL_NG),nanmean(ALL_AL_GO)],markSiz, 'filled', 'Marker', 'o' , 'MarkerFaceColor', 'g')
p1 = plot([-5, 5], [nanmean(ALL_AL_NG),nanmean(ALL_AL_GO)], 'color', [0 1 0], 'LineWidth', 5);


xlim([-5.8 5.8])
ylim([0 1])

%%


leg1 = legend([p1 p2],{'Pre-lesion','Post-lesion'} ,'FontSize',18, 'Location','southeast' )
% set(leg1,'Interpreter', 'latex','FontSize',markSiz)
legend('boxoff')
sdf(gcf, 'default')
title1 = sprintf('Lesioned mice retain their ability to detect touch')
title(title1,'FontSize',22)
xlabel('Normalized pole position')
ylabel('Lick probability')

tmp = gcf;
tmp.Position = [289,108,1497,918]
%% save
savLoc = 'C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster';
cd(savLoc)
winopen(savLoc)
dateString1 = datestr(now,'yymmdd_HHMM');
svName = 'lickProb_preAndPostLesion_discrimMice';
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])

saveas(gcf, [svName, '_', num2str(dateString1),'.png'])
saveas(gcf, [svName, '_', num2str(dateString1),'.eps'])
saveas(gcf, [svName, '_', num2str(dateString1),'.fig'])

