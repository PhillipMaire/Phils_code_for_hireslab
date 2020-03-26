function Kap = GetRealKappa(C)

Kap = squeeze(C.S_ctk(6, :, :));
Kap(isnan(Kap)) = 0;
[seg] = findInARow(Kap~=0, C.t);
for kk = 1:size(seg, 1) % correcting for the change in kapp subtracting out the first number in each >0 segment
    Kap(seg(kk, 1):seg(kk, 2)) = Kap(seg(kk, 1):seg(kk, 2)) - Kap(seg(kk, 1));
end