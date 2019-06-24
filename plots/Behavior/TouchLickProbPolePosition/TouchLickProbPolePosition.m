%% TouchLickProbPolePosition


close all

tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;1;1]
tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;2;2]

totalBias 
% tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;1]


PlesionDays = find(tmp ==0)
postLesDays = find(tmp ==1)
% recovDays = find(tmp ==2)

% PlesionDays = [nan]
% postLesDays = [1 2 3]

% figure
allPlot = struct;
theseCells = 1:length(U)
for k = theseCells
    tmpU = U{k};
    
    name1{k} = [tmpU.details.mouseName, '_', tmpU.details.sessionName];
    
    
    
    %%
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
    %% trim the file to performance region
    
    
    
    
    
    %%
    % for kk = 1:tmpU.k
    %     barPos(kk, 1:2) = tmpU.whisker.barPos{kk}(1, 2:3);
    % end
    
    %
    ansLickTime = tmpU.meta.answerLickTime;
    motPos = tmpU.meta.motorPosition;
    goPos = tmpU.meta.ranges(1);
    noGoPos =tmpU.meta.ranges(2);
    distBet = tmpU.meta.ranges(2) - tmpU.meta.ranges(1);
    
    % divide distance between poles into equal segments and get the trials inds for each
    numSeg = 11;
    edges1 = linspace(goPos ,noGoPos ,numSeg+1);
    edges1(1) = edges1(1) -200; edges1(end) = edges1(end) +200; % to capture rand shift of motor
    trialByPole = [];
    %%
    
    PLO = struct;
    for edgIter = 1:length(edges1)-1
        PLO.trialByPole{edgIter} = find((motPos>edges1(edgIter)).*(motPos<edges1(edgIter+1)));
        PLO.istouchAtEachPole{edgIter} = touchFirst(PLO.trialByPole{edgIter});
        PLO.isLick{edgIter} = ~isnan(ansLickTime(PLO.trialByPole{edgIter}));
    end
    %% binary touch in time
    rangeLoc = (1:numSeg) - (numSeg+1)./2;
    LP_touch = [];LP_noTouch = [];touchSamp = [];noTouchSamp = [];
    
    for plotIt = 1:length(edges1)-1
        TT = find(~isnan(PLO.istouchAtEachPole{plotIt}));
        NTT = find(isnan(PLO.istouchAtEachPole{plotIt}));
        LP_touch(plotIt) = mean(PLO.isLick{plotIt}(TT));
        LP_noTouch(plotIt) = mean(PLO.isLick{plotIt}(NTT));
        touchSamp(plotIt) = length(TT);
        noTouchSamp(plotIt) = length(NTT);
    end
    allPlot.LP_touch(k, 1:length(edges1)-1) = LP_touch;
    allPlot.LP_noTouch(k, 1:length(edges1)-1) = LP_noTouch;
    allPlot.touchSamps(k, 1:length(edges1)-1) = touchSamp;
    allPlot.noTouchSamp(k, 1:length(edges1)-1) = noTouchSamp;
    allPlot.rangeLoc = rangeLoc;
    %     plot(rangeLoc, LP_touch, 'g--'); hold on;
    %     plot(rangeLoc, LP_noTouch, 'r--')
    
end


%% now plot everything for when it was a cell

figure;hold on ;

alphVal = .15
for k = theseCells
    if any(PlesionDays == k)
        col1 = 'g-';
        col2 = [0 1 0 alphVal];
        W_T_LP = allPlot.LP_touch{k}.* allPlot.touchSamps(k);
        tmp = plot(allPlot.rangeLoc, allPlot.LP_touch{k}, 'color', col2);
        
    elseif any(postLesDays == k)
        col1 = 'r-';
        col2 = [1 0 0 alphVal];
        allPlot.LP_touch{k}.* allPlot.touchSamps(k);
        tmp = plot(allPlot.rangeLoc, allPlot.LP_touch{k}, 'color', col2);
        
    end
    
    
    
end
%%
figure; hold on
x1 = allPlot.rangeLoc;
y1 = nansum(allPlot.LP_touch(PlesionDays, :), 1)
N1 = nansum(allPlot.touchSamps(PlesionDays, :), 1)

% shadedErrorBar()



%%
figure; hold on 


alLMat = reshape(cell2mat( allPlot.LP_touch),numSeg, [] );
W_LP_touch.BL = nansum(alLMat(:, PlesionDays) .*allPlot.touchSamps(PlesionDays), 2)./nansum(allPlot.touchSamps(PlesionDays));

p1 = plot(allPlot.rangeLoc , W_LP_touch.BL', 'g-');

% alLMat = reshape(cell2mat( allPlot.LP_noTouch),numSeg, [] );
W_LP_touch.AL = nansum(alLMat(:, postLesDays) .*allPlot.touchSamps(postLesDays), 2)./nansum(allPlot.touchSamps(postLesDays));
p2 = plot(allPlot.rangeLoc , W_LP_touch.AL, 'r-');

W_LP_touch.AL = nansum(alLMat(:, recovDays) .*allPlot.touchSamps(recovDays), 2)./nansum(allPlot.touchSamps(recovDays));
p3 = plot(allPlot.rangeLoc , W_LP_touch.AL, 'b--');

ylim([0 1])
sdf(gcf, 'bigNclear')
%%
legend([p1 p2, p3],{'Pre-lesion','Post-lesion', '13 days post-Lesion'} ,'FontSize',18, 'Location','southeast')
legend('boxoff')
sdf(gcf, 'default')
title1 = sprintf('Lesioned mice lose the ability to discriminate touches in different locations')
title(title1,'FontSize',22)
xlabel('Normalized pole position')
ylabel('Lick probability')

tmp = gcf;
tmp.Position = [289,108,1497,918]
%% save
cd('C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster')
dateString1 = datestr(now,'yymmdd_HHMM');
svName = 'lickProb_preAndPostLesion_touchtrials';
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])

saveas(gcf, [svName, '_', num2str(dateString1),'.png'])
saveas(gcf, [svName, '_', num2str(dateString1),'.eps'])
saveas(gcf, [svName, '_', num2str(dateString1),'.fig'])



%%







%%

%%

figure;hold on ;

alphVal = .15
for k = theseCells
    if any(PlesionDays == k)
        col1 = 'g-';
        col2 = [0 1 0 alphVal];
        W_T_LP = allPlot.LP_noTouch{k}.* allPlot.noTouchSamp(k);
        tmp = plot(allPlot.rangeLoc, allPlot.LP_noTouch{k}, 'color', col2);
        
    elseif any(postLesDays == k)
        col1 = 'r-';
        col2 = [1 0 0 alphVal];
        allPlot.LP_noTouch{k}.* allPlot.noTouchSamp(k);
        tmp = plot(allPlot.rangeLoc, allPlot.LP_noTouch{k}, 'color', col2);
        
    end
    
    
    
end
%%
alLMat = reshape(cell2mat( allPlot.LP_noTouch),numSeg, [] );
W_LP_touch.BL = nansum(alLMat(:, PlesionDays) .*allPlot.noTouchSamp(PlesionDays), 2)./nansum(allPlot.noTouchSamp(PlesionDays));
p1 = plot(allPlot.rangeLoc , W_LP_touch.BL', 'g-');

% alLMat = reshape(cell2mat( allPlot.LP_noTouch),numSeg, [] );
W_LP_touch.AL = nansum(alLMat(:, postLesDays) .*allPlot.noTouchSamp(postLesDays), 2)./nansum(allPlot.noTouchSamp(postLesDays));
p2 = plot(allPlot.rangeLoc , W_LP_touch.AL, 'r-');

W_LP_touch.AL = nansum(alLMat(:, recovDays) .*allPlot.noTouchSamp(recovDays), 2)./nansum(allPlot.noTouchSamp(recovDays));
p3 = plot(allPlot.rangeLoc , W_LP_touch.AL, 'b--');

ylim([0 1])
sdf(gcf, 'bigNclear')
%%
legend([p1 p2, p3],{'Pre-lesion','Post-lesion', '13 days post-Lesion'} ,'FontSize',18, 'Location','southeast')
legend('boxoff')
sdf(gcf, 'default')
title1 = sprintf('PLACE HOLDER no touch trials')
title(title1,'FontSize',22)
xlabel('Normalized pole position')
ylabel('Lick probability')

tmp = gcf;
tmp.Position = [289,108,1497,918]
%% save
cd('C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster')
dateString1 = datestr(now,'yymmdd_HHMM');
svName = 'lickProb_preAndPostLesion_notouchtrials';
saveas(gcf, [svName, '_', num2str(dateString1),'.svg'])

saveas(gcf, [svName, '_', num2str(dateString1),'.png'])
saveas(gcf, [svName, '_', num2str(dateString1),'.eps'])
saveas(gcf, [svName, '_', num2str(dateString1),'.fig'])








