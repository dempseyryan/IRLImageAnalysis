function ShowPoints(PrevPts,img,ROIsize,p)
 
%load('PrevPoints.mat');
gPoints = zeros(1,size(PrevPts,1));
for i = 1:size(PrevPts,1)
    for u = 1:size(p,2)
        if i == p(1,u)
           gPoints(1,i) = 1;
        end
    end
end
l = range(PrevPts(:,1))+100;
h = range(PrevPts(:,2))+100;
imshow(img);
for i = 1:size(PrevPts,1)
    x = PrevPts(i,1);
    y = PrevPts(i,2);
    hold on;
    if gPoints(1,i) == 1
        col = 'green';
    else
        col = 'red';
    end

    rectangle('Position',[x-0.5*ROIsize y-0.5*ROIsize ROIsize ROIsize], 'EdgeColor',col);
    t = sprintf('%s',num2str(i));
    text(x-10,y-10,t,'Color',col,'FontSize',12);  %give point a number
end
