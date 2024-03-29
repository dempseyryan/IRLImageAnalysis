function [col] = ColScaleOld(min,max,length)
span = max + min;
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

if length > P2
    R = mR*length +yR;%if its greater than the midpoint, scale to red side
    G = mG2*length +yG2;
    B = 0;
elseif length <= P2
    R = 0;
    G = mG1*length +yG1;
    B = mB*length+yB;
end
if span == 0
    B = 1;
    G = 0;
    R = 0;
end
col = [R G B];
end

