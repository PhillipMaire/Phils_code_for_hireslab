%%

cellMouseInds  = uniqueStringsInCellArray(cellfun(@(x) x.details.mouseName, U, 'UniformOutput',false));
%%
%{
poleStruct
latencyStructPole
touchStruct
latencyStructTouch
%}
%% params
xlims1 = [-40, 160];
BLshift = -70:-20; % region used to shift BL to 0
smoothBy =6;
%% these are unsmoothed
p_upC = poleStruct.allpolesCell(:,1);
p_downC = poleStruct.allpolesCell(:,2);
t_proC = touchStruct.allTouchPro';
t_retC = touchStruct.allTouchRet';
poleTime = (1:size(p_upC{1}, 2)) -poleStruct.pvalsAll{1,4};% minus the time of the signal
touchTime = (1:size(t_proC{1}, 2)) -touchStruct.pvalsAll{1,4};% minus the time of the signal
%% get smoothed and nanmeaned signals (in spk/S)
% make sure the order of all these match
p_up = cellfun(@(x) smooth(x, smoothBy), cellfun(@(x) nanmean(x, 1), p_upC, 'UniformOutput', false), 'UniformOutput', false);  p_up = cell2mat(p_up');
p_down = cellfun(@(x) smooth(x, smoothBy), cellfun(@(x) nanmean(x, 1), p_downC, 'UniformOutput', false), 'UniformOutput', false); p_down = cell2mat(p_down');
t_pro = cellfun(@(x) smooth(x, smoothBy), cellfun(@(x) nanmean(x, 1), t_proC, 'UniformOutput', false), 'UniformOutput', false); t_pro = cell2mat(t_pro');
t_ret = cellfun(@(x) smooth(x, smoothBy), cellfun(@(x) nanmean(x, 1), t_retC, 'UniformOutput', false), 'UniformOutput', false); t_ret = cell2mat(t_ret');
sigStrs = {...
    'p_up', 'p_down', 't_pro', 't_ret'; ...
    'poleTime','poleTime','touchTime','touchTime'; ...
    'Pole Up','Pole Down','Protraction Touch','Retraction Touch', ...
    };
isSIG =[latencyStructPole.proRetTouchSignif,latencyStructTouch.proRetTouchSignif];
%%
cd ('C:\Users\maire\Documents\PLOTS\ANIMAL_ANALYSIS\eachCellFromEachAnimal')% place to save
close all
original_color_order=get(0,'DefaultAxesColorOrder');
miceNames = cellMouseInds.uniqueStrings;
miceCellInds = cellMouseInds.linInds;
for k = 1:length(miceNames)% mice
    cells1 = find(miceCellInds(:,k));
    [SPout] = SPmaker(1, 4);
    for sigType = 1:size(sigStrs, 2)% type of sligned signal
        sig1 = eval([sigStrs{1, sigType}]);
        time1 = eval([sigStrs{2, sigType}]);
        %         figure; hold on
        [SPout] = SPmaker(SPout); hold on
        title([sigStrs{3, sigType}])
        if sigType ==1 ;title([miceNames{k}, ' ',  sigStrs{3, sigType}]);end
        set(0,'DefaultAxesColorOrder',original_color_order);
        for kk = 1:length(cells1)% for each cell in the mouse
            isSig2 = isSIG(cells1(kk), sigType);
            sig2 = sig1(:, cells1(kk));
            sig2 = meanNorm(sig2);
            %             sig2 = sig2/(std(sig2));
            sig2 = sig2 - nanmean(sig2(BLshift+time1(end)));
            
            tmp = line(time1, repmat(kk, size(time1)));tmp.Color = [0 0 0 .5]; tmp.LineStyle = '--';tmp.MarkerSize = 4;
            
            tmp3 = plot(time1, sig2 + (kk/1));
            SDsig = std(sig2(find(time1<0)));
            SDsig(isnan(SDsig)) = 0;
            SDsig(SDsig>.5) = .5;
            pos = [ time1(1) ,kk-SDsig,length(time1) ,SDsig*2 ];
            tmp2 = rectangle('Position',pos, 'FaceColor', [tmp3.Color, .2], 'EdgeColor', 'none');
            if isSig2 ==1; plot(xlims1(1), kk+.15, '*r'); end
        end
        xlim(xlims1); line([0 0], ylim, 'Color', [0 0 0 .2])
        
    end
    
    saveas(gcf, miceNames{k}, 'svg')
    % % saveas(gcf, miceNames{k}, 'pdf')
    
end
%% make pie charts or similr
close all
isSIG2 = double(([sum(isSIG(:,1:2), 2) ,sum(isSIG(:,3:4), 2)])>0);
% isSIG2(:,2) = 2*isSIG2(:,2);
% isSIG2 = sum(isSIG2,2); % 3 pole+touch    2just Touch   1 just pole    0 neither 
for k = 3:length(miceNames)% mice
    cells1 = find(miceCellInds(:,k));
    numCellsStr = num2str(num2str(length(cells1)));
    tmp = confusionmat(isSIG2(cells1, 1), isSIG2(cells1, 2));
    figure;
    pie(tmp+0.00000000000001,[1 1 1 1], {...
        ['neither ' num2str(tmp(1)) '/' numCellsStr], ...
        ['pole only ' num2str(tmp(2)) '/' numCellsStr], ...
        ['touch only ' num2str(tmp(3)) '/' numCellsStr], ...
        ['both ' num2str(tmp(4)) '/' numCellsStr]...
        })
%     [~, count1] = find(isSIG2(cells1,:) >0);
%     [a,~]=hist(count1,unique(count1));
    keyboard
      saveas(gcf, [miceNames{k}, 'PIE'], 'png')
end
%%
% %% test the distribution
%
% % hist(p_down,
% smoothBy = 200;
% [no,xo] = hist(smooth(p_down(1, :), smoothBy), 50);
% figure;plot(no)