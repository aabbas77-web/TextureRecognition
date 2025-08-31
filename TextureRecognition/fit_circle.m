function X = fit_circle(x,y)
% x,y are vectors of coordinates (coloumns)
A = [x y ones(size(x))];
Y = -(x.^2 + y.^2);
S = A'*A;
S = S + 1E-6*ones(size(S));
X = S\(A'*Y);
%% EOF