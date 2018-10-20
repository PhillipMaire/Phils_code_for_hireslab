
function [newMeasurmentMat, notThisWhisker, indexWhisker] = extractSingleClassifiedWhisker(whiskerNumber, measurmentMat)
if ~ismatrix(measurmentMat)
    error('input 2 is not a matrix, please use loadMeasurementsMat.m turn the struct into a mat');
    display('loadMeasurementsMat.m code will be in this file too for reference');
end
indexWhisker = measurmentMat(:,3) == whiskerNumber;
 newMeasurmentMat = measurmentMat(indexWhisker,:);
 notThisWhisker = measurmentMat(~indexWhisker,:);
% meanX = mean(newMeasurmentMat(:,10));
% meanY = mean(newMeasurmentMat(:,11));

end
% %     %% just an easy way to make a mat from measurments file
% %  
% %     function [measurmentMat, fieldNames] = loadMeasurementsMat(input)
% %     
% %     measurmentstruct = LoadMeasurements(input);
% %     fieldNames = fieldnames(measurmentstruct)';
% %     measurmentCell = struct2cell(measurmentstruct)';
% %  test11 = double(cell2mat(measurmentCell(:,1:5)));
% %   test12 = cell2mat(measurmentCell(:,6:end));
% %   measurmentMat = [test11, test12];
% %     end