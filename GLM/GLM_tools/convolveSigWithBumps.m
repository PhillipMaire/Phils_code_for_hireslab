function [convolvedMAT_all] = convolveSigWithBumps(allBumps, sig, widthBumps,  bumpsOffset);  
convolvedMAT_all = [];
for kk= 1:size(allBumps, 2)
    convolvedMAT = [];
    for k = 1:size(sig, 2)
        convolvedMAT(:, k) = conv(sig(:, k), allBumps(:,kk));
    end
    convolvedMAT = convolvedMAT(1:size(sig, 1),:);
    convolvedMAT_all(:, kk) = convolvedMAT(:);
end

convolvedMAT_all = circshiftNAN(convolvedMAT_all, -widthBumps./2 + bumpsOffset);


