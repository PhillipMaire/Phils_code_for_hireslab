

%% plot pole up/down resonses response

xlim1 = [-50 500];
smoothBy = 1;
spout = SPmaker(2, 3, 1);
for kk = 1:2
    for k = theseCells
        C = U{k} ;
        if kk == 1
            sigZero = mode(C.meta.poleOnset);
        else
            sigZero = mode(C.meta.poleOffset);
        end
        
        Y = squeeze(C.R_ntk);
        [Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
        
        spout = SPmaker(spout);
        plot(Stime-sigZero,Strial , '.')
        axis tight
        if k == 1
            ylabel('Trials');
        end
        
        spout = SPmaker(spout);
        plot((1:C.t)- sigZero,smooth(mean(Y, 2).*1000, smoothBy))
        axis tight
        if k == 1
            ylabel('Spikes/Sec');
        end
        
        
        linkaxes(spout.mainFig.Children(:), 'x')
        xlim(xlim1)
        
    end
    if kk == 1
        [A1, H1] = supLabel_ALL([],'Time from pole up trigger (ms)',  [], []);
    else
        [A1, H1] = supLabel_ALL([],'Time from pole down trigger (ms)',  [], []);
    end
end