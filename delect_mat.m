clear all
clc


load 'D:/test/4.3��/dataתmat����/data2���ļ�3';
data=data((18*60+22)*1000:(21*60+09)*1000,:);


ecg=(data(:,2))/1000;%%��ȡecg����
ppg=(data(:,3))/4;%%��ȡppg����
BP=data(:,4);%%��ȡbp����

subplot(3,1,1)
plot(ecg')
subplot(3,1,2)
plot(ppg')
subplot(3,1,3)
plot(BP')




