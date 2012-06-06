% Sample Usage of the script GLDM
%
% For details on the Gray level Difference Method, refer the following paper
% J. K. Kim and H. W. Park, "Statistical textural features for
% detection of microcalcifications in digitized mammograms",
% IEEE Trans. Med. Imag. 18, 231-238 (1999).

%Read Input Image
inImg = imread('Input.bmp');

%Set the intersample distance d
d = 11;

[pdf1, pdf2, pdf3, pdf4] = GLDM(inImg, d);

figure;imshow(inImg);title('Input Mammogram Image');

figure;
subplot(221);plot(pdf1);title('PDF Form 1');
subplot(222);plot(pdf2);title('PDF Form 2');
subplot(223);plot(pdf3);title('PDF Form 3');
subplot(224);plot(pdf4);title('PDF Form 4');
