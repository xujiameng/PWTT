function [RR,X,Y]=test_R(x,y,gap)

%Description：
% 该程序功能为：根据确定的gap值，计算每gap个数值的平均值并记录输出
% 程序原理及流程：
%     Step1:根据确定的gap值，计算每gap个数值的平均值并记录
%     Step2:计算两组平均值数据的拟合优度R

%Inputs：
%     x：自变量     
%     y：因变量
%     gap：根据gap的取值，每gap个数据取一个平均值

%Outputs：
%	 X：取平均值后的自变量
%    Y：取平均值后的因变量
%    RR：X与Y的拟合优度

%Calls：
%	被本函数调用的函数清单
%     polyfit：求得拟合参数
%     polyval：求得拟合的直线
%     corrcoef：求两向量的相关性

%Called By：
%	调用本函数的清单
%     select_R_linear_fitting：从原始信号数据计算得出有效的PWTT与BP峰值点位置信息并进行拟合。

%V1.0：2018/5/7




l=floor(length(x)/gap); %计算出最后应获取多少数量的平均值数据
for i=1:1:l
    xi=x(((i-1)*gap+1):(i*gap));  %将第i段数据信息存储到xi,yi中
    yi=y(((i-1)*gap+1):(i*gap));
    X(i)=mean(xi);
    Y(i)=mean(yi);
%     X(i)=median(xi);
%     Y(i)=median(yi);
end
% X=x;
% Y=y;
 
if length(X)>30    %如果取平均值后的数据数量大于30，则进行下面的操作
%     X(1)=[];X(1)=[];Y(1)=[];Y(1)=[];        
    %[b,bint,r,rint,stats]= regress(y,x);
    [p1,S1]=polyfit(X,Y,1);%求得拟合参数
    y1=polyval(p1,X);%求得拟合的直线
    R1=corrcoef(X,Y);%求得X和Y的相关性
    R2=corrcoef(y1,Y);%求得y1和Y的相关性
    RR=R1(1,2);
else
    RR=1;      %将数据量不足30的数据的拟合优度信息定义为1，以便于查找
end
