%%

function [date1, numsFromVidALL] = ALIGNgetVidTimes(videoLOCATION) 

% minTrialLength = 4;
% addDueToRounding = .6;
% minTrialLength = minTrialLength + addDueToRounding;
numsFromVidALL = {nan, nan};
allDates =  {nan, nan};
%% get varibles set up
FTname = {'seq', 'AVI'};
for FT = 1:2
    cd(videoLOCATION)
    tmp1 = struct2cell(dir(['*ListAndInfoForAligning.mat']));
    tmp2 = {};
    for findType = 1:size(tmp1,2)
        tmpFN = tmp1{:, findType};
        if contains(lower(tmpFN) , lower(FTname{FT}))
            tmp2(1:size(tmp1(:, findType),1), end+1) = tmp1(:, findType);
        end
    end
    tmp1 = tmp2;
    if ~isempty(tmp1)
        [~, indToMostRecent]= max(cell2mat(tmp1(6, :)));
        tmp2  = load( tmp1{1, indToMostRecent});
        
        if FT == 2
            avi_list = struct2cell(tmp2.AVIlist);
            bytesLOC = find(~cellfun(@isempty, strfind(fieldnames(tmp2.AVIlist), 'bytes')) ==1);
            
        elseif FT ==1
            avi_list = struct2cell(tmp2.seqList);
            bytesLOC = find(~cellfun(@isempty, strfind(fieldnames(tmp2.seqList), 'bytes')) ==1);
            
        end
       
        if ~isempty(avi_list)
            %         avi_list = avi_list(:, modeBytes);
            
            startInd = cell2mat(strfind(avi_list(1, :), '-')) +1;
            for k =1 :size(avi_list, 2)
                numsFromVid(k) = str2num(avi_list{1, k}(startInd(k):end-4));
            end
            [date1, date1ind] = sort(cell2mat(avi_list(end, :)));
            numsFromVid = numsFromVid(date1ind);
               date1 = date1*60*60*24;
                 numsFromVidALL{FT} = numsFromVid;
                 allDates{FT} = date1;
        end
      
    end
   
end
