% GRAY LEVEL DIFFERENCE METHOD
%
% GLDM calculates the GLDM Probability Density Functions for the given image
%
% For details on the Gray level Difference Method, refer the following paper
% J. K. Kim and H. W. Park, "Statistical textural features for
% detection of microcalcifications in digitized mammograms",
% IEEE Trans. Med. Imag. 18, 231-238 (1999).
% 
% [pdf1, pdf2, pdf3, pdf4] = GLDM(inImg, d) 
%
% inImg - Input Image
% d     - Inter Sample distance
% pdf1  - GLDM Form 1 PDF
% pdf2  - GLDM Form 2 PDF
% pdf3  - GLDM Form 3 PDF
% pdf4  - GLDM Form 4 PDF

function [pdf1, pdf2, pdf3, pdf4] = GLDM(inImg, d)

s=size(inImg);
inImg=double(inImg);

%matrices
pro1=zeros(s);
pro2=zeros(s);
pro3=zeros(s);
pro4=zeros(s);

for i=1:s(1)
    for j=1:s(2)
        if((j+d)<=s(2))
            pro1(i,j)=abs(inImg(i,j)-inImg(i,(j+d)));
        end
        if((i-d)>0)&((j+d)<=s(2))
            pro2(i,j)=abs(inImg(i,j)-inImg((i-d),(j+d)));
        end
        if((i+d)<=s(1))
            pro3(i,j)=abs(inImg(i,j)-inImg((i+d),j));
        end
        if((i-d)>0)&((j-d)>0)
            pro4(i,j)=abs(inImg(i,j)-inImg((i-d),(j-d)));
        end
    end
end

%probability density functions
pdf1=zeros(256,1);
pdf2=zeros(256,1);
pdf3=zeros(256,1);
pdf4=zeros(256,1);

[cnt x]=imhist(uint8(pro1));
pdf1 = cumsum(cnt);

[cnt x]=imhist(uint8(pro2));
pdf2 = cumsum(cnt);

[cnt x]=imhist(uint8(pro3));
pdf3 = cumsum(cnt);

[cnt x]=imhist(uint8(pro4));
pdf4 = cumsum(cnt);

