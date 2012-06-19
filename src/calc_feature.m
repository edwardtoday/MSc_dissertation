function [ feature ] = calc_feature( mat )
%calc_feature
%   Calculate feature of a depth matrix, return a feature vector

% Dummy feature
feature = mean(mat);

% 
% [~,roi_size] = size(mat);
% 
% %% Surface Curvatures
% [x y] = meshgrid(1:roi_size,1:roi_size);
% x = 10*x/roi_size; y = 10*y/roi_size;
% [K H Pmax Pmin] = surfature(x,y,mat);
% 
% mu = mean(K(:));
% sigma = std(K(:));
% K_norm=(K-mu)./(2*sigma)*.5+.5;
% 
% feature = K_norm(:);
