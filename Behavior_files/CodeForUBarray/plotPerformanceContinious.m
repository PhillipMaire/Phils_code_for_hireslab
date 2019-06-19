%%

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
for k = 1:length(UB(:,1))
    
    M =  UB{k};
    switchPoint(k) = find(contains(M(:,3), daysOfLesion{k}) ==1);
    figure;hold on
    set(gca, 'ColorOrder', BL(end-switchPoint(k)+1:end, :))
    addToEnd = 0;
    for kk = 1:length(M(:,1))
        sameDay =   find(contains(M(:,3),M{kk, 3}(1:6)));
        %         sameDay = find(~cellfun(@isempty, sameDay));
        S = M{kk};
        %                 Dprim = cell2mat(S.AnalysisSection_Dprime);
        if kk == sameDay(1)
            Pcorr = cell2mat(S.AnalysisSection_PercentCorrect);
        else
            keyboard
            Pcorr = [Pcorr(:); cell2mat(S.AnalysisSection_PercentCorrect)];
        end
        if kk==switchPoint(k)
            set(gca, 'ColorOrder', AL)
            %                         addToEnd = 0;
        end
        
        if max(sameDay) == kk
            Pcorr = Pcorr(40:end); % to stop it from peaking early
            if bestXnumberOfTrials == 1
                if length(Pcorr) > numBestTrials
                    tmpPcorr = smooth(Pcorr, numBestTrials);
                    cutOff = ceil(numBestTrials/2);
                    [~, indToMax] = max(tmpPcorr(cutOff+1:end-cutOff));
                    indToMax = indToMax+cutOff;
                    Pcorr = smooth(Pcorr, smoothBY);
                    Pcorr = Pcorr(indToMax-cutOff :indToMax+cutOff);
                else
                    Pcorr = smooth(Pcorr, smoothBY);
                end
            end
            
            
            
            
            toPlot = Pcorr;
            %             toPlot = toPlot(20:end);
            plot((1:length(toPlot))+addToEnd, toPlot )
            addToEnd = addToEnd+length(toPlot);
        end
        
    end
    axis tight
    ylim([0.4 1])
    ylabel('Percent Correct')
    xlabel('trial')
    plot([xlim], [0.5 0.5], 'k--')
    title(UB{k,2})
    sdf(gcf, 'bigNclear')
    %         keyboard
    cd('C:\Users\maire\Dropbox\HIRES_LAB\PLOTS\Iris_lesion_poster')
    dateString1 = datestr(now,'yymmdd_HHMM');
    saveas(gcf, [UB{k,2}, ' lesion behavior performance_', num2str(dateString1),'.fig'])
    saveas(gcf, [UB{k,2}, ' lesion behavior performance_', num2str(dateString1),'.png'])
    saveas(gcf, [UB{k,2}, ' lesion behavior performance_', num2str(dateString1),'.svg'])
    
end