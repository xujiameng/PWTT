%%% ʧѪ��������    

%ʧѪ1���� data_label 1������������
%ʧѪ2���� data_label 1,3�� ��û��Ѫѹ�쳣����
%ʧѪ3���� data_label 1,2,3,4,5 �� ��û���쳣��������
%ʧѪ4���� data_label 1,2,3,4,5,6 �� ��ȫ������
%��ʧѪ3�ĸĽ�  data_label 1,2,4,5 ��ȥ����data(680000:780000,:)=[]; ��Ѫѹ�쳣����
%��ʧѪ3���ٸĽ�  data_label 2,4,5 ��ȥ����data(300000:400000,:)=[]; ��Ѫѹ�쳣����
%��ʧѪ4�ĸĽ�  data_label 1,2,3,4,5,6 �� ��ȥ����data(680000:780000,:)=[]; ��Ѫѹ�쳣����
%
% 
% 



clear all
clc
%% data_label1  ����
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�2';
data=data((26*60)*1000:(32*60+40)*1000,:);

delect=[ 394000,400001; 365000,377500 ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label1=data;

%% data_label2  Ѫѹ�쳣
clear data;
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�2';
data=data((34*60+25)*1000:(40*60+26)*1000,:);
delect=[ 305000,320000;248000,287500;];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label2=data;


% data_label3  �������쳣
clear data;
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�2';
data=data((44*60+21)*1000:(46*60+57)*1000,:);
delect=[];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label3=data;

%% data_label4  ������Ѫѹ�쳣
clear data;
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�3';
data=data((18*60+22)*1000:(21*60+9)*1000,:);

delect=[114000,136000; 72000,90000;  16000,52000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label4=data;

%% data_label5   ������Ѫѹ�쳣
clear data;
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�3';
data=data((68*60+38)*1000:(92*60+38)*1000,:);

delect=[1340000,1410000; 1175000,1180000; 930000,990000; 550000,775000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label5=data;

%% data_label6  ������Ѫѹ�쳣����
clear data;
load 'D:/test/ʵ�����������/dataתmat���ݴ���/data2���ļ�3';
data=data((116*60+18)*1000:(132*60+41)*1000,:);

delect=[580000,983001; 500000,545700;  380000,440000; 285000,305000];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
% data_label6=data;

%% ����
clear data
data=[data_label2;data_label4;data_label5];
