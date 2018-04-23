function [RR,X,Y]=test_R(x,y,gap)

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

if length(X)>30
    X(1)=[];X(1)=[];Y(1)=[];Y(1)=[];        
    %[b,bint,r,rint,stats]= regress(y,x);
    [p1,S1]=polyfit(X,Y,1);%求得拟合参数
    y1=polyval(p1,X);%求得拟合的直线
    R1=corrcoef(X,Y);%求得X和Y的相关性
    R2=corrcoef(y1,Y);%求得y1和Y的相关性
    RR=R1(1,2);
else
    RR=1;

end
