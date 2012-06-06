function [FMR] = calculate_FMR(imposter_scores)

count = 0;

v = var(all_scores);
m = mean(all_scores);
c = 1/(sqrt(v*2*pi));

%imposter_scores = c * exp( ((imposter_scores - m).^2) ./ (2*v) );
all_scores = sort(all_scores);


for threshold = 0.01:0.01:1.00
    %tempvec = (imposter_scores > threshold*61);
    tempvec = (imposter_scores <= all_scores(round (threshold * numel(all_scores)) ));
    FM = sum(tempvec);
    count = count + 1;
    FMR(count,1) = 100*FM / numel(imposter_scores);
end
