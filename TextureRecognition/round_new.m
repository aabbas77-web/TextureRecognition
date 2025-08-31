function [y] = round_new(x)
if(x-double(int32(x))>=0)
    y = int32(x)+1;
else
    y = int32(x);
end;
%% EOF