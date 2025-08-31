%% Initialize MATLAB
close all;
clear all;
clc;
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
%% Options
global scale;
global mask si dim;
is_write = 0;
is_movie = 0;

scale = 250;
% scale = 100;

is_add_noise = 0;
is_apply_gamma = 0;
is_filtered = 0;

H = 0;
W = H;
%% Determine targets
if(isempty(dir('scales_settings.mat')) == 1)
%     targets0 = [390]; %#ok<NBRAK>
%     
%     targets0 = [32,320,320,320];
%     
%     targets0 = [0]; %#ok<NBRAK>
%     targets0 = [1]; %#ok<NBRAK>
%     targets0 = [2]; %#ok<NBRAK>
%     targets0 = [3]; %#ok<NBRAK>
%     targets0 = [600]; %#ok<NBRAK>
%     targets0 = [1,2,3,0];
%     targets0 = [1,2,3,0,200];
%     targets0 = [1,2];
%     targets0 = [1,-1];
%     targets0 = [1,2,3];
%     targets0 = [11]; %#ok<NBRAK>
%     targets0 = [22]; %#ok<NBRAK>
%     targets0 = [11,22,33,44,55,66,77,88,99];
%     targets0 = [11,22];
%     targets0 = [11,22,33];
%     targets0 = [111]; %#ok<NBRAK>
%     targets0 = [111,222];
%     targets0 = [1111]; %#ok<NBRAK>
%     targets0 = [1111,2222];
%     targets0 = [200,201,202]; %#ok<NBRAK>
%     targets0 = [300,301,302,303];
%     targets0 = [400,400,400,400];
%     targets0 = [400,400,400];
%     targets0 = [400]; %#ok<NBRAK>
%     targets0 = [500,501,501,503,504];
%     targets0 = [600,600,600];
%     targets0 = [1000]; %#ok<NBRAK>
    
    Smax = 1.0;
else
    load scales_settings targets0 scales Smax;
end;
n_targets0 = length(targets0);
%% Create new folder
path = 'rotations/';
if(isdir(path) == 1)
    rmdir(path,'s');
end;
if(is_write ~= 0)
    mkdir(path);
end;
%% Apply transforms
srcs = [];
srcs_dims = [];
for p=1:n_targets0
    person_id = targets0(p);
    filename = [num2str(abs(person_id)) '.bmp'];
    
    src = read_grayscale_image(filename,H,W);
    [h,w] = size(src);
    src = im2double(src);
    if(person_id < 0)
        src = 1 - src;
    end;
    s = min(h,w);
    [src,rect] = select_rect(src,s,s,1);
%     [src,rect] = select_rect(src,h,w,1);
    scales(p,2) = rect(1);
    scales(p,3) = rect(2);
    
    [h,w] = size(src);
    if(mod(h,2) == 0)
        h = h - 1;
    end;
    if(mod(w,2) == 0)
        w = w - 1;
    end;
    src = imresize(src,[h w],'nearest');
    [h,w] = size(src);

    srcs(1:h,1:w,p) = src;
    srcs_dims(p,1) = h;
    srcs_dims(p,2) = w;
    if(is_write ~= 0)
        imwrite(src,[path 'p_' num2str(p) '.bmp']);
    end;
end;
%% Circle mask
masks = [];
masks_dims = [];
for p=1:n_targets0
    h = srcs_dims(p,1);
    w = srcs_dims(p,2);
    src = srcs(1:h,1:w,p);
    xc = 1+round((w-1)/2);
    yc = 1+round((h-1)/2);
    r = min(xc,yc)-1;
    mask = zeros(h,w);
    
    [mask,n_rotations] = PlotCircle(mask,xc,yc,r,255);
    n_rotations = 360;
%     n_rotations = max(n_rotations,360);
%     n_rotations = min(n_rotations,360);
%     n_rotations = min(n_rotations,36);
    disp(['n_rotations: ' num2str(n_rotations)]);
    mask = imfill(logical(mask),'holes');
    
    % reduce the number of mask pixels
%     src = normalize_image(src);
%     for ri=0:r
%         P = extract_circle(src,xc,yc,ri);
%         if(std(P(:,3)) <= 0.05)
%             mask = PlotCircle(mask,xc,yc,ri,0);
%         end;
%     end;

    mask0 = zeros(h,w);
    mask0 = PlotCircle(mask0,xc,yc,r,255);
    mask0 = imfill(logical(mask0),'holes');
    mask = zeros(h,w);
    dim = 0;
    s = 2*dim+1;
    is_debug = 0;
    for y=yc:s:h-dim
        for x=xc:s:w-dim
            if(mask0(y+dim,x+dim) > 0)
                if(is_debug)    mask = fill_window(mask,x,y,dim,128);end;
                mask(y,x) = 255;
            end;
        end;
        for x=xc-s:-s:1+dim
            if(mask0(y+dim,x-dim) > 0)
                if(is_debug)    mask = fill_window(mask,x,y,dim,128);end;
                mask(y,x) = 255;
            end;
        end;
    end;
    for y=yc-s:-s:1+dim
        for x=xc:s:w-dim
            if(mask0(y-dim,x+dim) > 0)
                if(is_debug)    mask = fill_window(mask,x,y,dim,128);end;
                mask(y,x) = 255;
            end;
        end;
        for x=xc-s:-s:1+dim
            if(mask0(y-dim,x-dim) > 0)
                if(is_debug)    mask = fill_window(mask,x,y,dim,128);end;
                mask(y,x) = 255;
            end;
        end;
    end;

%     mask = zeros(h,w);
%     dim = 1;
%     s = 2*dim+2;
%     for ri=0:s:r-dim
%         P = GenCirclePath(xc,yc,ri);
%         for k=1:s:size(P,1)
%             x = P(k,1);
%             y = P(k,2);
%             
% %             for j=-dim:dim
% %                 for i=-dim:dim
% %                     if((y+j >= 1) && (y+j <= h) && (x+i >= 1) && (x+i <= w))
% %                         mask(y+j,x+i) = 128;
% %                     end;
% %                 end;
% %             end;
% 
%             mask(y,x) = 255;
%         end;
%     end;

%     d = 1;
%     dst = zeros(size(mask));
%     for y=1+d:h-d
%         for x=1+d:w-d
%             if(std2(src(y-d:y+d,x-d:x+d)) <= 0.05)
%                 dst(y,x) = 0;
%             else
%                 dst(y,x) = 1;
%             end;
%         end;
%     end;
%     mask = dst;

    % remove zero boundaries
%     [x1,y1,x2,y2] = mask_bb(mask);
%     mask = mask(y1:y2,x1:x2);
    mask = cast(mask,'uint8');
    
    si = mask_size(mask);
    si
    [hm,wm] = size(mask)
    masks(1:hm,1:wm,p) = mask;
    masks_dims(p,1) = hm;
    masks_dims(p,2) = wm;
    masks_dims(p,3) = si;
    masks_dims(p,4) = n_rotations;

    imwrite(mask,['mask_' num2str(p) '.bmp']);
    imshow(mask,'InitialMagnification',scale);
end;
masks = cast(masks,'uint8');
%%
figure;
set(gcf,'KeyPressFcn',@OnKeyPress);
set(gcf,'CloseRequestFcn','setappdata(gcbf,''canceling'',1)');
set(gcf,'DoubleBuffer','on');
set(gcf,'backingStore','off');
setappdata(gcf,'canceling',0);

targets = [];
targets_dims = [];
mean_delay = 0;
n_delay = 0;
is_first = 1;
for p=1:n_targets0
    if(is_movie)
        % On Windows: 'Indeo3' 'Indeo5' 'Cinepak' 'MSVC' 'None'
        mov = avifile(['example_' num2str(p) '.avi'],'colormap',gray(256),'compression','None');
    end;
    hm = masks_dims(p,1);
    wm = masks_dims(p,2);
    si = masks_dims(p,3);
    n_rotations = masks_dims(p,4);
    mask = masks(1:hm,1:wm,p);
    f = zeros(si,1);
    person_id = targets0(p);
    h = srcs_dims(p,1);
    w = srcs_dims(p,2);
    src = srcs(1:h,1:w,p);
    imwrite(src,['p_' num2str(p) '.bmp']);
    
    min_angle = 1;
    max_angle = 360;
    d_angle = (max_angle-min_angle)/(n_rotations-1);
    
    k = 1;
    for angle=min_angle:d_angle:max_angle
        % rotation
        rot = imrotate(src,angle,'nearest','loose');
        [rh,rw] = size(rot);
        xc = round((rw-wm+1)/2);
        yc = round((rh-hm+1)/2);
        rect = [xc yc wm-1 hm-1];
        rot = imcrop(rot,rect);
        
        % apply gamma transformation
        if(is_apply_gamma ~= 0)
            %gamma = 2;
            gamma = 0.25;
            rot = imadjust(rot,[],[],gamma);
        end;
        
        % add noise
        if(is_add_noise ~= 0)
            m = 0.0;
            v = 0.001;
            rot = imnoise(rot,'gaussian',m,v);
        end;
        
        % find edges
%         [X, map] = gray2ind(rot,16);        
%         rot = im2double(ind2gray(X,map));
        
        if(is_filtered ~= 0)
            rot = image_filter(rot,2);
        end;
        
        tic;
        extract_data_c(rot);
        delay = toc;
        if(is_first == 0)
            mean_delay = mean_delay + delay;
            n_delay = n_delay + 1;
        else
            is_first = 0;
        end;
        rot = recreate_data(f,mask);
        if(is_write ~= 0)
            imwrite(rot,[path 'r_' num2str(k) '.bmp']);
        end;

        targets(1:si,k,p) = f;
        if(is_write ~= 0)
            imwrite(rot,[path 's_' num2str(k) '.bmp']);
        end;
        imshow(rot,'InitialMagnification',scale);
        if(is_movie)
            mov = addframe(mov,im2uint8(rot));
        end;
        title(['p [' sprintf('%0.0f',p) '] , a [' sprintf('%03.1f',angle) ']']);
        drawnow;
        cla;
        if(getappdata(gcf,'canceling'))
            break;
        end;
        k = k + 1;
    end;
    if(getappdata(gcf,'canceling'))
        break;
    end;
    if(is_movie)
        mov = close(mov);
    end;
end;
if(n_delay > 0)
    mean_delay = mean_delay/n_delay;
    disp(['mean time: [' num2str(mean_delay) '] sec , frame rate = [' num2str(1/mean_delay) '] fps']);
end;
delete(gcf);
delete(gcf);
%% Save settings
save settings targets masks masks_dims targets0 n_targets0 dim;
save scales_settings targets0 scales Smax;
%% EOF