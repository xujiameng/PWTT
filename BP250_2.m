function [BF]=BP250_2(BP,fs)

%Description��
% �ó�����Ϊ����BP�źŽ����˲�
% ����ԭ�����̣�
%     Step1: ʹ������λ�˲�����BP���ݽ����˲�

%Inputs��
%     BP��ԭʼBP�ź�
%     fs������Ƶ��

%Outputs��
%	  BF���˲����BP�ź�����

%Calls��
%	�����������õĺ����嵥
%     detrend��������ȥ��������;
%     fir1���ô����������������λFIRDF�Ĺ����亯��
%     filtfilt��ʹ������λ�˲���filtfilt�����˲����������ӳ�

%Called By��
%	���ñ��������嵥
%     usdbyplot����ԭʼ�ź����ݻ�ȡ��ǳ��쳣��λ�õ�PWTT��BP,���˲�������ECG�źţ�PPG�źţ�BP�ź�

%V1.0��2018/5/7


%% ��BP���ݽ����˲�
p=BP;
l=length(p);  % ��ȡBP�źų���

lo=(p-mean(p))/std(p);%���ݹ�һ�� 
u_bp=detrend(lo);%����ȥ��������;
%uu=p;
fc1=0.1;%ͨ�����޽�ֹƵ��5hz
fc2=3;%ͨ�����޽�ֹƵ��26hz
b=fir1(100,[2*fc1/fs,2*fc2/fs]);%����FIR�˲�����������Ϊ100
% BF=filter(b,1,u_bp);%ʹ�ø��˲��������˲�
BF=filtfilt(b,1,u_bp);%ʹ�ø��˲��������˲�

%% Ѱ��ԭʼBP�����϶�Ӧ�ķ�ֵ���λ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i=1:1:length(indmax)
%     if indmax(i)-60>0
%         Max_BP=p(indmax(i)-60:indmax(i));
%         s_max=indmax(i)-60;
%     else
%         Max_BP=p(1:indmax(i));
%         s_max=1;
%     end
%     p_ppg=max(Max_BP);
%     for j=s_max:1:indmax(i)
%         if Max_BP(j-s_max+1)==p_ppg
%             max_BP(i)=j;
%         end
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end