
function [allTouches, segments, protractionTouches, touchOrder, interTouchInterval] = GET_touches(C, touchType, getOnlyFirstTouch)

if strcmp(lower(touchType), 'onset')
    touchFirstOnset = find(squeeze(C.S_ctk(9,:,:))==1);
    touchLateOnset = find(squeeze(C.S_ctk(12,:,:))==1);
    if getOnlyFirstTouch
        touchLateOnset = touchFirstOnset(1); % plot only the first touches
    end
    allTouches = unique([touchFirstOnset; touchLateOnset]);
    [segments] = findInARow(sort(allTouches), C.t);
elseif strcmp(lower(touchType), 'offset')
    
    touchFirstOFF = find(squeeze(C.S_ctk(9+1,:,:))==1);
    touchLateOFF = find(squeeze(C.S_ctk(12+1,:,:))==1);
    if getOnlyFirstTouch
        touchLateOFF = touchFirstOFF(1); % plot only the first touches
    end
    allTouches = unique([touchFirstOFF; touchLateOFF]);
    [segments] = findInARow(sort(allTouches), C.t);
elseif strcmp(lower(touchType), 'all')
    touchFirstALL = find(squeeze(C.S_ctk(9+2,:,:))==1);
    touchLateALL = find(squeeze(C.S_ctk(12+2,:,:))==1);
    if getOnlyFirstTouch
        touchLateALL = touchFirstALL(1); % plot only the first touches
    end
    allTouches = unique([touchFirstALL; touchLateALL]);
    [segments] = findInARow(sort(allTouches), C.t);
    %     [segments2, mat2] = findInARowFINAL_TMP(sort(allTouches), C.t);
else
    
    error('unrecognized string')
end


%% determine retraction and protraction touches
% % % TIME_BEFORE_TOUCH_TO_DETERMINE_PRO_OR_RET = 10;% in ms
% % %
% % % % touchFirstOnset = find(squeeze(C.S_ctk(9,:,:))==1);
% % % % touchLateOnset = find(squeeze(C.S_ctk(12,:,:))==1);
% % % % if getOnlyFirstTouch
% % % %     touchLateOnset = touchFirstOnset(1); % plot only the first touches
% % % % end
% % % allTouchesTMP = segments(:, 1);
% % % [segmentsTMP] = segments;
% % %
% % % % this little chunck is for if (for whatever reason)
% % % % there is a touch that is less than or equal to
% % % % TIME_BEFORE_TOUCH_TO_DETERMINE_PRO_OR_RET this variable
% % % % this will then just take the first touch of the trial (as opposed to
% % % % going back 10 ms which would enter the previous trial
% % % tmp1 = segmentsTMP(:, 5);
% % % earlyInd = find(tmp1<=TIME_BEFORE_TOUCH_TO_DETERMINE_PRO_OR_RET);
% % % earlyTime = tmp1(earlyInd);
% % % allTouchesTMP(earlyInd) = allTouchesTMP(earlyInd)+...
% % %     (TIME_BEFORE_TOUCH_TO_DETERMINE_PRO_OR_RET-earlyTime+1);
% % % phase = squeeze(C.S_ctk(5,:,:));
% % %
% % % phase1 = phase(allTouchesTMP-TIME_BEFORE_TOUCH_TO_DETERMINE_PRO_OR_RET);
% % %
% % % protractionTouches = logical(phase1<=0);
% % % segments(:, end+1) = protractionTouches;
%% determine retraction and protraction touches
allTouchesTMP = segments(:, 1);
[touchExtract,touchNanOutThese] = getTimeAroundTimePoints(allTouchesTMP, -5:-1, C.t);

vel1 = squeeze(C.S_ctk(2, :, :));
vel1 = vel1(touchExtract);
vel1(touchNanOutThese) = nan;

phase1 = squeeze(C.S_ctk(5, :, :));
phase1 = phase1(touchExtract);
phase1(touchNanOutThese) = nan;


phaseMean = nanmean(phase1, 1);
velMean = nanmean(vel1, 1);
quadInds = quadrentsInds(phaseMean, velMean);
% quadInds matches the quadrents of plot(phaseMean, ampMean) in cell array form. top left are
% protraction touches and bottom left are retraction touches

protractionTouches = nan(size(allTouchesTMP));
protractionTouches(quadInds{1}) = 1;%protraction
protractionTouches(quadInds{4}) = 0;%retraction

segments(:, end+1) = protractionTouches;
%{
figure
histAuto(velMean)
hold on
histAuto(velMean(quadInds{1}))
histAuto(velMean(quadInds{4}))

%}
%%
% % % if strcmp(lower(touchType), 'all')
% % %     protactALL = nan(size(allTouches));
% % %     tmp1 = [1; cumsum(segments(:, 3))+1];
% % %     tmp1 = tmp1(1:end-1);
% % %     protactALL(tmp1) = protractionTouches;
% % %     protractionTouches = protactALL;
% % % end
% % % if ~strcmp(lower(touchType), 'all')
    tmp1 = segments(:, 4)+((1:length(segments(:, 4)))');
    test1 = findInARowFINAL(tmp1);
    touchOrder = colonMulti(test1.startInds-test1.startInds+1, test1.endInds-test1.startInds+1);
    interTouchInterval = [nan; diff(segments(:, 1))];
    interTouchInterval(touchOrder==1) = 0;
    segments(:, 8) = touchOrder;
% % % %     interTouchInterval(touchOrder==1) = inf;
% % %     
% % % else
% % %     
    
    
    
end
