function [RR,X,Y,thebest]=test_changeR(x,y,gap)



RRR=[];
l=floor(length(x)/gap);
for i=1:1:l%��pwtt��bpÿl����ȡƽ��ֵ���ֱ�ֵ��X��Y
    xi=x(((i-1)*gap+1):(i*gap));
    yi=y(((i-1)*gap+1):(i*gap));
    X(i)=mean(xi);
    Y(i)=mean(yi);
%     X(i)=median(xi);
%     Y(i)=median(yi);
end
% X=x;
% Y=y;


if length(X)<=31
    TTT=1;
else
    TTT=length(X)-31;;
end


for change_gap=1:TTT
    
    
for i=1:length(X)-change_gap
    XX(i)=(X(i+change_gap)-X(i))/X(i);
    YY(i)=(Y(i+change_gap)-Y(i))/Y(i);
end


X_temp=XX;
Y_temp=YY;

if length(X_temp)>30
    X_temp(1)=[];X_temp(1)=[];Y_temp(1)=[];Y_temp(1)=[];        
    %[b,bint,r,rint,stats]= regress(y,x);
    [p1,S1]=polyfit(X_temp,Y_temp,1);%�����ϲ���
    y1_temp=polyval(p1,X_temp);%�����ϵ�ֱ��
    R1=corrcoef(X_temp,Y_temp);%���X��Y�������
    R2=corrcoef(y1_temp,Y_temp);%���y1��Y�������
    RR=R1(1,2);
else
    RR=1;
end

RRR(change_gap)=RR;
end

thebest=find(RRR==min(RRR));

%% 

    
    
for i=1:length(X)-thebest
    XX(i)=(X(i+thebest)-X(i))/X(i);
    YY(i)=(Y(i+thebest)-Y(i))/Y(i);
end

clear X;
clear Y;
X=XX;
Y=YY;

if length(X)>30
    X(1)=[];X(1)=[];Y(1)=[];Y(1)=[];        
    %[b,bint,r,rint,stats]= regress(y,x);
    [p1,S1]=polyfit(X,Y,1);%�����ϲ���
    y1=polyval(p1,X);%�����ϵ�ֱ��
    R1=corrcoef(X,Y);%���X��Y�������
    R2=corrcoef(y1,Y);%���y1��Y�������
    RR=R1(1,2);
else
    RR=1;
end

