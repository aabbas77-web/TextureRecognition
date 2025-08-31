function [dst] = image_filter(src,degree)
% (degree >= 1)
[h,w] = size(src);
s = max(h,w);
%%
persistent T mask s0 degree0 dct invdct;
if(isempty(T) || (s ~= s0) || (degree ~= degree0))
    T = dctmtx(s);
    dct = @(x)T * x * T';
    invdct = @(x)T' * x * T;
    
    r = s/degree;
%     S = s/sqrt(2);
%     L = 2*(S-1)^2;
%     th = exp(-L/(2*r^2));
    th = 0.1;
    mask = zeros(s,s);
    for y=1:s
        for x=1:s
            L = (x-1)^2+(y-1)^2;
            m = exp(-L/(2*r^2));
            if(m >= th)
                mask(y,x) = m;
            end;
        end;
    end;
end;
s0 = s;
degree0 = degree;
%%
B = blkproc(src,[s s],dct);
B2 = blkproc(B,[s s],@(x)mask.* x);
dst = blkproc(B2,[s s],invdct);
%% EOF