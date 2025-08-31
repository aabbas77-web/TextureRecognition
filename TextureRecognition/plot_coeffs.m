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
figure;
imshow(src);
[hm,wm] = size(Msk);
%% Create new folder
path = 'zooms/';
if(isdir(path) == 1)
    rmdir(path,'s');
end;
mkdir(path);
%% find all expected squares
[h0,w0] = size(src);
s = min(h0,w0);

tic;
figure;
hold on;
X = zeros(10000,1);
Y = zeros(10000,1);
X1 = zeros(10000,1);
Y1 = zeros(10000,1);
K1 = 0;
% for sq=1:1:1
% for sq=8:1:9
% for sq=8:1:max(1,s-8)
for sq=1:1:s
    cla;
    plot(Coeffs(:,1,1),Coeffs(:,2,1),'-b');
    
    H0 = h0-sq+target_s;
    W0 = w0-sq+target_s;
    ratio = min(H0/h0,W0/w0);
    dst = imresize(src,ratio,'lanczos3');
    proj = find_projections2(dst);
    k = 0;
    k1 = 0;
    for y0=1:size(proj,1)
        for x0=1:size(proj,2)
            X0 = proj(y0,x0,1,1);
            Y0 = proj(y0,x0,2,1);
            x = sc*round(-sMins(1)+X0)+1;
            y = sc*round(-sMins(2)+Y0)+1;
            if((x >= 1) && (x <= wm) && (y >= 1) && (y <= hm))
                if(Msk(y,x) ~= 0)
                    k1 = k1 + 1;
                    X1(k1) = X0;
                    Y1(k1) = Y0;
                else
                    k = k + 1;
                    X(k) = X0;
                    Y(k) = Y0;
                end;
            else
                k = k + 1;
                X(k) = X0;
                Y(k) = Y0;
            end;
        end;
    end;
    k1
    plot(X(1:k-1),Y(1:k-1),'.r');
    plot(X1(1:k1-1),Y1(1:k1-1),'.g');
    K1 = K1 + k1;
    frame_name = [path 'zoom_' sprintf('%02.0f',sq)];
    saveas(gcf,frame_name,'emf');
end;
K1
delay = toc;
disp(['elapsed time: [' num2str(delay) '] sec']);
%% EOF