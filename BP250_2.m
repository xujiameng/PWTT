function [BF]=BP250_2(BP,fs)

%Description：
% 该程序功能为：对BP信号进行滤波
% 程序原理及流程：
%     Step1: 使用零相位滤波器对BP数据进行滤波

%Inputs：
%     BP：原始BP信号
%     fs：采样频率

%Outputs：
%	  BF：滤波后的BP信号数据

%Calls：
%	被本函数调用的函数清单
%     detrend：对数据去线性趋势;
%     fir1：用窗函数法设计线性相位FIRDF的工具箱函数
%     filtfilt：使用零相位滤波器filtfilt进行滤波，来避免延迟

%Called By：
%	调用本函数的清单
%     usdbyplot：从原始信号数据获取标记出异常点位置的PWTT与BP,及滤波处理后的ECG信号，PPG信号，BP信号

%V1.0：2018/5/7


%% 对BP数据进行滤波
p=BP;
l=length(p);  % 获取BP信号长度

lo=(p-mean(p))/std(p);%数据归一化 
u_bp=detrend(lo);%数据去线性趋势;
%uu=p;
fc1=0.1;%通带下限截止频率5hz
fc2=3;%通带上限截止频率26hz
b=fir1(100,[2*fc1/fs,2*fc2/fs]);%设置FIR滤波器，阶数设为100
% BF=filter(b,1,u_bp);%使用该滤波器进行滤波
BF=filtfilt(b,1,u_bp);%使用该滤波器进行滤波

%% 寻找原始BP数据上对应的峰值点的位置%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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