function find_all_targets(src,ds)
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
%% find all expected squares
[h0,w0] = size(src);
s = min(h0,w0);
o = 0;
Emin = 1E16;
s0 = max(8,round(s/3));
% s0 = 2;
% for sq=s0:s
for sq=target_s:target_s
    H0 = h0-sq+target_s;
    W0 = w0-sq+target_s;
    ratio = min(H0/h0,W0/w0);
    dst = imresize_old(src,ratio,'bilinear');
    [h,w] = size(dst);
    for y=1:h-target_s+1
        for x=1:w-target_s+1
            block = dst(y:y+target_s-1,x:x+target_s-1);
            extract_data_c(block);
            v = (f - mean_target)';
            [p0,a0,i0,e0] = find_best_target(v);
            if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360))
                continue;
            end;
            if(e0 < Emin)
                Emin = e0;
                o = 1;
                objs(o,1) = x;
                objs(o,2) = y;
                objs(o,3) = sq/target_s;
                objs(o,4) = p0;
                objs(o,5) = a0;
                objs(o,6) = i0;
                objs(o,7) = e0;
                objs(o,8) = 1/ratio;
            end;
        end;
    end;
end;
if(o > 0)
    objects_count = 1;
    objects(objects_count,:) = objs(1,:);
end;
%% EOF