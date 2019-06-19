function [pos1, pos2, distsALL, maxVar] = pdistFindInd(arrayNby2ofdists)
%% make test example where we know the two positions that are max distance
%{




variablePositionsToFind = [18, 10]
arrayNby2ofdists = rand(20,2);
arrayNby2ofdists(variablePositionsToFind(1),:) = 100;
arrayNby2ofdists(variablePositionsToFind(2),:) = -100;




%}
%%
distsALL = pdist(arrayNby2ofdists);
[maxVar, indVar] = max(distsALL);
%% create a matrix of continious numbers on lower half of matrix excluding diagnal

Lt = length(arrayNby2ofdists);
findMat = zeros(Lt,Lt);
cntr = 1;
repWith = [];
for k = 1:Lt
    if k ~=1
        repWith = cntr: cntr+length(repWith)-2;
    else
        repWith = (cntr: Lt-1);
    end
    findMat((k+1):Lt, k) = repWith;
    cntr = cntr +length(repWith);
end

%% only have to make the above matrix once if the size of the arrays to find the numbers are the same
[pos1, pos2 ] = find(findMat == indVar);