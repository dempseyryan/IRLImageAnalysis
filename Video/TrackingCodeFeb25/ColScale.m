function [col] = ColScale(min,max,length)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
span = max - min;
P1 = min;
P2 = span/2;
P3 = max;

mB = -1/P2;
yB = 1;

mG1 = 1/P2;
yG1 = 0;

mG2 = -1/P2;
yG2 = 2;

mR = 1/P2;
yR = -1;

if length > P2
    R = mR*length+yR;
    G = mG2*length+yG2;
    B = 0;
elseif length <= P2
    R = 0;
    G = mG1*length+yG1;
    B = mB*length+yB;
end
col = [R G B];
end

