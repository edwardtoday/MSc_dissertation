
% call with thinned, index, minutiae list, x
%Filters
function [res] = filter_minutia(img, index, m_list,  path_len)

   iax = 0; iay = 0; ibx = 0; iby = 0; icx = 0; icy = 0;
   x = m_list(index, 1);
   y = m_list(index, 2);
   CN = m_list(index, 3);
   progress = 1;
  
   res = index

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
      if ( iax  & ibx ) 
         break;
      end       

      if ( iax & icx )  
         break;
      end

      if ( ibx  & icx  )
         break;
      end


      if (CN == 1 & (iax  | ibx ))
         break;
      end

      progress = progress + 1;

      if iax == 0
        iax = find(m_list(:,1) == pax);
        if iax
           m_list(iax, 2)
           iay = find(m_list(iax, 2) == pay)
           if iay == 0
               iax = 0; 
           else
               iax = iax(iay);
           end
        else
           iax = 0;
        end  
      end

      if ibx == 0
        ibx = find(m_list(:,1) == pbx);
        if ibx
           iby = find(m_list(ibx, 2) == pby);
           if iby == 0
               ibx = 0;
           else
               ibx = ibx(iby);
           end
        else
             ibx = 0;
        end
      end

      if icx == 0
        icx = find(m_list(:,1) == pcx);
        if icx
           icy = find(m_list(icx, 2) == pcy);
           if icy == 0
               icx = 0;
           else
               icx = icx(icy);
           end
        else
           icx = 0;
        end
      end


      if pao ~= 0
        if iax == 0
          for i = 1:8
             if i == pao
                continue;
             end

             [ta, xa, ya] = p(img, pax, pay, i);

             if ta == 1
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
      end

      if pbo ~= 0
        if ibx == 0
          for i = 1:8
             if i == pbo
                continue;
             end

             [ta, xa, ya] = p(img, pbx, pby, i);

             if ta == 1
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
      end

      if pco ~= 0
        if icx == 0
          for i = 1:8
               if i == pco
                  continue;
               end
  
               [ta, xa, ya] = p(img, pcx, pcy, i);

               if ta == 1
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


   if progress >= path_len 
      res = 0;
   else 
      if iax > 0 
        res = index;
      elseif ibx > 0
        res = index;
      elseif icx > 0
        res = index;
      else
        res = 0;
      end
   end






