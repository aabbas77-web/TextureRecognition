function [mean_target,eigentargets,eigen_values] = generate_eigentargets(targets,eigenvalues_count,eigenvalue_threshold)
%% Calculating mean target
n_targets = size(targets,2);
mean_target = mean(targets,2);
%% Adjust targets
atargets = zeros(size(targets));
k = 1;
for i=1:n_targets
    f = targets(:,i) - mean_target;
    if(f'*f > eps)
        atargets(:,k) = f;
        k = k + 1;
    end;
end;
if(k-1 < n_targets)
    atargets(:,k:end) = [];
end;
%% Calculating covariance matrix
% cov_mat = atargets'*atargets/(n_targets-1);
cov_mat = atargets'*atargets;
%% Calculating eigen values and eigen targets of the covariance matrix
[V,D] = eig(cov_mat);
nv = size(V,2);
eigen_values = [];
if(eigenvalues_count > 0)
    V1 = [];
    k = 1;
    for i=nv:-1:max(1,nv-eigenvalues_count+1)
        V1(:,k) = V(:,i);
        eigen_values(k,1) = D(i,i);
        k = k + 1;
    end;
    eigentargets = atargets * V1;
elseif(eigenvalues_count == 0)
    V1 = [];
    k = 1;
    th = eigenvalue_threshold*D(nv,nv);
    for i=nv:-1:1
        if(D(i,i) >= th)
            V1(:,k) = V(:,i);
            eigen_values(k,1) = D(i,i);
            k = k + 1;
        end;
    end;
    eigentargets = atargets * V1;
else
    V1 = [];
    k = 1;
    for i=nv:-1:1
        V1(:,k) = V(:,i);
        eigen_values(k,1) = D(i,i);
        k = k + 1;
    end;
    eigentargets = atargets * V1;
end;
%% Eigentargets orthogonalization
% eigentargets = orth(eigentargets);
%% EOF