function [a0,i0,e0] = find_best_target(v,p)
global eigentargets sCounts sCoeffs aCoeffs max_count coeff cn si;
R = zeros(360,1);
a0 = 0;
i0 = 0;
e0 = 0;
for i=1:cn
    % coeffiect calculation
    y0 = v * eigentargets(1:si,i,p);
    coeff(i,1) = y0;
    
    % polyline zeros
    M = sCounts(i,p);
    x = sCoeffs(i,1:M,1,p);
    y = sCoeffs(i,1:M,2,p);
    polyline_zeros_c(y0);
    mx = max(R);
    if(i < cn)
        if(mx < max_count)
            continue;
        end;
    end;
    ix = find(R >= mx);
    n = length(ix);
    i0 = i;
    a0 = ix(1);
    e0 = sum(abs(aCoeffs(1:max_count,a0,p)-coeff(1:max_count,1)))/max_count;
    if(n > 1)
        Emin = e0;
        Amin = a0;
        for j=2:n
            a0 = ix(j);
            e0 = sum(abs(aCoeffs(1:max_count,a0,p)-coeff(1:max_count,1)))/max_count;
            if(e0 < Emin)
                Emin = e0;
                Amin = a0;
            end;
        end;
        e0 = Emin;
        a0 = Amin;
    end;
    break;
end;
%% EOF