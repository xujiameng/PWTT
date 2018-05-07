
%Description：
% 该程序功能为：从原始信号数据获取有效的PWTT与BP峰值点位置信息并进行拟合。
% 程序原理及流程：
%     Step1: 对原始数据进行滤波处理并获取ECG信号，PPG信号,BP信号关键点位置；
%     Step2: 计算PWTT,并对PWTT数据与BP峰值点位置数据经过改进的7-step滤波法，BP异常点检测方法对数据中的异常点进行剔除;
%     Step3: 从原始信号数据获取有效点后根据需要 计算数据的最优的拟合结果
%            或根据设定的gap选取函数计算对所运行数据的预测gap值，进而进行拟合。
% 程序运行结果：
%     程序目标结果：以PWTT作为因变量,BP作为自变量，对这两组数据进行拟合
%     结果说明：输出图片为取平均值后的有效点分布，及PWTT与BP的拟合直线
%               R为拟合直线的拟合优度，len为经过异常点剔除后的有效点个数

%Function List：
% 所调用的函数列表
%     usedbyplot：对原始数据进行处理，得到标记处异常点的PWTT数据及BP峰值点数据
%     test_R：计算得出每gap个数据取一个平均值后的数据，及这两组数据的拟合优度R

% DataFile:
%  对于该程序，需要输入的数据有
%   data数据：为4*N的原始数据，其中第一列为时间数据，第二列为原始ECG信号数据，第三列为原始PPG信号数据，第四列为原始BP信号数据。
%   fs: 数据采样频率。

%Outputs：
%	输出图片为取平均值后的有效点分布，及PWTT与BP的拟合直线；
%   R为拟合直线的拟合优度；
%   len为经过异常点剔除后的有效点个数。

%V1.0：2018/5/7




close all; 
clc;       
clear;     
choose=1;  %与gap选取相关，choose=1时，gap为设定好的函数根据有效点个数计算得出的输出值；choose=0时，gap的选取为使R值最优的best_gap
fs=1000;   %采样频率设置为 1000，即1s采样1000个点

%% 数据来源
load 'D:/test/实验数据与程序/data转mat数据处理/打药.mat';



%% 根据原始信号计算出拟合所需要的有效点信息
[pwtt,~,bp,~,~]=usedbyplot(data);  %根据原始信号计算出PWTT与BP
x=pwtt;
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
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% choose=1时，gap为设定好的函数的输出值，并获取对应的自变量数据与因变量数据
if choose==1
x_gap=length(x);
gap=ceil(0.03031*x_gap+0.54) %根据经过滤波及剔除异常点后的有效点个数 获取gap的取值
% gap=1;
[~,X,Y]=test_R(x,y,gap); % 过去相应gap取值下对应的自变量数据与因变量数据，及拟合优度
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% 绘制拟合图像
figure(1)
plot(X,Y,'ro');hold on;         
%[b,bint,r,rint,stats]= regress(y,x);
[p1,S1]=polyfit(X,Y,1);%求得拟合参数
y1=polyval(p1,X);%求得拟合的直线
    
R1=corrcoef(X,Y); %求得X和Y的相关性
R1(1,2)
R2=corrcoef(y1,Y);%求得y1和Y的相关性
plot(X,y1);
xlabel('PWTT','fontsize',10)
ylabel('BP','fontsize',10)

len=length(x)  %原始数据经过滤波，异常点剔除后的有效点个数