%% for now lets not pay attention to the protraction vs retraction touches
% this iteration resets the Touch order after user setting of maxITItoInclude
% 
close all
extractRange = -100:200;
% SIGrange = 8:40;
BLrange = -50:-1;
XdisRange = [1, 50];
% [~, SIGrange, ~] = intersect(extractRange, SIGrange);
[~, BLrange, ~] = intersect(extractRange, BLrange);

smoothBy = 10;

maxITItoInclude = 150;% this makes touches after 500 ms a first touch again

figure
for k = 1:length(U)
    V2 = V{3, k};
    if V2.isSig
        SIGrange = nan;
        if ~isempty(V2.E)
            
            SIGrange = V2.plotRange(V2.E);
        elseif ~isempty(V2.I)
            SIGrange = V2.plotRange(V2.I);
        end
        
        [~, SIGrange, ~] = intersect(extractRange, SIGrange);
        hold on
        C = U{k};
        
        [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] =...
            GET_touches(C, 'onset', false);
        %     touchOrder2 = touchOrder;
        U1 = unique(touchOrder);
        trialNum = segments(:, 4);
        for k2 = 1:length(U1)
            kk = U1(k2);%just in case
            ind1 = 1;
            %             while sum(ind1) ~=0
            ind1 = interTouchInterval>maxITItoInclude & touchOrder == kk;
            %         tmp2 = find(touchOrder == kk);
%             if sum(ind1)>=1
%                 keyboard
%             end
            ind2 = find(ind1);
            tmp1 =  find(diff(touchOrder)~=1);
            for kk2 = 1:length(ind2)
                tmp2 = tmp1 - ind2(kk2);
                tmp2(tmp2<0) = inf;
                [~, ind7] = min(tmp2);
                repinds = ind2(kk2):tmp1(ind7);
                touchOrder(repinds) = 1:length(repinds);
            end
            
            interTouchInterval(ind2) = 0;
            %             end
        end
        
        spikes = squeeze(C.R_ntk).*1000;
        
        touchOspikes = {};
        for k2 = 1:length(U1)
            kk = U1(k2);%just in case
            [touchExtract, touch_makeTheseNans] = ...
                getTimeAroundTimePoints(allTouches(touchOrder==kk), extractRange, C.t);
            touchOspikes{kk} = spikes(touchExtract);
            touchOspikes{kk}(touch_makeTheseNans) = nan;
        end
        
        sig1 = cellfun(@(x) nanmean(nanmean(x(SIGrange, :))), touchOspikes);
        BL1 = cellfun(@(x) nanmean(nanmean(x(BLrange, :))), touchOspikes);
        diff1 = sig1-BL1;
        
        plot(diff1)
        xlim(XdisRange)
        
        
        keyboard
        clf
    end
    %{

if we are doing touch order and we are limiting the interval between
touches to be a max of some number then once it goes over that number then
it becomes touch order 1 correct?

other option is to have to limit

other option is to just use ITI
    %}
    
end