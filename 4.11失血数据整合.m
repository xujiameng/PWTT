%%% 4.11ʧѪ��������
%%%%%%%%%  label1,2 ��������           4.11_ʧѪ1
%%%%%%%%%  label1,2,3 BP��������       4.11_ʧѪ2
%%%%%%%%%  label1,2,3,5,6ȫ����������  4.11_ʧѪ3



clear all
clc
%% data_label1  
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_1.mat';
data=data(( 102*60+30)*1000:(112*60+30)*1000,:); 
delect=[442000,454000; 390000,398000; 344000,345000; 158000,164000];
    
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label1=data;

%% data_label2 
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_1.mat';
data=data(( 123*60+56)*1000:(133*60+56)*1000,:); 
delect=[185000,190000; 155000,160000; 50000,65000 ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label2=data;

%% data_label3  PPG������Щ���쳣������ֵλ����ȷ
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_1.mat';
data=data(( 173*60+20)*1000:(183*60+20)*1000,:); 
delect=[ 292000,298000; 238000,258000; 202000,222000;  85000,195000;  50000,60000 ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end
data_label3=data;


% %% data_label4  �ڶ��׶ε�һ��ʧѪ PPG̫�� �������ݲ�������
% load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_2.mat';
% data=data(( 3*60+0)*1000:(13*60+0)*1000,:); 
% delect=[ 1:length(data) ];
% 
% for i=1:length(delect)
%     data(delect(i,1):delect(i,2),:)=[];
% end
% data_label4=data;

%% data_label5   BP�Ƚ��쳣
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_2.mat';
data=data(( 17*60+54)*1000:(27*60+54)*1000,:); 
delect=[ 388000,420000; 356000,358000; 90000,145000; 1,35000  ];

for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end

data_label5=data;


%% data_label6  �ڶ��׶ε��� �Ĵ�ʧѪ PPG��BP����̫����
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_2.mat';
data=data(( 31*60+20)*1000:end,:); 
delect=[  585000,665000];

for i=1:1
    data(delect(i,1):delect(i,2),:)=[];
end
data_label6=data;


%% ����
clear data
data=[data_label1; data_label2; data_label3; data_label5; data_label6];