legendstr = '';
for i = 3:length(a);
    vbl = a(i).name(10:end-4);
    curve = eval(['mean((filt_steps',vbl,'(:,2:2:end)-filt_steps',vbl,'(1,2:2:end))'')']);
    offset = eval(['31-Peak',vbl]);
    plot(offset:length(curve)+offset-1,curve);
    hold on;
    legendstr = sprintf('%s''%s'',',legendstr,vbl);
    text(length(curve)+offset-1,curve(end),vbl(1:8))
    text(30,curve(30-offset),vbl(1:8));
end
