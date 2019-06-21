function NewPoints = TrackNext(img,ROIsize,TrackPoints)
%TrackNext Tracks points selected in SelectPoints for a different image
%   TrackNext(img,TrackPoints). img: image to find points in, TrackPoints:
%   points selected previously.
%%%%%%%Faster to crop image in here, then send to estimate centroid?
MaxTravel = 10;
NewPoints = zeros(size(TrackPoints, 1), 2); % pre-sizing to drastically increase computation speed
for i = 1:size(TrackPoints,1)           %for each point in the list of points to track
    [px, py] = EstimateCentroid(TrackPoints(i,1),TrackPoints(i,2),ROIsize,ROIsize,img);
    b=0;
    while (px == 0) && (py == 0) && b<3   %if the point can't be found, increase the ROI and search again
        ROIsize = ROIsize+5;
        b=b+1;
        [px, py] = EstimateCentroid(TrackPoints(i,1),TrackPoints(i,2),ROIsize,ROIsize,img,b);
        fprintf('Can''t find point #%s. Trying again.\n',num2str(i));
    end
    
%     if (sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>MaxTravel) && ~(px == 0) && ~(py ==0)
%        
%         px = mean([TrackPoints(i,1) px]);
%         py = mean([TrackPoints(i,2) py]);
%         fprintf('Max at pt %s. Difference X: %s. Difference Y: %s\n',num2str(i),num2str(px-TrackPoints(i,1)),num2str(py-TrackPoints(i,2)));
%     end
    
    if (px == 0) || (py == 0) || sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>MaxTravel %if it cant find it, or if it deviates too much in one step
         
         if (sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))>MaxTravel) && ~(px == 0) &&~(py ==0)
             fprintf('Max travel reached: %s.\n',num2str(sqrt(((abs(TrackPoints(i,1)-px))^2 + (abs(TrackPoints(i,2)-py))^2))));
         end
         
         str = sprintf('Draw an ROI around point # %s.\n',num2str(i));
         userCent2 = figure(3);
         userCent2.WindowState = 'maximized';
         [cpx, cpy, cpl, cph] = Helper(TrackPoints,img,ROIsize,i);
         title(str);
         rect = getrect(userCent2);
         px = rect(1)+0.5*(rect(3))+cpx;%+NewPoints(i,1)-25;
         py = rect(2)+0.5*(rect(4))+cpy;%+NewPoints(i,2)-25;
         %fprintf('Point: X: %s Y: %s\n',num2str(px),num2str(py));
         userCent2.delete;
     end
   NewPoints(i,:) = [px py];
end


%Double Check that the point can be found
% for i = 1:size(NewPoints,1);
%     
%     [px py] = EstimateCentroid(NewPoints(i,1),NewPoints(i,2),ROIsize,ROIsize,img);    
%     
%     if abs(px-NewPoints(i,1))>=5 || abs(py-NewPoints(i,2))>=5 %if they're not close, leave them as is
%         fprintf('Point # %s may be unstable.\n',num2str(i));
%     elseif     abs(px-NewPoints(i,1))<5 && abs(py-NewPoints(i,2))<5 %if they're close, save the double checked version
%         NewPoints(i,:) = [px py];
%     end
% end
