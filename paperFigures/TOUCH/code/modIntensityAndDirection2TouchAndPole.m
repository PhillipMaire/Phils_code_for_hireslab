% modintensity and direction

%% (sig-meanBL)./STD(BL);
ZSsig = {};
sigAll = {};
sigMeanAll = nan(4, length(U));
V(4, :) = V(3, :); % duplicate the last row for protraction and retraction touches.
CIall = nan(4, length(U));

for k = theseCells(:)'
    for Type1 = 1:4
        
        C = U{k};
        V2 = V{Type1, k};
        if V2.isSig% is significant?
            
            if ~isempty(V2.Efirst)
                sigInd = V2.Efirst;
            elseif ~isempty(V2.Ifirst)
                sigInd = V2.Ifirst;
            else
                error('wha happin'' -_-')
            end
            if Type1 == 3
                TouchIndKeep = (V2.protractionTouches==1);
            elseif Type1 == 4
                TouchIndKeep = ~(V2.protractionTouches==1);
            else
                TouchIndKeep = 1:size(V2.sig, 2);
            end
            TouchIndKeep = TouchIndKeep==1;
            %             sig1 = V2.sig(sigInd, TouchIndKeep);
            %             BL = nanmean(V2.BL(:, TouchIndKeep), 2);
            BL = nanmean(V2.sig(find(V2.plotRange<=0), TouchIndKeep), 2);
            BL_STD = nanstd(BL(:));
            BL_MEAN = nanmean(nanmean(V2.BL(:, TouchIndKeep)));
            sig2 = nanmean(V2.sig(:, TouchIndKeep), 2) - BL_MEAN;
            tmp1 = nanmean(V2.sig(:, TouchIndKeep), 1);
            ZSsig{Type1, k} = sig2./BL_STD;
            tmp1 = tmp1./BL_STD;
            sigAll{Type1, k} = ZSsig{Type1, k}(sigInd);
            sigMeanAll(Type1, k) = nanmean(sigAll{Type1, k});
            [~ , CIall(Type1, k)] = philsCIs(tmp1 , .05, length(tmp1));
        end
    end
end
% plot the touches


tmp1 = sigMeanAll(1:2, :);
toPlotPole = tmp1(:, all(~isnan(tmp1), 1));
CIallPole = CIall(1:2, all(~isnan(tmp1), 1));


tmp1 = sigMeanAll(3:4, :);
toPlotTouch = tmp1(:, all(~isnan(tmp1), 1));
CIallTouch = CIall(3:4, all(~isnan(tmp1), 1));
%%

s = {};

figure
EB = errorbar(toPlotPole(1, :), toPlotPole(2, :), -CIallPole(2,:), CIallPole(2,:),-CIallPole(1,:) ,CIallPole(1,:) , 'LineStyle','none');
hold on
EB.Color = 'k';
EB.LineWidth = 2;
EB.CapSize = 0
labelALL('Pole up VS Pole down response','Z-scored Pole Up response','Z-scored Pole Down response','')

s{1} = scatter(toPlotPole(1, :), toPlotPole(2, :), 'k', 'filled')
equalAxes([], 'same')
% logifyFig({'x', 'y'}, 2, .125, [], 1)
h = plotLine(2:3)

%%

figure
hold on

EB = errorbar(toPlotTouch(1, :), toPlotTouch(2, :), -CIallTouch(2,:), CIallTouch(2,:),-CIallTouch(1, :) ,CIallTouch(1,:) , 'LineStyle','none');

EB.Color = 'k';
EB.LineWidth = 2;
EB.CapSize = 0
s{2} = scatter(toPlotTouch(1, :), toPlotTouch(2, :), 'k', 'filled')
ylim([-32, 32]);% set to match the other plot])
equalAxes([], 'same')

%  logifyFig({'x', 'y'}, 2, .125, [], 2)
plotLine(2:3)
labelALL('Protraction VS Retraction touch response','Z-scored Protraction Touch response','Z-scored Retraction Touch response','')



%% all together

s = {};

figure
EB = errorbar(toPlotPole(1, :), toPlotPole(2, :), -CIallPole(2,:), CIallPole(2,:),-CIallPole(1,:) ,CIallPole(1,:) , 'LineStyle','none');
hold on
EB.Color = 'k';
EB.LineWidth = 2;
EB.CapSize = 0
labelALL('Pole up VS Pole down response','Z-scored Pole Up response/protraction','Z-scored Pole Down response/retraction ','')

s{1} = scatter(toPlotPole(1, :), toPlotPole(2, :), 'k', 'filled')



EB = errorbar(toPlotTouch(1, :), toPlotTouch(2, :), -CIallTouch(2,:), CIallTouch(2,:),-CIallTouch(1,:) ,CIallTouch(1,:) , 'LineStyle','none');
hold on
EB.Color = 'b';
EB.LineWidth = 2;
EB.CapSize = 0
s{2} = scatter(toPlotTouch(1, :), toPlotTouch(2, :), 'b', 'filled')


equalAxes([], 'same')
logifyFig({'x', 'y'}, 2, .125, [], 1)
% logifyFig({'x', 'y'}, 10, .1, [], 1)
h = plotLine(2:3)
legend([s{1}, s{2}], 'pole', 'touch')
%% all together  no log limit at 5
limTo = 10
toPlotPole2 = toPlotPole;
toPlotPole2(abs(toPlotPole2)>=limTo) = limTo*(toPlotPole2(abs(toPlotPole2)>=limTo)./abs(toPlotPole2(abs(toPlotPole2)>=limTo)))
toPlotTouch2 = toPlotTouch;
toPlotTouch2(abs(toPlotTouch2)>=limTo) = limTo*(toPlotTouch2(abs(toPlotTouch2)>=limTo)./abs(toPlotTouch2(abs(toPlotTouch2)>=limTo)))

s = {};

figure
EB = errorbar(toPlotPole2(1, :), toPlotPole2(2, :), -CIallPole(2,:), CIallPole(2,:),-CIallPole(1,:) ,CIallPole(1,:) , 'LineStyle','none');
hold on
EB.Color = 'k';
EB.LineWidth = 2;
EB.CapSize = 0
labelALL('Pole up VS Pole down response','Z-scored Pole Up response/protraction','Z-scored Pole Down response/retraction ','')

s{1} = scatter(toPlotPole2(1, :), toPlotPole2(2, :), 'k', 'filled')



EB = errorbar(toPlotTouch2(1, :), toPlotTouch2(2, :), -CIallTouch(2,:), CIallTouch(2,:),-CIallTouch(1,:) ,CIallTouch(1,:) , 'LineStyle','none');
hold on
EB.Color = 'b';
EB.LineWidth = 2;
EB.CapSize = 0
s{2} = scatter(toPlotTouch2(1, :), toPlotTouch2(2, :), 'b', 'filled')

xlim([-limTo, limTo])
ylim([-limTo, limTo])
% logifyFig({'x', 'y'}, 2, .125, [], 1)
% logifyFig({'x', 'y'}, 10, .1, [], 1)
h = plotLine(2:3)
legend([s{1}, s{2}], 'pole', 'touch')
%%
toPlotTouchABS = abs(toPlotTouch);
MI = (toPlotTouchABS(1, :) - toPlotTouchABS(2, :)) ./ (toPlotTouchABS(1, :) + toPlotTouchABS(2, :))
figure;
 hist(MI, 11)
xlim([-1, 1])
labelALL('Protraction modulation Index', 'Modulation index ((P-R)/(P+R))', 'Count')
%%
% crush
% A = rand(1, 1000000);
% B = rand(1, 1000000);
% C = (A-B)./(A+B);
% figure
% hist(C, 51)




