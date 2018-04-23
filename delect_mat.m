clear all
clc


load 'D:/test/4.3用/data转mat数据/data2子文件3';
data=data((18*60+22)*1000:(21*60+09)*1000,:);


ecg=(data(:,2))/1000;%%获取ecg数据
ppg=(data(:,3))/4;%%获取ppg数据
BP=data(:,4);%%获取bp数据

subplot(3,1,1)
plot(ecg')
subplot(3,1,2)
plot(ppg')
subplot(3,1,3)
plot(BP')




