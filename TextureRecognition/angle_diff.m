function [d] = angle_diff(a,b)
d1 = abs(a - b);
if(a <= b)
    d2 = abs(a + 360 - b);
else
    d2 = abs(b + 360 - a);
end;
d = min(d1,d2);
%% EOF