
    
%     
%     %% just an easy way to make a mat from measurments file
%  
%     function [measurmentMat] = loadMeasurementsMat(input)
%     
%     measurmentCell = struct2cell(LoadMeasurements(input))';
%  test11 = double(cell2mat(measurmentCell(:,1:5)));
%   test12 = cell2mat(measurmentCell(:,6:end));
%   measurmentMat = [test11, test12];
%     end
%     
%     
    
        
    %% just an easy way to make a mat from measurments file
 
    function [measurmentMat, fieldNames, measurmentstruct] = loadMeasurementsMat(input)
    
    measurmentstruct = LoadMeasurements(input);
    fieldNames = fieldnames(measurmentstruct)';
    measurmentCell = struct2cell(measurmentstruct)';
 test11 = double(cell2mat(measurmentCell(:,1:5)));
  test12 = cell2mat(measurmentCell(:,6:end));
  measurmentMat = [test11, test12];
    
% % %     
% % %     [saveName] = saveDatShit
% % % function [saveName] = saveDatShit
% % % directoryString = 'C:\Users\Public\Documents';
% % % cd(directoryString);
% % % dateString = datestr(now,'yymmdd_HHMMSS');
% % % saveName = [directoryString, filesep, 'saveDatShit_', dateString];
% % % save(saveName)
% % % end
% % %     
    
    end
    
    
    
    
    
    
    