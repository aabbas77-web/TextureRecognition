function [P,nPs] = extract_all_data(src,d,sq)
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs Coeffs Msk sc dm is_debug index path;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
P = zeros(500,2,n_targets0);
nPs = zeros(1,n_targets0);

[h,w] = size(src);
H = h-target_s+1;
W = w-target_s+1;
if(min(H,W) < 1)
    return;
end;
[hm,wm] = size(Msk);
%% find all expected squares
p = 1;

if(is_debug)
    X1 = [];
    Y1 = [];
    X = [];
    Y = [];
    k = 0;
end;
k1 = 0;
nn = 0;

for y1=1:d:H
    for x1=1:d:W
        x0 = round(x1);
        y0 = round(y1);
        extract_data_c(src(y0:y0+target_s-1,x0:x0+target_s-1));
        v = (f - mean_target(:,p))';
        X0 = v * eigentargets(:,1,p);
        Y0 = v * eigentargets(:,2,p);
    
        x = round(sc*(-sMins(1)+X0))+dm+1;
        y = round(sc*(-sMins(2)+Y0))+dm+1;
        if((x >= 1) && (x <= wm) && (y >= 1) && (y <= hm))
            if(Msk(y,x) ~= 0)
                k1 = k1 + 1;
                P(k1,1,1) = x0;
                P(k1,2,1) = y0;
                if(is_debug)
                    X1(k1) = X0;
                    Y1(k1) = Y0;
                end;
            else
                if(is_debug)
                    k = k + 1;
                    X(k) = X0;
                    Y(k) = Y0;
                end;
            end;
        else
            nn = nn + 1;
            if(is_debug)
                k = k + 1;
                X(k) = X0;
                Y(k) = Y0;
            end;
        end;
    end;
end;
nn
nPs(1,1) = k1;

if(is_debug)
    delete(gcf);
    figure;
    cla;
    hold on;
    plot(Coeffs(:,1,1),Coeffs(:,2,1),'-b');
    plot(X(1:k),Y(1:k),'.r');
    plot(X1(1:k1),Y1(1:k1),'.g');
    drawnow;
    frame_name = [path 'mask_' sprintf('%02.0f',sq) '_' sprintf('%03.0f',index)];
    saveas(gcf,frame_name,'emf');
end;
%% EOF