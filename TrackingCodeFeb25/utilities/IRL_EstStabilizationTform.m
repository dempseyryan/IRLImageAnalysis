function H = IRL_EstStabilizationTform(leftI,rightI,ptThresh,roix,roiy,roiw,roih)
%Get inter-image transform and aligned point features.
%  H = IRL_EstStabilizationTform(leftI,rightI,ROI) returns an 'similarity' transform
%  between leftI and rightI using the |estimateGeometricTransform|
%  function. Based on cvexEstStabilizationTransform. Also takes in ROI.
%

% Copyright 2010 The MathWorks, Inc.
% Modified by Scott - no longer corner detection - uses SURF Features
% (blobs).

% Set default parameters
if isempty(ptThresh)
    ptThresh = 1000;
end

%% Generate prospective points

pointsA = detectSURFFeatures(leftI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',5,'NumScaleLevels',6);
pointsB = detectSURFFeatures(rightI, 'MetricThreshold', ptThresh,'ROI',[roix roiy roiw roih],'NumOctaves',5,'NumScaleLevels',6);


%% Select point correspondences
% Extract features for the corners
[featuresA, pointsA] = extractFeatures(leftI, pointsA);
[featuresB, pointsB] = extractFeatures(rightI, pointsB);

% Match features which were computed from the current and the previous
% images
indexPairs = matchFeatures(featuresA, featuresB);
pointsA = pointsA(indexPairs(:, 1), :);
pointsB = pointsB(indexPairs(:, 2), :);

%% Use MSAC algorithm to compute the affine transformation
tform = estimateGeometricTransform(pointsB, pointsA, 'similarity','Confidence',95,'MaxDistance',5);
H = tform.T;
