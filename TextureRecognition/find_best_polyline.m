function [best_polyline] = find_best_polyline(polyline,startindex,endindex,epsilon)
n = size(polyline,1);
if(n <= 1)
    best_polyline = polyline;
    return;
elseif(n == 2)
    if(sqrt((polyline(2,1)-polyline(1,1))^2+(polyline(2,2)-polyline(1,2))^2) <= epsilon)
        best_polyline(1,1) = (polyline(1,1)+polyline(2,1))/2;
        best_polyline(1,2) = (polyline(1,2)+polyline(2,2))/2;
    else
        best_polyline = polyline;
    end;
    return;
end;

global poly best_poly epsilon2 k;
poly = polyline;
best_poly = zeros(size(poly));
k = 1;
epsilon2 = epsilon*epsilon;

% boundary correction
if(startindex < 1)
    startindex = 1;
end;
if(endindex > n)
    endindex = n;
end;

% Fill First Elements
if(startindex > 1)
    for i=1:startindex-1
        best_poly(k,:) = poly(i,:);
        k = k + 1;
    end;
end;

% Call Recursive Procedure
assemple(startindex,endindex);

% Fill Last Elements
if(endindex <= n)
    for i=endindex:n
        best_poly(k,:) = poly(i,:);
        k = k + 1;
    end;
end;

best_polyline = best_poly(1:k-1,:);
%%
function [] = assemple(i1,i2)
global poly best_poly epsilon2 k;
if(i2 <= i1)
    return;
end;

% Get p1, p2
p1 = poly(i1,:);
p2 = poly(i2,:);
L = sqrt((p2(1,1)-p1(1,1))^2+(p2(1,2)-p1(1,2))^2);

% Get J, i3
J = 0.0;
i3 = i1;
MaxD = -1E16;
if(L > 0.0) % (L > 0)
    if(p2(1,1) == p1(1,1)) % (Vertical Line)
        for i=i1:i2
            p = poly(i,:);
            d = abs(p(1,1) - p1(1,1));
            D = d * d;
            J = J + D;
            if(D > MaxD)
                MaxD = D;
                i3 = i;
            end;
        end;
    elseif(p2(1,2) == p1(1,2)) % (Horizontal Line)
        for i=i1:i2
            p = poly(i,:);
            d = abs(p(1,2) - p1(1,2));
            D = d * d;
            J = J + D;
            if(D > MaxD)
                MaxD = D;
                i3 = i;
            end;
        end;
    else % (Any Line)
        for i=i1:i2
            p = poly(i,:);
            d = abs(((p(1,1)-p1(1,1))*(p2(1,2)-p1(1,2))-(p(1,2)-p1(1,2))*(p2(1,1)-p1(1,1)))/L);
            D = d * d;
            J = J + D;
            if(D > MaxD)
                MaxD = D;
                i3 = i;
            end;
        end;
    end;
else % (L <= 0)
    for i=i1:i2
        p = poly(i,:);
        D = (p(1,1)-p1(1,1))^2+(p(1,2)-p1(1,2))^2;
        J = J + D;
        if(D > MaxD)
            MaxD = D;
            i3 = i;
        end;
    end;
end;

% Assemble
if(J <= epsilon2)
    best_poly(k,:) = poly(i1,:);
    k = k + 1;
else
    assemple(i1,i3);
    assemple(i3,i2);
end;
%% EOF