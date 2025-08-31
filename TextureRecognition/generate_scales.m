%% Initialize MATLAB
close all;
clear all;
clc;
%% Options
H = 0;
W = H;

% Smax = 2.0;
% Smax = 1.8;
% Smax = 1.6;
% Smax = 1.4;
% Smax = 1.2;
Smax = 1.0;

dS = 0.2;
%% Load source image
% targets1 = [11]; %#ok<NBRAK>
% targets1 = [22]; %#ok<NBRAK>
% targets1 = [33]; %#ok<NBRAK>
% targets1 = [11,22,33,44,55,66,77,88,99];
% targets1 = [11,22];
% targets1 = [11,22,33];
% targets1 = [3001]; %#ok<NBRAK>
% targets1 = [3002]; %#ok<NBRAK>
% targets1 = [3003]; %#ok<NBRAK>
% targets1 = [3004]; %#ok<NBRAK>
% targets1 = [3005]; %#ok<NBRAK>
% targets1 = [3006]; %#ok<NBRAK>
% targets1 = [3007]; %#ok<NBRAK>
% targets1 = [3008]; %#ok<NBRAK>
% targets1 = [3009]; %#ok<NBRAK>
% targets1 = [3010]; %#ok<NBRAK>
% targets1 = [3011]; %#ok<NBRAK>

% targets1 = [6000]; %#ok<NBRAK>
% targets1 = [4001]; %#ok<NBRAK>
% targets1 = [4001,4002];
% targets1 = [4001,4002,4003,4004,4005,4006,4007,4008,4009,4010];
% targets1 = [4007,4008];
% targets1 = [5003,5004,5005];

% targets1 = [7001,7002,7003,7004,7005,7006];
targets1 = [7001]; %#ok<NBRAK>

% targets1 = [2001]; %#ok<NBRAK>
% targets1 = [2001,2002,2003,2004,2005,2006,2007,2008,2009];
% targets1 = [2005,2006,2007,2008,2009];
n_targets1 = length(targets1);

% filename = '2001.bmp';
% filename = '2000.bmp';
% filename = '3000.bmp';
% filename = '4000.bmp';
% filename = '5000.bmp';
% filename = '390.bmp';
% filename = '400.bmp';
% filename = '1.bmp';
% filename = '11.bmp';
% filename = '111.bmp';

scales = [];
targets0 = [];
ks = 1000;
k = 1;
for p=1:n_targets1
    person_id = targets1(p);
    filename = [num2str(abs(person_id)) '.bmp'];
    src = read_grayscale_image(filename,H,W);
    [h,w] = size(src);
    
    % Generate scales
    for s=1:dS:Smax
        scales(k,1) = s;
        targets0(k,1) = ks;
        dst = imresize(src,s,'nearest');
        imwrite(dst,[num2str(ks) '.bmp']);
        k = k + 1;
        ks = ks + 1;
        figure;
        imshow(dst);
    end;
end;
%% Save settings
save scales_settings targets0 scales Smax;
%% EOF