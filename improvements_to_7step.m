%% 尝试改进7-step法则 
function [add_delect_ppg]=improvements_to_7step(ppg,d)

%Description：
% 该程序功能为：获取PPG信号数据部分异常点位置
% 程序原理及流程：
%     Step1: 借助R波信息计算PPG信息中的峰值点信息
%     Step2: 检索上述结果中可能的异常点并记录输出

%Inputs：
%     ppg：滤波后的PPG信号数据
%     d：ECG峰值点位置

%Outputs：
%	  add_delect_ppg：获取的PPG部分异常点位置信息

%Calls：
%	被本函数调用的函数清单
%     find_peaks：获取数据峰值点位置信息

%Called By：
%	调用本函数的清单
%      usdbyplot：从原始信号数据获取标记出异常点位置的PWTT与BP,及滤波处理后的ECG信号，PPG信号，BP信号

%V1.0：2018/5/7



[max_ppg]=find_peaks(d,ppg); %借助R波信息，获取PPG信号中峰值点位置信息
for i=1:1:length(d)-1%对存储有所有R波峰值点位置信息的数组进行循环，查找每相邻两个R波之间的ppg峰值点
    m=1;
    s=1;
    num_max=[];%用于存储两个R波峰值点之间的ppg峰值点位置信息
    %% 循环查找当前两个R波峰值点之间的PPG峰值点
    for j=1:1:length(max_ppg)%对存储有所有B峰值点位置信息的数组进行循环
        if max_ppg(j)>d(i) && max_ppg(j)<d(i+1)%判断该PPG峰值点是否在当前两个R波峰值点之间
            num_max(m)=max_ppg(j);%如果该ppg峰值点存在于当前两个R波峰值点之间，则存储到num_max中
            m=m+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    l_m=length(num_max);%获取当前两个R波峰值点之间的ppg峰值点个数
    if l_m==1%判断当前两个R波峰值点之间是否有且仅有一个ppg峰值点P
        max_r(i)=num_max(1);%将该ppg峰值点位置信息存入数组max_r中
    else%其他情况均视为异常点情况
        max_r(i)=0;%将当前位置存入0
    end
end

add_delect_ppg=find(max_r==0);  %将PPG异常点位置信息存储至向量add_delect_ppg


end
