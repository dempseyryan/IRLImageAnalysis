function [imgC] = imcrisp(imgC,range)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
imgA =imadjust(imgC);% im2bw(img,range(1));
for i = 2:length(range);
    imgA = imfuse(imgA,im2bw(imgC,range(i)),'diff');
end
imgC = imgA;
end

