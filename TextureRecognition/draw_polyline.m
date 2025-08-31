function [src] = draw_polyline(src,P,color,is_closed)
n = size(P,1);
if(is_closed)
    P(n+1,1) = P(1,1);
    P(n+1,2) = P(1,2);
    n = n + 1;
end;
x0 = P(1,1);
y0 = P(1,2);
for i=2:n
    x1 = P(i,1);
    y1 = P(i,2);
    [src] = draw_line(src,x0,y0,x1,y1,color);
    x0 = x1;
    y0 = y1;
end;
%% EOF