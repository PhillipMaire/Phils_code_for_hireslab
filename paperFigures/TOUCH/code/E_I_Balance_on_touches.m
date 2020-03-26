% calculates the difference in spiking for each touch

baysTest1 = [];
meanSPK = [];
spout = SPmaker(5, 9);
spout2 = SPmaker(5, 9);
spout3 = SPmaker(5, 9);
spkDiffs = {};

for k = [1 16 17 18]%1:length(U)
    try
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
        
        spout = SPmaker(spout);
        bar(edgesBetween(edges1), n)
        spout2 = SPmaker(spout2);
        bar(subtracted1)
        spout3 = SPmaker(spout3);
        plot(n(1+ceil(length(n)./2):end))
        hold on
        plot(flip(n(1:floor(length(n)./2))));
        
        figure
        tmp2 = nan(size(squeeze(C.R_ntk)));
        tmp2(segs(:, 1)) =  bin-ceil(length(n)./2);
        spkDiffs{k} = bin-ceil(length(n)./2);
        [Sorted1, Sinds] = sort(spkDiffs{k});
        
        
        %     canceledOutEvents = segs(find( bin-ceil(length(n)./2) == 0 ), 1);
        %     tmp2 = imgaussfilt(tmp2, [10, .1])';
        %     tmp2(canceledOutEvents+ 1:10) = nan(1);
        
        tmp2 = ndnanfilter(tmp2,'hamming',[10, 0]);
        imagescnan(round(tmp2'));
        colormap(jet);
        colorbar;
        
        caxis([-max(abs(caxis)), max(abs(caxis))])
        title(num2str(k))
        set(gca,'Color',[.3 .3 .3])
        %%
        [touchExtractInd, makeTheseNans] = getTimeAroundTimePoints(segs(Sinds, 1), -50:100, C.t);
        spk1 = squeeze(C.R_ntk);
        Trast = spk1(touchExtractInd);
        Trast(makeTheseNans) = nan;
        figure
        subplot(1, 10, 3:10)
        imagesc(Trast')
        subplot(1, 10, 1:2)
        plot(flip(Sorted1), 1:length(Sorted1));
        axis tight
        title(num2str(k))
        % % % % %   fullscreen;pause(2);      saveas(gcf, ['C:\Users\maire\Dropbox\tmpsave\diffInSpike\JON_' num2str(k) '_rastDiffInSpikes'], 'png');close
        %%
        tmp3 = round(tmp2');
        tmp10 = unique(tmp3);
        tmp10 = tmp10(~isnan(tmp10));
        spout4 = SPmaker(3, 3);
        GfiltParams = [5, 40];
        im12 = {};
        tmp10 = intersect(-4:4, tmp10)
        for kk = 1:length(tmp10)
            
            spout4 = SPmaker(spout4);
            D1 = ndnanfilter(tmp3==tmp10(kk), 'hamming',  GfiltParams);
            D1 = fixGaussFilt(D1, GfiltParams);
            im12{kk} = imagescnan(D1);
            title(num2str(tmp10(kk)))
            % % % %         set(gca,'Color',[.3 .3 .3])
            colormap(turbo);
            
            
        end
        %     spout4 = SPmaker(spout4);
        %     im12{kk} = imagescnan(D1);
        %     title('colorbar')
        
        
        setMaxTo = cellfun(@(x) max(x.CData(:)), im12);
        setMaxTo(find(tmp10==0)) = 0;
        setMaxTo = max(setMaxTo);
        for kk = 1:length(tmp10)
            try% if setToMax is 0 it will error out
                spout4.allSubPlots{1}{kk}.CLim = [0, setMaxTo]
            catch
            end
            if kk == length(tmp10)
                colorbar
            end
        end
        
        suplabel(num2str(k), 't')
        
        % % % % %           fullscreen;pause(2);saveas(gcf, ['C:\Users\maire\Dropbox\tmpsave\diffInSpike\JON_' num2str(k) '_heatDiffInSpikes2'], 'png');close
        dumsk9 = 1
        %     cellfun(@(x) x.,im12 )
        
        %     max(x.CData(:))
        %%
        %{
    could just convlve with a square wave in a for loop to capture each touch better and allow for
    simple integers
    
    have to check for edge effects and fix them ans make sure that the heat map color indicated the
    same frequency for each plot!!!
        %}
    catch
    end
%     keyboard
end
%% make curves in an attept to explain these differences
% for k = 1:length(U)
%     C = U{k};
%     T = V{3, k};
%
%     T2 = getSignalRegionFromVarray(T, T.plotRange);
%     segs = allCellsTouch{k}.segments;
%     [maxDeltaTrialTimeInd, maxDeltaKappa, Sind, absMaxKappaINDS, Tcell] = testin999(C, start1, stop1);
%
%
% end




