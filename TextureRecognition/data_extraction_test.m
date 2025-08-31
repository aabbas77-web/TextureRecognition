%% Initialize MATLAB
close all;
clear all;
clc;
%%
global eigentargets sMins sMaxs sCounts sCoeffs aCoeffs;
global target_s target_s2 si f mean_target Emax objects objects_count objs max_th mask I is_learning global_scale n_targets0 n_objects;
load eigentargets_params Coeffs mean_target eigentargets eigen_values;
load settings targets target_s si f mask targets0 n_targets0;
load coefficients sCoeffs sCounts sMaxs sMins aCoeffs Msk sc;
%%
H = 0;
W = H;
filename = '500.bmp';
% filename = '600.bmp';
src = read_grayscale_image(filename,H,W);
src = im2double(src);
[h0,w0] = size(src);
s = min(h0,w0);
figure;
imshow(src);
%% Basic scan
tic;
K1 = [];
k1 = 0;
for sq=8:1:s
    H0 = h0-sq+1;
    W0 = w0-sq+1;
    k = W0*H0;
    k1 = k1 + 1;
    K1(k1) = k;
end;
delay = toc;
disp(['elapsed time: [' num2str(delay) '] sec']);
%% Enhanced scan (with minimum use of resize function)
tic;
K2 = [];
k2 = 0;
for sq=8:1:s
    d = target_s/sq;
    H0 = h0*d;
    W0 = w0*d;
    dst = imresize(src,[H0 W0],'lanczos3');
    k = 0;
    for y=1:d:H0-target_s+1
        for x=1:d:W0-target_s+1
            k = k + 1;
        end;
    end;
    k2 = k2 + 1;
    K2(k2) = k;
end;
delay = toc;
disp(['elapsed time: [' num2str(delay) '] sec']);

figure;
hold on;
plot(K1,'b');
plot(K2,'r');
%% Create new folder
path = 'zooms/';
if(isdir(path) == 1)
    rmdir(path,'s');
end;
mkdir(path);
%% find all expected squares
tic;
mn = 2;
mx = 2;
% for sq=8:1:8
% for sq=target_s:1:target_s
% for sq=8:1:s
% for sq=16:1:s
for sq=max(1,target_s-mn):1:min(s,target_s+mx)
    d = target_s/sq;
    H0 = h0*d;
    W0 = w0*d;
    dst = imresize(src,[H0 W0],'lanczos3');
    data = extract_all_data(dst,d);
    sq
end;
delay = toc;
disp(['elapsed time: [' num2str(delay) '] sec']);
%% EOF