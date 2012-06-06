function FeatureVector=LDA2D(X,ClassNumber,Xlabel,Height, Width)

  % one-sided 2DLDA See see Liang et al ."A note on two-dimensional linear discriminant analysi
      % X denotes the traning set  and each column is a data point
    %Xlabel is the label of tranining set and is a colunm vector(such 1 denotes the 1th class and so on
   % Height denotes the rows of images and Width denotes the column of images
  % ClassNumber denotes of the number of classes
  % FeatureVector denotes projected vectors
  
        EachClass=zeros(1,ClassNumber);
          [m,n]=size(X);
            meanX=mean(X'); 
            meanX1=reshape(meanX', Height, Width);
            Sum0=zeros(Height, Height);
             for i=1:n 
             X1=reshape(X(:,i), Height, Width);
             Sum0=Sum0+(X1-meanX1)*(X1-meanX1)';
             end
             clear X1
              Sb=zeros(Height,Height);
           for i=1:ClassNumber
                  dd=find(Xlabel==i);
                  [m1,n1]=size(dd);
                  EachClass(1,i)=m1;
                  X1=X(:,dd');
                   meanXX=mean(X1');
                   XX1=reshape(meanXX', Height, Width);
                  Sb=Sb+m1*(XX1-meanX1)*(XX1-meanX1)';
           end
                 Sum1=Sum0-Sb;
                  t=rank(Sum1);
                  [U,S]=eig(pinv(Sum1)*Sb);
                   tt=diag(S);
                 [B,IX]=sort(tt,'descend');
                 U1=U(:,IX)
             
                 % zz1=pinv(S)*U'*Sb*U*pinv(S);
                 %Sb1=zz1;
                  %[U1,S1,V2] = svd(Sb1);
                  %sum0=0;
                  
         
          
             % featureVector=U1
          
                 
                
                 FeatureVector=U1;