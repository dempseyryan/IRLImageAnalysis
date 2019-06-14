DisplaceSlope = -14.909;
DisplaceIntercept = 49.856;
LoadSlope = 48.59;
LoadIntercept = -0.3302;


[fileID, filePath] = uigetfile('*.lvm');
indentfile = fopen(fileID);
[sample, VDisplace, VLoad] = textread([filePath fileID],'%f %f %f',-1,'headerlines',23,'delimiter',' ');
Displace = VDisplace*DisplaceSlope + DisplaceIntercept;
Load = VLoad*LoadSlope + LoadIntercept;
figure(1);
plot(sample,Displace);
title('Displacement');
figure(2);
plot(sample,Load);
title('Load');
figure(3);
plot(sample,Load);
hold on;
plot(sample,(Displace));
