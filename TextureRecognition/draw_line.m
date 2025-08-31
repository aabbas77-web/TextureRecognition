function [src] = draw_line(src,x0,y0,x1,y1,color,width)
steep = (abs(y1 - y0) > abs(x1 - x0));
if(steep)
    [x0,y0] = swap(x0,y0);
    [x1,y1] = swap(x1,y1);
end;
if(x0 > x1)
    [x0,x1] = swap(x0,x1);
    [y0,y1] = swap(y0,y1);
end;
deltax = x1 - x0;
deltay = abs(y1 - y0);
error = deltax / 2;
y = y0;
if(y0 < y1)
    ystep = 1;
else
    ystep = -1;
end;
for x=x0:x1
    if(steep)
        for j=-width:width
            for i=-width:width
                if((x+j >= 1) && (y+i >= 1))
                    src(x+j,y+i) = color;
                end;
            end;
        end;
    else
        for j=-width:width
            for i=-width:width
                if((y+j >= 1) && (x+i >= 1))
                    src(y+j,x+i) = color;
                end;
            end;
        end;
    end;
    error = error - deltay;
    if(error < 0)
        y = y + ystep;
        error = error + deltax;
    end;
end;

    function [q,r] = swap(s,t)
        q = t;
        r = s;
    end
end
%% EOF