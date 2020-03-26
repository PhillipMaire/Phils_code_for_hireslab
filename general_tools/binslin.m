% Varargin elements can be
% mode (equalN or equalX) equal number of elements in each bin or equal
% spacing.
% binBounds (vector of bin boundries)
%

function [sorted, sortedBy, binBounds, binINDs]=binslin(sortBy, toSort, sortMode, binBounds,varargin)
binINDs = {};
if isempty(sortBy) | isempty(toSort)
    sorted={[]};
    sortedBy={[]};
    binBounds={[]};
    disp('Empty input');
else
    if length(binBounds)==1
        if strcmp(sortMode,'equalX')
            binBounds=linspace(min(sortBy),max(sortBy),binBounds);
        elseif strcmp(sortMode,'equalN')
            tmp=sort(sortBy); % arrange the data for equalN indexing
            tmp=tmp(1:sum(isnan(tmp(:))==0)); %remove the NaNs (assumes there is at least 1 non NaN in the input)
            binBounds=round(0:(length(tmp)/binBounds):length(tmp));
            binBounds(1:end-1)=binBounds(1:end-1)+1;
            binBounds=tmp(binBounds)';
            
        elseif strcmp(sortMode,'equalE'); %JC 160526 sort based on edges, given by min (varargin{1}) and max, varargin{2}
            binBounds=linspace(min(varargin{1}),max(varargin{2}),binBounds);
            % % % %         elseif strcmp(sortMode,'equalNN');
            % % % %             if round(length(sortBy)./binBounds)== length(sortBy)./binBounds % yay equal
            % % % %
            % % % %             else
            % % % %                 keyboard
            % % % %             end
        end
        
    end
    sorted=cell(length(binBounds)-1,1);
    sortedBy=cell(length(binBounds)-1,1);
    for i=1:length(binBounds)-1
        
        if i == 1 % for the first test make sure to include the min values -Phil 19.12.20
            binINDs{i} = find(sortBy>=binBounds(i) & sortBy<=binBounds(i+1));
            sorted{i}=toSort(binINDs{i}, :);
            sortedBy{i}=sortBy(binINDs{i});
        else
            binINDs{i} = find(sortBy>binBounds(i) & sortBy<=binBounds(i+1));
            sorted{i}=toSort( binINDs{i} , :);
            sortedBy{i}=sortBy(binINDs{i});
        end
    end
end
