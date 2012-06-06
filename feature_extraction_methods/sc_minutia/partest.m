function partest(x)
%This function calculate the performance, based on Bayes theorem, of a
%clinical test.
%
% Syntax: 	PARTEST(X)
%      
%     Input:
%           X is the following 2x2 matrix.
%
%....................Unhealthy.....Healthy 
%                    _______________________
%Positive Test      |   True    |  False    |
%                   | positives | positives |
%                   |___________|___________|
%                   |  False    |   True    |
%Negative Test      | negatives | negatives |
%                   |___________|___________|
%
%     Outputs:
%           - Prevalence of disease
%           - Test Sensibility 
%           - Test Specificity
%           - False positive and negative proportions
%           - Youden's Index
%           - Number needed to Diagnose (NDD)
%           - Discriminant Power
%           - Test Accuracy
%           - Mis-classification Rate
%           - Positive predictivity
%           - Negative predictivity
%           - Positive Likelihood Ratio
%           - Negative Likelihood Ratio
%           - Test bias
%           - Diagnostic odds ratio
%           - Error odds ratio
%
%      Example: 
%
%           X=[80 3; 5 20];
%
%           Calling on Matlab the function: partest(X)
%
%           Answer is:
%
%           Prevalence: 78.7037%
%           Sensibility (probability that test is positive on unhealthy subject): 94.1176%
%           False positive proportion: 10%
%           Specificity (probability that test is negative on healthy subject): 86.9565%
%           False negative proportion: 2%
%           Youden's Index (a perfect test would have a Youden's index of +1): 0.81074
%           Number needed to Diagnose (NDD): 1
%           Discriminant Power: 2.9
%               A test with a discriminant value of 1 is not effective in discriminating between affected and unaffected individuals.
%               A test with a discriminant value of 3 is effective in discriminating between affected and unaffected individuals.
%           Accuracy or Potency: 92.5926%
%           Mis-classification Rate: 7.4074%
%           Predictivity of positive test (probability that a subject is unhealthy when test is positive): 96.3855%
%           Predictivity of negative test (probability that a subject is healthy when test is negative): 80%
%           Positive Likelihood Ratio: 7.2157
%           Moderate increase in possibility of disease presence
%           Negative Likelihood Ratio: 0.067647
%           Large (often conclusive) increase in possibility of disease absence
%           Test bias: 0.97647
%           Test underestimate the phenomenon
%           Diagnostic odds ratio: 106.6667
%           Error odds ratio: 2.4
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Clinical test performance: the performance of a
% clinical test based on the Bayes theorem. 
% http://www.mathworks.com/matlabcentral/fileexchange/12705

%Input Error handling
[r,c] = size(x);
if (r ~= 2 || c ~= 2)
    error('Warning: PARTEST requires a 2x2 input matrix')
end
clear r c %clear unnecessary variables

s1=sum(x); %columns sum
s2=sum(x,2); %rows sums
tot=sum(x(:)); %numbers of elements
d=diag(x); %true positives and true negatives
pr=(s1(1)/tot)*100; %Prevalence
a=d./s1'; %Sensibility and Specificity
dp=1-a; %false proportions
dpwr=(realsqrt(3)/pi)*prod(log(a./(1-a))); %Discriminant power
acc=trace(x)/tot; %Accuracy
mcr=1-acc; %Mis-classification rate
b=d./s2; %Positive and Negative predictivity
plr=a(1)/(1-a(2)); %Positive Likelihood Ratio
nlr=(1-a(1))/a(2); %Negative Likelihood Ratio
c=s2(1)/s1(1); %Test Bias
J=sum(a)-1; %Youden's index
NDD=round(1/J); %Number needed to Diagnose (NDD)
f=a./d;
EOR=f(1)/f(2); %Error odds ratio
DOR=f(1)/(1/f(2)); %Diagnostic odds ratio

%display results
fprintf('Prevalence: %0.1f%%\n',pr)
fprintf('Sensibility (probability that test is positive on unhealthy subject): %0.1f%%\n',a(1)*100)
fprintf('False positive proportion: %0.1f%%\n',dp(1)*100)
fprintf('Specificity (probability that test is negative on healthy subject): %0.1f%%\n',a(2)*100)
fprintf('False negative proportion: %0.1f%%\n', dp(2)*100)
fprintf('Youden''s Index (a perfect test would have a Youden index of +1): %0.4f\n', J)
fprintf('Number needed to Diagnose (NDD): %0.1f\n',NDD);
fprintf('Discriminant Power: %0.1f\n',dpwr)
disp([blanks(5) 'A test with a discriminant value of 1 is not effective in discriminating between affected and unaffected individuals.'])
disp([blanks(5) 'A test with a discriminant value of 3 is effective in discriminating between affected and unaffected individuals.'])
fprintf('Accuracy or Potency: %0.1f%%\n', acc*100)
fprintf('Mis-classification Rate: %0.1f%%\n', mcr*100)
fprintf('Predictivity of positive test (probability that a subject is unhealthy when test is positive): %0.1f%%\n', b(1)*100)
fprintf('Predictivity of negative test (probability that a subject is healthy when test is negative): %0.1f%%\n', b(2)*100)
fprintf('Positive Likelihood Ratio: %0.1f\n', plr)
dlr(plr)
fprintf('Negative Likelihood Ratio: %0.1f\n', nlr)
dlr(nlr)
fprintf('Test bias: %0.1f\n',c)
if c(1)>1
    disp('Test overestimates the phenomenon')
elseif c(1)<1
    disp('Test underestimates the phenomenon')
else
    disp('There is not test bias')
end
fprintf('Diagnostic odds ratio: %0.1f\n',DOR)
fprintf('Error odds ratio: %0.1f\n',EOR)
return

function dlr(lr) %Likelihood dialog
if lr==1
    disp('Test is not suggestive of the presence/absence of disease')
    return
end

if lr>10 || lr<0.1
    p1='Large (often conclusive)';
elseif (lr>5 && lr<=10) || (lr>0.1 && lr<=0.2)
    p1='Moderate';
elseif (lr>2 && lr<=5) || (lr>0.2 && lr<=0.5)
    p1='Low';
elseif (lr>1 && lr<=2) || (lr>0.5 && lr<=1)
    p1='Poor';
end

p2=' increase in possibility of disease ';

if lr>1
    p3='presence';
elseif lr<1
    p3='absence';
end
disp([p1 p2 p3])
return