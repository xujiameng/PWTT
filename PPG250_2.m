function [max_y,uq,PF]=PPG250_2(ppg,fs)
%% �ú���ʵ���˶�PPG�źŵķ�ֵ��ļ�⣬��Ҫ�����¼���ģ��
%%1.��PPG�źŽ���Ԥ�����������й�һ����ȥ�������ƺ��˲�
%%2.��ȡԤ����֮���PPG�źŵķ�ֵ�㣬��findpeaks������ģ������Ƿֱ�洢������max_y�У�
%%3.�����Ѱ��ԭʼPPG�źŵĲ���Ͳ��ȵ�λ�ã�������̼�������ͣ�

%% PPG���ݴ���
PPG=ppg;
q=PPG;
% q=q(101:end);%��ΪECG��ȥ��ǰ��100������Ϊ�˺�ECG��Ӧ������PPGҲ��ȥǰ��100����
l=length(q);
lq=(q-mean(q))/std(q);%���ݹ�һ�� 
uq=detrend(lq);%����ȥ��������;
f1=0.1;%ͨ�����޽�ֹƵ��5hz
f2=3;%ͨ�����޽�ֹƵ��26hz
r=fir1(100,[2*f1/fs,2*f2/fs]);%����FIR�˲�����������Ϊ200
% PF=filter(r,1,uq);%ʹ�ø��˲��������˲�
PF=filtfilt(r,1,uq);%ʹ�����ӳ��˲��������˲�
[pks,locs] = findpeaks(PF,'minpeakdistance',70);%��ֵ���⣬����70������ֻ�ܼ�⵽1����ֵ�㣨�����ɵ���
IndMax_y=locs;
max_y=IndMax_y;

end