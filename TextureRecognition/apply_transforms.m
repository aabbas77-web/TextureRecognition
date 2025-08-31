function [dst] = apply_transforms(src,scale,angle,gamma)
[h,w] = size(src);

% scale
src = imresize(src,[scale*h,scale*w],'bicubic');

% rotation
src = imrotate(src,angle,'bicubic','loose');

% normal intensity
dst = imadjust(src,[],[],gamma);
%% EOF