function [RR,X,Y]=test_R(x,y,gap)

%Description��
% �ó�����Ϊ������ȷ����gapֵ������ÿgap����ֵ��ƽ��ֵ����¼���
% ����ԭ�����̣�
%     Step1:����ȷ����gapֵ������ÿgap����ֵ��ƽ��ֵ����¼
%     Step2:��������ƽ��ֵ���ݵ�����Ŷ�R

%Inputs��
%     x���Ա���     
%     y�������
%     gap������gap��ȡֵ��ÿgap������ȡһ��ƽ��ֵ

%Outputs��
%	 X��ȡƽ��ֵ����Ա���
%    Y��ȡƽ��ֵ��������
%    RR��X��Y������Ŷ�

%Calls��
%	�����������õĺ����嵥
%     polyfit�������ϲ���
%     polyval�������ϵ�ֱ��
%     corrcoef�����������������

%Called By��
%	���ñ��������嵥
%     select_R_linear_fitting����ԭʼ�ź����ݼ���ó���Ч��PWTT��BP��ֵ��λ����Ϣ��������ϡ�

%V1.0��2018/5/7




l=floor(length(x)/gap); %��������Ӧ��ȡ����������ƽ��ֵ����
for i=1:1:l
    xi=x(((i-1)*gap+1):(i*gap));  %����i��������Ϣ�洢��xi,yi��
    yi=y(((i-1)*gap+1):(i*gap));
    X(i)=mean(xi);
    Y(i)=mean(yi);
%     X(i)=median(xi);
%     Y(i)=median(yi);
end
% X=x;
% Y=y;
 
if length(X)>30    %���ȡƽ��ֵ���������������30�����������Ĳ���
%     X(1)=[];X(1)=[];Y(1)=[];Y(1)=[];        
    %[b,bint,r,rint,stats]= regress(y,x);
    [p1,S1]=polyfit(X,Y,1);%�����ϲ���
    y1=polyval(p1,X);%�����ϵ�ֱ��
    R1=corrcoef(X,Y);%���X��Y�������
    R2=corrcoef(y1,Y);%���y1��Y�������
    RR=R1(1,2);
else
    RR=1;      %������������30�����ݵ�����Ŷ���Ϣ����Ϊ1���Ա��ڲ���
end
