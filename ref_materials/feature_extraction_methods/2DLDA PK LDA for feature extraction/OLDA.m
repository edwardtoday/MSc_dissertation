function FeatureVector=OLDA(X,ClassNumber,Xlabel)
   % orthogonal LDA  See Pattern recognition Letter
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
                  [U0,S0,V0]  = svd(Ht,0);
                   U1=U0(:,1:t1);
                  S1=S0(1:1,1:t1);
                   
                 
                  TTT=U1*pinv(S1);
                   TTTT=TTT'*Hb;
                    uu=rank(Hb);
                  [U2,S2,V2]=svd(TTTT);
                  
                 
              
               [Q,R]=qr(TTT*U2,0);
                
          FeatureVector=Q;

                 