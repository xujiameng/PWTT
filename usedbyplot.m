 
function [pwtt,BP,bp,p,uu]=usedbyplot(data)
%Description：
% 该程序功能为：从原始信号数据获取标记出异常点位置的PWTT与BP,及滤波处理后的ECG信号，PPG信号，BP信号
% 程序原理及流程：
%     Step1: 对原始信号进行滤波，并获取数据关键点（如ECG峰值，PPG峰值与上升最快点位置，BP峰值）。
%     Step2: 计算PWTT，并根据改进的7-step滤波法及BP异常点的检测方法对对应异常点位置的PWTT与BP中位置进行标记。

%Inputs：
%     data数据：为4*N的原始数据，其中第一列为时间数据，第二列为原始ECG信号数据，第三列为原始PPG信号数据，第四列为原始BP信号数据。

%Outputs：
%	pwtt：ECG峰值点位置到PPG谷值点(PWTT1)，或PPG峰值点(PWTT2)，或PPG上升最快点(PWTT3)位置的距离
%   BP：原始血压信号数据
%   bp：滤波后的血压信号数据
%   p：滤波后的PPG信号数据
%   uu：滤波后的ECG信号数据

%Calls：
%	被本函数调用的函数清单
%     ECG250：获取R波峰值点的位置信息
%     BP250_2：获取BP数据的峰值点位置信息
%     find_peaks：结合R波信息，获取信息中峰值点位置
%     detrend：对数据去线性趋势;
%     fir1：用窗函数法设计线性相位FIRDF的工具箱函数
%     filtfilt：使用零相位滤波器filtfilt进行滤波，来避免延迟
%     diff：计算数据导数
%     unique：筛除向量中的重复值
%     improvements_to_7step：对7-step滤波法的改进，用于获取PPG峰值异常点信息

%Called By：
%	调用本函数的清单
%     select_R_linear_fitting：从原始信号数据计算得出有效的PWTT与BP峰值点位置信息并进行拟合。

%V1.0：2018/5/7


%% 对原始数据进行滤波，并获取ECG数据，BP数据关键点位置
time=data(:,1);%%获取时间序列
ppg=data(:,3);%%获取ppg数据
ecg=data(:,2);%%获取ecg数据
BP=data(:,4);%%获取bp数据
fs=1000;%定义采样频率
choose=1; %choose=1时采用的是改进的7-step滤波法，choose=0时采用的是未改进的7-step滤波法
[st_ll,d,uu]=ECG250(ecg,fs);%%获取R波峰值点的位置信息（存储在d中）
%[max_BP,min_BP,u_bp]=BP250(BP,fs);%%获取BP数据的峰值点位置信息
[BF]=BP250_2(BP,fs);%%获取BP数据的峰值点位置信息

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[max_BP]=find_peaks(d,BF); %结合R波信息，获取BF信息中血压峰值点位置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

lo=(ppg-mean(ppg))/std(ppg);%数据归一化 
d_ppg=detrend(lo);%数据去线性趋势;
fc1=0.1;%通带下限截止频率0.1hz
fc2=3;%通带上限截止频率3hz
b=fir1(50,[2*fc1/fs,2*fc2/fs]);%设置FIR滤波器，阶数设为50
% p=filter(b,1,d_ppg);%使用该滤波器进行滤波
p=filtfilt(b,1,d_ppg);%使用零相位滤波器filtfilt进行滤波，来避免延迟
l=length(d);%获取R波个数的长度
% ed=mean(diff(d))*1;

%% 7 step PW-filter算法，并获取PPG关键位置信息 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:l-1
    bg=1000*(50/1000);%定义每相邻两个R波之间使用的PPG数据段的起点（即R波开始后的50ms）
    ed=(d(i+1)-d(i))*1;%定义相邻两个R波之间使用的PPG数据段的终点（因为数据不一样需要的宽度可能不一样，故此处没有限制数据长度）
    if ed<=bg
        bg=ed/10;
    end
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
    foot(i)=p_begin(i)+I1;%获取谷值点在整段数据中的位置信息
end

for i=1:1:length(foot)%进行7 step规则判断
    diff1=diff(p(p_begin(i):p_end(i)));%求得当前数据段的一阶导数，接下来会用到
    diff2=diff(p(p_begin(i):p_end(i)),2);%求得当前数据段的二阶导数，接下来会用到
    if foot(i)<peak(i)% 规则1：满足规则则赋值为0，不满足赋值为1
        I(1,i)=0;     % 7-step滤波法规则1：PPG波形起始点要在PPG峰值之前；
    else
        I(1,i)=1;
    end
    if d(i)<peak(i)<d(i+1)% 规则2：满足规则则赋值为0，不满足赋值为1
        I(2,i)=0;         % 7-step滤波法规则2：PPG峰值点位置要在两个相邻R波之间；
    else
        I(2,i)=1;
    end
    if d(i)<foot(i)<d(i+1)% 规则3：满足规则则赋值为0，不满足赋值为1
        I(3,i)=0;         % 7-step滤波法规则3：PPG波形起始点位置要在两个相邻R波之间；
    else
        I(3,i)=1;
    end
    if p(peak(i))>p(foot(i))% 规则4：满足规则则赋值为0，不满足赋值为1
        I(4,i)=0;           % 7-step滤波法规则4：PPG峰值点高度要比起始点高度要高；
    else
        I(4,i)=1;
    end
    
    
    
%     if (foot(i)-p_begin(i))==0||(foot(i)-p_begin(i))>length(diff1)% 规则5：满足规则则赋值为0，不满足赋值为1
%         I(5,i)=1;                                                 % 7-step滤波法规则5：PPG波形起始点不能与PPG数据段起始点位置是同一点；
%     elseif diff1(foot(i)-p_begin(i))>0
%         I(5,i)=0;
%     else
%         I(5,i)=1;
%     end
    

    if (peak(i)-p_begin(i))==0||(peak(i)-p_begin(i))>length(diff2)% 规则6：满足规则则赋值为0，不满足赋值为1
        I(6,i)=1;                                                 % 7-step滤波法规则6：PPG峰值点不能与PPG数据段起始点位置是同一点；
    elseif diff2(peak(i)-p_begin(i))<0
        I(6,i)=0;
    else
        I(6,i)=1;
    end
    if (foot(i)<rise(i))&(rise(i)<peak(i))% 规则7：满足规则则赋值为0，不满足赋值为1
        I(7,i)=0;                         % 7-step滤波法规则7：PPG上升最快点要在PPG波形起始点之前，PPG峰值点位置
    else
        I(7,i)=1;
    end
end



[x,y]=find(I~=0); %查找数组I中的非0点的位置
x=x';
y=y';
dis=[x;y];%得到干扰点和违反的规则
delect= unique(y);%存储的是干扰点


%% 对BP异常点位置的检索 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:length(d)-1%对存储有所有R波峰值点位置信息的数组进行循环，查找每相邻两个R波之间的BP峰值点
    m=1;
    s=1;
    num_max=[];%用于存储两个R波峰值点之间的BP峰值点位置信息
    % 循环查找当前两个R波峰值点之间的BP峰值点
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
%% 对7-Step滤波法的补充%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if choose==1  %判断是否使用对7-step滤波法的补充
[add_delect_ppg]=improvements_to_7step(p,d);  %获取PPG峰值异常点信息并存至一维向量add_delect_ppg中

delect=[delect,add_delect_ppg,delect_BP];   %将通过原始的7-step滤波法，对7-step滤波法的补充 及 对BP峰值点进行检测 获取的异常点拼接到一起
delect=unique(delect); %确保该向量中没有重复的信息
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
max_r(delect)=0;  %将异常点对应在BP信息中的位置置零


%% 计算PWTT并获取BP峰值，对干扰点位置置零
D=d(1:end-1);
pwtt1=foot-D;%根据求得的PPG起始点减去相应的R波峰值点得到pwtt1
pwtt2=peak-D;%根据求得的PPG峰值点减去相应的R波峰值点得到pwtt2
pwtt3=rise-D;%根据求得的PPG上升最快点减去相应的R波峰值点得到pwtt3
pwtt1((delect))=0;%将干扰点位置置0
pwtt2((delect))=0;%将干扰点位置置0
pwtt3((delect))=0;%将干扰点位置置0



for i=1:1:length(max_r)%获得bp峰值点的真实值
    if max_r(i)==0
        p_bp(i)=0;
    else
        p_bp(i)=BP(max_r(i));
    end
end
bp=p_bp;

pwtt=pwtt3;



end
