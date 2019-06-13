function [Tail1,Tail2,ArrowLength,ArrowAngle] = arrowPoints(StartPtX, StartPtY,EndPtX,EndPtY)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
ArrowLength = sqrt((EndPtX - StartPtX)^2 + (EndPtY - StartPtY)^2);
Xlength = EndPtX-StartPtX;
Ylength = EndPtY-StartPtY;
M = Ylength/Xlength;
ArrowAngle = atan(M);
AHSize = 0.25;
CrossPointX = StartX + cosd(30)*(1-AHSize)*ArrowLength;
CrossPointY = StartY + sind(30)*(1-AHsize)*ArrowLength;
Tail1 = [];
Tail2 = [];
end

%{
    EndPtX = 1;
StartPtX = 0;
EndPtY = 1;
StartPtY = 0;

ArrowLength = sqrt((EndPtX - StartPtX)^2 + (EndPtY - StartPtY)^2);
Xlength = EndPtX-StartPtX;
Ylength = EndPtY-StartPtY;
M = Ylength/Xlength;
ArrowAngle = atan(M);
AHSize = 0.25;
CrossPointX = StartPtX + (1-AHSize)*ArrowLength*cos(ArrowAngle)
CrossPointY = StartPtY + (1-AHSize)*ArrowLength*sin(ArrowAngle)

plot([StartPtX EndPtX],[StartPtY EndPtY])
hold on;
plot(CrossPointX,CrossPointY,'.');
axis equal
}%