%%
%goal of this is to plot the change from BL to Sig of the unmasked pole
%responses. Based on my classification of which direction it is (inhibited
%and excited) and use this as the signal period.
% function balchblah222(U, pole, V, theseCells)
extractRange = -400:200;
BLinds = -300:0;
[~, BLinds, ~] = intersect(extractRange, BLinds);




spout = SPmaker(3, 1);
tmp.sig = nan;tmp.BL = nan;
P =cell(2, max(theseCells));
P(1:2, 1:max(theseCells)) = {tmp};ff
for kk = 1:2
    for k = theseCells
        C = U{k} ;
        Y = squeeze(C.R_ntk)*1000;
        if kk == 1
            sig1 = C.meta.poleOnset;
            sig1 = sig1+(0:C.t: (C.k-1).*C.t);
            
            V2 = V{1, k};
        else
            sig1 = C.meta.poleOffset;
            sig1(sig1>C.t) = nan;
            sig1 = sig1+(0:C.t: (C.k-1).*C.t);
            V2 = V{2, k};
            
        end
        %% ad mask here if you want to
        
        %%
        [touchExtract, touch_makeTheseNans] = getTimeAroundTimePoints(sig1, extractRange, C.t);
        sig2 = Y(touchExtract);
        sig2(touch_makeTheseNans) = nan;
        %% get the signal region
        if V2.ModDirection ~= 0
            if V2.ModDirection >0
                SIGinds = V2.plotRange(V2.E(1):V2.E(end));
                [~, SIGinds, ~] = intersect(extractRange, SIGinds);
            elseif V2.ModDirection <0
                SIGinds = V2.plotRange(V2.I(1):V2.I(end));
                [~, SIGinds, ~] = intersect(extractRange, SIGinds);
            end
            
            P{kk, k}.sig = sig2(SIGinds, :);
            P{kk, k}.BL = sig2(BLinds, :);
            
        else
        end
    end
end

%% plot it
% V2.ModDirection
% for kk= 1:2
%     for k = theseCells
%
%         %         P{kk, k}.
%
%     end
% end
%%

sig1 = cellfun(@(x) nanmean(x.sig(:)), P);
BL1 = cellfun(@(x) nanmean(x.BL(:)), P);
addedSPKperSec = sig1 - BL1;
tmp1 = ~isnan(nanmean(addedSPKperSec, 1));
addedSPKperSec(logical(isnan(addedSPKperSec).*tmp1)) = 0;

figure;
hold on
plot(addedSPKperSec(1, :),addedSPKperSec(2, :), 'ok')
equalAxes
plot([xlim', zeros(2, 1)], [zeros(2, 1), ylim'], 'k--')
supLabel_ALL('title','pole up response','pole down response','')
% set(gca, 'XScale', 'log')
%%
[x, y, evalXaxis, evalYaxis] = logify(addedSPKperSec(1, :),addedSPKperSec(2, :), 10);
crush

plot(x, y, 'ko')
hold on 
equalAxes

plot([xlim', zeros(2, 1)], [zeros(2, 1), ylim'], 'k--')
supLabel_ALL('title','pole up response','pole down response','')
eval(evalXaxis)
eval(evalYaxis)
