function [FMR] = calculate_FMR(impostor_dists, all_dists)

count = 0;

%v = var(all_dists);
%m = mean(all_dists);
%c = 1/(sqrt(v*2*pi));

%impostor_dists = c * exp( ((impostor_dists - m).^2) ./ (2*v) );

all_dists = sort(all_dists); 

for threshold = 0.01:0.0001:1.00
    %tempvec = (impostor_dists <= threshold*61);

    %Find all impostors <= than the threshold 'percentile' for all results
    tempvec = (impostor_dists <= all_dists(round (threshold * numel(all_dists)) ));

    FM = sum(tempvec);
    count = count + 1;
    FMR(count,1) = FM / numel(impostor_dists);
end
