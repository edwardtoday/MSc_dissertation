function [FNMR] = calculate_FNMR(genuine_dists)

count = 0;

genuine_scores = 1 ./ genuine_dists;


%genuine_scores = c * exp( ((genuine_scores - m).^2) ./ (2*v) );

for threshold = 0.01:0.01:1.00
    tempvec = (genuine_scores <= all_scores(round (threshold * numel(all_scores)) )); 
    FNM = sum(tempvec);
    count = count + 1;
    FNMR(count,1) = 100*FNM / numel(genuine_scores);
end
