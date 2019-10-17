function [line1, line2, line3] = GoodArrow(xt1,yt1,xt2,yt2,col,dilation, head)
%{
GoodArrow Takes in two points and returns the handles to the
arrowheads and tail, for the arrow drawn from the first point to the second. 
   xt1, yt1: coordinates for first point
   xt2, yt2: coordinates for second point

   head = 0 means the head is on the particle's current location. 
   1 means the particle is touching the midpoint of the arrow, and 2 means
   it's on the arrow's tail.
%}
%if given a nan, return
if isnan(xt1) || isnan(yt1) || isnan(xt2) || isnan(yt2) || isnan(max(col)) 

    line1 = 0;%if infinity make the supposed handles scalars 
    line2 = 0;%to signify arrow not drawn
    line3 = 0;
    return
end
 %trajectory was continued
%if there is a dilation, put the arrow end point that times further along
%the same vector
if dilation ~= 0 
    d1 = xt1 - xt2;
    d2 = yt1 - yt2;
    xt1 = xt1 + (dilation - 1)*d1;%dilation - 1 because when it is just dil'n
    yt1 = yt1 + (dilation - 1)*d2;%will get different vector for 1x
%%added term is just that - added, to the original
%this version works for all values and is mathematically correct
end
if head == 1%if particle needs to be in the midpoint, change the head location to accomodate
    xt2 = 2*xt2 - xt1;
    yt2 = 2*yt2 - yt1;
elseif head == 2%if it needs to be on the tail, change both the head and tail to shift forward
    
    newX = 2*xt2 - xt1;%current (xt2,yt2) is midpoint of desired (xt2,yt2) and current (xt1, yt1)
    newY = 2*yt2 - yt1;
    
    xt1 = xt2;
    yt1 = yt2;
    
    xt2 = newX;
    yt2 = newY;
    
    
end
angAt = atan((yt2-yt1)/(xt2-xt1));
angT = 30;
% Finding length between two given points 

P1=[xt1,yt1];P2=[xt2,yt2];
R=sqrt((xt2-xt1)^2+(yt2-yt1)^2);

%Find points for arrow if it was just horizontal, but same size R
if xt1 > xt2 
    angAt = angAt+pi;
end

x1 = 0;
y1 = 0;
y2 = 0;
x2 = R;
angA = 0;

%scaling length to 75%

RS = 0.75*R;


%Finding point C - corresponding to 0.75 length of vector between P1 and P2
Cx=x1+RS*cosd(angA);
Cy=y1+RS*sind(angA);

%Finding B, corresponding to length from C to P2
B=0.25*R;

%Finding A, corresponding to length from C to unknown point T1
A=B*tand(angT);

%Finding unknown points T1 and T2
Tx1=Cx-A*cosd(90-angA);
Ty1=Cy+A*sind(90-angA);

Tx2=Cx+A*sind(angA);
Ty2=Cy-A*cosd(angA);

%transform these horizontal arrow points to match the actual arrow, rotated
%about its first point

tf= [cos(angAt) sin(angAt) 0;
     -sin(angAt) cos(angAt) 0;
     0 0 1];

 tform = affine2d(tf);

[Tx,Ty] = transformPointsForward(tform,[Tx1;Tx2],[Ty1;Ty2]);
Tx = Tx+xt1;
Ty = Ty+yt1;




line1 = line([Tx(1) xt2],[Ty(1) yt2],'Color',col);%head
line2 = line([Tx(2) xt2],[Ty(2) yt2],'Color',col);%head
line3 = line([xt1 xt2],[yt1 yt2],'Color',col);%shaft
end

