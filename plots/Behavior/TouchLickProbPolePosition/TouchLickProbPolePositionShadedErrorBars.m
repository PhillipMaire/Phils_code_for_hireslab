%%

%% TouchLickProbPolePosition


close all

tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;1;1]


% PlesionDays = [nan]
% postLesDays = [1 2 3]

% figure
allPlot = struct;
theseCells = 1:length(U)
polePos = [];
% counter1 = 0
allMat = {}
for k = theseCells
    %     counter1 = counter1+1;
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
    
    ansLickTime = tmpU.meta.answerLickTime;
    motPos = tmpU.meta.motorPosition;
    goPos = tmpU.meta.ranges(1);
    noGoPos =tmpU.meta.ranges(2);
    distBet = tmpU.meta.ranges(2) - tmpU.meta.ranges(1);
    allMat{1,k}(:, 1) = ansLickTime;
    allMat{1,k}(:, 2) = motPos;
    allMat{1,k}(:, 3) = touchFirst;
    
    
    
    polePos(k, 1) = goPos;
    polePos(k, 2) = noGoPos;
    polePos(k, 3) = distBet;
    % allCell{k, 4} = noGoPos;
    % allCell{k, 5} = distBet;
    %%
    
    % divide distance between poles into equal segments and get the trials inds for each
    numSeg = 11;
    edges1 = linspace(goPos ,noGoPos ,numSeg+1);
    edges1(1) = edges1(1) -200; edges1(end) = edges1(end) +200; % to capture rand shift of motor
    trialByPole = [];
    %%
    
    polBins = []
    for edgIter = 1:length(edges1)-1
        polBins(:, edgIter) = logical(motPos>edges1(edgIter)).*(motPos<edges1(edgIter+1));
        
    end
    allMat{2,k} = polBins;
    allMat{3,k}= polePos;
end

%% allMat
% trials by pole position by touch/notouch

tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;2;2];


% tmp = [0;0;0;1;1;1;0;0;1;1;1;1;1;1]


Group1{1} = find(tmp ==0);
Group1{2} = find(tmp ==1);
Group1{3} = find(tmp ==2);


allGroups = {};
for Gs = 1:length(Group1)
    allCell = {}
    allMat2 = allMat(:, Group1{Gs})
    
    for TT_NT = 1:2 % touch or no touch
        
        for k = 1:size(allMat2, 2) % session
            licks = ~isnan(allMat2{1,k}(:,1));
            if TT_NT == 1
                touchInds = ~isnan(allMat2{1,k}(:,3));%touches
            else
                touchInds = isnan(allMat2{1,k}(:,3)); %no touches
            end
            for kk = 1:numSeg % pole positions bins
                poleInds = logical(allMat2{2, k}(:, kk));
                
                
                
                tmp1 = licks(find(poleInds(:) .* touchInds(:)));
                allCell{kk, TT_NT,k} =tmp1;
                
            end
            %             keyboard
        end
        %         keyboard
    end
    allGroups{Gs} = allCell;
end

%% allGroups each cell is a different group
%% in those it goes pole position by touch(yes vs no ) by session
allPoints = [];
ci = {};
for Touc = 1:2
    allGroupsTT = allGroups
    for G = 1:length(allGroups)
        Gtmp = allGroups{G}(:,Touc ,:);
        
        for P = 1:size(Gtmp, 1)
            licksTMP = [];
            for ses = 1:size(Gtmp, 3)
                licksTMP = [licksTMP; Gtmp{ P, :, ses}];
            end
            % this is where you can perform statistics like CIs and SEM
            pd = fitdist(licksTMP,'normal')
            SEM_licks(Touc,G, P) = std(licksTMP)/sqrt(length(licksTMP));
            ciTMP = paramci(pd,'Alpha',0.1)
            allPoints(Touc,G, P, 1) = nanmean(licksTMP);
            allPoints(Touc,G, P, 2) = ciTMP(1);
            allPoints(Touc,G, P, 3) = ciTMP(2);
            ci{Touc, G, P} = ciTMP;
%             ciTMP
%            keyboard 
        end
    end
    
end
%%
close all
figure; hold on
rangeLoc = (1:numSeg) - (numSeg+1)./2;
G = 1; TT = 1;

shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), [squeeze(allPoints(TT, G, :, 2)), squeeze(allPoints(TT, G, :, 3))],'lineprops',{'-go','MarkerFaceColor','g'})
G = 2
shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), [squeeze(allPoints(TT, G, :, 2)), squeeze(allPoints(TT, G, :, 3))],'lineprops',{'-ro','MarkerFaceColor','r'})

G = 3
shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), [squeeze(allPoints(TT, G, :, 2)), squeeze(allPoints(TT, G, :, 3))],'lineprops',{'-bo','MarkerFaceColor','b'})

ylim([0 1])

%%
close all
figure; hold on
rangeLoc = (1:numSeg) - (numSeg+1)./2;
G = 1; TT = 1;
shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), squeeze(SEM_licks(TT, G, :)).*[1, 1] ,'lineprops',{'-go','MarkerFaceColor','g'})
G = 2
shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), squeeze(SEM_licks(TT, G, :)).*[1, 1],'lineprops',{'-ro','MarkerFaceColor','r'})
G = 3
shadedErrorBar(rangeLoc, allPoints(TT, G, :, 1), squeeze(SEM_licks(TT, G, :)).*[1, 1],'lineprops',{'-bo','MarkerFaceColor','b'})
ylim([0 1])




