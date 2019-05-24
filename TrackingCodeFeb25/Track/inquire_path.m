

fprintf('%stransform.mat',path(1:end-2));
transformfile = sprintf('%stransform.mat',path(1:end-2));
load(transformfile);
steps_bk = steps;
StepsPerPt = [];
filt_steps = [];
for i = 1:size(steps_bk,1)
    StepsPerPt = [StepsPerPt steps_bk(i,1:2:end)' steps_bk(i,2:2:end)'];
end

for i = 1:2:size(StepsPerPt,2)
    filt_steps = [filt_steps smoothdata(StepsPerPt(:,i),'gaussian',10) smoothdata(StepsPerPt(:,i+1),'gaussian',10) ];
end
%%original point location
original_pts_x= filt_steps(1,1:2:end);
original_pts_y = filt_steps(1,2:2:end);
trans_orig_steps = [];
for i = 1:length(HsRts)
    tform = affine2d(HsRts(:,:,i));
    [U V] = transformPointsInverse(tform,original_pts_x,original_pts_y);
    step_trans_pt = [];
    for u = 1:length(U)
        step_trans_pt = [step_trans_pt U(u) V(u)];        
    end
    trans_orig_steps = [trans_orig_steps; step_trans_pt];
end

clr = 'rgbywp';
t=StartFrame; %which frame to start at
v = VideoWriter(sprintf('%sanimation.avi',path),'Motion JPEG AVI');     %NAME OF VIDEO FILE
open(v);
    for i = 1:1:size(filt_steps,1);
        trackplot = figure(5);
        
          file_name=sprintf('%s%s',mydir,a(t).name);
          t=t+1;
        imshow(file_name);
        hold on;
        for u = 1:2:size(filt_steps,2)
      %  plot(filt_steps(i,u),filt_steps(i,u+1),'.','Color',clr(mod(u,5)+1))
        % colmod = sqrt(filt_steps(i,u)-trans_orig_steps(1,u))^2+ (filt_steps(i,u+1)-trans_orig_steps(1,u+1))^2)/
        quiver(trans_orig_steps(i,u), trans_orig_steps(i,u+1), filt_steps(i,u)-trans_orig_steps(1,u), filt_steps(i,u+1)-trans_orig_steps(1,u+1),'ShowArrowHead','on','Color','red');  %draw arrow from original point to new point. Original point shifted with frame-wise transform.
        hold on;
        end
        frame=getframe(trackplot.CurrentAxes);
        writeVideo(v,frame);
        trackplot.delete;    
    end
close(v);
save(sprintf('%sDisplacementData.mat',path),'filt_steps','steps_bk','StepsPerPt');




