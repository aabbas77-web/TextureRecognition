function find_all_targets_ex(src,ds)
global eigentargets sMaxs sMins mean_target objects objects_count objs n_targets0 n_objects As masks masks_dims si ths is_debug frame_name path Coeffs dim Emax is_learning targets;
persistent X Y F1 F2 F10 F20;
if(isempty(X))
    [h,w] = size(src);
    s = h*w;
    X = zeros(s,1);
    Y = zeros(s,1);
    if(is_debug)
        F1 = zeros(s,1);
        F2 = zeros(s,1);
        F10 = zeros(s,1);
        F20 = zeros(s,1);
    end;
end;
%% find all expected squares
K = 0;
o = 0;
for p=1:n_targets0
    th = ths(p,1);
    hm = masks_dims(p,1);
    wm = masks_dims(p,2);
    si = masks_dims(p,3);
    n_rotations = masks_dims(p,4);
    mask = masks(1:hm,1:wm,p);
    f = zeros(si,1);
    m_target = mean_target(1:si,p);
    e_target1 = eigentargets(1:si,1,p);
    e_target2 = eigentargets(1:si,2,p);
    A = As(:,p);
    min1 = sMins(1,p);
    min2 = sMins(2,p);
    max1 = sMaxs(1,p);
    max2 = sMaxs(2,p);
    
    k = extract_pos_c;
    if(is_debug)
        delete(gcf);
        figure;
        hold on;
        plot(F1(1:k(2),1),F2(1:k(2),1),'.r');
        plot(F10(1:k(1),1),F20(1:k(1),1),'.g');
        
        interval = [-0.1,1.1];
        ezplot(@(x,y)myfun(x,y,A,0),interval);
        a0 = A(6);
        A(6) = a0-ths(p,1);
        ezplot(@(x,y)myfun(x,y,A,0),interval);
        A(6) = a0+ths(p,1);
        ezplot(@(x,y)myfun(x,y,A,0),interval);
        
        saveas(gcf,[path 'dbg_' frame_name],'emf');
        
        delete(gcf);
        figure;
        set(gcf,'KeyPressFcn',@OnKeyPress);
        set(gcf,'CloseRequestFcn','setappdata(gcbf,''canceling'',1)');
        set(gcf,'DoubleBuffer','on');
        set(gcf,'backingStore','off');
        setappdata(gcf,'canceling',0);
    end;
    K = K + k(1);
    for i=1:k(1)
        x0 = X(i,1);
        y0 = Y(i,1);
        extract_data_c(src(y0:y0+hm-1,x0:x0+wm-1));
        v = (f - m_target)';
        [a0,i0,e0] = find_best_target(v,p);
        if((a0 < 1) || (a0 > 360))
            continue;
        end;
        if(is_learning == 0)
            if(e0 > 2*Emax(p,2))
                continue;
            end;
        end;
        o = o + 1;
        objs(o,1) = x0;
        objs(o,2) = y0;
        objs(o,3) = 1;
        objs(o,4) = p;
        objs(o,5) = a0;
        objs(o,6) = i0;
        objs(o,7) = e0;
        objs(o,8) = 1;
    end;
end;
if(o <= 0)
    objects_count = 0;
    return;
end;
%% final process
% sort objects with respect to errors
Os = sortrows(objs(1:o,:),7);

% exclude overlaped circles
objects_count = 0;
for i=1:size(Os,1)
    x0 = Os(i,1);
    y0 = Os(i,2);
    p0 = Os(i,4);
    hm0 = masks_dims(p0,1);
    wm0 = masks_dims(p0,2);
    
    is_ok = 0;
    for j=1:objects_count
        x1 = objects(j,1);
        y1 = objects(j,2);
        p1 = objects(j,4);
        hm1 = masks_dims(p1,1);
        wm1 = masks_dims(p1,2);
        Lx = (x1+wm1/2)-(x0+wm0/2);
        Ly = (y1+hm1/2)-(y0+hm0/2);
        L2 = Lx*Lx+Ly*Ly;
        L1 = hm0/2+hm1/2-ds;
        if(L2 < L1*L1)
            is_ok = 1;
            break;
        end;
    end;
    if(is_ok == 0)
        % final test
        error = 0.0;
        if(is_learning == 0)
            a0 = round(Os(i,5));
            si = masks_dims(p0,3);
            mask = masks(1:hm0,1:wm0,p0);
            f = zeros(si,1);
            f0 = targets(1:si,a0,p0);
            extract_data_c(src(y0:y0+hm0-1,x0:x0+wm0-1));
            error = sum(abs(f-f0))/si;
        end;
        error
        if(error < 0.1)
            objects_count = objects_count + 1;
            objects(objects_count,:) = Os(i,:);
            if(objects_count >= n_objects)
                return;
            end;
        end;
    end;
end;
%% EOF