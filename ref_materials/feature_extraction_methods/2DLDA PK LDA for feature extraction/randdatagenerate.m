clear





String1= strvcat('Oreaddata1')

vv=cellstr(String1);
for ppp=1:1
   
    fff=char(vv(ppp,1));
    load (char(fff))
    LiangORL1=[];
    LiangORL2=[];
    LiangORL3=[];
    LiangORL4=[];
    LiangORL5=[];
    LiangORL6=[];
    LiangORL7=[];
    LiangORL8=[];
    LiangORL9=[];
    LiangORL10=[];
    Store=[];


%load readdata data LabelClass count1
% data is a matrix whose columns are data points
%LabelClass is the label of data
%count is a vector that contains the number of each class.
[m1,n1]=size(count1);
for h=1:9
EachNumber=h+1;
% EachNumber is the number of each class in training samples

for j=1:20
%j is the number of runs
 tempLabel=[0 cumsum(count1)];
 
 Trainset=[];
Testset=[];
LabelTrain=[];
LabelTest=[];
 
 
    for i=1:n1
        
     inx=randperm(count1(1,i)); 
     index=inx+tempLabel(1,i)*ones(1,count1(1,i));
   
     
    index1=index(1,1:EachNumber);
    index2=index(1,(EachNumber+1):count1(1,i));
     Trainset=[Trainset data(:,index1)];
     LabelTrain=[LabelTrain; LabelClass(index1',1)];
      Testset=[Testset data(:,index2)];
     LabelTest=[LabelTest; LabelClass(index2',1)];
         
    end
     save tempdata5 Trainset Testset LabelTrain LabelTest
     load tempdata5 Trainset Testset LabelTrain LabelTest
     X=Trainset;
     Xlabel=LabelTrain;
     percent=0;
     ClassNumber=15;
     r=112;
     c=92;
     TrainSet=Trainset;
     TrainLabel=Xlabel;
     TestSet=Testset;
     TestLabel=LabelTest;
     
     
     
     
     
     for pp=1:50
         q=pp;
         p=pp;
         
     [R, L]=iterative2DLDA(Trainset, LabelTrain, p, q,r, c);
     count1=0;
     for hh=0.1:0.1:3
         mm=hh;
         count1=count1+1;
     ErrorRates= ADM1(TrainSet,TrainLabel,TestSet,TestLabel, R,L,r,c,mm);
     Liang1(1,count1)=ErrorRates;
     end
    
     
     LiangORL1(pp,j,h)=min(Liang1);
     ErrorRates= VM1(TrainSet,TrainLabel,TestSet,TestLabel, R,L,r,c);
     
     LiangORL2(pp,j,h)=ErrorRates;
     
     ErrorRates= Fnorm(TrainSet,TrainLabel,TestSet,TestLabel, R,L,r,c);
     
     LiangORL3(pp,j,h)=ErrorRates;
     end 
      FeatureVector=LDA2D(X,ClassNumber,Xlabel,percent,r, c);  
      
      
      for pp=1:50
         q=pp;
      
     R=FeatureVector(:,1:p);
     count1=0;
     for hh=0.1:0.1:3
         mm=hh;
         count1=count1+1;
     ErrorRates= ADM2(TrainSet,TrainLabel,TestSet,TestLabel, R,r,c,mm);
     Liang(1,count1)=ErrorRates;
     end
     
     LiangORL4(pp,j,h)=min(Liang);
     ErrorRates= VM2(TrainSet,TrainLabel,TestSet,TestLabel, R,r,c)
     
     LiangORL5(pp,j,h)=ErrorRates;
     
     ErrorRates= Fnorm2(TrainSet,TrainLabel,TestSet,TestLabel, R,r,c)
     
     LiangORL6(pp,j,h)=ErrorRates;
     end 
     
     
     
     
     
     
    
   
  
 %method2 
    
    
    FeatureVector=LDASVD(X,ClassNumber,Xlabel,percent);
     [mm,nn]=size(FeatureVector);
     nn1=min(nn,120);
     for uu=1:nn1
     R=FeatureVector(:,1:uu)
       count1=0;
      for hh=0.1:0.1:3
         mm=hh;
         count1=count1+1;
     ErrorRates= ADM3(TrainSet,TrainLabel,TestSet,TestLabel, R,mm);
     Liang2(1,count1)=ErrorRates;
      end
     
     
     
      LiangORL7(uu,j,h)=min(Liang2);
     end
     
     %method1
     nn1=min(nn,120);
     Store(j,h)=nn1;
     for k=1:nn1
     FeatureVector1=FeatureVector(:,1:k);
     TrainSet1=FeatureVector1'*Trainset;
     TestSet1=FeatureVector1'*Testset;
     TrainLabel1=LabelTrain;
     TestLabel1=LabelTest;
     LabelClass1=2;
    ErrorRates= MiniClassfiers(TrainSet1,TrainLabel1,TestSet1,TestLabel1, LabelClass1);
     %Liang(k,1)=ErrorRates;
    LiangORL8(k,j,h)=ErrorRates;
   end
     
   FeatureVector=LDASVD(X,ClassNumber,Xlabel,percent);
     [mm,nn]=size(FeatureVector);
     for uu=1:39
     R=FeatureVector(:,1:uu)
       count1=0;
      for hh=0.1:0.1:3
         mm=hh;
         count1=count1+1;
     ErrorRates= ADM3(TrainSet,TrainLabel,TestSet,TestLabel, R,mm);
     Liang2(1,count1)=ErrorRates;
      end
     
     
     
      LiangORL7(uu,j,h)=min(Liang2);
     end
     
     %method1
     nn1=min(nn,120);
     Store(j,h)=nn1;
     for k=1:nn1
     FeatureVector1=FeatureVector(:,1:k);
     TrainSet1=FeatureVector1'*Trainset;
     TestSet1=FeatureVector1'*Testset;
     TrainLabel1=LabelTrain;
     TestLabel1=LabelTest;
     LabelClass1=2;
    ErrorRates= MiniClassfiers(TrainSet1,TrainLabel1,TestSet1,TestLabel1, LabelClass1);
     %Liang(k,1)=ErrorRates;
    LiangORL8(k,j,h)=ErrorRates;
   end
     
   
  FeatureVector=ULDA(X,ClassNumber,Xlabel,percent);
  
   [mm,nn]=size(FeatureVector);
     for uu=1:39
     R=FeatureVector(:,1:uu)
       count1=0;
      for hh=0.1:0.1:3
         mm=hh;
         count1=count1+1;
     ErrorRates= ADM3(TrainSet,TrainLabel,TestSet,TestLabel, R,mm);
     Liang3(1,count1)=ErrorRates;
      end
     
     
     
      LiangORL9(uu,j,h)=min(Liang3);
     end
     
     %method1
     nn1=min(nn,120);
     Store(j,h)=nn1;
     for k=1:nn1
     FeatureVector1=FeatureVector(:,1:k);
     TrainSet1=FeatureVector1'*Trainset;
     TestSet1=FeatureVector1'*Testset;
     TrainLabel1=LabelTrain;
     TestLabel1=LabelTest;
     LabelClass1=2;
    ErrorRates= MiniClassfiers(TrainSet1,TrainLabel1,TestSet1,TestLabel1, LabelClass1);
     %Liang(k,1)=ErrorRates;
    LiangORL10(k,j,h)=ErrorRates;
   end
     
  
     
     
      ddd=strcat('New',fff);
     
   save (ddd, 'LiangORL1','LiangORL2', 'LiangORL3','LiangORL4','LiangORL5','LiangORL6','LiangORL7','LiangORL8','LiangORL9','LiangORL10','Store')

     
     
   %save ORLEx LiangORL1 LiangORL2 LiangORL3 LiangORL4 LiangORL5 LiangORL6 LiangORL7
end
end
end