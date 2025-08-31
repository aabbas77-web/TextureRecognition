function [dst,a,b] = adjust_image(src,c1,c2)
mx = max(max(src));
mn = min(min(src));
if(mx == mn)
    a = 0;
    b = 0;
    dst = ones(size(src))*mx;
    return;
end;
a = (c2-c1)/(mx-mn);
b = c1-a*mn;
dst = a*src+b;
%% EOF