function [PDF] = calc_imposter_pdf(imposter_dists)

count = 0;

imposter_scores = 1 ./ imposter_dists;


for threshold = 0.01:0.01:1.00
    tempvec = intersect(find((imposter_scores <= threshold)) ,  find((imposter_scores > threshold - 0.01) ) );
    P = numel(tempvec);
    count = count + 1;
    PDF(count,1) = P / numel(imposter_scores);
end
~
~

