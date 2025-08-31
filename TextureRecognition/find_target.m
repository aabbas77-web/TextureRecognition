function [] = find_target(src,p,o,th)
global eigentargets sMaxs sMins target_s target_s2 f mean_target objects objects_count objs n_targets0 n_objects Msks Sizes As;
m_target = mean_target(:,p);
e_target1 = eigentargets(:,1,p);
e_target2 = eigentargets(:,2,p);
A = As(:,p);
min1 = sMins(1,p);
min2 = sMins(2,p);
max1 = sMaxs(1,p);
max2 = sMaxs(2,p);

k = extract_pos_c;
for i=1:k
    X0 = X(i,1);
    Y0 = Y(i,1);
    
    extract_data_c(src(Y0:Y0+target_s-1,X0:X0+target_s-1));
    v = (f - m_target)';
    [p0,a0,i0,e0] = find_best_target(v,p);
    
    if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360))
        continue;
    end;
    
    o = o + 1;
    objs(o,1) = X0;
    objs(o,2) = Y0;
    objs(o,3) = 1;
    objs(o,4) = p0;
    objs(o,5) = a0;
    objs(o,6) = i0;
    objs(o,7) = e0;
    objs(o,8) = 1;
end;
%% EOF