function [ d_ref ] = find_ref_plane( roi )
%FIND_REF_PLANE Find the depth of reference plane of an ROI
%   Detailed explanation goes here

[~,roi_size] = size(roi);

refplane = roi(1:(roi_size*0.25),(roi_size*0.25):(roi_size*0.9));
d_ref = max(max(refplane));

end

