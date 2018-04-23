close all;
clc;
clear;
% load 'pigdata处理/未处理数据/1407-1524/1407-1524_5';
% load '实验数据/实验数据3/mat/data_2';
load '实验数据/实验数据3/mat/data2/data2_16';
% data=data((30000:end),:);
time=data(:,1);%%获取时间序列
ppg=data(:,2);%%获取ppg数据
ecg=data(:,3);%%获取ecg数据
BP=data(:,4);%%获取bp数据
fs=250;%定义采样频率
[st_ll,d,uu]=ECG250(ecg,fs);%%获取R波峰值点的位置信息（存储在d中）
%[max_BP,min_BP,u_bp]=BP250(BP,fs);%%获取BP数据的峰值点位置信息
[max_BP,u_bp]=BP250(BP,fs);%%获取BP数据的峰值点位置信息-yj
lo=(ppg-mean(ppg))/std(ppg);%数据归一化 
d_ppg=detrend(lo);%数据去线性趋势;
fc1=0.1;%通带下限截止频率5hz
fc2=3;%通带上限截止频率26hz
b=fir1(50,[2*fc1/fs,2*fc2/fs]);%设置FIR滤波器，阶数设为50
% p=filter(b,1,d_ppg);%使用该滤波器进行滤波
p=filtfilt(b,1,d_ppg);%使用零相位滤波器filtfilt进行滤波，来避免延迟
l=length(d);%获取R波个数的长度
% ed=mean(diff(d))*1;

%%7 step PW-filter修改算法%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:l-1
    bg=250*(50/1000);%定义每相邻两个R波之间使用的PPG数据段的起点（即R波开始后的50ms）
    ed=(d(i+1)-d(i))*1;%定义相邻两个R波之间使用的PPG数据段的终点（因为数据不一样需要的宽度可能不一样，故此处没有限制数据长度）
    p_begin(i)=d(i)+round(bg);%获取当前PPG数据段的起点
    p_end(i)=d(i)+round(ed);%获取当前PPG数据段的终点
end
for i=1:1:length(p_begin)
    i_ppg=[];
    i_ppg=p(p_begin(i):p_end(i));%获取当前需要处理的PPG数据段
%     [ma1,I1]=max(diff(i_ppg,2));
%     foot(i)=p_begin(i)+I1;
    [ma2,I2]=max(i_ppg);%获取当前数据段最大值的位置
    peak(i)=p_begin(i)+I2;%获取峰值点在整段数据中的位置信息
%     [maxtab, mintab] = peakdet(i_ppg,0.1);
    [ma3,I3]=max(diff(i_ppg));%获取当前数据段的一阶导数最大值的位置
    rise(i)=p_begin(i)+I3;%获取上升最快点在整段数据中的位置信息
    f_ppg=[];
    f_ppg=p(p_begin(i):(peak(i)+3));%获取当前数据段起始点到峰值点之间的数据
    [ma1,I1]=max(diff(f_ppg,2));%获取上述数据段的二阶导数最大值的位置
    foot(i)=p_begin(i)+I1;%获取起始点在整段数据中的位置信息
end

for i=1:1:length(foot)%进行7 step规则判断
    diff1=diff(p(p_begin(i):p_end(i)));%求得当前数据段的一阶导数，接下来会用到
    diff2=diff(p(p_begin(i):p_end(i)),2);%求得当前数据段的二阶导数，接下来会用到
    if foot(i)<peak(i)%规则1：满足规则则赋值为0，不满足赋值为1
        I(1,i)=0;
    else
        I(1,i)=1;
    end
    if d(i)<peak(i)<d(i+1)%规则2：满足规则则赋值为0，不满足赋值为1
        I(2,i)=0;
    else
        I(2,i)=1;
    end
    if d(i)<foot(i)<d(i+1)%规则3：满足规则则赋值为0，不满足赋值为1
        I(3,i)=0;
    else
        I(3,i)=1;
    end
    if p(peak(i))>p(foot(i))%规则4：满足规则则赋值为0，不满足赋值为1
        I(4,i)=0;
    else
        I(4,i)=1;
    end
    if (foot(i)-p_begin(i))==0||(foot(i)-p_begin(i))>length(diff1)%规则5：满足规则则赋值为0，不满足赋值为1
        I(5,i)=1;
    elseif diff1(foot(i)-p_begin(i))>0
        I(5,i)=0;
    else
        I(5,i)=1;
    end
    if (peak(i)-p_begin(i))==0||(peak(i)-p_begin(i))>length(diff2)%规则6：满足规则则赋值为0，不满足赋值为1
        I(6,i)=1;
    elseif diff2(peak(i)-p_begin(i))<0
        I(6,i)=0;
    else
        I(6,i)=1;
    end
    if (foot(i)<rise(i))&(rise(i)<peak(i))%规则7：满足规则则赋值为0，不满足赋值为1
        I(7,i)=0;
    else
        I(7,i)=1;
    end
end

[x,y]=find(I~=0); %查找数组I中的非0点的位置
x=x';
y=y';
dis=[x;y];%得到干扰点和违反的规则
delect= unique(y);%存储的是干扰点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:length(d)-1%对存储有所有R波峰值点位置信息的数组进行循环，查找每相邻两个R波之间的BP峰值点
    m=1;
    s=1;
    num_max=[];%用于存储两个R波峰值点之间的BP峰值点位置信息
    %% 循环查找当前两个R波峰值点之间的BP峰值点
    for j=1:1:length(max_BP)%对存储有所有B峰值点位置信息的数组进行循环
        if max_BP(j)>d(i)&&max_BP(j)<d(i+1)%判断该BP峰值点是否在当前两个R波峰值点之间
            num_max(m)=max_BP(j);%如果该BP峰值点存在于当前两个R波峰值点之间，则存储到num_max中
            m=m+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    l_m=length(num_max);%获取当前两个R波峰值点之间的BP峰值点个数
    if l_m==1%判断当前两个R波峰值点之间是否有且仅有一个BP峰值点P
        max_r(i)=num_max(1);%将该BP峰值点位置信息存入数组max_r中
    else%其他情况均视为异常点情况
        max_r(i)=0;%将当前位置存入0
    end
end
delect_BP=find(max_r==0);%找到数组max_r中数值为0的点，即为干扰点
D=d(1:end-1);
pwtt1=foot-D;%根据求得的PPG起始点减去相应的R波峰值点得到pwtt1
pwtt2=peak-D;%根据求得的PPG峰值点减去相应的R波峰值点得到pwtt2
pwtt3=rise-D;%根据求得的PPG上升最快点减去相应的R波峰值点得到pwtt3
pwtt1((delect))=0;%将干扰点位置置0
pwtt2((delect))=0;%将干扰点位置置0
pwtt3((delect))=0;%将干扰点位置置0

t=1:1:length(p);
figure(1)
plot(t,p);
hold on;
plot(t,uu);
hold on;
plot(d,uu(d),'d');
hold on;
plot(d(delect),uu(d(delect)),'d','LineWidth',2);
hold on; 
plot(foot,p(foot),'p',peak,p(peak),'k+',rise,p(rise),'*');
hold on;
% for i=1:1:length(d)
%     text(d(i),uu(d(i))+0.2,num2str(i),'HorizontalAlignment','center','VerticalAlignment','middle');
% end
figure(2)
plot(t,p);
hold on;
plot(t,d_ppg);
figure(3)
plot(t,d_ppg);
hold on;
plot(t,ecg);
hold on;
plot(d,ecg(d),'d');
hold on; 
plot(foot,d_ppg(foot),'p',peak,d_ppg(peak),'k+',rise,d_ppg(rise),'*');
figure(4)
t2=1:1:length(pwtt1);
plot(t2,pwtt1);
hold on;
plot(t2,pwtt2);
hold on;
plot(t2,pwtt3);
hold on;
for i=1:1:length(max_r)%获得bp峰值点的真实值
    if max_r(i)==0
        p_bp(i)=0;
    else
        p_bp(i)=BP(max_r(i));
    end
end
bp=p_bp;
pwtt=pwtt1;
% save(['实验数据/实验数据3/mat/data2_7step修改/PWTT/pwtt1/pwtt09'],'pwtt') ;
% pwtt=pwtt2;
% save(['实验数据/实验数据3/mat/data2_7step修改/PWTT/pwtt2/pwtt09'],'pwtt') ;
% pwtt=pwtt3;
% save(['实验数据/实验数据3/mat/data2_7step修改/PWTT/pwtt3/pwtt09'],'pwtt') ;
% save(['实验数据/实验数据3/mat/data2_7step修改/BP/bp09'],'bp') ;
plot(t2,p_bp);
