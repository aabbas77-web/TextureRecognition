function [src] = fill_window(src,x,y,dim,color)
[h,w] = size(src);
for j=-dim:dim
    for i=-dim:dim
        if((y+j >= 1) && (y+j <= h) && (x+i >= 1) && (x+i <= w))
            src(y+j,x+i) = color;
        end;
    end;
end;
%% EOF