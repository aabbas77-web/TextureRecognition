function [P] = GenCirclePath(xc,yc,r)
n0 = round(2*pi*r);
P1 = zeros(n0,2);
P2 = zeros(n0,2);
P3 = zeros(n0,2);
P4 = zeros(n0,2);
P5 = zeros(n0,2);
P6 = zeros(n0,2);
P7 = zeros(n0,2);
P8 = zeros(n0,2);
k = 1;

x = r;
y = 0;
XChange = 1-2*r;
YChange = 1;
RadiusError = 0;
while(x >= y) % only formulate 1/8 of circle
    %upper left left
    P1(k,1) = xc-x;
    P1(k,2) = yc-y;
    %upper upper left
    P2(k,1) = xc-y;
    P2(k,2) = yc-x;
    %upper upper right
    P3(k,1) = xc+y;
    P3(k,2) = yc-x;
    %upper right right
    P4(k,1) = xc+x;
    P4(k,2) = yc-y;
    %lower left left
    P5(k,1) = xc-x;
    P5(k,2) = yc+y;
    %lower lower left
    P6(k,1) = xc-y;
    P6(k,2) = yc+x;
    %lower lower right
    P7(k,1) = xc+y;
    P7(k,2) = yc+x;
    %lower right right
    P8(k,1) = xc+x;
    P8(k,2) = yc+y;
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
    P1(k:n0,:) = [];
    P2(k:n0,:) = [];
    P3(k:n0,:) = [];
    P4(k:n0,:) = [];
    P5(k:n0,:) = [];
    P6(k:n0,:) = [];
    P7(k:n0,:) = [];
    P8(k:n0,:) = [];
end;
P = [P1;flipdim(P2,1);P3;flipdim(P4,1);P8;flipdim(P7,1);P6;flipdim(P5,1)];
end
%% EOF