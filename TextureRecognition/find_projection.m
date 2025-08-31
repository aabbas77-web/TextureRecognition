function [dst,P] = find_projection(src,No)
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
[h,w] = size(src);
H = h-target_s+1;
W = w-target_s+1;
dst = zeros(H,W);
for y=1:H
    for x=1:W
        extract_data_c(src(y:y+target_s-1,x:x+target_s-1));
        dst(y,x) = (f - mean_target)' * eigentargets(:,No);
    end;
end;

nP = 1000;
P = zeros(nP,2);
k = 0;

% DST = abs(dst);
% DST = adjust_image(DST,0,1);
% [row,col] = find(DST >= 0.99);
% for i=1:size(row,1)
%     k = k + 1;
%     P(k,1) = col(i);
%     P(k,2) = row(i);
% end;

% DST = abs(dst);
% Ymax = max(max(DST));
% [row,col] = find(abs(DST - Ymax) <= 0.01);
% for i=1:size(row,1)
%     k = k + 1;
%     P(k,1) = col(i);
%     P(k,2) = row(i);
% end;

% Ymax = sMaxs(1,1);
% Ymin = sMins(1,1);
% [row,col] = find((dst <= Ymax) & (dst >= Ymin));
% for i=1:size(row,1)
%     k = k + 1;
%     P(k,1) = col(i);
%     P(k,2) = row(i);
% end;

dst = adjust_image(dst,0,1);
Ymax = max(max(dst));
Ymin = min(min(dst));
[row,col] = find(dst == Ymax);
for i=1:size(row,1)
    k = k + 1;
    P(k,1) = col(i);
    P(k,2) = row(i);
end;
[row,col] = find(dst == Ymin);
for i=1:size(row,1)
    k = k + 1;
    P(k,1) = col(i);
    P(k,2) = row(i);
end;

% k
% H*W

if(k+1 <= nP)
    P(k+1:nP,:) = [];
end;
%% EOF