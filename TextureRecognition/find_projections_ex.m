function [P,nPs] = find_projections_ex(src,d,sq)
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs Coeffs Msk sc is_debug index path proj0 H0 W0;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
P = zeros(100,2,n_targets0);
nPs = zeros(1,n_targets0);

[h,w] = size(src);
H = h-target_s+1;
W = w-target_s+1;
if(min(H,W) < 1)
    return;
end;
[hm,wm] = size(Msk);
%% find all expected squares
proj = extract_all_data(src,d);

% proj = proj0;

% proj(:,:,1,1) = imresize(proj0(:,:,1,1),[H W],'lanczos3');

% proj = zeros(H,W,2,1);
% proj(:,:,1,1) = imresize(proj0(:,:,1,1),[H W],'bicubic');
% proj(:,:,2,1) = imresize(proj0(:,:,2,1),[H W],'bicubic');

if(is_debug)
    X1 = [];
    Y1 = [];
    X = [];
    Y = [];
    k = 0;
end;
k1 = 0;
nn = 0;
% for y0=1:size(proj,1)
%     for x0=1:size(proj,2)
for y1=1:d:size(proj,1)
    for x1=1:d:size(proj,2)
        x0 = round(x1);
        y0 = round(y1);
        X0 = proj(y0,x0,1,1);
        Y0 = proj(y0,x0,2,1);
        x = round(sc*(-sMins(1)+X0))+1;
        y = round(sc*(-sMins(2)+Y0))+1;
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