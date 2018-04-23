%%% 4.11打药数据整合

clear all
clc
%% data_label1  升压部分
load 'D:/test/实验数据与程序/data转mat数据处理/4.11_data_1.mat';
data=data(( 44*60+14)*1000:(68*60+15)*1000,:); 
delect=[ 1275000,length(data);1212000,1220000;1076000,1078000;1060000,1068000;998000,1008000;938000,942000;892000,900000;868000,888000;820000,830000; 754000,758000;720000,726000;698000,699000;606000,607000;558000,559000;484000,486000];
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label1=data;

%% data_label1  降压部分
load 'D:/test/实验数据与程序/data转mat数据处理/4.11_data_1.mat';
data=data(( 69*60+37)*1000:(88*60+3)*1000,:); 
delect=[ 1098000,length(data);  1016000,1018000;  1000000,1002000;  958000,964000;  918000,930000;  884000,900000;  762000,776000; 624000,630000 ];
    
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label2=data;


%% 整合
clear data
data=[data_label1; data_label2];
