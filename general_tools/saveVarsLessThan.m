function [evalString] = saveVarsLessThan(whos1, lessThan, varargin)
%{
[evalString] = saveVarsLessThan(whos, 3000, 'test1');
eval(evalString)

or just

eval(saveVarsLessThan(whos, 3000, 'test1'));
%}
whosIt = (whos1);
tmpInd = strcmpi(fieldnames(whosIt), 'bytes');
whosIt = struct2cell(whosIt);
keepInds = cell2mat(whosIt(tmpInd, :))<lessThan;
whosIt = whosIt(:, keepInds);
if nargin == 3
    varName = varargin{1};
else
    varName = 'saveSmallerThan';
end
evalString = '';
for k = 1:size(whosIt, 2)
    
    evalString = [evalString, varName, '.', whosIt{1, k}, '=', whosIt{1, k}, ';     '];
    
end
