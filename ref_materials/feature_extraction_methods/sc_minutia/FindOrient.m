% Joshua Ibrahim
% img - Thinned binary  inverse image
% y,x - coordinates within boundary of image with 1 pixel padding
% theta is in radians

function theta = FindOrient(img, x, y)
theta = -1;
X1=0;
Y1=0;
X2=0;
Y2=0;
Xt=0;
Yt=0;

first_pos=0;
second_pos=0;
val=0;

if img(y,x) == 0
  return
end 

for i=1:8
    [val, Xt,Yt] = p(img, x, y, i);
    if val == 1
      if (first_pos == 0) 
        first_pos = i;
        X1 = Xt;
        Y1 = Yt;
      else 
         second_pos = i;
         X2 = Xt; 
         Y2 = Yt; 
      end
    end

    if val == 0 && second_pos ~= 0
      break;
    end
end

if first_pos == 0
  return
end

theta = atan2(Y1-y, X1-x);

if (second_pos ~= 0)
  theta = (atan2(Y2-y, X2-x) - theta);
  if  ((pi - theta)/2) > 0
    theta = atan2(Y2-y, X2-x) + (pi-theta)/2;
  else
    theta = atan2(Y1-y, X1-x) - (pi-theta)/2;
  end
end


if theta < 0
  theta = 2*pi + theta;
end
