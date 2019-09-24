function [allConv, allConvSummed] = convolveBetasWithBumps...
    (betas, allBumps, widthBumps, trimConvolvedBetasTo);
if ~(widthBumps==1);%if there are actually no basis functions
    
    betas = betas(:)';
    allConv = [];
    % allBumps = squeeze(sum(reshape(allBumps, binSize, [], size(allBumps, 2)), 1));
    
    for k = 1:length(betas)
        allConv(:, k) = conv(betas(k),allBumps(:, k) );
    end
%     allConvBinned = squeeze(sum(reshape(allConv, binSize, [], size(allConv, 2)), 1));
%     allConvSummed = sum(allConvBinned, 2);
% trim it 
allConv = allConv(1:trimConvolvedBetasTo , :);
allConvSummed =sum(allConv, 2);
else
    allConv = betas;
    allConvSummed = betas;
end




%{
add binSize to make the size the correct size
also sum it and output an x for plotting in ms units
make sure you account for the shift as well


%}