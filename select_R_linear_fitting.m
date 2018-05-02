close all; %�ر�����������򿪵Ĵ���
clc;       %��� �����д��� ��Ϣ
clear;     %�������������ľ�����Ϣ
choose=1;  %��gapѡȡ��أ�choose=1ʱ��gapΪ�趨�õĺ��������ֵ��choose=0ʱ��gap��ѡȡΪʹRֵ���ŵ�best_gap
fs=1000;   %����Ƶ������Ϊ 1000����1s����1000����

%% ������Դ
load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_1.mat';
data=data(( 102*60+30)*1000:(112*60+30)*1000,:); 
delect=[442000,454000; 390000,398000; 344000,345000; 158000,164000];
    
for i=1:length(delect)
    data(delect(i,1):delect(i,2),:)=[];
end


%% ����ԭʼ�źż�����������Ҫ����Ч����Ϣ
% [pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data,1);  
[pwt2,~,bp,~,~,~,~]=usedbyplot(data,1);  %����ԭʼ�źż����PWTT��BP
x=pwt2;
y=bp;   
x(x==0|y==0)=0;%��pwtt��bp��pwtt�����и��ŵ�λ����0
y(x==0|y==0)=0;%��bp��bp��pwtt�����и��ŵ�λ����0
x(x==0)=[];%��pwtt�и��ŵ�ɾ��
y(y==0)=[];%��bp�и��ŵ�ɾ��


%% ȷ��gap��ȡֵ���������Ӧ���Ա������������������
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% choose=0ʱ��gap��ѡȡΪʹ����Ŷ���ѵ�best_gap������ȡ��Ӧ���Ա������������������
if choose==0
i=0;
for gap=1:1:300
    i=i+1;
    RR(i,1)=gap;
    [RR(i,2),XX,YY]=test_R(x,y,gap); %�����Ӧ��gapȡֵ�£���Ӧ���Ա�����������������ݼ�����Ŷ�
    if RR(i,2)==min(RR(:,2))   %�������Ŷ���ѵ�����
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
% choose=1ʱ��gapΪ�趨�õĺ��������ֵ������ȡ��Ӧ���Ա������������������
if choose==1
x_gap=length(x);
gap=ceil(0.03031*x_gap+0.54) %���ݾ����˲����޳��쳣������Ч����� ��ȡgap��ȡֵ
% gap=1;
[R,X,Y]=test_R(x,y,gap); % ��ȥ��Ӧgapȡֵ�¶�Ӧ���Ա�����������������ݣ�������Ŷ�
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

figure(1)
plot(X,Y,'ro');hold on;         
%[b,bint,r,rint,stats]= regress(y,x);
[p1,S1]=polyfit(X,Y,1);%�����ϲ���
y1=polyval(p1,X);%�����ϵ�ֱ��
    
R1=corrcoef(X,Y);%���X��Y�������
R2=corrcoef(y1,Y);%���y1��Y�������
plot(X,y1);
xlabel('PWTT','fontsize',10)
ylabel('BP','fontsize',10)
% hold on 
% plot(X(1:2),Y(1:2),'k+','LineWidth',2)
R1(1,2)
length(x)  %ԭʼ���ݾ����˲����쳣���޳������Ч�����