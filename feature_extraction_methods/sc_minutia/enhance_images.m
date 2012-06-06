
% Bibliography
% Thai, Raymond. Fingerprint Image Enhancement and Minutiae Extraction. 
% read image into memory
%
% Modified:  20/7/2006 (Paul Kwan)
%            04/8/2006 (Paul Kwan) - ellipsoidal area for filtering
%                                    spurious endings along the boundaries
%
blk_sz_c = 24;
blk_sz_o = 24;
cd  '/home/joshua/FVC2002/Dbs/Db1_a'
files = dir(  '/home/joshua/FVC2002/Dbs/Db1_a/*.tif');
file_names = {files.name};

res=[];
ret=0;
index1 = START;
while index1 <= FINISH
filename=files(index1).name
img = imread(filename);
% convert to gray scale
if ndims(img) == 3         % colour image
    img = rgb2gray(img);
end

yt=1;
yb=size(img,2);
xr=size(img,1);
xl=1;

YA=0;
YB=0;
XA=0;
XB=0;

delta_test=0;

for x=1:55
    if numel(find(img(x,:)<200)) < 8
       img(1:x,:) = 255;
       yt=x;
    end
end

for x=225:size(img,1)
    if numel(find(img(x,:)<200)) < 3
       img(x-17:size(img,1),:) = 255;
       yb=x;
       break
    end
end

for y=200:size(img,2)
    if numel(find(img(:,y)<200)) < 1
       img(:,y:size(img,2)) = 255;
       xr=y;
       break
    end
end

for y=1:75
    if numel(find(img(:,y)<200)) < 1
       img(:,1:y) = 255;
       xl=y;
    end	
end

%if size(img,1)-yb > yt
%   img(size(img,1)-yb+1:size(img,1),:)=img(1:yb,:);
%   img(1:size(img,1)-yb,:)=255;
%elseif size(img,1)-yb < yt
%%   img(size(img,1)-yt+1:size(img,1),:)=255;
%end
enhimg = img;

%[cimg, oimg2,fimg,bwimg,eimg,enhimg1] =  fft_enhance_cubs(img, -1);
%[cimg, oimg2,fimg,bwimg,eimg,enhimg2] =  fft_enhance_cubs(img, 1);

[cimg1, o1,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(enhimg,blk_sz_o/4);
[cimg, oimg2,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(enhimg, blk_sz_o/2);
[cimg2, oimg,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(enhimg, blk_sz_o);

[newim, binim, mask, o_rel, orient_img] =  testfin(enhimg);  % testfin is from Dr. Peter Kovesi's code
[cimg, oimg2,fimg,bwimg,eimg,enhimg] =  fft_enhance_cubs(img, -1);
[newim, binim, mask, o_rel, orient_img_m] =  testfin(enhimg);




%    t=enhimg1;
%    numel(find(enhimg<120))
%    t(intersect(find(enhimg1 < 125), find(img > 80)))=120;
%    t(365:size(t,1),:)=img(365:size(t,1),:);
    %x=t(350:size(t,1),:);
    %enhimg2=enhimg2(350:size(enhimg2,1),:);
    %x(intersect(find(enhimg2 < 140), find(img(350:size(img,1),:) > 80)))=110;
    %t(350:size(t,1),:)= img(350:size(img,1),:);

%if size(img,1)-yb > yt
%   t(1:yb,:)=t(size(img,1)-yb+1:size(img,1),:);
%   t(yb:size(img,1),:)=255;
%elseif size(img,1)-yb < yt
%   t(yt+1:size(img,1),:)=t(1:size(img,1)-yt,:);
%   t(1:yt,:)=255;
%end


th=bwmorph(binim, 'thin',Inf);
th=(th==0);

subplot(1,2,1), subimage(binim), title('a')
subplot(1,2,2), subimage(th), title('a')
drawnow
%pause

    filename(length(filename)+1:length(filename)+4)='.jpg';
    imwrite(th, filename, 'jpg');
    index1=index1+1;
end
