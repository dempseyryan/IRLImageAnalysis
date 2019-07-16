function [col] = ColScale(min,max,length)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if length == inf
  col = inf;
  return
end
if length > max
   errordlg('The length is greater than the maximum.', 'Error');
   return;
end

if length < min
   errordlg('The length is less than the minimum.', 'Error');
   return;
end
span = max - min;
midpoint = (max + min)/2;
P1 = min;
P2 = span/2;
P3 = max;

% if span~=0
mB = -1/P2;
% end
yB = 1;

mG1 = 1/P2;
yG1 = 0;

mG2 = -1/P2;
yG2 = 2;

mR = 1/P2;
yR = -1;

if length > midpoint
    R = mR*(length - P1) +yR;%if its greater than the midpoint, scale to red side
    G = mG2*(length - P1) +yG2;
    B = 0;
elseif length <= midpoint
    R = 0;
    G = mG1*(length - P1) +yG1;
    B = mB*(length - P1)+yB;
end
if span == 0
    B = 1;
    G = 0;
    R = 0;
end
col = [R G B];
end

