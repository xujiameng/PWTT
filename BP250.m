function [max_BP,u_bp]=BP250(BP,fs)
p=BP;
l=length(p);

lo=(p-mean(p))/std(p);%���ݹ�һ�� 
u_bp=detrend(lo);%����ȥ��������;
%uu=p;
fc1=0.1;%ͨ�����޽�ֹƵ��5hz
fc2=3;%ͨ�����޽�ֹƵ��26hz
b=fir1(100,[2*fc1/fs,2*fc2/fs]);%����FIR�˲�����������Ϊ100
BF=filter(b,1,u_bp);%ʹ�ø��˲��������˲�
% IndMin_y=find(diff(sign(diff(SF)))>0)+1;
% IndMax_y=find(diff(sign(diff(SF)))<0)+1;
[pks,locs] = findpeaks(BF,'minpeakdistance',70);%��ֵ���⣬����70������ֻ�ܼ�⵽1����ֵ�㣨�����ɵ���
indmax=locs;
% [indmin, inmax] = extr(BF);

% IndMax_y = nonzeros(IndMax_y);
% for i=1:1:length(indmin)
%     if indmin(i)-60>0
%         Min_BP=p(indmin(i)-60:indmin(i));
%         s_min=indmin(i)-60;
%     else
%         Min_BP=p(1:indmin(i));
%         s_min=1;
%     end
%     t_ppg=min(Min_BP);
%     for j=s_min:1:indmin(i)
%         if Min_BP(j-s_min+1)==t_ppg
%             min_BP(i)=j;
%         end
%     end
% end
%% Ѱ��ԭʼBP�����϶�Ӧ�ķ�ֵ���λ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:length(indmax)
    if indmax(i)-60>0
        Max_BP=p(indmax(i)-60:indmax(i));
        s_max=indmax(i)-60;
    else
        Max_BP=p(1:indmax(i));
        s_max=1;
    end
    p_ppg=max(Max_BP);
    for j=s_max:1:indmax(i)
        if Max_BP(j-s_max+1)==p_ppg
            max_BP(i)=j;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end