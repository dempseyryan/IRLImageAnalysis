%Track Points in Image
%ResetPoints;
clear;
close all;
clc;
% 
%%% Get first file
[filename, path]=uigetfile('*.tif');
mydir = path;
a = dir([path '*.tif']);
nfile = max(size(a)) ;                                                      %take the number of files and store it in nfile
[~, reindex] = sort( str2double( regexp( {a.name}, '\d+', 'match', 'once' ))); %reorder to natural numbering
a = a(reindex);

%%%% Get first file and select points
img1 = imread([path filename]);
%img1 = imadjust(img1,[0.1;0.6],[0;1]);
ROISize = 40;
NumPoints = 50;
TrackPoints = SelectNPoints(img1,ROISize,NumPoints,1);
close all
%%%%
% load('doover.mat');
%starts =TrackPoints;
StartFrame = find(strcmp({a.name}, filename)==1);
EndFrame = nfile;
steps = [];
for t = StartFrame+1:EndFrame%length(a); %don't want first file - same starting image.
    file_name=sprintf('%s%s',mydir,a(t).name);
    img3 = imread(file_name);
    img3 = imflatfield(img3,10);
   % img3 = imadjust(img3);
    img3 = imsharpen(img3);
%     segs = 7;
%     thresh = multithresh(img3,segs);
%     segI = imquantize(img3,thresh);
%     %imshow(uint8((segI*255/segs)));
%     img3 = uint8(segI*255/segs);
%    % img3 = imcrisp(img3,[0.255:0.001:0.27]);
    NewPoints = TrackNext(img3,ROISize,TrackPoints);
    TrackPoints = NewPoints;
    steps = [steps NewPoints];
    fprintf('Process: %s %%\n',num2str(round((t-StartFrame)/(EndFrame-StartFrame)*100)));
    
end

%inquire_path
%straincalc;
fprintf('That''s all folks.\n');
displacements;
