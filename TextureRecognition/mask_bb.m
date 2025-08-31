function [x1,y1,x2,y2] = mask_bb(mask)
[h,w] = size(mask);
x1 = 1E16;
x2 = -1E16;
y1 = 1E16;
y2 = -1E16;
for y=1:h
    for x=1:w
        if(mask(y,x) > 0)
            if(x < x1), x1 = x; end;
            if(x > x2), x2 = x; end;
            if(y < y1), y1 = y; end;
            if(y > y2), y2 = y; end;
        end;
    end;
end;
%% EOF