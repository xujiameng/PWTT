function [RR,X,Y]=test_R(x,y,gap)

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
