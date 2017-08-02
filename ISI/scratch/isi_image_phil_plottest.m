%%

newMat = (0:20:380);
newTimeMat = zeros(size(read_qcamraw([filename '.qcamraw'], (newMat+1))));
 basline = mean(timeMat(:,:,1:5),3);

for k = 1:20-1
    
    newTimeMat(:,:,k) = (timeMat(:,:,k+1)-basline)...
        ./(basline*100);
    
end
    
    
    imtool(newTimeMat(:,:,12)',[-0.5 0.5])
    
    test = mean(newTimeMat(:,:,6:10),3);
    imtool(test',[-0.5 0.5])
    
    
    
    