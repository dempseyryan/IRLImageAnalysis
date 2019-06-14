function im_out = drawQuiver(im_dir,x,y,x_mag,y_mag,max_val,max_length,num,xpix,ypix,arrowscale)
%DRAWQUIVER Summary of this function goes here
%   Detailed explanation goes here
%%%arrowscale scales the colours


%magnitude check 
xy_mags = sqrt(x_mag.^2+y_mag.^2);
max_mag = max(xy_mags(:));

%assign colormap
cmap_steps = 64;%%%64 
cmap = jet(cmap_steps);

%determine arrow scale
scale = max_length/max_mag;%max_val;
headLength = ceil(max_length/6);
headWidth = ceil(headLength/2);

%draw image
im_out = imread(im_dir);
im = cat(3,im_out,im_out,im_out);

% hold on
% axis off
% set(gca,'Ydir','reverse');
f=figure;%(11);close;figure(11)
hold on
ylim([-ypix,-1])%[1,1920])
xlim([1,xpix])
for this_arrow = 1:length(x)
    %ensure it is a valid point
    if x_mag(this_arrow)~=0 && y_mag(this_arrow)~=0 && ~isnan(x_mag(this_arrow))&& ~isnan(y_mag(this_arrow))
    
        
            ah = annotation('arrow','headStyle','vback2','HeadLength',ceil(xy_mags(this_arrow).*scale/10),...
                'HeadWidth',ceil(xy_mags(this_arrow).*scale/20),'color',cmap(ceil(xy_mags(this_arrow)/max_mag*cmap_steps*arrowscale),:));
            
            set(ah,'parent',gca);
            set(ah,'position',[x(this_arrow), -y(this_arrow), x_mag(this_arrow).*scale, -y_mag(this_arrow).*scale]);
            

            %pause(1/10000);
        
    end
end
%show image, hide under arrows
colorbar
image([1,xpix],[-1,-ypix],im)
chH = get(gca,'Children');
set(gca,'Children',flipud(chH))
axis equal
axis off
saveas(f,sprintf('Figure_scale%d.png',num));
close all
end

