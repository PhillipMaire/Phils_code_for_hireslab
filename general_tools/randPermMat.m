function [permMat] = randPermMat(sizeToSample, numberOfIterations)
[~, permMat]= sort(rand(sizeToSample, numberOfIterations));