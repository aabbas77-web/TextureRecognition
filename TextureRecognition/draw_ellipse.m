function [handle] = draw_ellipse(rect,color)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
rx = w/2;
ry = h/2;
xc = x + rx;
yc = y + ry;

dt = 2*pi/100;
t = 0:dt:2*pi;
X = xc + rx * cos(t);
Y = yc + ry * sin(t);

handle = plot(X,Y,'Color',color);
%% EOF