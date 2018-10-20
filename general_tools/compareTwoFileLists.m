%% funciton 
function [testIfMatch] = compareTwoFileLists(filelist_measurements, filelist_whiskers)

lengthEndName = find(filelist_measurements(1).name=='.');
lengthEndName1 = length(filelist_measurements(1).name(lengthEndName:end));
lengthEndName = find(filelist_whiskers(1).name=='.');
lengthEndName2 = length(filelist_whiskers(1).name(lengthEndName:end));

lengthToGo = min(length(filelist_measurements), length(filelist_whiskers));
for k = 1:lengthToGo
testIfMatch(k) = strcmp(filelist_measurements(k).name(1:end-lengthEndName1), ...
    filelist_whiskers(k).name(1:end-lengthEndName2));
end

if ~sum(testIfMatch==0)==0
   error('the file lists of whisker and measurments dont match, please reference the output matrix')
end
end