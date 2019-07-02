%XRayVideoCapture = 7500;
%XRayVideoFps = 30;
SpeedFactor = 12.5; %XRayVideoCapture/XRayVideoFps;  % how many times slower would you like the video to be?
startTime = 42; % start time (s) from original video
endTime = 43 ;%% end time (s) from original video
originalVid = uigetfile('*.mov');  % original video filename
newVid = sprintf('%s_Overlay_%s.avi',originalVid(1:length(originalVid-4)),num2str(SpeedFactor));  %new filename

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% The code below does the work %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
v = VideoReader(originalVid);
wv = VideoWriter(newVid);
wv.FrameRate = v.FrameRate/SpeedFactor;
open(wv)
v.CurrentTime = startTime;
while v.CurrentTime < endTime
    vidFrame = readFrame(v);
    writeVideo(wv,vidFrame);
end
close(wv);