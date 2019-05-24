clc;
close all;
clear all;

%%%Switches%%%
setContrast = 0; %1 for contrast, 0 for video.
%vidname = ('Hockey.avi');
reSize = 0;
newSize = 0.5;

%%% Contrast stuff
conInLow = 0; %.15
conInHigh = 1;%.41
conOutLow = 0;
conOutHigh = 1;
conGamma = 1;

% if (setContrast && makeVid) || (~setContrast && ~makeVid)
%     fprintf('You must either set contrast or make video, not both or neither.\n');
% end

[filename, path]=uigetfile('*.tif');
mydir = path;
a = dir([path '*.tif']);
nfile = max(size(a)) ;                                                      %take the number of files and store it in nfile
[~, reindex] = sort( str2double( regexp( {a.name}, '\d+', 'match', 'once' ))); %reorder to natural numbering
a = a(reindex);

%%%% Get first file

vidname = sprintf('%svid1_%s',path,a(1).name(1:length(a(1).name)-13));

startFr = find(strcmp({a.name}, filename)==1);
endFr = nfile;

if setContrast
    conFig = figure(1);
    subplot(1,3,1);
    file_name=sprintf('%s%s',mydir,a(startFr+10).name);
    imshow(imread(file_name));
    title('Original');
    subplot(1,3,2);
    imshow(imadjust(imread(file_name),[conInLow; conInHigh],[conOutLow; conOutHigh],conGamma));
    str = sprintf('Contrast Adjustment:  [%s ; %s], [%s ; %s]',num2str(conInLow),num2str(conInHigh),num2str(conOutLow),num2str(conOutHigh));
    title(str);
    subplot(1,3,3);
    file_name=sprintf('%s%s',mydir,a(endFr-10).name);
    imshow(imadjust(imread(file_name),[conInLow; conInHigh],[conOutLow; conOutHigh],conGamma));
    str = sprintf('Contrast Adjustment:  [%s ; %s], [%s ; %s]',num2str(conInLow),num2str(conInHigh),num2str(conOutLow),num2str(conOutHigh));
    title(str);
    conFig.Position = [0 360 2100 776];
end

if ~setContrast
    v = VideoWriter(vidname,'Motion JPEG AVI');     %NAME OF VIDEO FILE
    open(v);
    for i = startFr:endFr  
         file_name=sprintf('%s%s',mydir,a(i).name);
        img = imread(file_name);                %read image
        img = imadjust(img,[conInLow; conInHigh],[conOutLow; conOutHigh],conGamma);  %adjust contrast
        if reSize
           img = imresize(img,newSize);                %resize image
         % img =  uint8(img / 256);
        end
       % img =  uint8(img / 256);
        writeVideo(v,img);                      %write image
        clear img;
    end;
    close(v);
end
