function [] = rastersForFirstPaper(U, cellNums)


try
    U = msAndRoundUarray(U, 'ms');
catch
end

for k = 1:length(cellNums)
C = U{cellNums(k)} ;
Y = squeeze(C.R_ntk);
[Stime, Strial] = find(reshape(Y, [ C.t,C.k]));
figure; plot(Stime,Strial , '.')
figure; plot(smooth(mean(Y, 2).*1000, 20))
end