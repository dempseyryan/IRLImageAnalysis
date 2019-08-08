function [xc yc l h] = Helper(PrevPts,img,ROIsize,p)
 
%load('PrevPoints.mat');
xc = min(PrevPts(:,1))-50;
yc = min(PrevPts(:,2))-50;
l = range(PrevPts(:,1))+100;
h = range(PrevPts(:,2))+100;
I = imcrop(img,[xc yc l h]);
imshow(I);
for i = 1:size(PrevPts,1)
    x = PrevPts(i,1);
    y = PrevPts(i,2);
    hold on;
        if i == p
        col = 'green';
    elseif i~=p
        col = 'red';
    end
    rectangle('Position',[x-0.5*ROIsize-xc y-0.5*ROIsize-yc ROIsize ROIsize], 'EdgeColor',col);
    t = sprintf('%s',num2str(i));
    text(x-10-xc,y-10-yc,t,'Color',col,'FontSize',12);  %give point a number
end


