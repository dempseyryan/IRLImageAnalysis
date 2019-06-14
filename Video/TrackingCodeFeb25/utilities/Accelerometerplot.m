% clear all 
% close all
% 
% load('Rotational_filtered.mat');
% 
% ARS_time = 1e3*(Tstart + Tinterval * (1:Length));
% ARS1 = -A / 0.1948;
% ARS2 = -B / 0.2000;
% ARS3 = -C / -0.1955;
% Trig2 = D;
% Voltage = mean(E);
% 
% plot(ARS_time,A);
% 
% clear  A B C D E
% 
% load('Linear_filtered.mat');
% 
% ACC_time = Tstart + Tinterval * (1:Length);
% ACC1 = -A ./ 0.01203 ./ Voltage; % in g's (mV / (mV/V/g * V))
% ACC2 = -B ./ -0.01210 ./ Voltage;
% ACC3 = -C ./ 0.01292 ./ Voltage;
% Trig1 = D;
% 
% clear  A B C D E
% 
% figure(1)
% hold on
% plot(ARS_time,ARS1, 'b');
% plot(ARS_time,ARS2, 'r');
% plot(ARS_time,ARS3, 'g');
% 
% xlabel('Time (ms)');
% ylabel('Angular Rate (^{o}/s)');
% hold off
% 
% figure(2)
% hold on
% plot(ACC_time,ACC1, 'b');
% plot(ACC_time,ACC2, 'r');
% plot(ACC_time,ACC3, 'g');
% 
% xlabel('Time (ms)');
% ylabel('Linear Acceleration (g)');
% hold off


% clear all 
% close all
fprintf('Select data file for rotational rate.\n');
[rotFile,rotPath] = uigetfile;
load([rotPath rotFile]);

ARS_time = 1e3*(Tstart + Tinterval * (1:Length));
ARS1 = -A*1e3 / 0.1948;
ARS1_offset = sum(ARS1(1:500))/500;

ARS2 = -B*1e3 / 0.2000;
ARS2_offset = sum(ARS2(1:500))/500;

ARS3 = -C*1e3 / -0.1955;
ARS3_offset = sum(ARS3(1:500))/500;

P_Coup = G*1000/6.2;
P_ContCoup = F*1000/6.2;


Trig2 = D*1e3;
TrigPoint2 = find(Trig2 >= max(Trig2),1,'last');

ARS1_Cropped = ARS1(TrigPoint2:end);
ARS2_Cropped = ARS2(TrigPoint2:end);
ARS3_Cropped = ARS3(TrigPoint2:end);

targetSampleRate = 20000;
[ARS1y,ty] = resample(ARS1_Cropped,ARS_time(TrigPoint2:end)/1000,targetSampleRate);
[ARS2y,ty] = resample(ARS2_Cropped,ARS_time(TrigPoint2:end)/1000,targetSampleRate);
[ARS3y,TRSy] = resample(ARS3_Cropped,ARS_time(TrigPoint2:end)/1000,targetSampleRate);

Voltage = mean(E);

clear  A B C D E

fprintf('Select data file for linear acceleration.\n');
[linFile,linPath] = uigetfile;
load([linPath linFile]);

ACC_time = 1e3 * (Tstart + Tinterval * (1:Length));
ACC1 = -A*1e3 ./ 0.01203 ./ Voltage; % in g's (mV / (mV/V/g * V))
ACC1_offset = sum(ACC1(1:10000))/10000;

ACC2 = -B*1e3 ./ -0.01210 ./ Voltage;
ACC2_offset = sum(ACC2(1:500))/500;

ACC3 = -C*1e3 ./ 0.01292 ./ Voltage;
ACC3_offset = sum(ACC3(1:500))/500;

Trig1 = D*1e3;
TrigPoint1 = find(Trig1 >= max(Trig1),1,'last');


ACC1_Cropped = ACC1(TrigPoint1:end);
ACC2_Cropped = ACC2(TrigPoint1:end);
ACC3_Cropped = ACC3(TrigPoint1:end);

targetSampleRate = 20000;
[ACC1y,ty] = resample(ACC1_Cropped,ACC_time(TrigPoint1:end)/1000,targetSampleRate);
[ACC2y,ty] = resample(ACC2_Cropped,ACC_time(TrigPoint1:end)/1000,targetSampleRate);
[ACC3y,TCCy] = resample(ACC3_Cropped,ACC_time(TrigPoint1:end)/1000,targetSampleRate);



clear  A B C D E

f1=figure(1);
subplot(2,1,1);
set(gcf, 'Position', [100 100 512 768]);
hold on
plot(ARS_time,(ARS1-ARS1_offset)*pi/180, 'b');
plot(ARS_time,(ARS2-ARS2_offset)*pi/180, 'r');
plot(ARS_time,(ARS3-ARS3_offset)*pi/180, 'g');
axis([-50 200 -25 15]);
xlabel('Time (ms)');
ylabel('Angular Rate (rad/s)');
legend('Rotation about Axial','Lateral','Neck','Location','SouthEast')

%{
%v = VideoWriter('ARS.avi','Uncompressed AVI');
%open(v);
R = rectangle('Position',[ARS_time(1) -24 200-ARS_time(1) 40], 'FaceColor', [1 1 1], 'EdgeColor',[1 1 1]);
for k = 1:100:length(ARS_time)
    delete(R);
    R = rectangle('Position',[ARS_time(k) -24 200-ARS_time(k) 40], 'FaceColor', [1 1 1],'EdgeColor',[1 1 1]);
   % frame = getframe(gcf);
   % writeVideo(v,frame);
   pause(0.001);
end
%close(v);

hold off
saveas(f1,'Rotational_impact8.fig');
%}

%f2=figure(2)
subplot(2,1,2);
%set(gcf, 'Position', [100 100 1024 768]);
hold on
axis([-50 200 -30 30]);
plot(ACC_time,ACC1-ACC1_offset, 'b');
plot(ACC_time,ACC2-ACC2_offset, 'r');
plot(ACC_time,ACC3-ACC3_offset, 'g');

xlabel('Time (ms)');
ylabel('Linear Acceleration (g)');
legend('Axial','Lateral','Neck','Location','SouthEast')
%{
R = rectangle('Position',[ACC_time(1) -24 200-ACC_time(1) 40], 'FaceColor', [1 1 1], 'EdgeColor',[1 1 1]);


%v = VideoWriter('ACC.avi','Uncompressed AVI');
%open(v);
for k = 1:100:length(ACC_time)
    delete(R);
    R = rectangle('Position',[ACC_time(k) -29 200-ACC_time(k) 59], 'FaceColor', [1 1 1],'EdgeColor',[1 1 1]);
    %frame = getframe(gcf);
    %writeVideo(v,frame);
    pause(0.001);
end
%close(v);
% axis([0 60 -50 50])
hold off
%saveas(f2,'Linear_impact8.fig');
%}

f2 = figure(2);
plot(ARS_time,P_Coup);
hold on;
plot(ARS_time,P_ContCoup);
xlabel('Time (ms)');
ylabel('Pressure (kPa)');
legend('Coup Pressure','Contrecoup Pressure','Location','SouthEast')