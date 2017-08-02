function follicle_n_mask_single_whisker(mouseName,sessionName,videoloc,varargin)
% Jinho made this on 6/10/17 to auto draw a mask on his two whisker view
% videos. previously named follicle_n_mask.m, I renamed it to edit and make
% it work with single whisker on 6/20/17 -Phil

%% Setup whisker array builder 
%%%% Z:\Data\Video\AHHD_009\AH0698\170601
mouseName = 'AH0698'
 sessionName = '170606';
 videoloc =  'AHHD_009';
numOfWhiskers = 1;
% % % % % % if nargin > 3
% % % % % %     optional = varargin{4};
% % % % % % elseif nargin > 4
% % % % % %     error('Too many input arguments')
% % % % % % end

if exist('optional','var')
    d = (['Z:\Data\Video\' videoloc filesep mouseName filesep sessionName filesep optional filesep])
else
    d = (['Z:\Data\Video\' videoloc filesep mouseName filesep sessionName filesep])
end
cd(d)

maskfn = [mouseName sessionName 'follicle_n_mask.mat'];
% if exist(maskfn,'file')
%     disp([maskfn ' already exists. Skipping.'])
%     return
% end

number_of_random_trials = 20; % for averaging for mask detection
inflate_rate = 1.02;

%% Follicle
flist = dir('*.mp4');
v = VideoReader(flist(50).name);
follicle_first = zeros(2,2);
width = v.Width; height = v.Height; % to save these parameters
vavg = zeros(height,width);
for i = 1 %: v.NumberOfFrames
    vtemp = read(v,i);    
    vtemp = double(vtemp(:,:,1));
    vavg = vavg + vtemp/1;%v.NumberOfFrames;
end
vavg = mat2gray(vavg);
figure('units','normalized','outerposition',[0 0 1 1]), imshow(vavg,'InitialMagnification','fit'), axis off, axis image, title('Select follicle points, first top-view, and then front-view'), hold all

i = 1;
while (i < 3)
    [y, x] = ginput(1);
    obj_h = scatter(y, x, 'mo');
    if numOfWhiskers == 1
        button = questdlg('is this correct?', 'follicle', 'Yes', 'No', 'Cancel', 'Yes');
        i =2;
    elseif numOfWhiskers == 2
        if i == 1
            button = questdlg('is this correct?', 'Top-view follicle', 'Yes', 'No', 'Cancel', 'Yes');
        else
            button = questdlg('is this correct?', 'Front-view follicle', 'Yes', 'No', 'Cancel', 'Yes');
        end
    end
    switch button
        case 'Yes'
            follicle_first(i,2)= y; follicle_first(i,1) = x;
            i = i + 1;
            scatter(y, x, 'go');
        case 'No'
            delete(obj_h);
            continue
        case 'Cancel'
            disp('measurements adjustment aborted')
            return
    end
end


drawnow;

%% Mask

randlist = randi(length(flist), 1, number_of_random_trials);
if exist('parfor','builtin')
    vstack = zeros(v.Height,v.Width,number_of_random_trials);
    parfor i = 1 : number_of_random_trials
        v = VideoReader(flist(randlist(i)).name);
        temp_vavg = zeros(v.Height,v.Width);
        nof = fix(v.FrameRate*v.Duration); % number of frames
        for iter = 1 %: v.NumberOfFrames
            vtemp = read(v,i);
            vtemp = double(vtemp(:,:,1));
            vavg = vavg + vtemp/1;%v.NumberOfFrames;
        end
    end
    vavg = mean(vstack,3);
else
    vavg = zeros(v.Height,v.Width);
    for i = 1 : number_of_random_trials
        v = VideoReader(flist(randlist(i)).name);
        temp_vavg = zeros(v.Height,v.Width);
        nof = fix(v.FrameRate*v.Duration); % number of frames
        while hasFrame(v)
            vtemp = readFrame(v);    
            vtemp = double(vtemp(:,:,1));
            temp_vavg = temp_vavg + vtemp/nof;
        end
        vavg = vavg + temp_vavg/number_of_random_trials;
    end
end
vavg_filt = imgaussfilt(vavg,3);





H = fspecial('disk',10);
blurred = imfilter(vavg,H,'replicate'); 
figure
imshow(blurred);









vavg_filt =  fspecial('gaussian', size(vavg), 20);
maskx = {[],[]};
masky = {[],[]};

vavg_inflate = imresize(vavg_filt,inflate_rate);
BW = edge(vavg_inflate,'Prewitt');
[edge_i,edge_j] = ind2sub(size(BW),find(BW));
top_ind = find(edge_j >= size(BW,2)/2);
edge_i = edge_i - size(BW,2) + size(vavg,2);
edge_j(top_ind) = edge_j(top_ind) - (size(BW,1) - size(vavg,1))*(sind(21)/sind(45)); % 21 degrees tilted
scatter(edge_j,edge_i,3,'mo');

i = 1;
while (i < 3)            
    temp_ind = zeros(2,1);
    for j = 1 : 2
        [x, y] = ginput(1);
        temp_dist = (edge_j - x).^2 + (edge_i - y).^2;
        [~,temp_ind(j)] = min(temp_dist);        
    end
    temp_j = floor(edge_j(min(temp_ind):max(temp_ind)));
    temp_j(temp_j < 1) = 1;
    temp_j(temp_j > size(vavg,2)) = size(vavg,2);    
    temp_i = floor(edge_i(min(temp_ind):max(temp_ind)));
    temp_i(temp_i < 1) = 1;
    temp_i(temp_i > size(vavg,1)) = size(vavg,1);
    temp_bw = zeros(size(vavg));
    temp_ind = sub2ind(size(temp_bw),temp_i,temp_j);
    temp_bw(temp_ind) = 1;
    bl = bwlabel(temp_bw);        
    [mask_i,mask_j] = ind2sub(size(vavg),find(bl == bl(temp_i(1),temp_j(1)) | bl == bl(temp_i(end),temp_j(end))));

    obj_h = scatter(mask_j,mask_i,3,'bo');
    drawnow;
    if i == 1
        button = questdlg('is this correct?', 'Top-view mask', 'Yes', 'No', 'Cancel', 'Yes');
    else
        button = questdlg('is this correct?', 'Front-view mask', 'Yes', 'No', 'Cancel', 'Yes');
    end
    switch button
        case 'Yes'
            maskx{i} = mask_j;
            masky{i} = mask_i;

            qnum = length(mask_j);
            polyDegree = min([qnum-1,6]);
            mask_j = mask_j'; mask_i = mask_i';
            q = (0:(qnum-1))./(qnum-1);
            px = Whisker.polyfit(q,mask_j,polyDegree);
            py = Whisker.polyfit(q,mask_i,polyDegree);
            q = linspace(0,1);
            x = polyval(px,q);
            y = polyval(py,q);
            plot(x,y,'g-','LineWidth',2)

            i = i + 1;
        case 'No' 
            delete(obj_h);
            continue
        case 'Cancel'
            disp('measurements adjustment aborted')
            return
    end
end

%% save mask

save(maskfn,'maskx','masky','width', 'height', 'follicle_first')