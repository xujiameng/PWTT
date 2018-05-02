close all; %关闭所有因命令打开的窗口
clc;       %清除 命令行窗口 信息
clear;     %清除工作区保存的矩阵信息
choose=1;  %与gap选取相关，choose=1时，gap为设定好的函数的输出值；choose=0时，gap的选取为使R值最优的best_gap
fs=1000;   %采样频率设置为 1000，即1s采样1000个点

%% 数据来源
load 'D:/test/实验数据与程序/data转mat数据处理/4.11_data_1.mat';
data=data(( 102*60+30)*1000:(112*60+30)*1000,:); 
delect=[442000,454000; 390000,398000; 344000,345000; 158000,164000];
    
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end


%% 根据原始信号计算出拟合所需要的有效点信息
% [pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data,1);  
[pwt2,~,bp,~,~,~,~]=usedbyplot(data,1);  %根据原始信号计算出PWTT与BP
x=pwt2;
y=bp;   
x(x==0|y==0)=0;%将pwtt中bp和pwtt的所有干扰点位置置0
y(x==0|y==0)=0;%将bp中bp和pwtt的所有干扰点位置置0
x(x==0)=[];%将pwtt中干扰点删除
y(y==0)=[];%将bp中干扰点删除


%% 确定gap的取值并计算出对应的自变量数据与因变量数据
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% choose=0时，gap的选取为使拟合优度最佳的best_gap，并获取对应的自变量数据与因变量数据
if choose==0
i=0;
for gap=1:1:300
    i=i+1;
    RR(i,1)=gap;
    [RR(i,2),XX,YY]=test_R(x,y,gap); %获得相应的gap取值下，对应的自变量数据与因变量数据及拟合优度
    if RR(i,2)==min(RR(:,2))   %获得拟合优度最佳的数据
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
% choose=1时，gap为设定好的函数的输出值，并获取对应的自变量数据与因变量数据
if choose==1
x_gap=length(x);
gap=ceil(0.03031*x_gap+0.54) %根据经过滤波及剔除异常点后的有效点个数 获取gap的取值
% gap=1;
[R,X,Y]=test_R(x,y,gap); % 过去相应gap取值下对应的自变量数据与因变量数据，及拟合优度
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
length(x)  %原始数据经过滤波，异常点剔除后的有效点个数