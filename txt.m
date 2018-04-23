close all;
clc;
clear;
di=dir('D:\test\20180411\txt\*.txt');
for k= 1:length(di)
    a=importdata(['D:/test/20180411/txt/',di(k).name]);
    data=a.data;
    m=di(k).name;
    m=strrep(m,'.txt','');
    save(['D:/test/20180411/mat/',m],'data') ;
end

