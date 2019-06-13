

getter = figure(1);


    rect = getrect;
    save('roidata.mat','rect');
roix = rect(1);
roiy = rect(2);
roiw = rect(3);
roih = rect(4);
getter.delete;
pointsA = detectSURFFeatures(leftI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',3,'NumScaleLevels',6);
pointsB = detectSURFFeatures(rightI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',3,'NumScaleLevels',6);
