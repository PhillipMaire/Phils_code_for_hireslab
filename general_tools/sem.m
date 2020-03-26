function [B] = sem(A)

B = (nanstd( A ))./(sqrt(sum(~isnan(A(:)))));