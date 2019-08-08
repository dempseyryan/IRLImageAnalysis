function TrackPoints = SelectNPoints(TrackingImage,ROIsize,NPts,mode)
TrackPoints = [];
f1 = figure(1);
imshow(TrackingImage);
for i = 1:NPts

    validRect = false;
    while validRect == false
        str = sprintf('Select point %s of %s by clicking, or drawing an ROI around.',num2str(i),num2str(NPts));
        title(str);
        try
            p = getrect(f1);
            validRect = true;
        catch
            validRect = false;
            invalidPt = questdlg('The point was not selected', 'User canceled point', 'Reselect point', 'Cancel tracking', 'Reselect point');            
            if strcmp(invalidPt, 'Cancel tracking')
                warndlg('The tracking was canceled.', 'Points not tracked');
                TrackPoints = NaN;              
                return;
            end
            f1 = figure(1);
            imshow(TrackingImage);
            for u = 1:size(TrackPoints,1)
                t = sprintf('%s',num2str(u));
                hold on;
                plot(TrackPoints(u,1),TrackPoints(u,2),'.','color','red');
                text(TrackPoints(u,1)-5,TrackPoints(u,2)-5,t,'Color','White');
                rectangle('Position',[TrackPoints(u,1)-0.5*ROIsize TrackPoints(u,2)-0.5*ROIsize ROIsize ROIsize], 'EdgeColor','r');
            end
        end
    end
    px = p(1)+0.5*p(3);
    py = p(2)+0.5*p(4);
    if mode == 1%look into this
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