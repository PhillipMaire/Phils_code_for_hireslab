
%% actual bar tracker
function barTracker_SAH_mega_part2(fileToLoadVars)
load([fileToLoadVars, '_part1']);
load([fileToLoadVars, '_part2']);

ci=zeros(2*cs+1, 2*cs+1, length(movie_files)); %preallocate memory


hh=waitbar(0,'correlating', 'Position', 1000* [0.1    0.1    0.2700    0.0563]);
sp=figure('position', [200 200 20*cs 20*cs]);

% save(saveName);
for i=1:length(movie_files)
    if ~exist(movie_files{i}, 'file')
        error(['file ', movie_files{i}, ' doesnt exist... perhaps you ran "delete not 4000 frame videos" program after finding pole positions, run pole positions again']) 
    end
    waitbar(i/length(movie_files),hh,['correlating...'  num2str(i) '..of..' num2str(length(movie_files))] );
    i
    %clf;
    if strcmp(movie_files{1}(end-2:end), 'mp4')
        
        f=mmread([slider.path movie_files{i}], slider.val);
        iii=f.frames(1).cdata(:,:,1);
        %         f=mmread(slider.filename, slider.val);
        %          ii=f.frames(1).cdata(:,:,1);
    elseif strcmp(movie_files{1}(end-2:end), 'seq')
        
        [seq_info, fid] = read_seq_header(slider.filename);
        f = read_seq_images(seq_info, fid, slider.val);
        iii=f;%f.frames(1).cdata(:,:,1);
        
    end
    
    
    
    frame_num(i)=abs(slider.f.nrFramesTotal); %frame number to generate bar file
    
    cor=normxcorr2(cropped_image, iii);
    [a b]= max(max(cor, [], 1));
    [c d]= max(max(cor, [], 2));
    
    
    
    final_pos(i, 1)=b-cs;
    final_pos(i, 2)=d-cs;
    
    cor(d, b)
    if cor(d, b)<0.88
        final_pos(i, 1)=100-cs;
        final_pos(i, 2)=100-cs;
        disp('set bar to corner')
    end
    
    
    %              figure; imagesc(cor);colormap('gray')
    %         figure; mesh(cor);
    
    ci(:,:, i)=iii( final_pos(i, 2)-cs:final_pos(i, 2)+cs, final_pos(i, 1)-cs:final_pos(i, 1)+cs);
    
    figure(sp);
    subplot(2,1,1);imagesc(iii);colormap('gray');
    
    subplot(2,1,2); imagesc(ci(:,:,i)); colormap('gray');hold on;
    h3=rectangle ('position', [8 8 16 16 ], 'curvature', [1, 1], 'LineWidth', 2, 'EdgeColor', 'r');
    plot(cs, cs, 'ro');
    set(sp, 'Name', [movie_files{i}]);
    %pause
end
close(hh)
close(sp)

%% reviews

h6=figure('Position', [5 200 2*slider.f.width 2*slider.f.height], 'Color', 'w', 'Name', [slider.filename]);
imagesc(ii); colormap ('gray');

hold on; plot(final_pos(:,1),final_pos(:,2), 'ro');


%% detailed review of the locations

% % cc=questdlg('review locations', 'review');
% % switch cc
% %     case 'Yes'
% %         
% %         hhh=figure('position', [200 200 20*cs 20*cs]);
% %         pause on;
% %         for i=1:size(ci, 3)
% %             clf;
% %             imagesc(ci(:,:,i));colormap('gray'); hold on;
% %             rectangle ('position', [8 8 16 16 ], 'curvature', [1, 1], 'LineWidth', 2, 'EdgeColor', 'r');
% %             plot(cs, cs, 'ro');
% %             set(hhh, 'Name', [movie_files{i}]);
% %             i
% %             pause(0.2)
% %             
% %         end
% %         close (hhh)
% %         pause off
% %         
% %         
% %     case 'No'
% % end
%% save the bar files

% aa=questdlg('Save to bar files? Will overwrite and existing bar file! ', 'Save?');
% close(h6);
% 
% switch aa
%     case 'Yes'
%         %save the files
%         
        disp('Saving all bar files (automatically overwrites)')
        for i=1:length(movie_files)
            %i=3
            i
            bm=[];
            bm(:, 2:3)=repmat(final_pos(i, :),  frame_num(i), 1);
            bm(:, 1)=[1: frame_num(i)]';
            barname{i}=[movie_files{i}(1:end-4), '.bar'];
            fid=fopen(barname{i}, 'wt');
            fprintf(fid, '%u %4.4f %4.4f \n', bm');
            %sprintf('%u %4.4f %4.4f \n', bm')
            fclose(fid);
            
        end
        disp('done')
        
        
%     case 'No'
%         disp('done')
% end


end


function [seq_info, fid] = read_seq_header(seq_file)
% [seq_info, fid] = read_seq_header(seq_file)
% this function reads a sequence header for a StreamPix .seq file
% seq_file is a string with the file name
% Thus far only tested on 8 bit monichrome sequences - MBR 6/19

fid = fopen(seq_file, 'r');
% put in an error message here if file not found
status = fseek(fid, 548, 'bof'); % the CImageInfo structure starts at byte 548

if status == 0
    CImageInfo = fread(fid, 6, 'uint32');
    seq_info.Width = CImageInfo(1);            % Image width in pixel
    seq_info.Height = CImageInfo(2);           % Image height in pixel
    seq_info.BitDepth = CImageInfo(3);         % Image depth in bits (8,16,24,32)
    seq_info.BitDepthReal = CImageInfo(4);     % Precise Image depth (x bits)
    seq_info.SizeBytes = CImageInfo(5);        % Size used to store one image
    seq_info.ImageFormat = CImageInfo(6);      % format information, should be 100 monochrome (LSB)
end

seq_info.NumberFrames = fread(fid, 1, 'uint32');
status = fseek(fid, 580, 'bof');
seq_info.TrueImageSize = fread(fid, 1, 'uint32');
seq_info.FrameRate = fread(fid, 1, 'double');
end



function seq_image = read_seq_images(seq_info, fid, frames)
% seq_im = read_seq_images(seq_info, fid, frames)
% reads the frames specified by frames, either a range, or -1 for all of
% them, and returns in the seq_im structure

if frames == -1  % if -1, then set frames to entire sequence
    frames = 1:seq_info.NumberFrames;
end

seq_image = zeros(length(frames), seq_info.Height, seq_info.Width);

if length(frames) == 1 % if just one frame, do not return a structure
    image_address = 1024 + (frames-1)*seq_info.TrueImageSize;
    status = fseek(fid, image_address, 'bof');
    seq_image = fread(fid, [seq_info.Width, seq_info.Height], 'uint8')';
else
    for j = 1:length(frames)
        image_address = 1024 + (frames(j)-1)*seq_info.TrueImageSize;
        status = fseek(fid, image_address, 'bof');
        seq_image(j,:,:) = fread(fid, [seq_info.Width, seq_info.Height], 'uint8')';
    end
end
end



