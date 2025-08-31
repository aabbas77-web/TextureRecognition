function [Coeffs] = apply_eigentargets(targets,mean_target,eigentargets)
% image decomposition coefficients
atargets = zeros(size(targets));
for i=1:size(targets,2)
    atargets(:,i) = targets(:,i) - mean_target;
end;
Coeffs =  atargets' * eigentargets;
%% EOF