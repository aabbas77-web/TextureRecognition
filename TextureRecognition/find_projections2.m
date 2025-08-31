function [dst] = find_projections2(src)
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs Msk sc;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
persistent index;
if(isempty(index))
    index = 1;
else
    index = index + 1;
end;

[h,w] = size(src);
H = h-target_s+1;
W = w-target_s+1;
if(min(H,W) < 1)
    return;
end;

% d = 7;
% d = 6;
% d = 5;
d = 4;
% d = 3;
% d = 2;
% d = 1;

J1 = 1;
J2 = 2;

H0 = floor(H/d);
W0 = floor(W/d);
dst = zeros(H0,W0,J2-J1+1,n_targets0);
y0 = 1;
for y=1:d:H
    x0 = 1;
    for x=1:d:W
        extract_data_c(src(y:y+target_s-1,x:x+target_s-1));
        for p=1:n_targets0
            v = (f - mean_target(:,p))';
            for j=J1:J2
                dst(y0,x0,j,p) = v * eigentargets(:,j,p);
            end;
        end;
        x0 = x0 + 1;
    end;
    y0 = y0 + 1;
end;

tmp = zeros(H,W,J2-J1+1,n_targets0);
for p=1:n_targets0
    for j=J1:J2
        tmp(:,:,j,p) = imresize(dst(:,:,j,p),[H W],'lanczos3');
    end;
end;
dst = tmp;
%% EOF