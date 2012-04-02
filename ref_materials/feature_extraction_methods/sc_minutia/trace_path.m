
% call with thinned, index, minutiae list, x
%Filters
function [img_n] = trace_path(img, m_list, path_len)

 img_n = zeros(size(img));  
 for index=1:size(m_list,1)
   x = m_list(index, 1);
   y = m_list(index, 2);
   CN = m_list(index, 3);
   progress = 1;
 
   res = index;
   img_n(y,x)=1;

   pax = 0; pay=0; pbx = 0; pby=0; pcx = 0; pcy=0;
   pao = 0; pbo = 0; pco = 0;      %1-8 position of 3x3 square around minutia
   
   for i = 1:8
         [ta, xa, ya] = p(img, x, y, i);
         [tb, xb, yb] = p(img, x, y, i+1);
         if (ta > tb) 
           if pao == 0
              if i < 5
                 pao = 4 + i;
              else
                 pao = mod(4 + i, 9) + 1;
              end
              pax = xa;
              pay = ya;
           elseif pbo == 0
              if i < 5
                 pbo = 4 + i;
              else
                 pbo = mod(4 + i, 9) + 1;
              end
              pbx = xa;
              pby = ya;
           else
              if i < 5
                 pco = 4 + i;
              else
                 pco = mod(4 + i, 9) + 1;
              end
              pcx = xa;
              pcy = ya;
           end   
         end
   end


   while ( progress < path_len) 
      if pax == 0
         break
      end
      img_n(pay,pax)=1; 
      if pbx ~= 0
        img_n(pby,pbx)=1; 
      end
      if pcx ~= 0
        img_n(pcy,pcx)=1; 
      end

      progress = progress + 1;



      if pao ~= 0
          for i = 1:8
             if i == pao
                continue;
             end

             [ta, xa, ya] = p(img, pax, pay, i);

             if ta == 1 && img_n(ya,xa) ~= 1
                if i < 5
                   pao = 4 + i;
                else
                   pao = mod(4 + i, 9) + 1;
                end
                pax = xa;
                pay = ya;
                break;
             end
          end
      end

      if pbo ~= 0
          for i = 1:8
             if i == pbo
                continue;
             end

             [ta, xa, ya] = p(img, pbx, pby, i);

             if ta == 1 && img_n(ya,xa) ~= 1 
                if i < 5
                   pbo = 4 + i;
                else
                   pbo = mod(4 + i, 9) + 1;
                end
                pbx = xa;
                pby = ya;
                break;
             end
          end
      end

      if pco ~= 0
          for i = 1:8
               if i == pco
                  continue;
               end
  
               [ta, xa, ya] = p(img, pcx, pcy, i);

               if ta == 1 && img_n(ya,xa) ~= 1
                  if i < 5
                     pco = 4 + i;
                  else
                     pco = mod(4 + i, 9) + 1;
                  end
  
                  pcx = xa;
                  pcy = ya;
                  break;
               end
          end
      end
   end
 end





