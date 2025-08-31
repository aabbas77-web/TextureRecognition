function extract_data(src)
global f mask I;

% I = (mask > 0);
% f = src(I);

[h,w] = size(mask);
% f = reshape(src,w*h,1);

% m = mean(f);

k = 1;
m = 0;
for y=1:h
    for x=1:w
        if(mask(y,x) > 0)
            f(k,1) = src(y,x);
            m = m + f(k,1);
            k = k + 1;
        end;
    end;
end;
m = m/(k-1);

% subtract mean value
f = f-m+0.5;

% filtering
% th1 = 0.25;
% th2 = 0.75;
% I = (f < th1);
% f(I) = th1;
% I = (f > th2);
% f(I) = th2;
end
%% EOF