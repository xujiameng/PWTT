close all;
clc;
clear;
choose=1;  % gap相关

%% data
load 'D:/test/实验数据与程序/data转mat数据处理/data2子文件3';
data=data((116*60+18)*1000:(132*60+41)*1000,:);
delect=[580000,983001; 500000,545700;  380000,440000; 285000,305000];
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end

%% 
[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data,1);
x=pwt2;
y=bp;
x(x==0|y==0)=0;%将pwtt中bp和pwtt的所有干扰点位置置0
y(x==0|y==0)=0;%将bp中bp和pwtt的所有干扰点位置置0
x(x==0)=[];%将pwtt中干扰点删除
y(y==0)=[];%将bp中干扰点删除


%% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if choose==0
i=0;
for gap=1:1:300
    i=i+1;
    RR(i,1)=gap;
    [RR(i,2),XX,YY]=test_R(x,y,gap);
    if RR(i,2)==min(RR(:,2))
        XX_FIT=XX;
        YY_FIT=YY;
        linshi=i;
    end
end
linshi
clear X;
clear Y;
X=XX_FIT;
Y=YY_FIT;
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % 
if choose==1
x_gap=length(x);
gap=ceil(0.03031*x_gap+0.54)
% gap=1;
[R,X,Y]=test_R(x,y,gap);
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure(1)
plot(X,Y,'ro');hold on;         
%[b,bint,r,rint,stats]= regress(y,x);
[p1,S1]=polyfit(X,Y,1);%求得拟合参数
y1=polyval(p1,X);%求得拟合的直线

R1=corrcoef(X,Y);%求得X和Y的相关性
R2=corrcoef(y1,Y);%求得y1和Y的相关性
plot(X,y1);
xlabel('PWTT','fontsize',10)
ylabel('BP','fontsize',10)
% hold on 
% plot(X(1:2),Y(1:2),'k+','LineWidth',2)
R1(1,2)
length(x)