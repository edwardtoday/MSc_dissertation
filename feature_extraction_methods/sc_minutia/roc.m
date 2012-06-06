function roc(x,y)
% ROC - Receiver Operating Characteristics.
% The ROC graphs are a useful tecnique for organizing classifiers and
% visualizing their performance. ROC graphs are commonly used in medical
% decision making.
% If you have downloaded partest 
% http://www.mathworks.com/matlabcentral/fileexchange/12705
% the routine will compute several data on test performance.
%
% Syntax: roc(x,y)
%
% Input: x and y - two arrays with the value of the test in unhealthy (x)
%                  and healthy (y) subjects
%
% Output: The ROC plot;
%         The Area under the curve with Standard error and Confidence
%         interval and comment.
%         Cut-off point for best sensibility and specificity.
%         (Optional) the test performance at cut-off point.
%
% Example: 
%           load rocdata
%           roc(x,y)
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2008) ROC curve: compute a Receiver Operating Characteristics curve. 
% http://www.mathworks.com/matlabcentral/fileexchange/19950


lx=length(x); ly=length(y); %number of subjects
%join both arrays and add a label (1-unhealthy; 2-healthy)
z=sortrows([x(:) repmat(1,lx,1); y(:) repmat(2,ly,1)],1);
%find unique values in z
labels=unique(z(:,1));
ll=length(labels); %count unique value
a=zeros(ll,2); %array preallocation
for K=1:ll
     i=length(z(z(:,1)<=labels(K))); %set unique value(i) as cut-off
     table(1)=length(z(z(1:i,2)==1)); %true positives
     table(2)=length(z(z(1:i,2)==2)); %false positives
     test=[table;[lx ly]-table]; %complete the table
     a(K,:)=(diag(test)./sum(test)')'; %Sensibility and Specificity
end
xroc=1-a(:,2); yroc=a(:,1); %ROC points

%the best cut-off point is the closest point to (1,1)
d=realsqrt(xroc.^2+(1-yroc).^2); %apply the Pitagora's theorem
[y,j]=min(d); %find the least distance
co=labels(j); %set the cut-off point

AUCt=1-trapz(yroc,xroc); %estimate the area under the curve
%standard error of area
SE=realsqrt((-AUCt*(AUCt-1)*(AUCt^2*(1+lx+ly)+AUCt*(1-2*ly)-(3+lx))/((AUCt-2)*(1+AUCt)*lx*ly))); 
%confidence interval 
ci=AUCt+[-1 1].*(1.96*SE);
%z-test
SAUC=AUCt/SE; %standardized area
p=1-0.5*erfc(-SAUC/realsqrt(2)); %p-value
%Performance of the classifier
if AUCt==1
    str='Perfect test';
elseif AUCt>=0.90 && AUCt<=0.99
    str='Excellent test';
elseif AUCt>=0.80 && AUCt<=0.89
    str='Good test';
elseif AUCt>=0.70 && AUCt<=0.79
    str='Fair test';
elseif AUCt>=0.60 && AUCt<=0.69
    str='Poor test';
elseif AUCt<=0.59
    str='Fail test';
end
%display results
disp('ROC CURVE ANALYSIS')
disp(' ')
tr=repmat('-',1,80);
disp(tr)
fprintf('AUC\t\t\t\tS.E.\t\t\t\t\t95%% C.I.\t\t\t\tComment\n')
disp(tr)
fprintf('%0.5f\t\t\t%0.5f\t\t\t%0.5f\t\t\t%0.5f\t\t\t\n',AUCt,SE,ci)
disp(tr)
fprintf('Standardized AUC\t\t1-tail p-value\n')
fprintf('%0.4f\t\t\t\t\t%0.6f',SAUC,p)
if p<0.05
    fprintf('\t\tThe area is statistically greater than 0.5\n')
else
    fprintf('\t\tThe area is not statistically greater than 0.5\n')
end
disp(' ')
fprintf('cut-off point for best sensibility and specificity (blu circle in plot)= %0.4f\n',co)
%display graph
plot(xroc,yroc,'b-',xroc(j),yroc(j),'bo',[0 1],[0 1],'k')
xlabel('False positive rate (1-specificity)')
ylabel('True positive rate (sensibility)')
title('ROC curve')
axis square
%disp('Press a key to continue'); pause
%if partest.m was downloaded
try
    %table at cut-off point
    i=length(z(z(:,1)<=co));
    table(1)=length(z(z(1:i,2)==1));
    table(2)=length(z(z(1:i,2)==2));
    test=[table;[lx ly]-table];
    disp('Table at cut-off point')
    disp(test)
    disp(' ')
    partest(test)
catch ME
    disp(ME)
    disp('If you want to calculate the test performance at cutoff point please download partest from Fex')
    disp('http://www.mathworks.com/matlabcentral/fileexchange/12705')
end
