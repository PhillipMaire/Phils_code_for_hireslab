function [] = logifyFig(AxesesToLogify,base1, powerMakeZeros, varargin)
%{
midLabel - *if blank or not 1 or 2 then it labels the mid label as a nan
*if 1 then mid label is "(+/-) number"
*if 2 then mid label is "-number to number"
'number' here is an actual number

powerMakeZeros - *if a number it makes that number the 'zero line' shold match the power you choose,
so if your power is 10 then number should be a power of 10 (e.g. 1000, 100, .1, .01 etc.)
* if is string 'tight' it will make it so that all non-zero elements DO NOT fall on that mid line
for x and y. this setting x midline and y midline can be different.
* if is string 'equal' it is the same as tight but makes the midlines for x and y equal

AxesesToLogify - is a cell array of strings containing x y and/or z to indicate which axes to logify
NOTE: Z has not really been test it is just assumed it will act the same as x and y


logifyFig({'x', 'y'}, 2,powerMakeZeros, [], midLabel)


%}

if nargin>=4 && ~isempty(varargin{1})
    h = varargin{1};
else
    h = gcf;
end
figure(h);
a1 = gca;
LabelType = 0;
if nargin>= 5 %if true plot text true values not nan
    LabelType = varargin{2};
end

% h = CloneFig(h)

power1 = base1.^(-1000:1000);
power1(power1==0) = -inf;


D = h.Children;
% for ChildNum = 1:length(D)
%     d = D(ChildNum).Children;
%     if ~isempty(d)




%%
for ChildNum = 1:length(D)
    d = D(ChildNum).Children;
    if ~isempty(d)
        if isnumeric(powerMakeZeros)
            if length(powerMakeZeros) == 1
                powerMakeZeros = repmat(powerMakeZeros, size(AxesesToLogify));
            elseif length(powerMakeZeros) ~= length(AxesesToLogify)
                error('powerMakeZeros length must be 1 or equal to selected axes, or ''tight'', or ''equal''')
            end
        elseif ischar(powerMakeZeros)
            if any(strcmpi(powerMakeZeros, {'tight', 'equal'}))
                % go through all the data and find the smallest number and set
                % powerMakeZeros the power below that number. for 'tight' do it for
                % each of the axes for 'equal' take the min of the tight axes.
                xminTMP = nan(length(d), 1);
                yminTMP =  nan(length(d), 1);
                zminTMP =  nan(length(d), 1);
                for k = 1:length(d)
                    t = d(k).XData;
                    t(t==0) = nan;
                    t = nanmin(abs(t));
                    if ~isempty(t)
                        xminTMP(k) = t;
                    end
                    t = d(k).YData;
                    t(t==0) = nan;
                    t = nanmin(abs(t));
                    if ~isempty(t)
                        yminTMP(k) = t;
                    end
                    try
                        t = d(k).ZData;
                        t(t==0) = nan;
                        t = nanmin(abs(t));
                    catch
                        t = 0;
                    end
                    if ~isempty(t)
                        zminTMP(k) = t;
                    end
                end
                xminTMP(xminTMP==0) = nan;
                xminTMP = nanmin(xminTMP);
                yminTMP(yminTMP==0) = nan;
                yminTMP = nanmin(yminTMP);
                zminTMP(zminTMP==0) = nan;
                zminTMP = nanmin(zminTMP);
                if strcmpi(powerMakeZeros, 'tight')
                    % rearrange to match user input
                    powerMakeZeros = [];
                    powerMakeZeros(strcmpi('x', AxesesToLogify)) = xminTMP;
                    powerMakeZeros(strcmpi('y', AxesesToLogify)) = yminTMP;
                    powerMakeZeros(strcmpi('z', AxesesToLogify)) = zminTMP;
                elseif strcmpi(powerMakeZeros, 'equal')
                    powerMakeZeros = [xminTMP, yminTMP, zminTMP];
                    powerMakeZeros= repmat(min(powerMakeZeros), size(powerMakeZeros));
                end
                
                powerMakeZeros = power1(sum((power1(:) - powerMakeZeros)<0));
                
            else
                error('powerMakeZeros length must be 1 or equal to selected axes, or ''tight'', or ''equal''')
            end
            
        end
    end
end

if ismember('x', lower(AxesesToLogify))
    convertDataAndAxisLabels('XTick', 'XTickLabel', 'xlim', 'XData',...
        powerMakeZeros(strcmpi('x', AxesesToLogify)));
end
if ismember('y', lower(AxesesToLogify))
    convertDataAndAxisLabels('YTick', 'YTickLabel', 'ylim', 'YData',...
        powerMakeZeros(strcmpi('y', AxesesToLogify)));
end
if ismember('z', lower(AxesesToLogify))
    convertDataAndAxisLabels('ZTick', 'ZTickLabel', 'zlim', 'ZData',...
        powerMakeZeros(strcmpi('z', AxesesToLogify)));
end

%
%     end
% end
%









%% #################################################
    function xOUT = logWithNegs(x2, base2, powerMakeZerosIN)
        zeroInd = abs(x2)<powerMakeZerosIN;
        negInd = -2*(x2<0) + 1;
        xOUT = log(abs(x2))./log(base2);
        xOUT = (xOUT).*negInd;
        xOUT(zeroInd) = 0;
        
    end

    function cellOut = num2strCell(arrayIn)
        arrayIn = arrayIn(:);
        cellOut = cell(size(arrayIn));
        for k2 = 1:length(arrayIn)
            cellOut{k2}  = num2str(arrayIn(k2));
        end
    end


    function convertDataAndAxisLabels(tickStr, labStr, limString, dataStr,  powerMakeZeros2)
        multDataBy = power1(find(powerMakeZeros2.*power1>=1, 1, 'first'));
        LIMSET = eval(limString);
        [~, powZeros ] = min(abs(power1-powerMakeZeros2));
        xOUT = [];
        for ChildNum2 = 1:length(D)
            d1 = D(ChildNum2).Children;
            if ~isempty(d1)
                for k4 = 1:length(d1)
                    d2 = d1(k4);
                    eval(['xOUT = logWithNegs(d2.', dataStr, '*multDataBy, base1, powerMakeZeros2.*multDataBy);']);
                    eval(['h.Children(ChildNum2).Children(k4).', dataStr, ' = xOUT;']);
                end
            end
        end
        % set the limits to be the closest whole number outside of the xlim
        xOUT = logWithNegs(LIMSET.*multDataBy, base1, powerMakeZeros2);
        xlimSet = [floor(xOUT(1)), ceil(xOUT(2))];
        eval([ limString, '(xlimSet);'])
        % now only allow for whole numbers so that we can make pretty
        % labels later
        set(a1, tickStr, xlimSet(1):xlimSet(2))
        % make the pretty labels
        pos1 = power1(powZeros+1:powZeros+max(eval(limString)));
        neg1 = flip(-1*power1(powZeros+1:powZeros+abs(min(eval(limString)))));
        
        newLabels = [neg1, nan, pos1];
        labelCell = num2strCell(newLabels);
        tmp1 = nanmin(abs(newLabels));
        if LabelType ==1
            labelCell{length(neg1)+1} = ['(-/+) ', num2str(tmp1./base1)];
        elseif LabelType ==2
            labelCell{length(neg1)+1} = ['-', num2str(tmp1./base1), ' to ', num2str(tmp1./base1)];
        end
        % use below to relabel the range of numbers centered at 0 to
        % something else, I haven't settled on anything yet though
        %         labelCell{length(neg1)+1} = ...
        %             ['-/+', num2str(power1(powZeros2))]
        set (a1, labStr, labelCell);
    end
end