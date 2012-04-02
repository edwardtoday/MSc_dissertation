%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Matlab source codes for                              %
%              Multilinear Principal Component Analysis (MPCA)                %
%                                                                             %
% Author: Haiping LU                                                          %
% Email : hplu@ieee.org   or   eehplu@gmail.com                               %
% Release date: March 12, 2011                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%[Algorithms]%
The matlab codes provided here implement two algorithms presented in the 
paper "MPCA_TNN08Jan.pdf" included in this package:

	Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos, 
	"MPCA: Multilinear Principal Component Analysis of Tensor Objects", 
	IEEE Transactions on Neural Networks, 
	Vol. 19, No. 1, Page: 18-39, January 2008.

Algorithm 1: "MPCA.m" implements the MPCA algorithm described in this paper
Algorithm 2: "MPCALDA.m" implements the MPCA+LDA algorithm in this paper


%[Usages]%
Please refer to the comments in the codes, which include example usage on 
2D data and 3D data below:

FERETC80A45.mat: 320 faces (32x32) of 80 subjects (4 samples per class) from 
		 the FERET database
USF17Gal.mat:    731 gait samples (32x22x10) of 71 subjects from the gallery 
		 set of the USF gait challenge data sets version 1.7


%[Restriction]%
In all documents and papers reporting research work that uses the matlab codes 
provided here, the respective author(s) must reference the following paper: 

[1]	Haiping Lu, K.N. Plataniotis, and A.N. Venetsanopoulos, 
	"MPCA: Multilinear Principal Component Analysis of Tensor Objects", 
	IEEE Transactions on Neural Networks, 
	Vol. 19, No. 1, Page: 18-39, January 2008.


%[Comment/Question?]%
Please send your comment (e.g., ways to improve the codes) or question (e.g., 
difficulty in using the codes) to hplu@ieee.org or eehplu@gmail.com


%[Update history]%
1. March 1, 2008: Version 1.0 is released.

2. June 24, 2008: Version 1.1 is released.
[Example usage on 2D data is included]
[Recommendation on parameter MPCADADim is updated]

3. March 12, 2011: Version 1.2 is released. 
[Minor change to code: insertion of line 275 to MPCALDA.m]
[Since the publication of MPCA, several extensions have been developed. Therefore, 
in this update, we include a survey paper "SurveyMSL_PR2011.pdf" and a BibTeX file 
"MPCApublications.bib" for user convenience]