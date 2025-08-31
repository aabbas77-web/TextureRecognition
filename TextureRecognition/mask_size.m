function [n] = mask_size(mask)
[h,w] = size(mask);
n = 0;
for y=1:h
    for x=1:w
        if(mask(y,x) > 0)
            n = n + 1;
        end;
    end;
end;
%% EOF