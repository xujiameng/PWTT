%%% 失血数据整合    

%失血1包含 data_label 1，即最优数据
%失血2包含 data_label 1,3， 即没有血压异常数据
%失血3包含 data_label 1,2,3,4,5 ， 即没有异常严重数据
%失血4包含 data_label 1,2,3,4,5,6 ， 即全部数据
%对失血3的改进  data_label 1,2,4,5 且去除了data(680000:780000,:)=[]; 的血压异常数据
%对失血3的再改进  data_label 2,4,5 且去除了data(300000:400000,:)=[]; 的血压异常数据
%对失血4的改进  data_label 1,2,3,4,5,6 ， 且去除了data(680000:780000,:)=[]; 的血压异常数据
%
% 
% 



clear all
clc
%% data_label1  正常
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件2';
data=data((26*60)*1000:(32*60+40)*1000,:);

delect=[ 394000,400001; 365000,377500 ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label1=data;

%% data_label2  血压异常
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件2';
data=data((34*60+25)*1000:(40*60+26)*1000,:);
delect=[ 305000,320000;248000,287500;];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label2=data;


% data_label3  脉搏波异常
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件2';
data=data((44*60+21)*1000:(46*60+57)*1000,:);
delect=[];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label3=data;

%% data_label4  脉搏波血压异常
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件3';
data=data((18*60+22)*1000:(21*60+9)*1000,:);

delect=[114000,136000; 72000,90000;  16000,52000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label4=data;

%% data_label5   脉搏波血压异常
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件3';
data=data((68*60+38)*1000:(92*60+38)*1000,:);

delect=[1340000,1410000; 1175000,1180000; 930000,990000; 550000,775000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label5=data;

%% data_label6  脉搏波血压异常严重
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件3';
data=data((116*60+18)*1000:(132*60+41)*1000,:);

delect=[580000,983001; 500000,545700;  380000,440000; 285000,305000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
% data_label6=data;

%% 整合
clear data
data=[data_label2;data_label4;data_label5];
