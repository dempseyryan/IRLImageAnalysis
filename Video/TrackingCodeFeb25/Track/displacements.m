[filename, path]=uigetfile('*.tif');
a = dir([path '*.tif']);
nfile = max(size(a)) ;                                                      %take the number of files and store it in nfile
[~, reindex] = sort( str2double( regexp( {a.name}, '\d+', 'match', 'once' ))); %reorder to natural numbering
a = a(reindex);
StartFrame = find(strcmp({a.name}, filename)==1);

path;

LoadDisplacements = 0;      %Switch
RemPoints = 0;              %Switch
IgnoreTransform = 0;        %Switch
MakeVideo = 1;              %Switch
MakePlots = 1;              %Switch
SaveDisplacements = 1;      %Switch

if LoadDisplacements
    load(sprintf('%sDisplacementData.mat',path));  %load previously calculated
elseif ~LoadDisplacements
%     steps_bk = steps;
    StepsPerPt = [];
    filt_steps = [];
    for i = 1:size(steps_bk,1)
        StepsPerPt = [StepsPerPt steps_bk(i,1:2:end)' steps_bk(i,2:2:end)'];
    end
    for i = 1:2:size(StepsPerPt,2)
        filt_steps = [filt_steps smoothdata(StepsPerPt(:,i),'gaussian',10) smoothdata(StepsPerPt(:,i+1),'gaussian',10) ];
    end
end

%Remove Points

RemovePoints = [1;2;3;4]; %Points must be in order!
if RemPoints   
    StepsPerPtB = StepsPerPt;
    filt_stepsB = filt_steps;
    for i = 1:length(RemovePoints)
        RmPt = RemovePoints(i) - (i-1);  %Compensates for for removed points
        StepsPerPtR = RemColumn(StepsPerPt,RmPt*2); %remove Y component
        StepsPerPtR = RemColumn(StepsPerPtR,RmPt*2-1); %remove X component
        StepsPerPt = StepsPerPtR;
        clear StepsPerPtR;
    end
    filt_steps = [];
    for i = 1:2:size(StepsPerPtR,2)
        filt_steps = [filt_steps smoothdata(StepsPerPt(:,i),'gaussian',10) smoothdata(StepsPerPt(:,i+1),'gaussian',10) ];
    end
end



[transformfile, junk] = sprintf('%stransform.mat',convertCharsToStrings(path(1:end-2)));
if exist(transformfile) && ~IgnoreTransform
    load(transformfile);
elseif ~exist(transformfile) || IgnoreTransform
    for i = 1:size(StepsPerPt,2); HsRts(:,:,i) = [1 0 0; 0 1 0; 0 0 1]; end %if transform data not available
end

%original point location
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


if MakeVideo
    clr = 'rgbywp';
    t=StartFrame; %which frame to start at
    v = VideoWriter(sprintf('%sStepQuiver.avi',path),'Motion JPEG AVI');     %NAME OF VIDEO FILE
    open(v);
        for i = 1:1:size(filt_steps,1);
            trackplot = figure(5);
            file_name=sprintf('%s%s',path,a(t).name);
            t=t+1;
            imshow(file_name);
            hold on;
            for u = 1:2:size(filt_steps,2)
%            plot(filt_steps(i,u),filt_steps(i,u+1),'.','Color',clr(mod(u,5)+1))
%            colmod = sqrt(filt_steps(i,u)-trans_orig_steps(1,u))^2 + (filt_steps(i,u+1)-trans_orig_steps(1,u+1))^2)
                       GoodArrow(trans_orig_steps(i,u),trans_orig_steps(i,u+1),filt_steps(i,u), filt_steps(i,u+1),ColScale(0,70,Rs(i,(u+1/2))));

            quiver(trans_orig_steps(i,u), trans_orig_steps(i,u+1), filt_steps(i,u)-trans_orig_steps(1,u), filt_steps(i,u+1)-trans_orig_steps(1,u+1),2,'Color',[0 1 0]);  %draw arrow from original point to new point. Original point shifted with frame-wise transform.
            hold on;
            end
            frame=getframe(trackplot.CurrentAxes);
            writeVideo(v,frame);
            trackplot.delete;    
        end
    close(v);
end



if MakePlots 
    figure(1);plot(filt_steps(:,[1:2:end]));
    title('X Displacement per Frame');
    ylabel('Displacement (px)');
    xlabel('Frame');
    figure(2);plot(filt_steps(:,[2:2:end]));
    title('Y Displacement per Frame');
    ylabel('Displacement (px)');
    xlabel('Frame');
    figure(3); plot(filt_steps(:,1:2:end),filt_steps(:,2:2:end));
    title('X vs Y Displacement: Time History');
    ylabel('Y Displacement (px)');
    xlabel('X Displacement (px)');
    figure(3);axis equal;
    figure(4); plot(mean((filt_steps(:,2:2:end)-filt_steps(1,2:2:end))'))
    title('Mean Y Displacement per Frame');
    ylabel('Mean Displacement (px)');
    xlabel('Frame');
    figure(4);axis equal;
    figure(5); plot(mean((filt_steps(:,1:2:end)-filt_steps(1,1:2:end))'))
    title('Mean X Displacement per Frame');
    ylabel('Mean Displacement (px)');
    xlabel('Frame');
    figure(4);axis equal; 
    
     saveas(figure(1),sprintf('%sXDisplacement.png',path));
     saveas(figure(2),sprintf('%sYDisplacement.png',path));
     saveas(figure(3),sprintf('%sXYTime.png',path));
     saveas(figure(4),sprintf('%sAverageY.png',path));
     saveas(figure(5),sprintf('%sAverageX.png',path));
end


if SaveDisplacements
    if RemPoints
        save(sprintf('%sDisplacementRemPtsData.mat',path),'filt_steps','steps_bk','StepsPerPt');
    elseif ~RemPoints
        save(sprintf('%sDisplacementData.mat',path),'filt_steps','steps_bk','StepsPerPt');
    end
end

%%%%%
% for i = 1:1:size(filt_steps,1);
%             %file_name=sprintf('%s%s',path,a(t).name);
%             %t=t+1;
%             %imshow(file_name);
%             %hold on;
%             for u = 1:2:size(filt_steps,2)
%            % plot(filt_steps(i,u),filt_steps(i,u+1),'.','Color',clr(mod(u,5)+1))
%            % colmod = sqrt(filt_steps(i,u)-trans_orig_steps(1,u))^2+ (filt_steps(i,u+1)-trans_orig_steps(1,u+1))^2)
%            
%             GoodArrow(trans_orig_steps(i,u),trans_orig_steps(i,u+1),filt_steps(i,u), filt_steps(i,u+1),ColScale(0,70,Rs(i,(u+1/2))));
%            %Rs(i,(u+1)/2) =  sqrt((filt_steps(i,u) - trans_orig_steps(i,u))^2+(filt_steps(i,u+1) - trans_orig_steps(i,u+1))^2);
%           %  quiver(trans_orig_steps(i,u), trans_orig_steps(i,u+1), filt_steps(i,u)-trans_orig_steps(1,u), filt_steps(i,u+1)-trans_orig_steps(1,u+1),2,'Color',[0 1 0]);  %draw arrow from original point to new point. Original point shifted with frame-wise transform.
%             %hold on;
%           axis equal;
%             end
%            % frame=getframe(trackplot.CurrentAxes);
%             %writeVideo(v,frame);
%             %trackplot.delete;    
%                
% end


