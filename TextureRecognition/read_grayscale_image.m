function [src] = read_grayscale_image(filename,H,W)
info = imfinfo(filename);
if(strcmp(info.ColorType,'indexed') == 1)
    [X,map] = imread(filename);
    src = ind2gray(X,map);
elseif(strcmp(info.ColorType,'truecolor') == 1)
    src = imread(filename);
    src = rgb2gray(src);
else
    src = imread(filename);
end;
if((H > 0) && (W > 0))
    src = imresize(src,[H W],'lanczos3');
end;
%% EOF