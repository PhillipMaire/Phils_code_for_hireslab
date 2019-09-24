function normOG = meanNorm(OG, varargin)
if nargin==1
    normOG = (OG - nanmean(OG(:)))./((nanmax(OG(:) -nanmin(OG(:))))+.0000000000000000000000000000000000000001);
    normOG = reshape(normOG, size(OG));
elseif nargin == 2
    if strcmp(lower(varargin{1}), 'dm')
        normOG = (OG - nanmean(OG))./((nanmax(OG -nanmin(OG)))+.0000000000000000000000000000000000000001);
        normOG = reshape(normOG, size(OG));
    end
end
end
