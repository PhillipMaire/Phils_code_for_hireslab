function [saveName] = barTracker_SAH_mega(varargin)

saveDir = 'D:\backup\Users\Phil\Data\BARtrackerSaves';
nextSet =0; 
if nargin ==0
    [b a] = uigetfile({'*.mp4'; '*.seq'}, 'select a movie mp4 or seq');
    
    filename=[a b];
    cd(a)
    %% section to save to run multiple bar trackers
    saveName = strfind(filename,'\');
    saveName = saveName(end);
    saveName = filename(saveName+1 : saveName+13);
    
% % % %     saveName = [saveDir,filesep, saveName];
    %%
elseif nargin ==1
    filename=varargin{1};
    [a b]=fileparts(filename);
    cd(a)
end




%filename = 'F:\Processed_Whiskers_DOM3_A\jf25607\jf25607x121409\jf25607x121409_0009.mp4';
slider.filename=filename;
slider.distance=0;
slider.path=a;
slider.val=2000;
slider.x=[];
slider.y=[];
slider.r_ms=1:4500; % ALERT

if strcmp(slider.filename(end-2:end), 'mp4')
    slider.f=mmread(slider.filename, slider.val);
    ii=slider.f.frames(1).cdata(:,:,1);
elseif strcmp(slider.filename(end-2:end), 'seq')
    
    [seq_info, fid] = read_seq_header(slider.filename);
    slider.f = read_seq_images(seq_info, fid, slider.val);
    ii=slider.f;%f.frames(1).cdata(:,:,1);
    
    slider.f.nrFramesTotal=seq_info.NumberFrames;
    slider.f.width=seq_info.Width;
    slider.f.height=seq_info.Height;
end



%slider.f=mmread(slider.filename, slider.val);





%slider.M = Whisker.read_whisker_measurements_v3([slider.filename(1:end-4) '.measurements']);
if exist([slider.filename(1:end-4) '.measurements.mat'],'file')
    [slider.r, obj.trackerFileFormat] = Whisker.load_whiskers_file([slider.filename(1:end-4) '.whiskers']);
    
    a=load([slider.filename(1:end-4) '.measurements.mat']);
    slider.M=a.M;
    disp('loaded .measurements.mat file')
elseif exist([slider.filename(1:end-4) '.measurements'],'file')
    [slider.r, obj.trackerFileFormat] = Whisker.load_whiskers_file([slider.filename(1:end-4) '.whiskers']);
    slider.M = Whisker.read_whisker_measurements_v3([slider.filename(1:end-4) '.measurements']);
    disp('loaded .measurements file')
else
    slider.M=[];
end


if  exist('DOM3_wrong_pulses.mat')
    a=load('DOM3_wrong_pulses.mat');
    slider.r_ms=a.r_ms/1000;
    
end



slider.fh=figure('Position', [5 200 2*slider.f.width 2*slider.f.height], 'Color', 'w', 'Name', [slider.filename]);
ii=plot_mp4(slider);
slider.ii=ii;
%
sh = uicontrol(slider.fh,'Style','slider',...
    'Max',abs(f.nrFramesTotal),'Min',1,'Value',slider.val,...
    'SliderStep',[1/abs(slider.f.nrFramesTotal) 20/abs(slider.f.nrFramesTotal)],...
    'Position',[10 10 100 20],...
    'Callback',@slider_callback);

eth = uicontrol(slider.fh,'Style','edit',...
    'String',num2str(get(sh,'Value')),...
    'Position',[10 60 100 20],...
    'Callback',@edittext_callback);

but = uicontrol(slider.fh,'Style','pushbutton',...
    'String','bar_tracker',...
    'Position',[10 80 100 20],...
    'Callback',@pushbut_callback);


op = uicontrol(slider.fh,'Style','pushbutton',...
    'String','open new file',...
    'Position',[10 100 100 20],...
    'Callback',@open_callback);

mp = uicontrol(slider.fh,'Style','pushbutton',...
    'String','measure pixels',...
    'Position',[10 120 100 20],...
    'Callback',@measurepix_callback);


pd = uicontrol(slider.fh,'Style','text',...
    'String',num2str(slider.distance) ,...
    'Position',[10 140 100 20],...
    'Callback',@pd_callback);


td = uicontrol(slider.fh,'Style','text',...
    'String',num2str(slider.r_ms(slider.val)) ,...
    'Position',[10 40 100 20],...
    'Callback',@time_callback);


% Set edit text UserData property to slider structure.


set(eth,'UserData',slider)


    function slider_callback(hObject,eventdata)
        % Get slider from edit text UserData.
        slider = get(eth,'UserData');
        slider.previous_val = slider.val;
        slider.val = round(get(hObject,'Value'));
        set(eth,'String',num2str(slider.val));
        %        set(td,'String',num2str(slider.r_ms(slider.val)));
        
        % Save slider in UserData before returning.
        ii=plot_mp4(slider);
        slider.ii=ii;
        set(eth,'UserData',slider)
        
    end

    function pushbut_callback(hObject,eventdata)
        
        slider = get(eth,'UserData');
        bartracker(slider.ii)
    end


    function time_callback(hObject,eventdata)
        slider = get(eth,'UserData');
        %set(td,'String',num2str(slider.r_ms(slider.val)));
    end

    function pd_callback(hObject,eventdata)
        
        slider = get(eth,'UserData');
        %set(pd,'UserData',slider);
        set(pd,'String',num2str(slider.distance));
        set(eth,'UserData',slider);
    end

    function  measurepix_callback(hObject,eventdata)
        
        %global x y
        
        slider = get(eth,'UserData');
        %measure_pixels(slider)
        [x, y] = getline
        hold on; plot(x,y);
        hold off;
        slider.distance=0
        for i=1:length(x)-1
            r=norm([x(i),y(i)]-[x(i+1),y(i+1)]);
            slider.distance=slider.distance+r;
            
        end
        
        slider.distance
        slider.x=x;
        slider.y=y;
        set(eth,'UserData',slider)
        set(pd,'String',num2str(slider.distance));
    end



    function open_callback(hObject,eventdata)
        slider = get(eth,'UserData');
        [b a] = uigetfile('*.mp4', 'select go trial');
        slider.filename=[a b];
        cd(a)
        [slider.r, obj.trackerFileFormat] = Whisker.load_whiskers_file([slider.filename(1:end-4) '.whiskers']);
        
        if exist([slider.filename(1:end-4) '.measurements.mat'],'file')
            a=load([slider.filename(1:end-4) '.measurements.mat']);
            slider.M=a.M;
            disp('loaded .measurements.mat file')
        else
            slider.M = Whisker.read_whisker_measurements_v3([slider.filename(1:end-4) '.measurements']);
            disp('loaded .measurements file')
        end
        
        
        ii=plot_mp4(slider);
        slider.ii=ii;
        set(eth,'UserData',slider);
        
    end

    function edittext_callback(hObject,eventdata, filename)
        % Get slider from edit text UserData.
        slider = get(eth,'UserData');
        slider.previous_val = slider.val;
        slider.val = round(str2double(get(hObject,'String')));
        % Determine whether slider.val is a number between the
        % slider's Min and Max. If it is, set the slider Value.
        if isnumeric(slider.val) && ...
                length(slider.val) == 1 && ...
                slider.val >= get(sh,'Min') && ...
                slider.val <= get(sh,'Max')
            set(sh,'Value',slider.val);
        else
            slider.val = slider.previous_val;
        end
        % Save slider structure in UserData before returning.
        
        
        ii=plot_mp4(slider);
        slider.ii=ii;
        % set(td,'String',num2str(slider.r_ms(slider.val)));
        set(eth,'UserData',slider)
    end
%% plot the image from the mp4 movie
    function ii=plot_mp4(slider)
        if strcmp(slider.filename(end-2:end), 'mp4')
            f=mmread(slider.filename, slider.val);
            ii=f.frames(1).cdata(:,:,1);
        elseif strcmp(slider.filename(end-2:end), 'seq')
            
            [seq_info, fid] = read_seq_header(slider.filename);
            f = read_seq_images(seq_info, fid, slider.val);
            ii=f;%f.frames(1).cdata(:,:,1);
            
            f.nrFramesTotal=seq_info.NumberFrames;
            f.width=seq_info.Width;
            f.height=seq_info.Height;
            
        end
        
        
        
        h2=imagesc(ii); colormap ('gray');
        hold on; plot(slider.x, slider.y, 'r'); hold off;
        
        if ~isempty(slider.M)
            
            ccc=['rgbmcky'];
            for i=[0,1,2,3,4,5,6]
                seg_pos=[];
                x=[];
                y=[];
                seg_pos=find(slider.M(:, 2)==slider.val-1 & slider.M(:, 1)==i);
                if seg_pos>0
                    seg=slider.M(seg_pos, 3);
                    pos=find(slider.r{slider.val}{2}==seg);
                    x=slider.r{slider.val}{3}{pos};
                    y=slider.r{slider.val}{4}{pos};
                    hold on; plot(x, y, 'Color',ccc(i+1), 'linewidth', 3);
                end
            end
            
            
        end
        
        
        
        
        set(slider.fh, 'Name', slider.filename)
    end

%% bar tracker
    function bartracker(ii)
        
        
        [x,y] = ginput(1);
        %close(h1)
        cs=8;
        xpos=round(x)+1;
        ypos=round(y)+1;
        if ypos >cs && ypos>cs
            
            cropped_image=ii( ypos-cs:ypos+cs, xpos-cs:xpos+cs);
        else
            cropped_image=ii(1:cs, 1:cs);
        end
        h5=figure('position',[300 25 400 400]); imagesc(cropped_image); colormap('gray'); hold on;
        rectangle ('position', [8 8 16 16 ], 'curvature', [1, 1], 'LineWidth', 2, 'EdgeColor', 'r');
        plot(cs, cs, 'ro');
        
        bb='No';
        p=0;
        
        while p==0
            bb=questdlg('accept bar?', 'Accept bar' );
            close(h5);
            switch bb
                case 'Yes'
                    %save the files
                    p=1;
                    
                case 'No'
                    %cd(movie_path)
                    [b a] = uigetfile('*.mp4', 'select go trial');
                    slider.filename=[a b];
                    ii=plot_mp4(slider);
                    slider.ii=ii;
                    set(eth,'UserData',slider)
                    [x,y] = ginput(1);
                    %close(h1);
                    
                    cs=8;
                    xpos=round(x);
                    ypos=round(y);
                    if ypos >cs && ypos>cs
                        
                        cropped_image=ii( ypos-cs:ypos+cs, xpos-cs:xpos+cs);
                    else
                        cropped_image=ii(1:cs, 1:cs);
                    end
                    
                    h5=figure; imagesc(cropped_image); colormap('gray'); hold on
                    rectangle ('position', [8 8 16 16], 'curvature', [1, 1], 'LineWidth', 2, 'EdgeColor', 'r');
                    plot(cs, cs, 'ro');
                    
                    p=0;
            end
        end
        
        
        cor=normxcorr2(cropped_image, ii);
        
        %         figure; imagesc(cor);colormap('gray')
        %         figure; mesh(cor);
        
        [a b]= max(max(cor, [], 1));
        [c d]= max(max(cor, [], 2));
        
        
        x_calc=b-cs;
        y_calc=d-cs;
        
        
        %% go through all files
        if strcmp(slider.filename(end-2:end), 'mp4')
            movie_files=selectFilesFromList(slider.path, '*.mp4');
        elseif strcmp(slider.filename(end-2:end), 'seq')
            movie_files=selectFilesFromList(slider.path, '*.seq');
        end

        nextSet = 1;
        save([saveName, '_part2']);
        close all
    end
    function names = selectFilesFromList(path, type)
        
        global gh state
        
        if nargin < 1
            path = pwd;
            type = '.tif'
        end
        
        if nargin == 1
            try
                filetype = get(gh.autotransformGUI.fileType, 'String');
                value = get(gh.autotransformGUI.fileType, 'Value');
                filetype = filetype{value};
            catch
                filetype = type;
            end
        end
        if nargin == 2
            filetype = type;
        end
        
        d = dir(fullfile(path, ['/*' filetype]));
        if length(d) == 0
            str = 'No Files Found';
        else
            str = {d.name};
        end
        str = sortrows({d.name}');
        if isempty(str)
            names = {};
            disp('No Files with that Extension Selected. Please choose a Path with Image files');
            return
        end
        
        [s,v] = listdlg('PromptString','Select a file:', 'OKString', 'OK',...
            'SelectionMode','multiple',...
            'ListString', str, 'Name', 'Select a File');
        names = str(s);
        
        
    end
while nextSet == 0
    pause(1)
end
save([saveName, '_part1']);
end


