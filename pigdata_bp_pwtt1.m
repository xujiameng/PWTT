close all;
clc;
clear;
%% 本程序主要有以下3个部分组成%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%1.将原始ECG和PPG信号读入，并给采样频率赋值，之后获取ECG和PPG的数据长度，使得他们的长度一致
%%2.程序的核心部分，即函数pwtt4，完成了对心电R波峰值点的检测（函数ECG），PPG峰值点和谷值点的检测（函数PPG），
%以及PWTT相关参数的求取（函数ECG_PPG）。
%%3.画出ECG和PPG在同一坐标系中的图形，并标出R波峰值、PPG峰值点和PPG谷值点
%并将所有点以冲击线条的方式画出来，便于观察，最终还获取了出现异常点的R波的位置

%% 1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load '实验数据/10-25/80minute';
load '实验数据/实验数据2/10-25/80minute';
data=t;
time=data(:,1);
ppg=data(:,2);
ecg=data(:,3);
BP=data(:,4);

fs=250;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%d_rp表示R波峰值到PPG信号峰值的距离，d_rt表示R波峰值到PPG信号谷值的距离，d_pt表示PPG信号峰值到谷值的距离
%%d表示R波峰值点位置，min_y表示PPG信号所有的谷值点位置，max_y表示PPG信号所有的峰值点位置
%%max_r表示每个R波峰值点对应的PPG信号峰值点位置，min_r表示每个R波峰值点对应的PPG信号的谷值点位置
%%max_r和min_r是对应到每个RR间期，有一个RR间期就有一个max_r和min_r的值，正常情况下每个RR间期有且仅有一个PPG信号
%%的波峰和波谷，这种情况下min_r存储的就是这个RR间期对应的PPG信号的波谷的位置，max_r存储的是这个RR间期对应的PPG
%%信号的波峰的位置。当出现异常情况，即在这个RR间期出现了多个PPG信号的波峰或波谷，或者是没有出现波峰和波谷的情况下
%%min_r和max_r存储为0，来表示出现异常情况。而min_y和max_y存储的是PPG信号的所有的谷值点和峰值点，和R波间期没有关系。
[d_rp,d_bp,d_rt,d_tbp,hr,d,max_y,peak_ppg,uu,uq]=pwtt5_BP(ecg,ppg,BP,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[line_RR,line_peak,line_through]=draw_ECG_PPG(uu,uq,d,max_y,max_r);
l_min_r=find(peak_ppg==0);%%异常点的位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1)
% t=1:1:length(uu);
% plot(t,uu,'m-',t,uq,'b-');hold on;
% plot(d,uu(d),'p',max_y,uq(max_y),'k+');
% figure(2)%查看检测到的R峰值点
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

figure(6)
subplot(411)
plot(t2,d_rp);
subplot(412)
plot(t2,d_rt);
subplot(413)
plot(t2,p_bp);
subplot(414)
plot(t2,p_tbp);

figure(7)
plot(t2,d_rp);
hold on;
plot(t2,d_rt);
hold on;
plot(t2,p_bp);
hold on;
plot(t2,p_tbp);

figure(8)
plot(t2,d_rp);
hold on;
plot(t2,p_bp);
% hold on;
% plot([d_loc1,d_loc1],[0,300]);
% hold on;
% plot([d_loc2,d_loc2],[0,300]);
% hold on;
% plot([d_loc3,d_loc3],[0,300]);
% hold on;
% plot([d_loc4,d_loc4],[0,300]);
% hold on;
% plot([d_loc5,d_loc5],[0,300]);
% 
% figure(8)
% plot(t2,d_rp);
% hold on;
% plot(t2,p_bp);
% hold on;
% plot([d_loc1,d_loc1],[0,300]);
% hold on;
% plot([d_loc2,d_loc2],[0,300]);
% hold on;
% plot([d_loc3,d_loc3],[0,300]);
% hold on;
% plot([d_loc4,d_loc4],[0,300]);
% hold on;
% plot([d_loc5,d_loc5],[0,300]);
% figure(3)
% % subplot(313);
% BP=BP';
% plot(t,BP);
% hold on;
% [p2,S2]=polyfit(t,BP,10); 
% fit2=polyval(p2,t);
% plot(t,fit2);
% xi=1/length(t):(length(d_rp)/(length(t))):length(d_rp);
% zi=interp1(t2,d_rp,xi,'spline');
% figure(4)
% plot(t,zi);
% hold on;
% plot(t,BP);
% yi=interp1(t2,fit1,xi,'spline');
% figure(5)
% plot(t,yi);
% hold on;
% plot(t,fit2);


%%%1、2、3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%