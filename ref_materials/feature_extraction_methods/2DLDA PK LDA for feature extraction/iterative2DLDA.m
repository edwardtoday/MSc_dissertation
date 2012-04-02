function [R, L]=iterative2DLDA(Trainset, LabelTrain, p, q,r, c)


   %iterative 2DLDA, see Liang et al ."A note on two-dimensional linear discriminant analysis," Pattern Recogntion Letter
  % Trainset denotes the traning set  and each column is a data point
    %LabelTrain is the label of tranining set and is a colunm vector(such 1 denotes the 1th class and so on
   % r denotes the rows of images and c denotes the column of images
  %note that we set 10 iterations in our method
  % q is the right projected dimension and p is the left projected dimesnion
 % R is the right projected vectors and L is the left projected vectors. 

          [m,n]=size(Trainset);
          ClassNumber=max(LabelTrain);
          for i=1:ClassNumber
              temp=find(LabelTrain==i);
              temp1=temp';
              [m1, n1]=size(temp1);
              Trainset1=Trainset(:,temp1);
                aa(:,i)=mean(Trainset1');
          end
          bb=mean(Trainset');
          bb1=bb';
          R=[eye(q,q)
             zeros(c-q,q)];
         
             for j=1:10
                  
                 sb1=zeros(r,r);
                 sw1=zeros(r,r);
                 for i=1:ClassNumber
              temp=find(LabelTrain==i);
              temp1=temp';
              [m1, n1]=size(temp1);
                 Trainset1=Trainset(:,temp1);
                 [m2,n2]=size(Trainset1);
                 for s=1:n2
                     sw1=sw1+(reshape(Trainset1(:,s), r,c)-reshape(aa(:,i), r,c))*R*R'*(reshape(Trainset1(:,s), r,c)-reshape(aa(:,i), r,c))';
                 end
                     sb1=sb1+n1*(reshape(aa(:,i), r,c)-reshape(bb1, r,c))*R*R'*(reshape(aa(:,i), r,c)-reshape(bb1, r,c))';
                 end
                 %obtian sb1 sw1
             % U=eigendecomposition(sb1,sw1);
                    [U,S] =eig(pinv(sw1)*sb1);
                     tt=diag(S);
                 [B,IX]=sort(tt,'descend');
                 U11=U(:,IX);
                    
                  L=U11(:,1:p);
                   sb2=zeros(c,c);
                 sw2=zeros(c,c);
                    for i=1:ClassNumber
              temp=find(LabelTrain==i);
              temp1=temp';
              [m1, n1]=size(temp1);
                 Trainset1=Trainset(:,temp1);
                 [m2,n2]=size(Trainset1);
                 for s=1:n2
                     sw2=sw2+(reshape(Trainset1(:,s), r,c)-reshape(aa(:,i), r,c))'*L*L'*(reshape(Trainset1(:,s), r,c)-reshape(aa(:,i), r,c));
                 end
                     sb2=sb2+n1*(reshape(aa(:,i), r,c)-reshape(bb1, r,c))'*L*L'*(reshape(aa(:,i), r,c)-reshape(bb1, r,c));
                 end
                % U1=eigendecomposition(sb2,sw2);
                  [U1,S1] =eig(pinv(sw2)*sb2);
                     tt1=diag(S1);
                 [B,IX1]=sort(tt1,'descend');
                 U12=U1(:,IX1);
                  
                  R=U12(:,1:q);
             end
                  
                  