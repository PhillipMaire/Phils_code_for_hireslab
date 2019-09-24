function [] = plotBetas(Betas, numberInEachCategory, varargin)
% dont make the first number 1 unless there is only 1 in that category for example if the first 5
% variables are the smae but just time shifted then put 5 as the first number not 1.
% if nargin >2
%     labels1 = varargin{1};
% else
%     labels1 = cell(1,length(numberInEachCategory));
%     labels1(:) = {''};
% end

numberInEachCategory = cumsum(numberInEachCategory);
figure;
hold on
if nargin>3
    xTimePoints = varargin{2};
else
    xTimePoints = [];
    for k = 1:length(numberInEachCategory)
        xTimePoints = [xTimePoints, 1:numberInEachCategory(k)];
    end
    
end

plotStrings = {'-*' '-.*' '-s' '--s'};
plotStringNum = 1;
for k = 1:length(numberInEachCategory)
if k./7 == round(k./7)
plotStringNum = plotStringNum+1;
end
    if k == 1
        toPlot = Betas(1:numberInEachCategory(k));
        xTimePointsTMP = xTimePoints(1:numberInEachCategory(k));
    else
        toPlot = Betas(numberInEachCategory(k-1)+1:numberInEachCategory(k));
        xTimePointsTMP = xTimePoints(numberInEachCategory(k-1)+1:numberInEachCategory(k));
    end
    if numel(toPlot)>1
        plot(xTimePointsTMP, toPlot, plotStrings{plotStringNum});
    else
        plot(xTimePointsTMP, toPlot, '+');
    end
end
if nargin >2
    labels1 = varargin{1};
    legend(labels1);
end
