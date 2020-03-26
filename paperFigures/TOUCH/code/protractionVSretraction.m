%% protraction vs retractions
%%
touchPvR = {}
notSigWindow = 8:40;

for kk= 1:2
    for k =theseCells(:)'
        V2 = V{3, k};
        if kk == 1;
            sig = V2.sig(:, V2.protractionTouches==1);
        elseif kk == 2
            sig = V2.sig(:, V2.protractionTouches==0);
        end
        
        if V2.ModDirection>0 %excited
            sig = sig(V2.Efirst , :);
        elseif V2.ModDirection<0%inhibited
            sig = sig(V2.Ifirst , :);
        else% insignificant
            ind1 = find(V2.plotRange == notSigWindow(1));
            ind1 = ind1:ind1+length(notSigWindow)-1;
            sig = sig(ind1 , :);
        end
        touchPvR{kk, k}.sem = sem(sig(:));
        touchPvR{kk, k}.Mean = nanmean(sig(:));
        touchPvR{kk, k}.isSig = V2.isSig
        
        
    end
end

%% plot it
crush
h = figure; hold on
means = 1000.*(cellfun(@(x) x.Mean, touchPvR))';
sem1 = 1000.*(cellfun(@(x) x.sem, touchPvR))';

modDir = (cellfun(@(x) x.ModDirection, V(3, :)));
colorInds{1} = modDir>0;%excited
colorInds{2} = modDir<0;%inhibted
colorInds{3} = modDir==0;%not sig
colors1 = {'b' 'r' 'k'}
p1 = {}; e1= {};
for k = flip(1:3)
    inds1 =  colorInds{k};
    e1{k} = errorbar(means(inds1, 2), means(inds1, 1), ...
        -sem1(inds1, 1), sem1(inds1, 1), -sem1(inds1, 2), sem1(inds1, 2), 'LineStyle','none');
    
    e1{k}.Color = colors1{k};
    e1{k}.CapSize = 0;
    e1{k}.LineWidth = 1.5
    P1{k} = scatter(means(inds1, 2), means(inds1, 1), colors1{k});
    if k~=3
        P1{k}.MarkerFaceColor = colors1{k};
    else
        P1{k}.MarkerFaceColor = 'w';
    end
    
end
xlabel(sprintf('Spikes/sec Retraction'));
ylabel(sprintf('Spikes/sec Protraction'));
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
axis tight
axis square

title('Protraction VS Retraction touch response')
ylim([10.^-2,  10.^3]);


equalAxes(h)
plotDiag(h)
fixErrorBarsOnLogLogPlot(e1)
legend([P1{1}, P1{2}, P1{3}], 'Significantly Excited', 'Significantly Inhibited', 'Insignificant', 'Location', 'northwest')
tmp1 = yticklabels;
yticklabels(['0'; tmp1(2:end)])
tmp1 = xticklabels;
xticklabels(['0'; tmp1(2:end)])
%%



if saveOn
    saveNames = {'Pro_VS_Ret_touchResponses'};
    
    cd(saveDir)
    fullscreen(h)
    fn = [saveNames{k}, '_', dateString1];
    saveFigAllTypes(fn, h, saveDir, 'protractionVSretraction.m');
    winopen(saveDir)
end
















