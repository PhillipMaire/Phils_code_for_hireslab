function normOG = ZscoreMe(OG)
normOG = (OG - nanmean(OG(:)))/(std(OG(:)));
normOG = reshape(normOG, size(OG));
end