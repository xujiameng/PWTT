close all;
clc;
clear;
%% ��������Ҫ������3���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%1.��ԭʼECG��PPG�źŶ��룬��������Ƶ�ʸ�ֵ��֮���ȡECG��PPG�����ݳ��ȣ�ʹ�����ǵĳ���һ��
%%2.����ĺ��Ĳ��֣�������pwtt4������˶��ĵ�R����ֵ��ļ�⣨����ECG����PPG��ֵ��͹�ֵ��ļ�⣨����PPG����
%�Լ�PWTT��ز�������ȡ������ECG_PPG����
%%3.����ECG��PPG��ͬһ����ϵ�е�ͼ�Σ������R����ֵ��PPG��ֵ���PPG��ֵ��
%�������е��Գ�������ķ�ʽ�����������ڹ۲죬���ջ���ȡ�˳����쳣���R����λ��

%% 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load 'ʵ������/ʵ������2/10-25/80minute';
load 'ʵ������/ʵ������3/mat/data2/data2_16';
% load 'ʵ������/ʵ������2/mat/1407-6_7';
% data=t;
time=data(:,1);
ppg=data(:,2);
ecg=data(:,3);
BP=data(:,4);
for i=1:1:length(time)
%     if time(i)==4257
%         loc1=i;
%     end
%     if time(i)==4504
%         loc2=i;
%     end
    if time(i)==180
        loc1=i;
    end
    if time(i)==1980
        loc2=i;
    end
    if time(i)==2340
        loc3=i;
    end
    if time(i)==3120
        loc4=i;
    end
    if time(i)==3360
        loc5=i;
    end
end

fs=250;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%d_rp��ʾR����ֵ��PPG�źŷ�ֵ�ľ��룬d_rt��ʾR����ֵ��PPG�źŹ�ֵ�ľ��룬d_pt��ʾPPG�źŷ�ֵ����ֵ�ľ���
%%d��ʾR����ֵ��λ�ã�min_y��ʾPPG�ź����еĹ�ֵ��λ�ã�max_y��ʾPPG�ź����еķ�ֵ��λ��
%%max_r��ʾÿ��R����ֵ���Ӧ��PPG�źŷ�ֵ��λ�ã�min_r��ʾÿ��R����ֵ���Ӧ��PPG�źŵĹ�ֵ��λ��
%%max_r��min_r�Ƕ�Ӧ��ÿ��RR���ڣ���һ��RR���ھ���һ��max_r��min_r��ֵ�����������ÿ��RR�������ҽ���һ��PPG�ź�
%%�Ĳ���Ͳ��ȣ����������min_r�洢�ľ������RR���ڶ�Ӧ��PPG�źŵĲ��ȵ�λ�ã�max_r�洢�������RR���ڶ�Ӧ��PPG
%%�źŵĲ����λ�á��������쳣������������RR���ڳ����˶��PPG�źŵĲ���򲨹ȣ�������û�г��ֲ���Ͳ��ȵ������
%%min_r��max_r�洢Ϊ0������ʾ�����쳣�������min_y��max_y�洢����PPG�źŵ����еĹ�ֵ��ͷ�ֵ�㣬��R������û�й�ϵ��
[d_rp,d_bp,d_rt,d_tbp,hr,d,max_y,peak_ppg,uu,uq]=pwtt5_BP(ecg,ppg,BP,fs);
for i=1:1:length(d)
    if d(i)<=loc1&d(i+1)>=loc1
        d_loc1=i;
    end
    if d(i)<=loc2&d(i+1)>=loc2
        d_loc2=i;
    end
    if d(i)<=loc3&d(i+1)>=loc3
        d_loc3=i;
    end
    if d(i)<=loc4&d(i+1)>=loc4
        d_loc4=i;
    end
    if d(i)<=loc5&d(i+1)>=loc5
        d_loc5=i;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[line_RR,line_peak,line_through]=draw_ECG_PPG(uu,uq,d,max_y,max_r);
l_min_r=find(peak_ppg==0);%%�쳣���λ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1)
% t=1:1:length(uu);
% plot(t,uu,'m-',t,uq,'b-');hold on;
% plot(d,uu(d),'p',max_y,uq(max_y),'k+');
% figure(2)%�鿴��⵽��R��ֵ��
% t=1:1:length(d_rp);
% plot(t,d_rp);
% d_rp(d_rp==0)=NaN;
figure(1)
t=1:1:length(uu);
plot(t,uu,'m-',t,uq,'b-');hold on;
plot(d,uu(d),'p',max_y,uq(max_y),'k+');

figure(2)
t2=1:1:length(d_rp);
plot(t2,d_rp);
% hold on;
% [p1,S1]=polyfit(t2,d_rp,10); 
% fit1=polyval(p1,t2);
% % plot(t2,fit1);
figure(3)
for i=1:1:length(d_bp)
    if d_bp(i)==0
        p_bp(i)=0;
    else
        p_bp(i)=BP(d_bp(i));
    end
end
plot(t2,p_bp);

figure(4)
plot(t2,d_rt);

figure(5)
for i=1:1:length(d_tbp)
    if d_tbp(i)==0
        p_tbp(i)=0;
    else
        p_tbp(i)=BP(d_tbp(i));
    end
end
plot(t2,p_tbp);

% figure(6)
% subplot(411)
% plot(t2,d_rp);
% subplot(412)
% plot(t2,d_rt);
% subplot(413)
% plot(t2,p_bp);
% subplot(414)
% plot(t2,p_tbp);

figure(6)
plot(t2,d_rp);
hold on;
plot(t2,d_rt);
hold on;
plot(t2,p_bp);
hold on;
plot(t2,p_tbp);
hold on;
plot([d_loc1,d_loc1],[0,200]);
hold on;
plot([d_loc2,d_loc2],[0,200]);
hold on;
plot([d_loc3,d_loc3],[0,300]);
hold on;
plot([d_loc4,d_loc4],[0,300]);
hold on;
plot([d_loc5,d_loc5],[0,300]);

figure(7)
plot(t2,d_rp);
hold on;
plot(t2,p_bp);
hold on;
plot([d_loc1,d_loc1],[0,300]);
hold on;
plot([d_loc2,d_loc2],[0,300]);
hold on;
plot([d_loc3,d_loc3],[0,300]);
hold on;
plot([d_loc4,d_loc4],[0,300]);
hold on;
plot([d_loc5,d_loc5],[0,300]);


figure(8)
plot(t2,d_rt);
hold on;
plot(t2,p_bp);
hold on;
plot([d_loc1,d_loc1],[0,300]);
hold on;
plot([d_loc2,d_loc2],[0,300]);
hold on;
plot([d_loc3,d_loc3],[0,300]);
hold on;
plot([d_loc4,d_loc4],[0,300]);
hold on;
plot([d_loc5,d_loc5],[0,300]);
%%%1��2��3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%