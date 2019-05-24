%%This script will find the CG of a density weighted image. High density =
%%white, low density = black - use imcomplement if source image is
%%opposite.

clc;clear;close all;
[filename, path]=uigetfile('*.tif');
I = imread([path filename]);
%I = rgb2gray(I);
I = imcomplement(I);
imsize = size(I);

%find the averages in each direction
skullROI = roipoly(I);
%once the ROI is selected (above), scan to find start/finish of each
%vertical line of interest. These are stored in
%skullPoints_start (topmost) and skullPoints_end
%(bottommost). Lines are stored in skullLines_V.The same is then done for
%the horizontal lines.

skullPoints_start = [];
for i = 1:imsize(2)-1           %scan horizontally
    first = 1;
    for t = 1:imsize(1)-1       %scan vertically
        if skullROI(t,i) > 0 && first == 1
            skullPoints_start = [skullPoints_start;i t];
            first = 0;
        end
    end
end

skullPoints_end = [];

for i = imsize(2):-1:1          %scan horizontally
    first = 1;
    for t = imsize(1):-1:1      %scan vertically
        if skullROI(t,i) > 0 && first == 1
            skullPoints_end = [skullPoints_end;i t];
            first = 0;
        end
    end
end
skullPoints_end = flip(skullPoints_end); 
skullLines_V = [skullPoints_start skullPoints_end(:,2)]; %vertical lines (x,ystart,yend)


skullPoints_start = [];
for i = 1:imsize(1)-1           %scan horizontally
    first = 1;
    for t = 1:imsize(2)-1       %scan vertically
        if skullROI(i,t) > 0 && first == 1
            skullPoints_start = [skullPoints_start;i t];
            first = 0;
        end
    end
end

skullPoints_end = [];

for i = imsize(1):-1:1          %scan horizontally
    first = 1;
    for t = imsize(2):-1:1      %scan vertically
        if skullROI(i,t) > 0 && first == 1
            skullPoints_end = [skullPoints_end;i t];
            first = 0;
        end
    end
end
skullPoints_end = flip(skullPoints_end); 
skullLines_H = [skullPoints_start skullPoints_end(:,2)]; %horiz lines (y, xstart, xend)

clear skullPoints_end skullPoints_start i t
for i = 1:length(skullLines_V);
    line_len(i) = skullLines_V(i,3)-skullLines_V(i,2);
    line_mass(i) = sum(I([skullLines_V(i,2):skullLines_V(i,3)],skullLines_V(i)));
end
skullLines_V = [skullLines_V line_mass'];

clear line_mass line_len

for i = 1:length(skullLines_H);
    line_len(i) = skullLines_H(i,3)-skullLines_H(i,2);
    line_mass(i) = sum(I(skullLines_H(i),[skullLines_H(i,2):skullLines_H(i,3)])); %multiply?
end
skullLines_H = [skullLines_H line_mass'];
clear line_mass line_len

%x location
xbar = 0;
xleft = 0;
xright = 1;

while xleft < xright
    xbar=xbar+1;
    xleft = sum(skullLines_V(1:xbar,4));
    xright = sum(skullLines_V(xbar:length(skullLines_V),4));
end
xbar = skullLines_V(xbar)

%y location
ybar = 0;
ytop = 1;
ybot = 0;
while ytop>ybot
    ybar=ybar+1;
    ybot = sum(skullLines_H(1:ybar,4));
    ytop = sum(skullLines_H(ybar:length(skullLines_H),4));
end
ybar= skullLines_H(ybar)

%display image with crosshairs at centroid
figure(1);
imshow(imfuse(imcomplement(skullROI),imcomplement(I),'blend'))
figure(2);
imshow(I);
line([xbar xbar],[0 imsize(1)]);
line([0 imsize(2)],[ybar ybar]);
