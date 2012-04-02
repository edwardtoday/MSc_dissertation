function Y=GetFullRankMatrix(YY)
 % obtain a full rank matrix of YY.
     [m1,n1]=size(YY);
     DD=[];
    
       for i=1:n1
          CC= YY(:,i);
          DD=[DD CC];
          [m2,n2]=size(DD);
          t=rank(DD);
          if t==n2
         DD=DD;
          else 
              DD(:,n2)=[];
          end
       end
       Y=DD;