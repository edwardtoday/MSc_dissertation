%JI
% returns similarity score and sorted index of minutiae pair scores

function [similarity, index, r_g] = calc_orient(A, rA, B, rB, W) 
  penalty = 0;
  C = [];
  raw_val=[];
  
  index = 1;
  good_points = 0;
  r_g=[];
  raw_val = [];

  wX = 0;
  wY = 0;

  for i = 1:size(A,1)
      if i > numel(rA) || i > numel(rB)
          continue;
      end
      count = 0; 
      raw_val(index) = 0;
      for j = 1:size(A,2)
        if rA(i,j) ~= -1 && rB(i,j) ~= -1
          temp = abs(A(i,j) - B(i,j));
          raw_val(j)= temp;
          count = count + 1;
          r_g(count)=j;
        end
      end
      if count > 0
         index = count;
      else
         raw_val(index) = 0;
      end
   
  end

  if(index > 1)
    %JI: Normalized mean
    raw_val = exp(-raw_val*8) * exp(max(0, 70-count)*-1/50); 
  %   similarity = 1/mean(raw_val);
    similarity = mean(raw_val);
  else
    similarity = -1;
  end
