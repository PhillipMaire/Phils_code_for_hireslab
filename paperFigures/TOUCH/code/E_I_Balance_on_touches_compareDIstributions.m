% calculates the difference in spiking for each touch

baysTest1 = [];
meanSPK = [];
spout = SPmaker(5, 9);
spout2 = SPmaker(5, 9);
spout3 = SPmaker(5, 9);
spkDiffs = {};

for k = theseCells(:)'
    %     try
    C = U{k};
    T = V{3, k};
    
    T2 = getSignalRegionFromVarray(T, T.plotRange);
    segs = allCellsTouch{k}.segments;
    if ~T.isSig
        
        T2.OGsigExtract = 8:20;
    end
    
    
    sigCount = nansum(T.sig(T2.OGsigExtract, :));
    
    tmp1 = find(T.plotRange==0);
    BLinds = (1+tmp1-length(T2.OGsigExtract)):tmp1;
    
    BLcount = nansum(T.sig(BLinds, :));
    
    edges1 = -10.5:1:10.5;
    [no,xo] = hist(sigCount-BLcount,edges1)
    [n,edges,bin]  = histcounts(sigCount-BLcount,edges1);
    subtracted1 = n(1+ceil(length(n)./2):end) - flip(n(1:floor(length(n)./2))) ;
    
    %         spout = SPmaker(spout);
    %         bar(edgesBetween(edges1), n)
    %         spout2 = SPmaker(spout2);
    %         bar(subtracted1)
    spout3 = SPmaker(spout3);
    n = n./size(T.sig, 2);
    plot(n(1+ceil(length(n)./2):end), 'b-')
    hold on
    plot(flip(n(1:floor(length(n)./2))), 'r-');
    %         plot(0, n(ceil(length(n)./2)), 'k*')
    
    % only during pole up times
    % same lengths
    % make sure the limit is inside the 4000 length and not before the 1 length
    %%  fake touyches to compare the distributions
    addTo = ((1:C.k)-1)*C.t;
    pDown = C.meta.poleOffset;
    pDown(pDown>C.t) = C.t;
    poleRangePeriods = colonMulti(C.meta.poleOnset+addTo, (pDown+addTo)- T2.OGsigExtract(end));
    %         T2.OGsigExtract
    tmp1 = randsample(length(poleRangePeriods),10000);
    fakeTouches = poleRangePeriods(tmp1);
    [fakeTouchInds, makeTheseNans] = getTimeAroundTimePoints(fakeTouches, T.plotRange, C.t);
    
    
    sig = C.R_ntk(fakeTouchInds);
    sig(makeTheseNans) = nan;
    sigCount = nansum(sig(T2.OGsigExtract, :));
    
    tmp1 = find(T.plotRange==0);
    BLinds = (1+tmp1-length(T2.OGsigExtract)):tmp1;
    
    BLcount = nansum(sig(BLinds, :));
    
    edges1 = -10.5:1:10.5;
    [no,xo] = hist(sigCount-BLcount,edges1)
    [n,edges,bin]  = histcounts(sigCount-BLcount,edges1);
    subtracted1 = n(1+ceil(length(n)./2):end) - flip(n(1:floor(length(n)./2))) ;
    
    %         spout = SPmaker(spout);
    %         bar(edgesBetween(edges1), n)
    %         spout2 = SPmaker(spout2);
    %         bar(subtracted1)
    %         spout3 = SPmaker(spout3);
    n = n./size(sig, 2);
    plot(n(1+ceil(length(n)./2):end), 'b--')
    hold on
    plot(flip(n(1:floor(length(n)./2))), 'r--');
    asdkf = 1
    %     catch
    %     end
end



