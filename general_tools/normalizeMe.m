function normOG = normalizeMe(OG)
normOG = (OG - min(OG(:)));
normOG =normOG./max(normOG);
normOG = reshape(normOG, size(OG));
end