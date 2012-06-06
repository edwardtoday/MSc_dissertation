function ErrorRates= MiniClassfiers(TrainSet,TrainLabel,TestSet,TestLabel, LabelClass)




 % see Liang et al ."A note on two-dimensional linear discriminant analysis," Pattern Recogntion Letter
  % TrainSet denotes the traning set  and each column is a data point
    %TrainLabel is the label of tranining set and is a colunm vector(such as 1 denotes the 1th class and so on.
   % TestSet denotes the tesing set and each column is a data point. 
  %TestLabel denotes the label of testing set and is stored like TrainLabel 
  %r is the number of rows for each image  and c is the number of cloumns of each image
% note that  r and c is the image size. such as 32*32 images
 % R is the right projected vectors and L is the left projected vectors. 
%LableClass==1 denotes L1 norm classifiers 2  L2 norm classifers  3 is correlation measure 

%L1 norm classifiers
    if LabelClass==1
        [m1,n1]=size(TrainSet);
        [m2,n2]=size(TestSet);
        ErrorRates=0;
   A1=0;
        for i=1:n2
             Test1=TestSet(:,i);
             TempStore=zeros(n1,1);
             
            for j=1:n1
                
              TempStore(j,1)=norm((Test1-TrainSet(:,j))',1);
            end
              [B,IX]=sort(TempStore);
             TempLabel =TrainLabel(IX(1,1),1);
            if TestLabel(i,1)~=TempLabel;
                A1=A1+1;
            end
           
        end 
        ErrorRates=A1/n2;
    end
    %L2 norm classifers
    
    
         if LabelClass==2
        [m1,n1]=size(TrainSet);
        [m2,n2]=size(TestSet);
        ErrorRates=0;
           A1=0;
        for i=1:n2
             Test1=TestSet(:,i);
             TempStore=zeros(n1,1);
             
            for j=1:n1
                
              TempStore(j,1)=norm((Test1-TrainSet(:,j))',2);
            end
              [B,IX]=sort(TempStore);
             TempLabel =TrainLabel(IX(1,1),1);
            if TestLabel(i,1)~=TempLabel;
                A1=A1+1;
            end
            
        end
        ErrorRates=A1/n2;
         end   
    
         
    if LabelClass==3
        [m1,n1]=size(TrainSet);
        [m2,n2]=size(TestSet);
        ErrorRates=0;
        A1=0;
        for i=1:n2
             Test1=TestSet(:,i);
             TempStore=zeros(n1,1);
             
            for j=1:n1
                
                f1=norm(TrainSet(:,j)',2);
                if f1==0
                    f1=f1+0.00001;
                end
                f2=norm(Test1',2);
                if f2==0
                    f2=f2+0.00001;
                end
                
                
              TempStore(j,1)=-Test1'*TrainSet(:,j)/(f1*f2);
            end
            
              [B,IX]=sort(TempStore);
             TempLabel =TrainLabel(IX(1,1),1);
            if TestLabel(i,1)~=TempLabel;
                A1=A1+1;
            end
            
        end
        ErrorRates=A1/n2;
    end   