function [pdetect,tetadetect,Accumulator] = houghline(Imbinary,pstep,tetastep,thresh)
%HOUGHLINE - detects lines in a binary image using common computer vision operation known as the Hough Transform.
%
%Comments:
%       Function uses Standard Hough Transform to detect Lines in a binary image.
%       According to the Hough Transform, each pixel in image space
%       corresponds to a line in Hough space and vise versa.This function uses
%       polar representation of lines i.e. x*cos(teta)+y*sin(teta)=p to detect 
%       lines in binary image. upper left corner of image is the origin of polar coordinate
%       system.
%
%Usage: [pdetect,tetadetect,Accumulator] = houghline(Imbinary,pstep,tetastep,thresh)
%
%Arguments:
%       Imbinary - a binary image. image pixels that have value equal to 1 are
%                  interested pixels for HOUGHLINE function.
%       pstep    - interval for radius of lines in polar coordinates.
%       tetastep - interval for angle of lines in polar coordinates.
%       thresh   - a threshold value that determines the minimum number of
%                  pixels that belong to a line in image space. threshold must 
%                  be bigger than or equal to 3(default).
%
%Returns:
%       pdetect     - a vactor that contains radius of detected lines in
%                     polar coordinates system.
%       tetadetect  - a vector that contains angle of detcted lines in
%                     polar coordinates system.
%       Accumulator - the accumulator array in Hough space.
%
%Written by :
%       Amin Sarafraz
%       Photogrammetry & Computer Vision Devision
%       Geomatics Department,Faculty of Engineering
%       University of Tehran,Iran
%       sarafraz@geomatics.ut.ac.ir
%
%May 5,2004         - Original version
%November 24,2004   - Modified version,slightly faster and better performance.          
                          

if nargin == 3
    thresh = 3;
elseif thresh < 3
    error('threshold must be bigger than or equal to 3')
    return;
end

p = 1:pstep:sqrt((size(Imbinary,1))^2+(size(Imbinary,2))^2);
teta = 0:tetastep:180-tetastep;

%Voting
Accumulator = zeros(length(p),length(teta));
[yIndex xIndex] = find(Imbinary);
for cnt = 1:size(xIndex)
    Indteta = 0;
    for tetai = teta*pi/180
        Indteta = Indteta+1;
        roi = xIndex(cnt)*cos(tetai)+yIndex(cnt)*sin(tetai);
        if roi >= 1 & roi <= p(end)
            temp = abs(roi-p);
            mintemp = min(temp);
            Indp = find(temp == mintemp);
            Indp = Indp(1);
            Accumulator(Indp,Indteta) = Accumulator(Indp,Indteta)+1;
        end
    end
end

% Finding local maxima in Accumulator
AccumulatorbinaryMax = imregionalmax(Accumulator);
[Potential_p Potential_teta] = find(AccumulatorbinaryMax == 1);
Accumulatortemp = Accumulator - thresh;
pdetect = [];tetadetect = [];
for cnt = 1:length(Potential_p)
    if Accumulatortemp(Potential_p(cnt),Potential_teta(cnt)) >= 0
        pdetect = [pdetect;Potential_p(cnt)];
        tetadetect = [tetadetect;Potential_teta(cnt)];
    end
end

% Calculation of detected lines parameters(Radius & Angle).
pdetect = pdetect * pstep;
tetadetect = tetadetect *tetastep - tetastep;