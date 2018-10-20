
function [newCellName, originalCellName] = cellNameLetterModify(cellName)
originalCellName = cellName;
% just created to deal with cells names ending with a letter because of
% various reasons its eaier to this than to change it on every file and paper
% copy of the data. letters will be replaced with four digit numbers 1111 for A
% 2222 for B ect. lower upper doesnt matter. input is a string. -psm 180504
if iscell(cellName)
    cellName = cellName{:};
end
if isnumeric(cellName)
    cellName = num2str(cellName);
end
if ~isstr(cellName)
    error('input must be string, cell containing string, cell containing number or a number')
end

var1 = double(cellName);
for k = 1: length(var1)
    var2{k} = upper(char(var1(k)));
    isLetter(k) =  isempty(str2num(var2{k}));
end

renameLetterStrings = {'1111', '2222', '3333', '4444', '5555', '6666', '7777'...
    '8888', '9999'};

var3 = var2;
allLetterInds =    find(isLetter);
for k = 1:sum(isLetter)
    currentLetterInd = allLetterInds(k);
    currentLetter = var2{currentLetterInd};
    
    
    if  currentLetter == 'A'
        replaceInd = 1;
    elseif  currentLetter == 'B'
        replaceInd = 2;
    elseif  currentLetter == 'C'
        replaceInd = 3;
    elseif  currentLetter == 'D'
        replaceInd = 4;
    elseif  currentLetter == 'E'
        replaceInd = 5;
    elseif  currentLetter == 'F'
        replaceInd = 6;
    elseif  currentLetter == 'G'
        replaceInd = 7;
    elseif  currentLetter == 'H'
        replaceInd = 8;
    elseif  currentLetter == 'I'
        replaceInd = 9;
    else
        error('letter other than A, B, C, D, E, F, G, H, or, I in in name');
    end
    var3{currentLetterInd} = renameLetterStrings{replaceInd};
end

newCellName = strjoin(var3, '');

end