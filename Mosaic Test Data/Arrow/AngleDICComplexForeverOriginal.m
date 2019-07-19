close all
clc
clear
run('C:\Users\ashle\Desktop\Masters\MATLAB\ElastomerDrops\Alignmentcheck.m')
fprintf('done running Alignment Check \n Now running Angle DIC Complex \n')
% frame=30;
jet2 = jet(2049);
jet2(1025,:)=[1 1 1];
%put stephane's stretch code here

for frame=1:10
load('E:\Elastomer Drop Redo\MorphDOWNWARD\ncorr\Smooth\CS30cm2.mat')                                      %open smooth data in this folder
%gets displacement/strain data
i=data_dic_save.strains(frame).plot_exy_ref_formatted; %gives data variable
i(1,1)=0.0000000000001;
I=zeros(3*x,3*y); %makes box huge so can rotate complex image
I(x:2*x-1, y:2*y-1)=i;
this_I= imread(strcat(current_save(frame).path,current_save(frame).name));


load('E:\Elastomer Drop Redo\MorphDOWNWARD\ncorr\Complex\C30cm2.mat')                                      %open complex data in this folder
[x, y] = size(data_dic_save.strains(frame).plot_exy_ref_formatted); %gets displacement/strain data,do frame + number to make both slices move at same time
i2=data_dic_save.strains(frame).plot_exy_ref_formatted; %gives data variable, do frame + number to make both slices move at same time
I2=zeros(3*x,3*y);
%I(x:2*x-1, y:2*y-1)=i2;
scale = 1;
i2(1:end-4*scale,1:end-12*scale)=i2(4*scale:end-1,12*scale:end-1); %moves complex image into good directions,first number y, second x 
%i2(8:end-1,:)=i2(1:end-8,:);

i2(1,1)=0.00000001;
i2p = imrotate(i2,-7.4, 'bilinear'); %rotates complex image to match with smooth
ind=find(i2p(1,:)~=0);
I2(x-ind(1):x-ind(1)+size(i2p,1)-1,y:y+size(i2p,2)-1)=i2p;

% figure(1)
% subplot(1,2,1);
% imagesc(I)
% axis equal
% colormap(gray)
% subplot(1,2,2);
% imagesc(I2)
% 
% axis equal
% colormap(gray)
% 
% figure(2) %checks to see both images are aligned
% 
% Ir = I; %smooth slice
% Ir(Ir~=0)=255;
% Ig = I2; %complex slice, yellow is overlap
% Ig(Ig~=0)=255;
% Ib = I;
% Ib(Ib~=0)=0;
% Im = cat(3,Ir,Ig,Ib);
% 
% 
% image(Im)
% colormap(gray)
% colorbar

I(I2==0)=0;
I2(I==0)=0;
C = I2-I;
figure(3)
subplot(2,3,1)

imshow(this_I(:,10:end))%changes width of video, middle number
title('Smooth')

subplot(2,3,[2 3 5 6])
imagesc(C);     %draws the differential image as heat map
colormap(jet2);

%type colorbar(c4)
colorbar;
caxis([-0.01 0.01]);    %Make sure scale matches observed strain/displacement in varibale 'C'
xlim([300 600]);        %Make sure window overlays the location of the slice in the image
ylim([300 600]);        %same as xlim
%axis equal
axis off
daspect([1 1 1]);
this_title = sprintf('Complex-Smooth @ Frame: %i',frame);
title(this_title)
subplot(2,3,4)
this_I2= imread(strcat(current_save(frame).path,current_save(frame).name)); %do frame + number to make both slices move at same time
imshow(this_I2(:,10:end)) %changes width of video, middle number
title('Complex')
%saveas(gcf,['2p12' num2str(frame) '.png']);        %to save each figure
%instance as a .png



%gif utilities
set(gcf,'color','w'); % set figure background to white
drawnow;
frame1 = getframe(3); %getframe(N) N= figure number
im = frame2im(frame1);
[imind,cm] = rgb2ind(im,256);
outfile = '2p12Exysmallrange_MAY30_test.gif'; %name of gif to be saved

%On the first loop, create the file. In subsequent loops, append.
if frame==1
   imwrite(imind,cm,outfile,'gif','DelayTime',0.3,'loopcount',inf);
else
   imwrite(imind,cm,outfile,'gif','DelayTime',0.3,'writemode','append');
end
end
fprintf('DONE EVERYTHING, ANTON IS THE BESTEST')
