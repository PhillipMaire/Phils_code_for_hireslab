function Plick_givenTouchEDIT(U)

saveON = 0;


allcellNum = [1000, 1006, 1007, 1008, 1009, 1013, 1014, 1015, 1016, 1017];


titleCell= {'PM0001 Before Lesion 2', 'PM0001 Before Lesion 0', ...
    'PM0001 After Lesion 1', 'PM0001 After Lesion 2', ...
    'PM0001 After Lesion 3', 'AH0718 Before Lesion 1', ...
    'AH0718 Before Lesion 0', 'AH0718 After Lesion 1', ...
    'AH0718 After Lesion 2', 'AH0718 After Lesion 3', };
%%
counter1 = 0 ;
metaCounter = 1;

%%
for cellNum = 1:numel(allcellNum)
    
    clearvars -except cellNum U titleCell saveON counter1 metaCounter
    %%
    display(num2str(cellNum));
    counter1 = counter1+1;
    %%
    totalSubplots = 2;
    numSubplotPerPlot = [5,5];
 
   
    %% isolate the region of analysis to a select region based on high perfomrance
    windowShowSample = 10000; %show sample size for sliding window;
    ROIperfON = 1;
    totalTrialsPicked = 249; %only if ROIperfON is == 1 
    numSmoothTrials = 100;
    [pointOfHighPerf, indexHighPerfLinInds, totalTrialsPicked] = highPerfRegion2(U{cellNum}.meta.trialCorrect, numSmoothTrials, totalTrialsPicked);
    %% basic info
    ranges = U{cellNum}.meta.ranges;%first number is nogo second is go limits
    
    %%
    
    trialType = U{cellNum}.meta.trialType;
    nogoTrialInds = trialType==0;
    trialCorrect = U{cellNum}.meta.trialCorrect;
    firstContacts = U{cellNum}.S_ctk(9,:,:);
    allContacts = U{cellNum}.S_ctk(11,:,:);
    onsetPlusRise = round((U{cellNum}.meta.poleOnset + 0.15)*1000);
    answerLicks = round(U{cellNum}.meta.answerLickTime*1000);
    
    [~,~,trials] = size(firstContacts);
    allTouchTimes = nan(4000, trials);
    for kk = 1:trials
        AllTouchTimesSingle = find(allContacts(:,:,kk)==1);
        allTouchTimes(1:numel(AllTouchTimesSingle),kk) = AllTouchTimesSingle';
    end
    %%% only look at touches if it was before answer lick and after onset
    test1 = allTouchTimes>answerLicks;
    test2 = allTouchTimes<onsetPlusRise;
    test3 = isnan(allTouchTimes);
    dontIncludeTheseTouches = (test1+test2+test3)>0;
    dontIncludeTheseTouchesSummed = sum(dontIncludeTheseTouches);
    allTouchTimesIndex = ones(size(dontIncludeTheseTouches));
    allTouchTimesIndex(dontIncludeTheseTouches) = nan;
    
    %% added this part to condence dow the mat to an array 
    allTouchTimesIndex = (nansum(allTouchTimesIndex))>0;
    allTouchTimesIndex2 = nan(size(allTouchTimesIndex));
    allTouchTimesIndex2(allTouchTimesIndex) = 1;
    allTouchTimesIndex = allTouchTimesIndex2;
    %%
    
    motorPosition = U{cellNum}.meta.motorPosition;
    Plick = (trialCorrect + trialType);
    Plick = Plick~=1;
    
    %%
    if ROIperfON == 1;
        trialType = trialType(indexHighPerfLinInds);
        nogoTrialInds = nogoTrialInds(indexHighPerfLinInds) ;
        trialCorrect = trialCorrect(indexHighPerfLinInds);
        firstContacts = firstContacts(indexHighPerfLinInds);
        onsetPlusRise = onsetPlusRise(indexHighPerfLinInds);
        answerLicks = answerLicks(indexHighPerfLinInds);
        Plick = Plick(indexHighPerfLinInds);
        
        allTouchTimesIndex = allTouchTimesIndex(indexHighPerfLinInds);
        
        motorPosition = motorPosition(indexHighPerfLinInds);

    end
    
    
    %%
    
    
    W_touch = (allTouchTimesIndex>0);
    WO_touch = isnan(allTouchTimesIndex);
    
    
    
    W_touch_mot = motorPosition(find(W_touch));
    WO_touch_mot = motorPosition(find(WO_touch));
    [W_touch_mot_sort sortInd_W ] = sort(W_touch_mot);
    [WO_touch_mot_sort sortInd_WO ] = sort(WO_touch_mot);
    
    W_touch_cor = Plick(find(W_touch));
    WO_touch_cor = Plick(find(WO_touch));
    
    W_touch_cor = W_touch_cor(sortInd_W);
    WO_touch_cor = WO_touch_cor(sortInd_WO);
    
    W_touch_cor2 = smooth(W_touch_cor, numSmoothTrials, 'moving')';
    WO_touch_cor2 = smooth(WO_touch_cor, numSmoothTrials, 'moving')';
    
    
    [W_samplingNums] = calcNumInWindow(W_touch_mot_sort, ranges, windowShowSample);
    [WO_samplingNums] = calcNumInWindow(WO_touch_mot_sort, ranges, windowShowSample);
    %%
    if counter1 == 1
        figure(metaCounter);
        clf
    end
    subplot(2,3,counter1)
    
    totalSamples = length(W_touch);
    if counter1 == numSubplotPerPlot(metaCounter)
        metaCounter = metaCounter+1;
        counter1 = 0;
    end
    
    %% plot with number samples
    ybackground = [0, 0];
    plotBackGroundRegions = [1,0;1,0];
    plotBackGroundRegions(:,:,2) =[0,0;1,1];
    
    discrimBound = mean(ranges);
    %%
    backGroundOpacity = 0.07;
    %%
    
    goRange = [discrimBound, ranges(2)];
    nogoRange = [ranges(1),discrimBound];
    %% plot backgrounds first
    lineProps. col = {'r'};
    lineProps.opacity = backGroundOpacity;
    mseb2(nogoRange, ybackground,plotBackGroundRegions, lineProps, 0);
    
    lineProps. col = {'b'};
    lineProps.opacity = backGroundOpacity;
    mseb2(goRange, ybackground,plotBackGroundRegions, lineProps, 0);
    
    
    
    
    
    
    %%
    
    totalSamples = length(W_touch);
    totalSamples = 100*2
    lineProps. col = {'r'};
    lineProps.opacity = 0.15;
    mseb2(WO_touch_mot_sort, WO_touch_cor2,WO_samplingNums/totalSamples, lineProps, 0);
    
    lineProps. col = {'b'};
    lineProps.opacity = 0.15;
    mseb2(W_touch_mot_sort, W_touch_cor2,W_samplingNums/totalSamples, lineProps, 0);
    
    
    
    
    %% plot just with the lines
    %     plot(W_touch_mot_sort,  W_touch_cor2, 'b')
    %     hold on
    %     plot(WO_touch_mot_sort,  WO_touch_cor2, 'r')
    
    %     plot(motorPosition, ones(numel(motorPosition)), '.');
    xlabel('pole positions (only no go)')
    ylabel('Probability of Lick')
    title(titleCell{cellNum})
    
    
    if saveON == 1
        savefig(titleCell{cellNum})
        saveas(gcf,titleCell{cellNum},'png')
    end
    
    
    
    
end
end




%%
function [samplingNums2] = calcNumInWindow(vector, ranges, windowShowSample);

samplesPer = ranges(1):ranges(2);
nanPads = nan(windowShowSample,1);
samplesPer(end+1 : length(samplesPer)+windowShowSample) = nanPads;
samplesPer = [nanPads', samplesPer];
for k = 1:(length(samplesPer)-(windowShowSample))
    % get the total count of all samples ina certain space.
    %% if is nan then make high or low number to count edge trials
    factor1 = samplesPer(k);
    factor2 = samplesPer(k+windowShowSample);
    if isnan(factor1)
        factor1 = ranges(1);
    end
    if isnan(factor2)
        factor2 = ranges(2);
    end
    %%
    samplingNums(k) = sum((vector >= factor1).*(vector < factor2));
end
%%
samplingNums = samplingNums(windowShowSample+1:end);
% % % % for kk = 1:2
% % % %     for k = 1:windowShowSample
% % % %         edge(k) = sum((vector > samplesPer(k)).*(vector < samplesPer(k+windowShowSample)));
% % % %     end
% % % % end
addNum = ranges(1)-1;
for k = 1:length(vector)
    try
        samplingNums2(k) = samplingNums(vector(k)-addNum);
    catch
        test1 = vector(k)-addNum;
        if abs(vector(k)-ranges(1))>abs(vector(k)-ranges(2))
            varAdjust = ranges(2);
        else
            varAdjust = ranges(1);
        end
        samplingNums2(k) = samplingNums(varAdjust-addNum);
        warning(['pole position out of range sutoset number ', num2str(k), ' from ', num2str(vector(k)), ' to ', num2str(varAdjust)]);
        display(['actual range is from ', num2str(ranges(1)), ' to ', num2str(ranges(2))]);
    end
end
end


%%
function [pointOfHighPerf, indexHighPerf, totalTrialsPicked] = highPerfRegion2(arrayOfPerformance, numSmoothTrials, totalTrialsPicked)
% % arrayOfPerformance = U{1, 1}.meta.trialCorrect;
% % numSmoothTrials = 200;
if totalTrialsPicked > length(arrayOfPerformance)
    warning('number of trials requested exceeds the total number of trials, changing it to the just include all trials consider changing this variable')
    totalTrialsPicked
    totalTrialsPicked = length(arrayOfPerformance)
end

if (totalTrialsPicked/2) == round(totalTrialsPicked/2) %if even
    warning('numSmoothTrials (input 2) must be centered around one number and this must be odd');
    display(['Changing numSmoothTrials from ', num2str(totalTrialsPicked) , ' to ', num2str(totalTrialsPicked-1)]);
    totalTrialsPicked = totalTrialsPicked-1;
end
if numSmoothTrials> (totalTrialsPicked-1)/2
    paddingNum = numSmoothTrials;
else
    paddingNum =   (totalTrialsPicked-1)/2;
end

smoothedPerf = smooth(arrayOfPerformance, numSmoothTrials,'moving');

smoothedPerf(1:paddingNum)= 0;
smoothedPerf(end-paddingNum+1:end)= 0;

[sortedSmoothPerf, index] = sort(smoothedPerf);
pointOfHighPerf = index(end);

eachEnd = (totalTrialsPicked-1)/2;



indexHighPerf = pointOfHighPerf-eachEnd: pointOfHighPerf+eachEnd;
indexHighPerfLinInds = zeros(length(arrayOfPerformance),1)';
indexHighPerfLinInds(indexHighPerf) = 1;



end



function H = mseb2(x,y,errBar,lineProps,transparent)
% H = MSEB(x,y,errBar,lineProps,transparent)
%
% Multiple Shaded Error Bars (MSEB) makes a 2-d plot containing multiple 
% lines with pretty shaded error bars.
% This is an extension of the popular shadedErrorBar, by Rob Campbell,
% enabling plotting of multiple data lines with overlapping errorbars, as 
% well as turning off legends for all elements but the main lines. MSEB is
% directed at using the default renderer instead of openGL, which is known
% to cause problems, e.g., with logarithmic axes and not being able to save
% figures as vector graphics in the eps-format.
% To avoid the error bar patches concealing previously plotted main lines, 
% the different elements are plotted in a suitable order. The default
% setting plot edges of overshadowed patches in an non-obtrusive manner so 
% all error bars can be seen but avoids cluttering of the plot (see the 
% third example on how to customise this). The patches are plotted in
% reverse order to make sure the first entry is "on top".
%
% Andreas Trier Poulsen, atpo@dtu.dk
% Technical University of Denmark, Cognitive systems - January 2015
%
% Inputs
% x - vector of x values [optional, can be left empty]
% y - vector of y values or a matrix of C x N, where C is the number of
%     lines to be plotted and N is the number of samples in each line and
%     should be equal to length(X)
% errBar - if a vector we draw symmetric errorbars. If it has a
%          size of [C,length(x),2] then asymmetric error bars are drawn,
%          with row 1 being the upper bar and row 2 being the lower
%          bar. In the present version errBar does not support two function
%          handles.
% lineProps  - [optional. Can also be set as "[]" for default settings].
%              Struct containing fields that define lineproperties for the 
%              plot function. It is possible to only define some of the
%              fields.
%       .col - cell array, where each element defines the colour of each
%              line. This can be done using either strings or three-element
%              RGB vectors e.g., either 'b' or [0 0 1] for blue.
%     .style - linestyle of the lines from y-data. Default is '-'.
%     .width - linewidth of the lines from y-data. Default is 2.
% .edgestyle - linestyle of edges that are overlapped by errorbars from
%              other lines. 
%             
% transparent - [optional, 0 by default] if ==1 the shaded error
%               bar is made transparent, which forces the renderer
%               to be openGl. However, if this is saved as .eps the
%               resulting file will contain a raster not a vector
%               image. openGL does not support having logarithmic axes.
%
% Outputs
% H - structure with an element for each line entry containing handles to 
%     the generated plot objects (e.g. H(c) contains the handles to the
%     c'th line entry. 
%
%
%% Examples:
%
% x = 1:100; y = randn(1,100,30)*10;
% t = (1:100) - 50; y(2,:,:) = repmat(t,[1,1,30]);
% y(2,:,:) = y(2,:,:) + 0.06.*y(2,:,:).^2 + randn(1,100,30)*10;
% y(3,:,:) = repmat(t,[1,1,30]);
% y(3,:,:) = 60 - abs(y(3,:,:))+ randn(1,100,30)*10;
% y_mean = mean(y,3); y_std = std(y,[],3);
% figure; title('Default renderer'),
% mseb(x,y_mean,y_std);ylim([-50 150])
% legend('Line 1','Line 2','Line 3')
% figure; title('openGL');
% mseb(x,y_mean,y_std,[],1);ylim([-50 150]) 
% legend('Line 1','Line 2','Line 3')
% 
% % openGL issue with logarithmic axes:
% figure; title('Default renderer')
% mseb(x,y_mean,y_std);ylim([-50 150])
% set(gca,'xScale','log')
% figure; title('openGL')
% mseb(x,y_mean,y_std,[],1);ylim([-50 150])
% set(gca,'xScale','log')
%
% % Defing only some of the line parameters
% lineProps.width = 1;
% lineProps.edgestyle = ':';
% figure; title('Custom line properties')
% mseb([],y_mean,y_std,lineProps);ylim([-50 150])


%% Error checking
error(nargchk(3,5,nargin))

% Cheking the y data
[C, N] = size(y);
if N==1
    C = 1;
    N = length(y);
    y = y';
end

% Cheking the x data
if isempty(x)
    x=repmat(1:N,[C,1]);
elseif length(x(:))==N && C>1
    x=repmat(x(:)',[C,1]);
end

if (size(x,1) ~= C) || (size(x,2)~=N)
    error('inputs x and y do not have same dimensions')
end

% Checking ErrBar dimensions. If only one error bar is specified then we
% will mirror it, turning it into both upper and lower bars.
if (size(errBar,1) ~= C) || (size(errBar,2)~=N)
    if size(errBar,1)==N && size(errBar,2)==2 && size(errBar,3)~=1 && C==1
        errBar = permute(errBar,[3,1,2]);
    elseif size(errBar,1)==N && size(errBar,2)==1 && size(errBar,3)~=1 && C==1
        errBar=repmat(errBar,[1,2]);
        errBar = permute(errBar,[3,1,2]);
    else
        error('inputs errBar and y do not have same dimensions')
    end
end
if size(errBar,3)==1
    errBar = repmat(errBar,[1,1,2]);
end


%% Setting default line options
if nargin<4
    lineProps = [];
end
if nargin<5 || ~isnumeric(transparent)
    transparent=0;
end
if ~isfield(lineProps,'col')
    for c = 1:C
        colours = 'brkgmcy';
        col_ind = rem(c-1,length(colours))+1;
        lineProps.col{c} = colours(col_ind);
    end
end
if ~isfield(lineProps,'style'),	lineProps.style = '-'; end
if ~isfield(lineProps,'width'),	lineProps.width = 2; end
if ~isfield(lineProps,'edgestyle'),	lineProps.edgestyle = '--'; end
if ~isfield(lineProps,'opacity'),	lineProps.opacity = '0.15'; end

%% First loop over the number of lines to be plotted
% (More or less contains the original code from shadedErrorBar)
holdStatus=ishold;
if ~holdStatus, hold on,  end

for c = C:-1:1
    %% Plotting patches
    % Plot the main line. We plot this first in order to extract the RGB values
    % for the line colour. I am not aware of a function that does this.
    H(c).mainLine=plot(x(c,:),y(c,:),'color',lineProps.col{c});
    
    
    % Work out the color of the shaded region and associated lines
    % Using alpha requires the render to be openGL and so you can't
    % save a vector image. We therefore provide the option of choosing alpha
    % or a de-saturated solid colour for the patch surface.
    
    col=get(H(c).mainLine,'color');
    edgeColor=col+(1-col)*0.55;
    patchSaturation=lineProps.opacity; %How de-saturated or transparent to make the patch
    if transparent
        faceAlpha=patchSaturation;
        patchColor=col;
        set(gcf,'renderer','openGL')
    else
        faceAlpha=1;
        patchColor=col+(1-col)*(1-patchSaturation);
        set(gcf,'renderer','painters')
    end
    
    %Calculate the y values at which we will place the error bars
    uE=y(c,:)+errBar(c,:,1);
    lE=y(c,:)-errBar(c,:,2);
    
    %Make the cordinats for the patch
    yP=[lE,fliplr(uE)];
    xP=[x(c,:),fliplr(x(c,:))];
    
    %remove any nans otherwise patch won't work
    xP(isnan(yP))=[];
    yP(isnan(yP))=[];
    
    
    H(c).patch=patch(xP,yP,1,'facecolor',patchColor,...
        'edgecolor','none',...
        'facealpha',faceAlpha);
    
    
    %Make nice edges around the patch.
    H(c).edge(1)=plot(x(c,:),lE,'-','color',edgeColor);
    H(c).edge(2)=plot(x(c,:),uE,'-','color',edgeColor);
end

%% Second loop over the number of lines to be plotted
for c = C:-1:1
    %% Plot egdes for patchoverlaps
    col=get(H(c).mainLine,'color');
    edgeColor=col+(1-col)*0.55;
    lE = get(H(c).edge(1), 'ydata');
    uE = get(H(c).edge(2), 'ydata');
    
    H(c).edgeoverlap(1)=plot(x(c,:),lE,lineProps.edgestyle,'color',edgeColor);
    H(c).edgeoverlap(2)=plot(x(c,:),uE,lineProps.edgestyle,'color',edgeColor);
    
end

%% Third loop over the number of lines to be plotted
for c = 1:C
    %% Plot mainlines
    %The main line is now covered by the patch object and was plotted first to
    %extract the RGB value of the main plot line. I am not aware of an easy way
    %to change the order of plot elements on the graph so we'll just remove it
    %and put it back (yuk!)
    delete(H(c).mainLine)
    H(c).mainLine=plot(x(c,:),y(c,:),lineProps.style,'color',lineProps.col{c},...
        'linewidth',lineProps.width);
    
    
    %% Turn legendinformation off for all but the main lines
    set(get(get(H(c).patch,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(H(c).edge(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(H(c).edge(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(H(c).edgeoverlap(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(H(c).edgeoverlap(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
    set(get(get(H(c).mainLine,'Annotation'),'LegendInformation'),'IconDisplayStyle','on')
    
end
if ~holdStatus, hold off, end
end











