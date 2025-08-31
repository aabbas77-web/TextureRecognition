%% Initialize MATLAB
close all;
clear all;
clc;
%%
mex -O -inline extract_pos_c.c
mex -O -inline extract_data_c.c
mex -O -inline polyline_zeros_c.c

% mex extract_pos_c.c
% mex extract_data_c.c
% mex polyline_zeros_c.c

% mex -g extract_pos_c.c
% mex -g extract_data_c.c

% mex -O -inline extract_pos_c.c
% mex extract_coeff_c.c
% mex polyline_zeros_c.c
disp('[ok] Compiled successfully...');
%% EOF