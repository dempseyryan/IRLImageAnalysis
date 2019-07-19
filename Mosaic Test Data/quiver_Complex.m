clear all
close all

load('Complex.mat');
num = length(complexparticle);
% % %%%%% Specific Point in Complex
% % Center.x = 149;
% % Center.y = 140;

%%%%% Specific Point in Complex
% % % Center.x = 150;
% % % Center.y = 142;

im_out = imread('Down90cm_4_00000665.tif');
im = cat(3,im_out,im_out,im_out);

f=figure;%(11);close;figure(11)
hold on
image(im)
for i = 1:num
    plot(complexparticle(i).x(1),complexparticle(i).y(1),'ko');
end
% colorbar
axis equal
axis off


load('Smooth.mat');
num = length(Smoothparticle);
% % %%%%% Specific Point in Complex
% % Center.x = 149;
% % Center.y = 140;

%%%%% Specific Point in Smooth
% % % Center.x = 150;
% % % Center.y = 142;

im_out = imread('SmoothDown90cm_4_00000665.tif');
im = cat(3,im_out,im_out,im_out);

f=figure;%(11);close;figure(11)
hold on
image(im)
for i = 1:num
    plot(Smoothparticle(i).x(1),Smoothparticle(i).y(1),'ko');
end
% colorbar
axis equal
axis off