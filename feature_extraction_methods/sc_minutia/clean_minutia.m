
% JI: Removes spikes
% call with minutiae(:, 1,2), minutiae(:,3),x,y,dist
function [new_index]  = clean_minutia(m, m_CN, img,dist)

 index = 1;
 new_index = [];

 for i = 1:size(m,1)
   p_x = m(i,1);
   p_y = m(i,2);
   p_d = 0;
   l_x = 0;
   l_y = 0;    

   c_flag = 0;  

 
   while p_d < dist && c_flag == 0 && m_CN(i) == 1
 
     ind = 1;
     while c_flag == 0 && ind <= size(m,1) && p_d > 0
      if p_x == m(ind,1) && p_y == m(ind,2)
        c_flag = 1;
        continue;
      end
      ind = ind + 1;
     end
 
     for j = 1:8
       [t,nx,ny] = p(img, p_x, p_y, j);
       if t == 1 && (nx ~= l_x || ny ~= l_y)       
          l_x = p_x;
          l_y = p_y;
          p_x = nx;
          p_y = ny;
          break;
       end
     end
     p_d = p_d + 1;
   end

   if c_flag == 0
      new_index(index) = i; 
      index = index + 1;
   end

 end


