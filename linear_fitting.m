close all;
clc;
clear;

load 'D:/test/4.3��/dataתmat����/��ҩ';



[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data);
x=pwt2;
y=bp;
x(x==0|y==0)=0;%��pwtt��bp��pwtt�����и��ŵ�λ����0
y(x==0|y==0)=0;%��bp��bp��pwtt�����и��ŵ�λ����0
x(x==0)=[];%��pwtt�и��ŵ�ɾ��
y(y==0)=[];%��bp�и��ŵ�ɾ��


gap=40;
l=floor(length(x)/gap);
for i=1:1:l%��pwtt��bpÿ60����ȡƽ��ֵ���ֱ�ֵ��X��Y
    xi=x(((i-1)*gap+1):(i*gap));
    yi=y(((i-1)*gap+1):(i*gap));
    X(i)=mean(xi);
    Y(i)=mean(yi);
%     X(i)=median(xi);
%     Y(i)=median(yi);
end
% X=x;
% Y=y;

figure(1)
X(1)=[];X(1)=[];Y(1)=[];Y(1)=[];
plot(X,Y,'ro');hold on;         
%[b,bint,r,rint,stats]= regress(y,x);
[p1,S1]=polyfit(X,Y,1);%�����ϲ���
y1=polyval(p1,X);%�����ϵ�ֱ��

R1=corrcoef(X,Y);%���X��Y�������
R2=corrcoef(y1,Y);%���y1��Y�������
plot(X,y1);


R1(1,2)