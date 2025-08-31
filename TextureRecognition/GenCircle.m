function [P] = GenCircle(xc,yc,r)
if(r >= 24)
    n0 = round(2*pi*r);
else
    n0 = round(2*pi*(pi+r));
end;
P = zeros(n0,2);
k = 1;

x = r;
y = 0;
XChange = 1-2*r;
YChange = 1;
RadiusError = 0;
while(x >= y) % only formulate 1/8 of circle
    %upper left left
    P(k,1) = xc-x;
    P(k,2) = yc-y;
    k = k + 1;
    %upper upper left
    P(k,1) = xc-y;
    P(k,2) = yc-x;
    k = k + 1;
    %upper upper right
    P(k,1) = xc+y;
    P(k,2) = yc-x;
    k = k + 1;
    %upper right right
    P(k,1) = xc+x;
    P(k,2) = yc-y;
    k = k + 1;
    %lower left left
    P(k,1) = xc-x;
    P(k,2) = yc+y;
    k = k + 1;
    %lower lower left
    P(k,1) = xc-y;
    P(k,2) = yc+x;
    k = k + 1;
    %lower lower right
    P(k,1) = xc+y;
    P(k,2) = yc+x;
    k = k + 1;
    %lower right right
    P(k,1) = xc+x;
    P(k,2) = yc+y;
    k = k + 1;

    y = y + 1;
    RadiusError = RadiusError + YChange;
    YChange = YChange + 2;
    if(2*RadiusError + XChange > 0)
        x = x - 1;
        RadiusError = RadiusError + XChange;
        XChange = XChange + 2;
    end;
end;
if(k-1 < n0)
    P(k:n0,:) = [];
end;
end
%% EOF