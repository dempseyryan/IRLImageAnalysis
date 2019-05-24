%% Video Stabilization Using Blob Feature Matching

%% Step 1. Read Frames from a Movie File
% Here we read in the first two frames of a video sequence. We read them as
% intensity images since color is not necessary for the stabilization
% algorithm, and because using grayscale images improves speed. Below we
% show both frames side by side, and we produce a red-cyan color composite
% to illustrate the pixel-wise difference between them. There is obviously
% a large vertical and horizontal offset between the two frames.

close all;
clearvars -except filename path;
warning('off', 'Images:initSize:adjustingMag');
if ~exist('path','var')
    [filename, path]=uigetfile('*.tif');
end
mydir = path;
a = dir([path '*.tif']);
nfile = max(size(a)) ;                                                      %take the number of files and store it in nfile
[~, reindex] = sort( str2double( regexp( {a.name}, '\d+', 'match', 'once' ))); %reorder to natural numbering
a = a(reindex);

%%%% Get first file
startFrame = find(strcmp({a.name}, filename)==1);

imgA = imread([path a(startFrame).name]); % Read first frame into imgA
imgB = imread([path a(startFrame+1).name]); % Read second frame into imgB
imgA = imflatfield(imgA,40);
imgB = imflatfield(imgB,40);
leftI =imgA;       %this is here to copy into cvexEstStabilizationTform.m
rightI =imgB;
getter = figure(1);
imshow(imgB);

%%%THE SETTINGS ARE BELOW%%%

framesOI = 1000; %number of frames of interest
ptThresh = 150;  %How sensitive the search is 1 = low, 1000 = high
newroi = 0; %select a new roi
go = 1;  %run the whole sequence?
saveVid = 1; %save the whole sequence?

%%%THE SETTINGS ARE ABOVE%%%

if exist('roidata.mat','file')
    load('roidata.mat','rect');
end
if newroi || ~exist('roidata.mat','file')
    rect = getrect;
    save('roidata.mat','rect');
end
roix = rect(1);
roiy = rect(2);
roiw = rect(3);
roih = rect(4);
getter.delete;
pointsA = detectSURFFeatures(leftI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',3,'NumScaleLevels',6);
pointsB = detectSURFFeatures(rightI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',3,'NumScaleLevels',6);


if ~go
    
figure; imshowpair(imgA, imgB, 'montage');
title(['Frame A', repmat(' ',[1 70]), 'Frame B']);

%%
figure; imshowpair(imgA,imgB,'ColorChannels','red-cyan');
title('Color composite (frame A = red, frame B = cyan)');

% Display blobs found in images A and B.
figure; imshow(imgA); hold on;
plot(pointsA);
title('Blobs in A');

figure; imshow(imgB); hold on;
plot(pointsB);
title('Blobs in B');


%% Step 3. Select Correspondences Between Points
% Next we pick correspondences between the points derived above. For each
% point, we extract a Fast Retina Keypoint (FREAK) descriptor centered
% around it. The matching cost we use between points is the Hamming
% distance since FREAK descriptors are binary. Points in frame A and frame
% B are matched putatively. Note that there is no uniqueness constraint, so
% points from frame B can correspond to multiple points in frame A.

% Extract FREAK descriptors for the corners
[featuresA, pointsA] = extractFeatures(imgA, pointsA);
[featuresB, pointsB] = extractFeatures(imgB, pointsB);

%%
% Match features which were found in the current and the previous frames.
% Since the FREAK descriptors are binary, the |matchFeatures| function 
% uses the Hamming distance to find the corresponding points.
indexPairs = matchFeatures(featuresA, featuresB);
pointsA = pointsA(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

%%
% The image below shows the same color composite given above, but added are
% the points from frame A in red, and the points from frame B in green.
% Yellow lines are drawn between points to show the correspondences
% selected by the above procedure. Many of these correspondences are
% correct, but there is also a significant number of outliers.

figure; showMatchedFeatures(imgA, imgB, pointsA, pointsB);
R1 = rectangle('Position',[roix roiy roiw roih], 'EdgeColor',[1 0 0]);
legend('A', 'B');

%% Step 4. Estimating Transform from Noisy Correspondences
% Many of the point correspondences obtained in the previous step are
% incorrect. But we can still derive a robust estimate of the geometric
% transform between the two images using the M-estimator SAmple Consensus
% (MSAC) algorithm, which is a variant of the RANSAC algorithm. The MSAC
% algorithm is implemented in the |estimateGeometricTransform| function.

[tform, pointsBm, pointsAm] = estimateGeometricTransform(pointsB, pointsA, 'similarity','Confidence',95,'MaxDistance',5);
imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
pointsBmp = transformPointsForward(tform, pointsBm.Location);

%%
% Below is a color composite showing frame A overlaid with the reprojected
% frame B, along with the reprojected point correspondences. 

figure;
showMatchedFeatures(imgA, imgBp, pointsAm, pointsBmp);
legend('A', 'B');

%% Step 5. Transform Approximation and Smoothing
% Extract scale and rotation part sub-matrix.

H = tform.T;
R = H(1:2,1:2);
% Compute theta from mean of two possible arctangents
theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
% Compute scale from mean of two stable mean calculations
scale = mean(R([1 4])/cos(theta));
% Translation remains the same:
translation = H(3, 1:2);
% Reconstitute new s-R-t transform:
HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
  translation], [0 0 1]'];
tformsRT = affine2d(HsRt);

imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
imgBsRt = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));

figure(2), clf;
imshowpair(imgBold,imgBsRt,'ColorChannels','red-cyan'), axis image;
title('Color composite of affine and s-R-t transform outputs');
end

if go
%% Step 6. Run on the Full Video
% Now we apply the above steps to smooth a video sequence. For readability,
% the above procedure of estimating the transform between two images has
% been placed in the MATLAB(R) function
% <matlab:edit(fullfile(matlabroot,'toolbox','vision','visiondemos','cvexEstStabilizationTform.m')) |cvexEstStabilizationTform|>.
% The function
% <matlab:edit(fullfile(matlabroot,'toolbox','vision','visiondemos','cvexTformToSRT.m')) |cvexTformToSRT|>
% also converts a general affine transform into a
% scale-rotation-translation transform.
%
% At each step we calculate the transform $H$ between the present frames.
% We fit this as an s-R-t transform, $H_{sRt}$. Then we combine this the
% cumulative transform, $H_{cumulative}$, which describes all camera motion
% since the first frame. The last two frames of the smoothed video are
% shown in a Video Player as a red-cyan composite.
%
% With this code, you can also take out the early exit condition to make
% the loop process the entire video.

imgB = imread([path a(startFrame).name]);
imgBp = imgB;
correctedMean = imgBp/framesOI;
movMean = imgB/framesOI;
ii = 2;
Hcumulative = eye(3);
HsRts = [];
Hcumulatives = [];
while ii < framesOI
    
    %%%Transform ROI
    tform = affine2d(Hcumulative);
    rectx = [roix;roix+roiw];
    recty = [roiy;roiy+roih];
    [U,V] = transformPointsInverse(tform,rectx,recty);
    troix = U(1);
    troiw = U(2)-troix;
    troiy = V(1);
    troih = V(2)-troiy;
    
    if troix <1 
        troix = 1;
    end
    if (troix+troiw)>size(imgA,2)
        troiw = size(imgA,2)-troix-1
    end
%     if troiw <0
%         troiw = -troiw;
%     end
    if troiy <1 
        troiy = 1;
    end
    if (troiy+troih)>= size(imgA,1)
        troih = size(imgA,1)-troiy-1
    end
    
    % Read in new frame
    imgA = imgB; % z^-1
    imgAp = imgBp; % z^-1
    imgB = imread([path a(startFrame+ii-1).name]);
    movMean = movMean + imgB/framesOI;
    
    % Estimate transform from frame A to frame B, and fit as an s-R-t
    H = cvexEstStabilizationTform(imgA,imgB,ptThresh,troix,troiy,troiw,troih);
    HsRt = cvexTformToSRT(H);
    Hcumulative = HsRt * Hcumulative;
    HsRts= cat(3,HsRts,HsRt);
    Hcumulatives = cat(3,Hcumulatives,Hcumulative);
    imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));
    
    if ~saveVid  && mod(ii,10)==1           %if not saving video, show images frame-by-frame
        figure(1);
        fused = imfuse(imgAp,imgBp,'blend');%,'ColorChannels','red-cyan'));
        imshow(fused);
%         imshow(imgA);
%         rectangle('Position',[troix troiy troiw troih], 'EdgeColor',[1 0 0]);
        titlestr = sprintf('File: ...%s\n',a(startFrame+ii).name((length(a(startFrame+ii).name)-8):length(a(startFrame+ii).name)));
        fprintf(titlestr)
    end
    if saveVid              %if saving, dont show video, just save it.
        savedir = sprintf('%sC',mydir);
        
       if ~exist(savedir,'dir')
           mkdir(savedir)
       end
        str = sprintf('%s/%s',savedir,a(startFrame+ii).name((length(a(startFrame+ii).name)-8):length(a(startFrame+ii).name)));
        imwrite(imgBp,str);
    end
    correctedMean = correctedMean + imgBp/framesOI;
    ii = ii+1;
    
end
save(sprintf('%stransform.mat',path),'Hcumulatives','HsRts');

% Here you call the release method on the objects to close any open files
% and release memory.


%%
% During computation, we computed the mean of the raw video frames and of
% the corrected frames. These mean values are shown side-by-side below. The
% left image shows the mean of the raw input frames, proving that there was
% a great deal of distortion in the original video. The mean of the
% corrected frames on the right, however, shows the image core with almost
% no distortion. While foreground details have been blurred (as a necessary
% result of the car's forward motion), this shows the efficacy of the
% stabilization algorithm.

figure; imshowpair(movMean, correctedMean, 'montage');
title(['Raw input mean', repmat(' ',[1 50]), 'Corrected sequence mean']);

%% References
% [1] Tordoff, B; Murray, DW. "Guided sampling and consensus for motion
% estimation." European Conference n Computer Vision, 2002.
%
% [2] Lee, KY; Chuang, YY; Chen, BY; Ouhyoung, M. "Video Stabilization
% using Robust Feature Trajectories." National Taiwan University, 2009.
% 
% [3] Litvin, A; Konrad, J; Karl, WC. "Probabilistic video stabilization
% using Kalman filtering and mosaicking." IS&T/SPIE Symposium on Electronic
% Imaging, Image and Video Communications and Proc., 2003.
%
% [4] Matsushita, Y; Ofek, E; Tang, X; Shum, HY. "Full-frame Video
% Stabilization." Microsoft(R) Research Asia. CVPR 2005.

displayEndOfDemoMessage(mfilename)
if saveVid
    clear path
end
end
