function [d_rp,hr,peak_ppg,d_bp]=ECG_PPG_BP_250(max_y,d,max_BP,fs)
%% 该函数实现了对PWTT相关参数的求取，寻找和ECG信号峰值对应的PPG信号的峰值点和谷值点
%正常情况下，每两个R波峰值之间有且仅有一个PPG峰值点和谷值点，而其他所有情况均被视为异常点
%（即每两个R波峰值点之间多余一个PPG波峰或波谷，或者是没有PPG波峰或波谷）
%而出现异常点的原因大概有以下几个方面：1.ECG存在干扰点，2.PPG存在干扰点，3.PPG缺失波峰、波谷，4.PPG波峰存在偏差

%% 查找每两个R波峰值之间是否有且仅有一个PPG峰值点和谷值点，如果是把相应的点的位置存储下来，如果不是，
%则视为异常点，将该位置的点置0
for i=1:1:length(d)-1%对存储有所有R波峰值点位置信息的数组进行循环，查找每相邻两个R波之间的PPG峰值点和谷值点个数
    m=1;
    s=1;
    num_max=[];%用于存储两个R波峰值点之间的PPG峰值点位置信息
    num_BP=[];%用于存储两个R波峰值点之间的PPG估值点位置信息
    %% 循环查找当前两个R波峰值点之间的PPG峰值点
    for j=1:1:length(max_y)%对存储有所有PPG峰值点位置信息的数组进行循环
        if max_y(j)>d(i)&&max_y(j)<d(i+1)%判断该PPG峰值点是否在当前两个R波峰值点之间
            num_max(m)=max_y(j);%如果该PPG峰值点存在于当前两个R波峰值点之间，则存储到num_max中
            m=m+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% 循环查找当前两个R波峰值点之间的PPG谷值点
    for k=1:1:length(max_BP)%对存储有所有PPG谷值点位置信息的数组进行循环
        if max_BP(k)>d(i)&&max_BP(k)<d(i+1)%判断该PPG谷值点是否在当前两个R波峰值点之间
            num_BP(s)=max_BP(k);%如果该PPG谷值点存在于当前两个R波峰值点之间，则存储到num_min中
            s=s+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    l_m=length(num_max);%获取当前两个R波峰值点之间的PPG峰值点个数
    l_s=length(num_BP);%获取当前两个R波峰值点之间的PPG谷值点个数
    if l_m==1%判断当前两个R波峰值点之间是否有且仅有一个PPG峰值点和谷值点
        peak_ppg(i)=num_max(1);%将该PPG峰值点位置信息存入数组max_r中
    else%其他情况均视为异常点情况
        peak_ppg(i)=0;%将当前位置存入0
    end
    if l_s==1
        peak_bp(i)=num_BP(1);%将该PPG谷值点位置信息存入数组min_r中
    else
         peak_bp(i)=0;%将当前位置存入0
    end
end
% for i=1:1:length(d)-1%对存储有所有R波峰值点位置信息的数组进行循环，查找每相邻两个R波之间的PPG峰值点和谷值点个数
%     n=1;
%     r=1;
%     num_min=[];%用于存储两个R波峰值点之间的PPG谷值点位置信息
%     num_min_bp=[];
%     %% 循环查找当前两个R波峰值点之间的PPG峰值点
%     for j=1:1:length(min_y)%对存储有所有PPG峰值点位置信息的数组进行循环
%         if min_y(j)>d(i)&&min_y(j)<d(i+1)%判断该PPG峰值点是否在当前两个R波峰值点之间
%             num_min(n)=min_y(j);%如果该PPG峰值点存在于当前两个R波峰值点之间，则存储到num_max中
%             n=n+1;
%         end
%     end
%     for j=1:1:length(min_BP)%对存储有所有PPG峰值点位置信息的数组进行循环
%         if min_BP(j)>d(i)&&min_BP(j)<d(i+1)%判断该PPG峰值点是否在当前两个R波峰值点之间
%             num_min_bp(r)=min_BP(j);%如果该PPG峰值点存在于当前两个R波峰值点之间，则存储到num_max中
%             r=r+1;
%         end
%     end
%     l_n=length(num_min);%获取当前两个R波峰值点之间的PPG峰值点个数
%     l_r=length(num_min_bp);
%     if l_n==1%判断当前两个R波峰值点之间是否有且仅有一个PPG峰值点和谷值点
%         min_r(i)=num_min(1);%将该PPG谷值点位置信息存入数组min_r中
%     else%其他情况均视为异常点情况
%         min_r(i)=0;%将当前位置存入0
%     end
%     if l_r==1
%         t_bp(i)=num_min_bp(1);
%     else
%         t_bp(i)=0;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 求出R波峰值点到相应PPG峰值点和谷值点之间的距离，以及PPG峰值点和谷值点之间的距离
for i=1:1:length(peak_ppg)
    if peak_ppg(i)==0%max_r和min_r中为0的点都是异常点，这些点对应的位置在数组d_rp、d_rt和d_pt中也置0
        d_rp(i)=0;       
    else%非0点的位置则为正常点，则求取相应的间隔采样点数，存入数组
        d_rp(i)=peak_ppg(i)-d(i);%求当前R波峰值点位置到PPG峰值点位置的间隔       
    end
%     if peak_bp(i)==0
%         d_bp(i)=0;
%     else
%         d_bp(i)=peak_bp(i);
%     end
end
d_bp=peak_bp;
% for i=1:1:length(min_r)
%     if min_r(i)==0%max_r和min_r中为0的点都是异常点，这些点对应的位置在数组d_rp、d_rt和d_pt中也置0
%         d_rt(i)=0;
%     else%非0点的位置则为正常点，则求取相应的间隔采样点数，存入数组
%         d_rt(i)=min_r(i)-d(i);%求当前R波峰值点位置到PPG谷值点位置的间隔
%     end
% %     if t_bp(i)==0
% %         d_tbp(i)=0;
% %     else
% %         d_tbp(i)=t_bp(i);
% %     end
% end
% d_tbp=t_bp;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 求心率
for i=1:1:length(d)-1
    hr(i)=60/((d(i+1)-d(i))/512);%求每两个R波峰值点之间的心率
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%寻找和ECG信号峰值对应的PPG信号的峰值点和谷值点%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end