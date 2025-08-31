function [P] = extract_circle(src,xc,yc,r)
if(r >= 24)
    n0 = round(2*pi*r);
else
    n0 = round(2*pi*(pi+r));
end;
P = zeros(n0,3);
k = 1;
[h,w] = size(src);

x = r;
y = 0;
XChange = 1-2*r;
YChange = 1;
RadiusError = 0;
while(x >= y) % only formulate 1/8 of circle
    %upper left left
    P(k,1) = xc-x;
    P(k,2) = yc-y;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %upper upper left
    P(k,1) = xc-y;
    P(k,2) = yc-x;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %upper upper right
    P(k,1) = xc+y;
    P(k,2) = yc-x;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %upper right right
    P(k,1) = xc+x;
    P(k,2) = yc-y;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %lower left left
    P(k,1) = xc-x;
    P(k,2) = yc+y;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %lower lower left
    P(k,1) = xc-y;
    P(k,2) = yc+x;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %lower lower right
    P(k,1) = xc+y;
    P(k,2) = yc+x;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
    k = k + 1;
    %lower right right
    P(k,1) = xc+x;
    P(k,2) = yc+y;
    if((P(k,1) >= 1) && (P(k,1) <= w) && (P(k,2) >= 1) && (P(k,2) <= h))
        P(k,3) = src(P(k,2),P(k,1));
    end;
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