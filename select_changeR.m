close all;
clc;
clear;


load 'D:/test/ʵ�����������/dataתmat���ݴ���/4.11_data_1.mat';
data=data(  (124*60+3)*1000:(127*60+3)*1000 ,: );


%% 
[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data,0);
x=pwt2;
y=bp;
x(x==0|y==0)=0;%��pwtt��bp��pwtt�����и��ŵ�λ����0
y(x==0|y==0)=0;%��bp��bp��pwtt�����и��ŵ�λ����0
x(x==0)=[];%��pwtt�и��ŵ�ɾ��
y(y==0)=[];%��bp�и��ŵ�ɾ��


%% 

i=0;
for gap=1:1:300
    i=i+1;
    RR(i,1)=gap;
    [RR(i,2),XX,YY,thebest]=test_changeR(x,y,gap);
    TheBest(i)=thebest;
    if RR(i,2)==min(RR(:,2))
        XX_FIT=XX;
        YY_FIT=YY;
    end
end
min(RR(:,2))
RR(find(RR(:,2)==min(RR(:,2))) ,1 )

clear X;
clear Y;
X=XX_FIT;
Y=YY_FIT;

figure(1)
plot(X,Y,'ro');hold on;         
%[b,bint,r,rint,stats]= regress(y,x);
[p1,S1]=polyfit(X,Y,1);%�����ϲ���
y1=polyval(p1,X);%�����ϵ�ֱ��

R1=corrcoef(X,Y);%���X��Y�������
R2=corrcoef(y1,Y);%���y1��Y�������
plot(X,y1);
R1(1,2)
TheBest(find(RR(:,2)==min(RR(:,2))))