function find_targets(src,ds)
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
%% Pyramids count
[h,w] = size(src);
if((w < target_s) || (h < target_s))
    error(['invalid input image size , target_s: ' num2str(target_s) ' , w: ' num2str(w)]);
end;
M = min(h,w);
n_pyramids = 1;
ratio = 1/1.5;
for i=1:100
    if(ceil(ratio*M) < target_s)
        break;
    end;
    M = ceil(ratio*M);
    n_pyramids = n_pyramids + 1;
end;
n_pyramids = 1;% for test only
%% process pyramids
pyramid_scale = 1;
dt = 1;
o = 0;
for py=1:n_pyramids
    for y=1:dt:h-target_s+1
        for x=1:dt:w-target_s+1
%             extract_data_c(src(y:y+target_s-1,x:x+target_s-1));
            extract_data(src(y:y+target_s-1,x:x+target_s-1));
            v = (f - mean_target)';
            [p0,a0,i0,e0] = find_best_target(v);
            if(is_learning)
                if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360))
                    continue;
                end;
            else
%                 if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360) || (i0 > Emax(p0,1)) || (e0 > Emax(p0,2)))
%                 if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360) || (e0 > Emax(p0,2)))
                if((p0 < 1) || (p0 > n_targets0) || (a0 < 1) || (a0 > 360))
                    continue;
                end;
            end;
            
            o = o + 1;
            objs(o,1) = x;
            objs(o,2) = y;
            objs(o,4) = p0;
            objs(o,5) = a0;
            objs(o,6) = i0;
            objs(o,7) = e0;
            objs(o,8) = 1/pyramid_scale;
        end;
    end;
    
    if(n_pyramids > 1)
        src = imresize(src,[ratio*h ratio*w],'bilinear');
        [h,w] = size(src);
        if((w < target_s) || (h < target_s))
            break;
        end;
        pyramid_scale = ratio*pyramid_scale;
    end;
end;
%% final process
% sort objects with respect to errors
Os = sortrows(objs(1:o,:),7);

% exclude overlaped circles
objects_count = 0;
for i=1:size(Os,1)
    x0 = Os(i,1);
    y0 = Os(i,2);
    scale0 = Os(i,8);
    
    is_ok = 0;
    for j=1:objects_count
        x1 = objects(j,1);
        y1 = objects(j,2);
        scale1 = objects(j,8);
        Lx = scale1*(x1+target_s2)-scale0*(x0+target_s2);
        Ly = scale1*(y1+target_s2)-scale0*(y0+target_s2);
        L2 = Lx*Lx+Ly*Ly;
        L1 = (scale0+scale1)*target_s2-ds;
        if(L2 < L1*L1)
            is_ok = 1;
            break;
        end;
    end;
    if(is_ok == 0)
        objects_count = objects_count + 1;
        objects(objects_count,:) = Os(i,:);
        if(objects_count >= n_objects)
            return;
        end;
    end;
end;
%% EOF