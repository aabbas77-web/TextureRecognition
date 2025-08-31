function a = fit_ellipse(x,y)
% x,y are vectors of coordinates (coloumns)

% Build design matrix
D = [x.*x x.*y y.*y x y ones(size(x))];

% Build scatter matrix
S = D'*D;

% Add positive values to enhance matrix inversion (remove zeros)
% Added by Ali Abbas
S = S + 1E-6*ones(size(S));

% Build 6x6 constraint matrix
C(6,6)=0;
C(1,3)=2;
C(2,2)=-1;
C(3,1)=2;

% Solve eigensystem
% [gevec,geval] = eig(inv(S)*C);
[gevec,geval] = eig(S\C);

% Find the positive eigenvalue
[PosR,PosC] = find((geval>0) & (~isinf(geval)));

% Extract eigenvector corresponding to positive eigenvalue
a = gevec(:,PosC);
%% EOF