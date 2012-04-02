function FeatureVector=ULDA(X,ClassNumber,Xlabel)




% classical LDA  See Pattern recognition Letter
   %input: X denotes data matrix and each column denotes a data point, 
   %ClassNumber is the number of the classes
   % Xlabel is the label of X and is a colunm vector . 1 denotes the 1 class 2 denotes the 2th class, and so on
    
        EachClass=zeros(1,ClassNumber);
          [m,n]=size(X);
            meanX=mean(X');
            e1= ones(1,n);
             Ht=X-meanX'*e1;
            Hb=[];
           for i=1:ClassNumber
                  dd=find(Xlabel==i);
                  [m1,n1]=size(dd);
                  EachClass(1,i)=m1;
                  X1=X(:,dd');
                   meanXX=mean(X1');
                   Hb=[Hb sqrt(m1)*(meanXX'-meanX')];
           end
                    t1=rank(Ht);
                  [U0,S0,V0]  = svd(Ht'*Ht);
                  t1=t1;
                 U00=U0(:,1:t1);
                 S00=S0(1:t1,1:t1);
                % Hw=(Ht*Ht')-(Hb*Hb');
                TT0=Ht*U00*pinv(sqrt(S00));
                 Sw= (TT0'*Ht)*(Ht'*TT0)-(TT0'*Hb)*(Hb'*TT0);
                  t=rank(Sw);
                 
                  
                  [U,S,V]  = svd(Sw);
                  t=t;
                 U1=U(:,1:t);
                 S1=S(1:t,1:t);
              
                 TT9= U1*pinv(sqrt(S1));
                  TT=TT0*TT9;
                 %Hw=(Ht*Ht')-(Hb*Hb');
                  TTT= (TT'*Hb)*(Hb'*TT);
                    uu=rank(Hb);
                  [U2,S2,V2]=svd(TTT);
                  gg=diag(S2);
                 
              
               
                V=[];
             
               for i=1:1:uu
                  
                  
                   V=[V U2(:,i)];
               
                 
                 
              end
                 
            
                
                
                 FeatureVector=TT*V;
                 