%% Initialize MATLAB
close all;
clear all;
clc;
set(0,'ShowHiddenHandles','on');
delete(get(0,'Children'));
%% options
is_preview = 0;
%%
H = 0;
W = H;
start_frame = 0;
end_frame = 801;
frame_count = end_frame - start_frame + 1;
in_path = 'D:\Ali\tracking2010\videos\Kasion\';
out_path = 'D:\Ali\tracking2010\videos\';
out_name = 'Kasion.avi';

% On Windows: 'Indeo3' 'Indeo5' 'Cinepak' 'MSVC' 'None'
mov = avifile([out_path out_name],'colormap',gray(256),'compression','RLE','quality',100,'fps',25);
% mov = avifile([out_path out_name],'colormap',gray(256),'compression','MSVC','quality',100);
% mov = avifile([out_path out_name],'colormap',gray(256),'compression','None');

h_bar = waitbar(0,'Please wait...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(h_bar,'canceling',0);
for index=start_frame:end_frame
    if(getappdata(h_bar,'canceling'))
        break;
    end;
    filename = [in_path 'cam' sprintf('%03.0f',index) '.jpg'];
    src = read_grayscale_image(filename,H,W);
    if(is_preview)
        imshow(src);
        drawnow;
    end;
    mov = addframe(mov,im2uint8(src));
    waitbar(index/frame_count);
end;
mov = close(mov);
delete(h_bar);
%% EOF