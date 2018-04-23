close all;
clc;
clear;
% load 'pigdata����/δ��������/1407-1524/1407-1524_5';
% load 'ʵ������/ʵ������3/mat/data_2';
load 'ʵ������/ʵ������3/mat/data2/data2_16';
% data=data((30000:end),:);
time=data(:,1);%%��ȡʱ������
ppg=data(:,2);%%��ȡppg����
ecg=data(:,3);%%��ȡecg����
BP=data(:,4);%%��ȡbp����
fs=250;%�������Ƶ��
[st_ll,d,uu]=ECG250(ecg,fs);%%��ȡR����ֵ���λ����Ϣ���洢��d�У�
%[max_BP,min_BP,u_bp]=BP250(BP,fs);%%��ȡBP���ݵķ�ֵ��λ����Ϣ
[max_BP,u_bp]=BP250(BP,fs);%%��ȡBP���ݵķ�ֵ��λ����Ϣ-yj
lo=(ppg-mean(ppg))/std(ppg);%���ݹ�һ�� 
d_ppg=detrend(lo);%����ȥ��������;
fc1=0.1;%ͨ�����޽�ֹƵ��5hz
fc2=3;%ͨ�����޽�ֹƵ��26hz
b=fir1(50,[2*fc1/fs,2*fc2/fs]);%����FIR�˲�����������Ϊ50
% p=filter(b,1,d_ppg);%ʹ�ø��˲��������˲�
p=filtfilt(b,1,d_ppg);%ʹ������λ�˲���filtfilt�����˲����������ӳ�
l=length(d);%��ȡR�������ĳ���
% ed=mean(diff(d))*1;

%%7 step PW-filter�޸��㷨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:l-1
    bg=250*(50/1000);%����ÿ��������R��֮��ʹ�õ�PPG���ݶε���㣨��R����ʼ���50ms��
    ed=(d(i+1)-d(i))*1;%������������R��֮��ʹ�õ�PPG���ݶε��յ㣨��Ϊ���ݲ�һ����Ҫ�Ŀ�ȿ��ܲ�һ�����ʴ˴�û���������ݳ��ȣ�
    p_begin(i)=d(i)+round(bg);%��ȡ��ǰPPG���ݶε����
    p_end(i)=d(i)+round(ed);%��ȡ��ǰPPG���ݶε��յ�
end
for i=1:1:length(p_begin)
    i_ppg=[];
    i_ppg=p(p_begin(i):p_end(i));%��ȡ��ǰ��Ҫ�����PPG���ݶ�
%     [ma1,I1]=max(diff(i_ppg,2));
%     foot(i)=p_begin(i)+I1;
    [ma2,I2]=max(i_ppg);%��ȡ��ǰ���ݶ����ֵ��λ��
    peak(i)=p_begin(i)+I2;%��ȡ��ֵ�������������е�λ����Ϣ
%     [maxtab, mintab] = peakdet(i_ppg,0.1);
    [ma3,I3]=max(diff(i_ppg));%��ȡ��ǰ���ݶε�һ�׵������ֵ��λ��
    rise(i)=p_begin(i)+I3;%��ȡ�������������������е�λ����Ϣ
    f_ppg=[];
    f_ppg=p(p_begin(i):(peak(i)+3));%��ȡ��ǰ���ݶ���ʼ�㵽��ֵ��֮�������
    [ma1,I1]=max(diff(f_ppg,2));%��ȡ�������ݶεĶ��׵������ֵ��λ��
    foot(i)=p_begin(i)+I1;%��ȡ��ʼ�������������е�λ����Ϣ
end

for i=1:1:length(foot)%����7 step�����ж�
    diff1=diff(p(p_begin(i):p_end(i)));%��õ�ǰ���ݶε�һ�׵��������������õ�
    diff2=diff(p(p_begin(i):p_end(i)),2);%��õ�ǰ���ݶεĶ��׵��������������õ�
    if foot(i)<peak(i)%����1�����������ֵΪ0�������㸳ֵΪ1
        I(1,i)=0;
    else
        I(1,i)=1;
    end
    if d(i)<peak(i)<d(i+1)%����2�����������ֵΪ0�������㸳ֵΪ1
        I(2,i)=0;
    else
        I(2,i)=1;
    end
    if d(i)<foot(i)<d(i+1)%����3�����������ֵΪ0�������㸳ֵΪ1
        I(3,i)=0;
    else
        I(3,i)=1;
    end
    if p(peak(i))>p(foot(i))%����4�����������ֵΪ0�������㸳ֵΪ1
        I(4,i)=0;
    else
        I(4,i)=1;
    end
    if (foot(i)-p_begin(i))==0||(foot(i)-p_begin(i))>length(diff1)%����5�����������ֵΪ0�������㸳ֵΪ1
        I(5,i)=1;
    elseif diff1(foot(i)-p_begin(i))>0
        I(5,i)=0;
    else
        I(5,i)=1;
    end
    if (peak(i)-p_begin(i))==0||(peak(i)-p_begin(i))>length(diff2)%����6�����������ֵΪ0�������㸳ֵΪ1
        I(6,i)=1;
    elseif diff2(peak(i)-p_begin(i))<0
        I(6,i)=0;
    else
        I(6,i)=1;
    end
    if (foot(i)<rise(i))&(rise(i)<peak(i))%����7�����������ֵΪ0�������㸳ֵΪ1
        I(7,i)=0;
    else
        I(7,i)=1;
    end
end

[x,y]=find(I~=0); %��������I�еķ�0���λ��
x=x';
y=y';
dis=[x;y];%�õ����ŵ��Υ���Ĺ���
delect= unique(y);%�洢���Ǹ��ŵ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:length(d)-1%�Դ洢������R����ֵ��λ����Ϣ���������ѭ��������ÿ��������R��֮���BP��ֵ��
    m=1;
    s=1;
    num_max=[];%���ڴ洢����R����ֵ��֮���BP��ֵ��λ����Ϣ
    %% ѭ�����ҵ�ǰ����R����ֵ��֮���BP��ֵ��
    for j=1:1:length(max_BP)%�Դ洢������B��ֵ��λ����Ϣ���������ѭ��
        if max_BP(j)>d(i)&&max_BP(j)<d(i+1)%�жϸ�BP��ֵ���Ƿ��ڵ�ǰ����R����ֵ��֮��
            num_max(m)=max_BP(j);%�����BP��ֵ������ڵ�ǰ����R����ֵ��֮�䣬��洢��num_max��
            m=m+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    l_m=length(num_max);%��ȡ��ǰ����R����ֵ��֮���BP��ֵ�����
    if l_m==1%�жϵ�ǰ����R����ֵ��֮���Ƿ����ҽ���һ��BP��ֵ��P
        max_r(i)=num_max(1);%����BP��ֵ��λ����Ϣ��������max_r��
    else%�����������Ϊ�쳣�����
        max_r(i)=0;%����ǰλ�ô���0
    end
end
delect_BP=find(max_r==0);%�ҵ�����max_r����ֵΪ0�ĵ㣬��Ϊ���ŵ�
D=d(1:end-1);
pwtt1=foot-D;%������õ�PPG��ʼ���ȥ��Ӧ��R����ֵ��õ�pwtt1
pwtt2=peak-D;%������õ�PPG��ֵ���ȥ��Ӧ��R����ֵ��õ�pwtt2
pwtt3=rise-D;%������õ�PPG���������ȥ��Ӧ��R����ֵ��õ�pwtt3
pwtt1((delect))=0;%�����ŵ�λ����0
pwtt2((delect))=0;%�����ŵ�λ����0
pwtt3((delect))=0;%�����ŵ�λ����0

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
for i=1:1:length(max_r)%���bp��ֵ�����ʵֵ
    if max_r(i)==0
        p_bp(i)=0;
    else
        p_bp(i)=BP(max_r(i));
    end
end
bp=p_bp;
pwtt=pwtt1;
% save(['ʵ������/ʵ������3/mat/data2_7step�޸�/PWTT/pwtt1/pwtt09'],'pwtt') ;
% pwtt=pwtt2;
% save(['ʵ������/ʵ������3/mat/data2_7step�޸�/PWTT/pwtt2/pwtt09'],'pwtt') ;
% pwtt=pwtt3;
% save(['ʵ������/ʵ������3/mat/data2_7step�޸�/PWTT/pwtt3/pwtt09'],'pwtt') ;
% save(['ʵ������/ʵ������3/mat/data2_7step�޸�/BP/bp09'],'bp') ;
plot(t2,p_bp);
