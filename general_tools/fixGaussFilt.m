%%
function out = fixGaussFilt(filteredIMG, smoothingParam) 
if length(smoothingParam) == 1
    smoothingParam = [smoothingParam, smoothingParam];
elseif length(smoothingParam)~= 2
    error('smoothing param must be either 1 or 2 numbers')
end
out = filteredIMG;
a = smoothingParam(1);
b = smoothingParam(2);

% cut1 = out(a+1:size(out, 1)-a, b+1:size(out, 2)-b) ;
out(1:a, :) = nan;
out(:, 1:b) = nan;
out(size(out, 1)+1-a:size(out, 1), :) = nan;
out(:, size(out, 2)+1-b:size(out, 2)) = nan;
% figure;imagescnan(out)
