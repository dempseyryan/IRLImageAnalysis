[datafile,datapath] = uigetfile;
load([datapath datafile]);
load(sprintf('%stransform.mat',datapath(1:end-2)));
eval(['filt_steps',datapath(10:end-3),'=filt_steps;'])
eval(['StepsPerPt',datapath(10:end-3),'=StepsPerPt;'])
eval(['Hcumulatives',datapath(10:end-3),'=Hcumulatives;'])
eval(['HsRts',datapath(10:end-3),'=HsRts;'])

curve = mean((filt_steps(:,2:2:end)-filt_steps(1,2:2:end))');
[Y,I] = max(curve);
eval(['Peak',datapath(10:end-3),'=I;'])

newfile = sprintf('E:/Drops/DispData_%s.mat',datapath(10:end-3));
clear filt_steps StepsPerPt Hcumulatives HsRts steps_bk datapath datafile Y I curve
save(newfile);
clear
