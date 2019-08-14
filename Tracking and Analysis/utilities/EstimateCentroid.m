function [centx,centy,points] = EstimateCentroid(cx,cy,wx,wy,img,bfm)
points.Count = 0;
i = 0;
I = imcrop(img,[cx-wx/2 cy-wy/2 wx wy]);
%I = imadjust(I,[0.1;0.6],[0;1]);
if ~exist('bfm','var') || (exist('bfm','var') && bfm ==0)
      I = imgaussfilt(I,1);
      I = imcomplement(I);
      I = imadjust(I);
elseif exist('bfm','var') && bfm == 3
     I = imadjust(I);%,[.1;.5],[0;1]);
     I = imcomplement(I);
     I2 = imgaussfilt(I,2);
     I = (I2)-(I);
elseif exist('bfm','var') && bfm ==2
      I = imgaussfilt(I,2);
      I = imadjust(I)-mean(mean(I));
elseif exist('bfm','var') && bfm == 1
    points = detectBRISKFeatures(imgaussfilt(imadjust(I),1),'MinQuality',.5,'MinContrast',.2);
if points.Count ~=0
        fprintf('finding BRISK instead\n');
        wcentx = points.selectStrongest(1).Location(1);
        wcenty = points.selectStrongest(1).Location(2);
        figure('Visible', 'off');
        imshow(imgaussfilt(imadjust(I),1));
        hold on; plot(wcentx,wcenty,'X');
        pause(0.01);
        centx = sum(wcentx)+cx-wx/2;
        centy = sum(wcenty)+cy-wy/2;
      %  centx = double(round(centx));
      %  centy = double(round(centy));
        return
    end
end
    %figure(10);
    %imshow(I);
    %pause;

while points.Count <1 && i<=10;
   % points = detectSURFFeatures(I, 'MetricThreshold',10-i,'NumOctaves',2,'NumScaleLevels',6);
   points = detectBRISKFeatures(imgaussfilt(imadjust(I),1),'MinQuality',.5+i/22,'MinContrast',.2);
    i = i+2;
    %6-i
end
if points.Count == 0 %%if you can't find a point, return no point
    centx = 0;
    centy = 0;
    return
elseif points.Count ~=0 %%otherwise, continue
 
    centroids = cat(1, points.Location);
    areas = cat(1,points.Metric);
    areasum = sum(areas);
    wt_area = areas./areasum; %totals 1
    wcentx= wt_area.*centroids(:,1); wcentx(isnan(wcentx))=0; 
    wcenty= wt_area.*centroids(:,2); wcenty(isnan(wcenty))=0; 
end
    centx = sum(wcentx)+cx-wx/2;
    centy = sum(wcenty)+cy-wy/2;
 %   centx = double(round(centx));
 %   centy = double(round(centy));
end