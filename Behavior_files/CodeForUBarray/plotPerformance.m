%%
BL = (brewermap(17, 'Greens'));
BL = BL(end-13:end-2, :);
AL = flip(brewermap(17, 'Reds'));
AL = AL(2:14, :)


close all
switchPoint = [4, 7, 9, 6]; %index of 1st day of lesion
for k = 1:length(UB(:,1))
    
    M =  UB{k};
    
    
    figure;hold on
    set(gca, 'ColorOrder', BL(end-switchPoint(k)+1:end, :))
    for kk = 1:length(M(:,1))
        sameDay =   strfind(M(:,3),M{kk, 3}(1:6));
        sameDay = find(~cellfun(@isempty, sameDay));
        S = M{kk};
        %         Dprim = cell2mat(S.AnalysisSection_Dprime);
        if kk == sameDay(1)
            Pcorr = cell2mat(S.AnalysisSection_PercentCorrect);
        else
            Pcorr = [Pcorr(:); cell2mat(S.AnalysisSection_PercentCorrect)];
        end
        if kk==switchPoint(k)
            set(gca, 'ColorOrder', AL)
        end
        
        if max(sameDay) == kk
            toPlot = smooth(Pcorr, 10);
            toPlot = toPlot(20:end);
            plot(toPlot)
            
        end
        
    end
    ylim([0.4 1])
end