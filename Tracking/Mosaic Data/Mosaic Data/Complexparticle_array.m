%%%%%%%%%%%%
%%%%%%%%%%%% Mosaic Data Analysis
%%%%%%%%%%%%
%%%% Trajectory	Frame	x	y	z	m0	m1	m2	m3	m4	NPscore

clear all
close all

Traj = csvread('ComplexAllTrajectories.csv');
Traj(:,2) = Traj(:,2) + 1; %%%% Can't have frame "0"
num = max(Traj(:,1));

full_frame = max(Traj(:,2));

%%% Create Structured Array

for i = 1:num
    complexparticle(i).name = i;    
end

for i = 1:length(Traj)
    complexparticle(Traj(i,1)).frame(Traj(i,2)) = Traj(i,2);
    complexparticle(Traj(i,1)).x(Traj(i,2)) = Traj(i,3);
    complexparticle(Traj(i,1)).y(Traj(i,2)) = Traj(i,4);
    complexparticle(Traj(i,1)).z(Traj(i,2)) = Traj(i,5);
    complexparticle(Traj(i,1)).m0(Traj(i,2)) = Traj(i,6);
    complexparticle(Traj(i,1)).m1(Traj(i,2)) = Traj(i,7);
    complexparticle(Traj(i,1)).m2(Traj(i,2)) = Traj(i,8);
    complexparticle(Traj(i,1)).m3(Traj(i,2)) = Traj(i,9);
    complexparticle(Traj(i,1)).m4(Traj(i,2)) = Traj(i,10);
    complexparticle(Traj(i,1)).NP(Traj(i,2)) = Traj(i,11);   
end

%%%% Remove particles not tracked all the way
for i = num:-1:1
    if max(complexparticle(i).frame) < full_frame
        complexparticle(i)=[];
        num = num-1;
    end
end

% % %%%%% Specific Point in Complex
% % Center.x = 149;
% % Center.y = 140;


%%%%% Specific Point in Smooth
% % % Center.x = 150;
% % % Center.y = 142;
