function [P,nPs] = find_projections(src)
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
persistent index;
if(isempty(index))
    index = 1;
else
    index = index + 1;
end;
P = zeros(100,2,n_targets0);
nPs = zeros(1,n_targets0);

[h,w] = size(src);
H = h-target_s+1;
W = w-target_s+1;
if(min(H,W) < 1)
    return;
end;

% d = round(target_s/8);
% d = 2;
d = 1;

J1 = 1;
J2 = 1;

% th = 0.75;
% th = 0.5;
% th = 0.25;
% th = 0.1;
% th = 0.05;
% th = 0.01;
% th = 0.001;
th = 0.0;

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

for p=1:n_targets0
    k = 0;
    for j=J1:J2
        DST = imresize(dst(:,:,j,p),[H W],'lanczos3');
        DST = adjust_image(DST,0,1);
        imwrite(DST,[sprintf('%02.0f',index) '_' sprintf('%02.0f',p) '_' sprintf('%02.0f',j) '.bmp']);
        mx = max(max(DST));
        mn = min(min(DST));
        [row,col] = find(DST >= mx-th);
        if(~isempty(row))
            for i=1:size(row,1)
                k = k + 1;
                P(k,1,p) = col(i);
                P(k,2,p) = row(i);
            end;
        end;
        [row,col] = find(DST <= mn+th);
        if(~isempty(row))
            for i=1:size(row,1)
                k = k + 1;
                P(k,1,p) = col(i);
                P(k,2,p) = row(i);
            end;
        end;
    end;
    nPs(1,p) = k;
end;
%% EOF