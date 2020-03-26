%% pole location at touch




smoothBy = 10;

k = 1
C = U{k}

binSize = 10000; %microsteps
%% issues:
% 1) one rough pole position messing up the length or distnace of the poles
% 2) some cells only have 80000 microsteps in them, how should I deal with that? split them equally
% or have blanks on the edges. Or I could have the tuning of the pole positions based on the resting
% whisker position
% figure
% fullscreen([], 1)
Polebins = {};
range1 = [];
for k = 1:length(U)
    C = U{k};
    Pgo = C.meta.goPosition;
    Pno = C.meta.nogoPosition;
    PP = C.meta.motorPosition;
    range1(k) = range(PP);
    PP = PP-min(PP(:));
    edges = (0:binSize:max(PP)+binSize-1)
    [N,edges, Polebins{k}] = histcounts(PP, edges)
end





%% touch
nPoleSegs = cellfun(@(x) length(unique(x)), Polebins);
poleLocLinIndsTouch = {};
sig1 = {};
thetaMean = {};
for k = 1:length(U)
    C = U{k};
    A = allCellsTouch{k};
    thetaMeanTmp = [];
    for kk = 1:nPoleSegs(k)
        tmp1  = find(Polebins{k} == kk);
        
        [poleLocLinIndsTouch{k, kk}, ~] = find((A.segments(:, 4) - tmp1)==0);%find the inds for all the trials in this bin 
        theta1 = (C.S_ctk(1, :, :));
        thetaMeanTmp(kk) = nanmean(theta1(A.segments(poleLocLinIndsTouch{k, kk}, 1)));
        
        sig1{k, kk} = A.SIG(:, poleLocLinIndsTouch{k, kk});
    end
    thetaMean{k} = thetaMeanTmp;
end


%% plot it for touch 
crush
spout = SPmaker(5, 9);
for k = 1:length(U)
    sig = sig1(k, :);
    notEmpty = (~cellfun(@isempty, sig));
    toPlot = nan(length(sig), size(sig{find(notEmpty, 1, 'first')}, 1)) ;
    for kk = 1:sum(notEmpty)
        if any(find(notEmpty) == kk)
            toPlot(kk,:)  =  smooth(nanmean(sig{kk}, 2), smoothBy);
        end
    end
    toPlot = smoothEdgesNan(toPlot', smoothBy)
    spout = SPmaker(spout);
    imagescnan(toPlot');
    hold on 
    xticklabels(xticks-find(allCellsTouch{k}.plotRange    ==0)+1);
% keyboard

tmp1 = intersect(1:length(thetaMean{k}), cellfun(@str2num, yticklabels));
yticklabels(round(thetaMean{k}(tmp1)));
end
%%












%%












%% pole up 
nPoleSegs = cellfun(@(x) length(unique(x)), Polebins);
poleLocLinIndsTouch = {};
sig1 = {}
for k = 1:length(U)
    A = pole{k}.up;
    for kk = 1:nPoleSegs(k)
        tmp1  = find(Polebins{k} == kk);
%         [poleLocLinIndsTouch{k, kk}, ~] = find((A.segments(:, 4) - tmp1)==0);
        
        sig1{k, kk} = A.SIG(:, tmp1);
    end
end
%% pole down
nPoleSegs = cellfun(@(x) length(unique(x)), Polebins);
poleLocLinIndsTouch = {};
sig1 = {}
for k = 1:length(U)
    A = pole{k}.down;
    for kk = 1:nPoleSegs(k)
        tmp1  = find(Polebins{k} == kk);
%         [poleLocLinIndsTouch{k, kk}, ~] = find((A.segments(:, 4) - tmp1)==0);
        
        sig1{k, kk} = A.SIG(:, tmp1);
    end
end
%% plot it
crush
spout = SPmaker(5, 9);
for k = 1:length(U)
    sig = sig1(k, :);
    notEmpty = (~cellfun(@isempty, sig));
    toPlot = nan(length(sig), size(sig{find(notEmpty, 1, 'first')}, 1)) ;
    for kk = 1:sum(notEmpty)
        if any(find(notEmpty) == kk)
            toPlot(kk,:)  =  smooth(nanmean(sig{kk}, 2), smoothBy);
        end
    end
    toPlot = smoothEdgesNan(toPlot', smoothBy)
    spout = SPmaker(spout);
    imagescnan(toPlot');
    hold on 
    xticklabels(xticks-find(allCellsTouch{k}.plotRange    ==0)+1);

end


