figure(2);
imgB = imread(a(startFrame+1).filepath);
imshow(imgB)
    Obox = [0 0 roiw roiw; 0 roih roih 0];
%    Obox = [-0.5*roiw -0.5*roiw 0.5*roiw 0.5*roiw; -0.5*roih 0.5*roih 0.5*roih -0.5*roih];

for tt = 1:8:length(TAngC);
    imshow(imgB);
    imgB = imread(a(startFrame+1+tt).filepath);
    theta = Tang(tt);
    tform = affine2d([cosd(theta) -sind(theta) 0; sind(theta) cosd(theta) 0; Tx(tt) Ty(tt) 1])
    [U,V] = transformPointsInverse(tform,roix,roiy)
    
%     T = [cos(TAngC(tt)) -sin(TAngC(tt));
%         sin(TAngC(tt)) cos(TAngC(tt))]; 
%        
%     OboxP = T*Obox;
%     OboxPR(1,:) = OboxP(1,:)+roix;%+0.5*roiw;%-Txc(tt);
%     OboxPR(2,:) = OboxP(2,:)+roiy;%+0.5*roih;%-Tyc(tt);
           
    L1p = line([OboxPR(1,1) OboxPR(1,2)],[OboxPR(2,1) OboxPR(2,2)]);
    L2p = line([OboxPR(1,2) OboxPR(1,3)],[OboxPR(2,2) OboxPR(2,3)]);
    L3p = line([OboxPR(1,3) OboxPR(1,4)],[OboxPR(2,3) OboxPR(2,4)]);
    L4p = line([OboxPR(1,1) OboxPR(1,4)],[OboxPR(2,1) OboxPR(2,4)]);
    pause(0.01);  
    
end

% boxx = roix;
% boxy = roiy;
% boxw = roiw;
% boxh = roih;
% 
% box = [roix roix roix+roiw roix+roiw 
%        roiy roiy+roih roiy+roih roiy];
%    
%     L1 = line([box(1,1) box(1,2)],[box(2,1) box(2,2)]);
%     L2 = line([box(1,2) box(1,3)],[box(2,2) box(2,3)]);
%     L3 = line([box(1,3) box(1,4)],[box(2,3) box(2,4)]);
%     L4 = line([box(1,1) box(1,4)],[box(2,1) box(2,4)]);