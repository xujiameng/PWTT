close all;
clc;
clear;
di=dir('D:\test\20180411\mat\*.mat');
data=[];
for k= 1:length(di)
    a=[];
    a=importdata(['D:/test/20180411/mat/',di(k).name]);
%     m=di(k).name;
%     m=strrep(m,'.txt','');
%     save(['ʵ������/ʵ������3/mat/data4/',m],'data') ;
    data=[data;a];   
end
save(['D:/test/20180411/mat/4.11_data_1.mat'],'data') ;