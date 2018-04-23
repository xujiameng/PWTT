function [max_y,uq,PF]=PPG250_2(ppg,fs)
%% 该函数实现了对PPG信号的峰值点的检测，主要有以下几个模块
%%1.对PPG信号进行预处理，即进行归一化、去线性趋势和滤波
%%2.求取预处理之后的PPG信号的峰值点，是findpeaks函数求的，将他们分别存储到数组max_y中，
%%3.最后是寻找原始PPG信号的波峰和波谷的位置（具体过程见程序解释）

%% PPG数据处理
PPG=ppg;
q=PPG;
% q=q(101:end);%因为ECG减去了前面100个数，为了和ECG对应，所有PPG也减去前面100个数
l=length(q);
lq=(q-mean(q))/std(q);%数据归一化 
uq=detrend(lq);%数据去线性趋势;
f1=0.1;%通带下限截止频率5hz
f2=3;%通带上限截止频率26hz
r=fir1(100,[2*f1/fs,2*f2/fs]);%设置FIR滤波器，阶数设为200
% PF=filter(r,1,uq);%使用该滤波器进行滤波
PF=filtfilt(r,1,uq);%使用无延迟滤波器进行滤波
[pks,locs] = findpeaks(PF,'minpeakdistance',70);%峰值点检测，限制70个点内只能检测到1个峰值点（参数可调）
IndMax_y=locs;
max_y=IndMax_y;

end