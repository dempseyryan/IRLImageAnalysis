function TrackPoints = SelectNPoints(TrackingImage,ROIsize,NPts,mode);
TrackPoints = [];
f1 = figure(1);
imshow(TrackingImage);
for i = 1:NPts;
    str = sprintf('Select point %s of %s by clicking, or drawing an ROI around.',num2str(i),num2str(NPts));
    title(str);
    p = getrect(f1);
    px = p(1)+0.5*p(3);
    py = p(2)+0.5*p(4);
    if mode == 1
       [px py] = EstimateCentroid(px,py,ROIsize,ROIsize,TrackingImage); %EstimateCentroid returns the estimated center of the marker of interest
    end
    TrackPoints = [TrackPoints; px py];
    t = sprintf('%s',num2str(i));
    hold on;
    plot(px,py,'.','color','red');
    text(px-5,py-5,t,'Color','White');
    rectangle('Position',[px-0.5*ROIsize py-0.5*ROIsize ROIsize ROIsize], 'EdgeColor','r');
end
f1.delete;