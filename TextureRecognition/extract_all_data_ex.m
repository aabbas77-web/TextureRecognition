function [P,nPs] = extract_all_data_ex(src,d,sq)
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
m_target = mean_target(:,p);
e_target1 = eigentargets(:,1,p);
e_target2 = eigentargets(:,2,p);
Xc = -sMins(1);
Yc = -sMins(2);
X = zeros(1,2000);
Y = zeros(1,2000);
k = extract_pos_c(src);
k
P(1:k,1) = X(1,1:k);
P(1:k,2) = Y(1,1:k);
nPs(1,1) = k;
%% EOF