function [y0] = polyline_value(x,y,x0)
n = min(length(x),length(y));
y0 = 0;
if(x0 < x(1))
    y0 = y(1);
    return;
end;
if(x0 > x(n))
    y0 = y(n);
    return;
end;
for i=1:n-1
    if((x0 >= x(i)) && (x0 <= x(i+1)))
        y0 = y(i)+(y(i+1)-y(i))*(x0-x(i))/(x(i+1)-x(i));
        break;
    end;
end;
%% EOF