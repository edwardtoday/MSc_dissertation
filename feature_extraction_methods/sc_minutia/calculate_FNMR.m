function [FNMR] = calculate_FNMR(genuine_dists, all_dists)

count = 0;


v = var(all_dists);
m = mean(all_dists);

c = 1/(sqrt(v*2*pi));  

all_dists = sort(all_dists);  

%genuine_dists = c * exp( ((genuine_dists - m).^2) ./ (2*v) );

for threshold = 0.01:0.0001:1.00
    %tempvec = (genuine_dists > threshold*61);


    %Find all genuines > than the threshold 'percentile' for all results
    tempvec = (genuine_dists > all_dists(round (threshold * numel(all_dists)) )); 
    FNM = sum(tempvec);
    count = count + 1;
    FNMR(count,1) = FNM / numel(genuine_dists);
end
