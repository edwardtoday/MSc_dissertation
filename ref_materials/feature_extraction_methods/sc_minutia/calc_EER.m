function [gen_rate, imp_rate] = calc_EER(genuine_dists, imposter_dists)

count = 0;

genuine_scores = 1 ./ (genuine_dists);
imposter_scores = 1 ./ (imposter_dists);



%genuine_scores =  genuine_dists;


for threshold = -10:0.01:100
    tempvec =  find((genuine_scores < threshold) );
    Pgen = numel(tempvec) / numel(genuine_scores);
    count = count + 1;
    gen_rate(count,1) = Pgen*100;

    tempvec =  find((imposter_scores >= threshold) );
    if numel(imposter_scores) > 0
      Pimp = numel(tempvec) / numel(imposter_scores);
      imp_rate(count,1) = Pimp*100;
    else
      Pimp = 0;
      imp_rate = 0;
    end
end
