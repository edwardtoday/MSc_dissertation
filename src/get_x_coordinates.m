clear;

prefix = '..\..\3D_palm';

%% File to process
load_dir = [prefix filesep '3DPalm_xyz'];
file_mask = [load_dir filesep '*.dat'];
file_list = dir(file_mask);
file_list = char({file_list.name});

%% Get X coordinates from file
tic;
dat_file = reshape(dlmread([load_dir filesep file_list(1,:)]),768,576,3);
palmX=dat_file(:,1,1);

%% Save result to file
save_dir = ['output'];
save([save_dir filesep '3Dpalm_x.mat'],'palmX');
toc;