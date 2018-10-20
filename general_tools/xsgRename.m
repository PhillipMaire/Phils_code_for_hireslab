%%



d = 'C:\Users\maire\Desktop\PM0131\New folder\';
cd(d)

directory = dir('*.xsg');

for k = 1:numel(directory)
    
    
    originalName = directory(k).name ;
    newName = originalName;
    
    newName(10)='D';
    
    
    originalNumber = str2num(newName(11:14));
    newNum = originalNumber +47;
    
    newNumStr = num2str(newNum);
    
    addZerosNum = 4- numel(newNumStr);
    
    
    
    if addZerosNum == 1
        
        newNumStr = ['0', newNumStr];
        
    elseif addZerosNum ==2
        
        newNumStr = ['00', newNumStr];
        
    elseif addZerosNum ==3
        newNumStr = ['000', newNumStr];
    end
    
    newName(11:14)= newNumStr;
    
    originalName = [d originalName];
    newname = [d newName];
    movefile(originalName, newname)
    java.io.File(originalName).renameTo(java.io.File(newname))
    
end


