%strain
steps_bk_sort = StepsPerPt;
steps_strain = [steps_bk_sort steps_bk_sort(:,1:2)];
x = steps_bk_sort(:,1:2:end);
y = steps_bk_sort(:,2:2:end);
for t = 1:size(x,1);
for m = 1:size(x,2);
    x1 = x(t,m);
    y1 = y(t,m);
    for n = 1:size(x,2);
        x2 = x(t,n);
        y2 = y(t,n);
        lengthx(m,n,t) = x2-x1;
        lengthy(m,n,t) = y2-y1;
        R(m,n,t) = sqrt((x1-x2)^2+(y1-y2)^2);
        MidPositionx(m,n,t) = (x2+x1)/2;
        MidPositiony(m,n,t) = (y2+y1)/2;
    end
end
end
direct_strains = (R(:,:,:)-R(:,:,1))./R(:,:,1);
x_strains = (lengthx(:,:,:)-lengthx(:,:,1))./lengthx(:,:,1);
y_strains = (lengthy(:,:,:)-lengthy(:,:,1))./lengthy(:,:,1);

x_point_displ = x-x(1,:);
y_point_displ = y-y(1,:);
Xsize = 1:size(imgA,2);
Ysize = (1:size(imgA,1))';

%mesh average x strain


% t = 1;
% for r = 1:5:900
%     figure(1);
%     vq(:,:,t) = griddata(x(1,:),y(1,:),x_point_displ(r,:),Xsize,Ysize,'linear');
%     mesh(Xsize,Ysize,diff(vq(:,:,t),1,2));colorbar;view(0,270);caxis([-0.25 0.25]);
%     figure(2);
%     vq(:,:,t) = griddata(x(1,:),y(1,:),y_point_displ(r,:),Xsize,Ysize,'linear');
%     mesh(1:1279,Ysize,diff(vq(:,:,t),1,2));colorbar;view(0,270);caxis([-0.25 0.25]);
%     
% end
%{
for t = 1:1:900
    vq(:,:,t) = griddata(x(1,:),y(1,:),y_point_displ(t,:),Xsize,Ysize,'natural');
    mesh(1:1279,Ysize,diff(vq(:,:,t),1,2));colorbar;view(0,270);caxis([-0.25 0.25]);pause(0.01);
end
%}
[X,Y] = meshgrid(Xsize,Ysize);
StrainsPos = [];
% imshow(imgA);
for f = 1:size(direct_strains,3);
for t = 1:6
for i = 1+7*t:6+7*t;
    hold on;
%     plot(MidPositionx(0+i,1+i,f),MidPositiony(0+i,1+i,f),'x');
     StrainsPos = [StrainsPos;MidPositionx(0+i,1+i,f) MidPositiony(0+i,1+i,f) direct_strains(0+i,1+i,f);];
end

end
StrainFrame(:,:,f) = StrainsPos;
StrainsPos = [];
end
for f = 1:500;
vq = griddata(StrainFrame(:,1,f),StrainFrame(:,2,f),StrainFrame(:,3,f),X,Y);
caxis([-0.25 0.25])
mesh(X,Y,vq);
caxis([-0.5 0.5]);
view(0,270);
pause(0.001);
f
end