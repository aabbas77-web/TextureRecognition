function [src] = draw_point(src,x,y,color,width)
for j=-width:width
    for i=-width:width
        if((y+j >= 1) && (x+i >= 1))
            src(y+j,x+i) = color;
        end;
    end;
end;
%% EOF