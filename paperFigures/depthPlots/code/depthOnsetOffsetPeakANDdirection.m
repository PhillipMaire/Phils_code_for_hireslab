%%
crush
extractRange = -200:600; % doesnt really mtter going to just get signal regiojns anyway
%
% plot for the onset offset peak and direction of the response
limitSigTimeFromEventOnset = [100, 100, 50]; % pole up, down , and touch
try
    [Sorted1, sortedInds] = sort(cellfun(@(x) x.details.depth, U));
catch
    [Sorted1, sortedInds] = sort(cellfun(@(x) x.meta.depth, U));
    
end
theseCellsSorted = theseCells(sortedInds);
layerdEPTHS = [   0    128  269  418  588  708   890   1154 4000];
lNameCell = {  'L0' 'L1' 'L2' 'L3' 'L4' 'L5A' 'L5B' 'L6'};
Sorted1 = Sorted1(theseCells)



% [~, fdg] = max(((Sorted1(:) - layerdEPTHS(:)')<0), [], 2)
% [mp1 ] = findInARow(fdg);
% layerPlotting = fdg(find(mp1(:, 3)~=1));
% layerPlotting = [layerPlotting(1)-1; layerPlotting]
% lNameCell = lNameCell((layerPlotting))

xlabelString = {'Time from pole up (ms)' 'Time from pole down (ms)' 'Time from touch (ms)'};
for kk = 1:3 % pole up, down , and touch
    figure;
    tmp2 = [15,16,17,18,19,20;25,26,27,28,29,30;35,36,37,38,39,40;45,46,47,48,49,50;55,56,57,58,59,60;65,66,67,68,69,70;75,76,77,78,79,80;85,86,87,88,89,90;95,96,97,98,99,100];
    subplot(10, 10, tmp2(:));
    hold on
    
    for k = theseCellsSorted(:)'
        C = U{k};
        V2 = V{kk, k};
        eventTime = find(V2.plotRange==0);
        V3 = getSignalRegionFromVarray(V2, extractRange);
        V2.EnotCont = V2.EnotCont(V2.EnotCont>eventTime);
        V2.InotCont = V2.InotCont(V2.InotCont>eventTime);
        V2.EnotCont = V2.EnotCont(V2.EnotCont<eventTime+limitSigTimeFromEventOnset(kk));
        V2.InotCont = V2.InotCont(V2.InotCont<eventTime+limitSigTimeFromEventOnset(kk));
        colors1 = {'b' 'r'};
        plot(0:limitSigTimeFromEventOnset(kk), repmat(k, size(0:limitSigTimeFromEventOnset(kk)))-1, 'color', repmat(.9, [1, 3]))
        trig1 = [0 0];
        for EandI = 1:2
            
            if EandI == 1
                [segmentsOUT, matOut]  = findInARowFINAL(V2.EnotCont);
            elseif EandI == 2
                [segmentsOUT, matOut]  = findInARowFINAL(V2.InotCont);
            end
            for kk3 = 1:size(matOut, 1)
                
                x1 = matOut(kk3, 3):matOut(kk3, 4);
                
                if length(x1)>=10
                    %                 plot(x1-eventTime, repmat(C.details.depth, size(x1)), 'color', colors1{EandI})
                    %                     subplot(1, 10, 3:10); hold on
                    P = plot(x1-eventTime, repmat(k, size(x1))-1, 'color', colors1{EandI}, 'LineWidth', 3);
                    if EandI==1 && trig1(1)==0
                        trig1 = [1,trig1(2)];
                        pB = P;
                    elseif EandI==2 && trig1(1)==0
                        trig1 = [trig1(1), 1];
                        pR = P;
                    end
                    
                end
            end
        end
    end
    axis tight
    ylim([-.5, length(theseCellsSorted)-.5])
    fixPLotTicks([0 1 1])
    xlabel(xlabelString{kk})
    %%
    tmp2 = [11,12,13,14;21,22,23,24;31,32,33,34;41,42,43,44;51,52,53,54;61,62,63,64;71,72,73,74;81,82,83,84;91,92,93,94];
    
    subplot(10, 10, tmp2(:));
    hold on
    
    %     layerdEPTHS =     [0, 128  269  418  588   708   890   1154];
    %     lNameCell = {'nan' 'L1' 'L2' 'L3' 'L4' 'L5A' 'L5B' 'L6'};
    
    plotPlace = zeros(length(lNameCell), 1);
    for kk4 = 1:length(layerdEPTHS)
%         tmp1 =  find(((Sorted1 -   layerdEPTHS(kk4))>0), 1, 'first');
       plotPlace(kk4) = 122- sum(((Sorted1 -   layerdEPTHS(kk4))>0))
%         if isempty(tmp1) 
%             tmp1 = plotPlace(kk4-1)+1;
%         end
%         plotPlace(kk4) = tmp1;
    end
%     kk4 = kk4+1
% % % % %     plotPlace = [plotPlace; length(Sorted1)]
    %     plotPlace(1:find(plotPlace==1, 1, 'last')-1) = 0;
    plotPlace(plotPlace==1) = .5;
    plotPlace = plotPlace-.5;
    
    
    
    for kk4 = 1:length(lNameCell)-1
        R = rectangle('Position', [layerdEPTHS(kk4), plotPlace(kk4),...
            (layerdEPTHS(kk4+1)-layerdEPTHS(kk4)) , (plotPlace(kk4+1) -plotPlace(kk4))]);
        R.FaceColor = [.5 .5 .5]
        R.EdgeColor = 'none'
        
    end
    
    P = plot(Sorted1, 0:length(U)-1, 'k.', 'MarkerSize', 12);
    %     keyboard
    fixPLotTicks([0 1 1])
    xlabel('Depth (microns)')
    
    asdflk = [0; diff(plotPlace)];
    tmp1 = find(asdflk~=0);
    axis tight
    xlim([layerdEPTHS(tmp1(1)-1), layerdEPTHS(tmp1(end))+60])
    
    plotPlace2 = mean([plotPlace(:)'; circshift(plotPlace(:)', 1)])
    for kk5 = 1:length(plotPlace)
        if asdflk(kk5)~=0
            text(min(xlim)-150, plotPlace2(kk5), lNameCell{kk5})
        end
    end
    
    %{
    as psth of excited and inhibted responses for the length of the time it
    is significant also add a psth on the bottom of the onsets for each
    cell type binned in like 5 ms bins 
    
    
    %}
%     subplot(10, 10, 1:10);
    
%     legend([pB, pR], {'Excited response', 'Inhibited response'}, 'location', 'Northoutside')
end

%{
% - turn off y axis on the big plot
% - set the side plot to a standard size
% - demarcate the layers and sublayers in the .5 space between region
% % - add a gradient to each layer and sublayer to give intuition about the depth
% - ad peaks to each response
%}
% % % % L1, 128 ± 1mm
% % % % L2, 269 ± 2mm
% % % % L3, 418 ± 3mm
% % % % L4, 588 ± 3mm
% % % % L5A, 708 ± 4mm
% % % % L5B,890 ± 5mm
% % % % L6, 1154 ± 7mm



% xlim([0, 100])
% ylim([0, 1200])