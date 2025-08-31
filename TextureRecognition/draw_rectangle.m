function [handle] = draw_rectangle(rect,color)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);

X(1) = x;
Y(1) = y;
X(2) = x+w;
Y(2) = y;
X(3) = x+w;
Y(3) = y+h;
X(4) = x;
Y(4) = y+h;
X(5) = x;
Y(5) = y;

handle = plot(X,Y,'Color',color);
%% EOF