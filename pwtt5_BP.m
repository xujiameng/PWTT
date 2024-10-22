function [d_rp,d_bp,hr,d,max_y,peak_ppg,uu,uq,u_bp,max_BP,PF]=pwtt5_BP(ecg,ppg,BP,fs)
%% 本函数主要是是想以下三个功能%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%1.函数ECG250，输入为原始心电信号和采样频率，通过相关算法求得R波峰值点位置
%返回了三个参数，st_ll存储的是预处理后的ECG的R波峰值点位置信息，d存储的是原始ECG的R波峰值点位置信息
%uu表示将原始ECG进行归一化和去线性趋势之后的ECG数据

%%2.函数PPG250_2，输入为原始PPG信号和采样频率，通过相应算法求得PPG信号峰值点的位置信息
%返回参数有三个，max_y存储的是原始PPG信号的峰值点的位置信息，uq表示的是将原始PPG信号经过归一化和去线性趋势之后的PPG数据
%PF表示滤波之后的ppg信号，使用的是无延迟滤波器。

%%3.函数BP250，输入为原始BP信号和采样频率，通过相应算法求得BP信号峰值点的位置信息，返回两个参数
%max_BP存储的是原始BP信号的峰值点的位置信息，u_bp表示的是BP信号经过归一化和去线性趋势之后的BP数据

%%4.函数EGC_PPG_BP_250，输入为max_y、d、max_BP以及采样频率fs，通过相关算法求得PWTT相关参数
%即输出的4个参数，d_rp存储的是所有ECG的R波峰值点到相应的PPG峰值点间隔的采样点数（异常点则存储的是0）
%hr存储的是心率，peak_ppg存储的是与ECG的R波峰值点相对应的PPG峰值点位置，d_bp存储的是R波峰值点对应的BP峰值点位置
[st_ll,d,uu]=ECG250(ecg,fs);
% [max_y,uq]=PPG250(ppg,fs);
[max_y,uq,PF]=PPG250_2(ppg,fs);
[max_BP,u_bp]=BP250(BP,fs);
[d_rp,hr,peak_ppg,d_bp]=ECG_PPG_BP_250(max_y,d,max_BP,fs);
%%1、2、3%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end