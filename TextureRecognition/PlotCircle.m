function [src,n] = PlotCircle(src,xc,yc,r,color)
[h,w] = size(src);
n = 0;
x = r;
y = 0;
XChange = 1-2*r;
YChange = 1;
RadiusError = 0;
while(x >= y) % only formulate 1/8 of circle
    X = xc-x;
    Y = yc-y;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc-y;
    Y = yc-x;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc+y;
    Y = yc-x;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc+x;
    Y = yc-y;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc-x;
    Y = yc+y;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc-y;
    Y = yc+x;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc+y;
    Y = yc+x;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    X = xc+x;
    Y = yc+y;
    if((X >= 1) && (X <= w) && (Y >= 1) && (Y <= h))
        src(Y,X) = color;
    end;
    n = n + 8;
    y = y + 1;
    RadiusError = RadiusError + YChange;
    YChange = YChange + 2;
    if(2*RadiusError + XChange > 0)
        x = x - 1;
        RadiusError = RadiusError + XChange;
        XChange = XChange + 2;
    end;
end;
end
%% EOF

