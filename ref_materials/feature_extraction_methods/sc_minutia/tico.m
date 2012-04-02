
%JI:
function [orients, radii, minX, minY, minT] = tico(img,x,y, oimg, orient_img, o_rel, radius, theta_count, c_flag, start_t, blk_sz)
 
  Xt=0;
  Yt=0;
  orients=[];
  radii = [];
  index = 1;

  minX = 0;
  minY = 0;
  minT = 2*pi;

  start_theta = 0;
  if c_flag == 1
     start_theta = start_t;
  else
     start_theta = orient_img(y,x); %oimg(ceil(y/blk_sz),ceil(x/blk_sz)); 
  end
  
  theta = start_theta;
  tmp_radius = radius;
  o_index = 1;
  r_index = 1;
  o_i = 0;  

  while r_index <= numel(radius)
     
    while ( o_i < theta_count(o_index) ) && ~c_flag || c_flag && o_i < theta_count(o_index)/2 

      Xt = round(x + radius(r_index) * cos(theta));
      Yt = round(y - radius(r_index) * sin(theta));
      
      good=1; 
      if Xt <= 20 || Xt >= size(img,2) - 20 ||  Yt <= 20 || Yt >= size(img,1) - 20
         good = 0;
      end

      %JI: was 0.7
      if good == 0 || (~isnan(o_rel(Yt,Xt)) && o_rel(Yt,Xt) < 0.5 )
        radii(index) = -1;
        orients(index) = -1;
      else
        t_a=[];
        c = 0;
        for e=Yt-1:Yt+1
          for f=Xt-1:Xt+1
       %      if img(e,f) == 0  
               c = c + 1;
               t_a(c) = orient_img(e,f);
        %    end
          end
        end 
 
        if numel(c) == 0
           radii(index) = -1;
           orients(index) = -1;
        else
          t_a = median(t_a); %oimg(ceil(Yt/blk_sz), ceil(Xt/blk_sz));
          t_b = start_theta;
      
          radii(index) = radius(r_index);
          orients(index) = min([abs(t_b-t_a), abs(pi - abs(t_b-t_a))]) * 2/pi;

          if(orients(index) < minT)
            minT = orients(index);
            minX = Xt;
            minY = Yt;
          end

        end
      end 
      o_i = o_i + 1;  

      index = index + 1;
      theta = theta + o_i * 2*pi/theta_count(o_index);
    end
    r_index = r_index + 1;
    theta = start_theta;
    o_index = o_index + 1;
    o_i = 0;
  end
