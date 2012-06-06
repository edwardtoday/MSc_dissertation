function [PDF] = calc_genuine_pdf(genuine_dists, size)

count = 0;

genuine_scores = 1 ./ (genuine_dists*3);


%genuine_scores =  genuine_dists;


for threshold = 0.01:0.01:2.5
    tempvec = intersect(find((genuine_scores <= threshold)) ,  find((genuine_scores > threshold - 0.01) ) );
    P = numel(tempvec);
    count = count + 1;
    PDF(count,1) = P / numel(genuine_dists);
end
