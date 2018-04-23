close all;
clc;
clear;

load 'D:/test/4.3用/data转mat数据/打药';



[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data);
x=pwt2;
y=bp;
x(x==0|y==0)=0;%将pwtt中bp和pwtt的所有干扰点位置置0
y(x==0|y==0)=0;%将bp中bp和pwtt的所有干扰点位置置0
x(x==0)=[];%将pwtt中干扰点删除
y(y==0)=[];%将bp中干扰点删除


gap=40;
l=floor(length(x)/gap);
for i=1:1:l%对pwtt和bp每60个点取平均值，分别赋值给X和Y
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
[p1,S1]=polyfit(X,Y,1);%求得拟合参数
y1=polyval(p1,X);%求得拟合的直线

R1=corrcoef(X,Y);%求得X和Y的相关性
R2=corrcoef(y1,Y);%求得y1和Y的相关性
plot(X,y1);


R1(1,2)