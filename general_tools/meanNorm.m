function normOG = meanNorm(OG)
normOG = (OG - nanmean(OG(:)))/(nanmax(OG(:) -nanmin(OG(:))));
normOG = reshape(normOG, size(OG));
end