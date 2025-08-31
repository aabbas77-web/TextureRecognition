function [dst] = recreate_data(f,mask)
global dim;
[h,w] = size(mask);
dst = zeros(h,w);
k = 1;
for y=1:h
    for x=1:w
        if(mask(y,x) > 0)
            for j=-dim:dim
                for i=-dim:dim
                    if((y+j >= 1) && (y+j <= h) && (x+i >= 1) && (x+i <= w))
                        dst(y+j,x+i) = f(k);
                    end;
                end;
            end;
            k = k + 1;
        end;
    end;
end;
%% EOF