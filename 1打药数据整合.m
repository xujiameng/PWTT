%%% 打药数据整合



clear all
clc
%% data_label1
load 'D:/test/实验数据与程序/data转mat数据处理/data1';
data=data((23*60)*1000:(45*60+35)*1000,:);

delect=[ 1076000,1080000;  838000,842000;   150000,165000;   134000,137000;   30000,50000 ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label1=data;

%% data_label2
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data1';
data=data((62*60)*1000:(73*60)*1000,:);
delect=[   648000,654000;  609000,611000;  558000,562000;    500000,506000; 444000,446000;  380000,388000;   243000,247000; 165000,167000;  155000,156500;81000,84000; 10000,13000  ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label2=data;


%% data_label3
clear data;
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件1';
data=data((45*60)*1000:(67*60)*1000,:);
data1=data(75000:250000,:);
data2=data(275000:302500,:);
data=[data1;data2];
data(:,2)=(data(:,2))/1000;
data_label3=data;

%% 整合
clear data
data=[data_label1;data_label2;data_label3];
