function [P] = polyline_zeros(x,y,y0)
n = length(x);
P = zeros(n,1);
k = 1;
for i=1:n-1
    if((y(i) == y(i+1)) && (y0 == y(i)))
        P(k,1) = x(i);
        k = k + 1;
        P(k,1) = x(i+1);
        k = k + 1;
    elseif(((y0 >= y(i)) && (y0 <= y(i+1))) || ((y0 >= y(i+1)) && (y0 <= y(i))))
        P(k,1) = x(i)+(x(i+1)-x(i))*(y0-y(i))/(y(i+1)-y(i));
        k = k + 1;
    end;
end;
if(k <= n)
    P(k:n,:) = [];
end;
%% EOF