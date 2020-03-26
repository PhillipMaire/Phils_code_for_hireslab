%% for now lets not pay attention to the protraction vs retraction touches
close all
extractRange = -100:200;
SIGrange = 8:40;
BLrange = -33:-1;
XdisRange = [1, 10];
[~, SIGrange, ~] = intersect(extractRange, SIGrange);
[~, BLrange, ~] = intersect(extractRange, BLrange);

smoothBy = 10;

maxITItoInclude = 500;

figure
for k = 1:length(U)
    hold on
    C = U{k};
    
    [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] =...
        GET_touches(C, 'onset', false);
    %     touchOrder2 = touchOrder;
    U1 = unique(touchOrder);
    
    for k2 = 1:length(U1)
        kk = U1(k2);%just in case
        ind1 = interTouchInterval>maxITItoInclude & touchOrder == kk;
        %         tmp2 = find(touchOrder == kk);
        touchOrder(ind1) = 1;
        % recalculate the intertouch interval here first
        interTouchInterval(ind1) = 0;
        
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
    %{

if we are doing touch order and we are limiting the interval between
touches to be a max of some number then once it goes over that number then
it becomes touch order 1 correct?

other option is to have to limit

other option is to just use ITI
    %}
end