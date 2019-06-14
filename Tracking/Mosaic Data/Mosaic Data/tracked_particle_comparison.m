clear all
close all

load('Complex.mat');
load('Smooth.mat');

Smooth_C.x = 150;
Smooth_C.y = 142;

Complex_C.x = 149;
Complex_C.y = 140;

num_comp = length(complexparticle);
num_smooth = length(Smoothparticle);

for i = 1:num_comp
    complexparticle(i).x = complexparticle(i).x - Complex_C.x;
    complexparticle(i).y = complexparticle(i).y - Complex_C.y;
end

for i = 1:num_smooth
    Smoothparticle(i).x = Smoothparticle(i).x - Smooth_C.x;
    Smoothparticle(i).y = Smoothparticle(i).y - Smooth_C.y;
end

diff = 2;
k = 0;
for i = 1:num_smooth
    ind = 1;
    for j = 1:num_comp
        if abs(Smoothparticle(i).x(1) - complexparticle(j).x(1))<diff 
            if abs(Smoothparticle(i).y(1) - complexparticle(j).y(1))<diff
                if ind==1
                    k = k + 1;
                    ind = 2;
                    index(:,k) = [i,j];
                else
                    r1 = sqrt((Smoothparticle(i).x(1) - complexparticle(j).x(1))^2 + (Smoothparticle(i).y(1) - complexparticle(j).y(1))^2);
                    r2 = sqrt((Smoothparticle(index(1,k)).x(1) - complexparticle(index(2,k)).x(1))^2 + (Smoothparticle(index(1,k)).y(1) - complexparticle(index(2,k)).y(1))^2);
                    if r1 < r2
                        index(:,k) = [i,j];
                    end
                end
            end
        end
    end
end

for i = 1:k
    offset(i).x = complexparticle(index(2,i)).x(1) - Smoothparticle(index(1,i)).x(1);
    offset(i).y = complexparticle(index(2,i)).y(1) - Smoothparticle(index(1,i)).y(1);
    difs(i).x = complexparticle(index(2,i)).x - Smoothparticle(index(1,i)).x - offset(i).x;
    difs(i).y = complexparticle(index(2,i)).y - Smoothparticle(index(1,i)).y- offset(i).y;
    difs(i).resultant = difs(i).x.^2 + difs(i).y.^2; 
    difs(i).frame = complexparticle(index(2,i)).frame;
    
    difs(i).initialx = complexparticle(index(2,i)).x(1) + Complex_C.x;
    difs(i).initialy = complexparticle(index(2,i)).y(1) + Complex_C.y;
end

for i = k:-1:1
    if max(abs(difs(i).x)) > 100 
        difs(i)=[];
        else if max(abs(difs(i).y)) > 100
        difs(i)=[];
        end
    end
end

max_part = length(difs);
frame = 15;
%%%% Draw Arrows
%magnitude check 
max_mag = max(difs(i).resultant(frame));
arrowscale=0.7; %%% shoudl be between 0.5 and 1, changes colour scheme
%assign colormap
cmap_steps = 64;%%%64 
cmap = jet(cmap_steps);

max_length = 100;
%determine arrow scale
scale = max_length/max_mag;%max_val;
headLength = ceil(max_length/10);
headWidth = ceil(headLength/4);


im_out = imread('Down90cm_4_00000665.tif');
im = cat(3,im_out,im_out,im_out);



f=figure;%(11);close;figure(11)
hold on

% for i = 1:max_part
%     plot(difs(i).initialx,difs(i).initialy,'ko');
% end

ylim([-300,-1])%[1,1920])
xlim([1,310])

for i = 1:max_part
    %ensure it is a valid point
    ah = annotation('arrow','headStyle','vback2','HeadLength',ceil(difs(i).resultant(frame).*scale/10),...
                'HeadWidth',ceil(difs(i).resultant(frame).*scale/20),'color',cmap(ceil(difs(i).resultant(frame)/max_mag*cmap_steps*arrowscale),:));
            
            set(ah,'parent',gca);
            set(ah,'position',[difs(i).initialx, -difs(i).initialy, difs(i).x(frame).*scale, -difs(i).y(frame).*scale]);
            

            %pause(1/10000);
        
end
% colorbar
image([1,310],[-1,-300],im)
chH = get(gca,'Children');
set(gca,'Children',flipud(chH))
axis equal
axis off