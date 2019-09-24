function [] = plotBetasWithBasis(betas, DMsettings)

numberInEachCategory = DMsettings.numInEachLabel ;
BF = DMsettings.basisFuncs ;
bumpWidth = DMsettings.bumpWidth ;
bumpsOffset= DMsettings.bumpOffset ;
binSize= DMsettings.binSize ;
xTimePoints = DMsettings.timePoints;
labels1 = DMsettings.label;

numberInEachCategory = cumsum(numberInEachCategory);
figure;hold on
plotStrings = {'-*' '-.*' '-s' '--s'};
plotStringNum = 1;
for k = 1:length(numberInEachCategory)
    if k./7 == round(k./7)
        plotStringNum = plotStringNum+1;
    end
    if k == 1
        trimConvolvedBetasTo = range(xTimePoints(1:numberInEachCategory(k)));
        toPlot = betas(1:numberInEachCategory(k));
        [allConv, toPlot] = convolveBetasWithBumps...
            (toPlot(:)', BF{k}, bumpWidth(k), trimConvolvedBetasTo);
        
        xTimePointsTMP = xTimePoints(1:numberInEachCategory(k));
    else
        trimConvolvedBetasTo = range(xTimePoints(numberInEachCategory(k-1)+1:numberInEachCategory(k)))
        toPlot = betas(numberInEachCategory(k-1)+1:numberInEachCategory(k));
        [allConv, toPlot] = convolveBetasWithBumps...
            (toPlot(:)', BF{k},  bumpWidth(k), trimConvolvedBetasTo);
        xTimePointsTMP = xTimePoints(numberInEachCategory(k-1)+1:numberInEachCategory(k));
    end
    if numel(toPlot)>1 && bumpWidth(k)>1
        plot((0:length(toPlot)-1)+bumpsOffset(k), toPlot, plotStrings{plotStringNum});
    elseif numel(toPlot)==1
        plot(xTimePointsTMP, toPlot, '+');
    else
        plot(xTimePointsTMP, toPlot, plotStrings{plotStringNum});
        
    end
end
legend(labels1);

