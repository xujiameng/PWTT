function [RR,X,Y]=test_R(x,y,gap)

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
