function [dst] = normalize_image(src)
src = im2double(src);
m = mean2(src);
dst = src-m+0.5;
%% EOF