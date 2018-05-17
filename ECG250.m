function [st_ll,d,uu]=ECG250(ecg,fs)

%Description��
% �ó�����Ϊ����ECG�źŽ����˲�����ȡ��ֵλ����Ϣ
% ����ԭ�����̣�
%     Step1:  ECG����Ԥ����
%     Step2: Ѱ��Ԥ���������ݵ�R����ֵ��
%     Step4: Ѱ�Ҳ��޳��ж��쳣��R����ֵ��
%     Step4: Ѱ��ԭʼECG�źŵķ�ֵ��λ��

%Inputs��
%     ecg��ԭʼECG�ź�
%     fs������Ƶ��

%Outputs��
%	  st_ll��Ԥ���������ݵ�R����ֵ��
%     d����ȡ��ǰR����ֵ��λ��
%     uu������ȥ��������

%Calls��
%	�����������õĺ����嵥
%     detrend��������ȥ��������;
%     fir1���ô����������������λFIRDF�Ĺ����亯��
%     filter��ʹ����λ�Ƶ��˲��������˲�
%     detectionRR2����ȡECG�źŷ�ֵ��Ϣ

%Called By��
%	���ñ��������嵥
%     usdbyplot����ԭʼ�ź����ݻ�ȡ��ǳ��쳣��λ�õ�PWTT��BP,���˲�������ECG�źţ�PPG�źţ�BP�ź�

%V1.0��2018/5/7
%V1.1��2018/5/17



%% ECG����Ԥ����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p=ecg;
tr=length(p);
%��һ����ȥ��������
lo=(p-mean(p))/std(p);%���ݹ�һ�� x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
uu=detrend(lo);%����ȥ��������
%���FIR��ͨ�˲���
fc1=22;%ͨ�����޽�ֹƵ��5hz
fc2=26;%ͨ�����޽�ֹƵ��26hz
b=fir1(60,[2*fc1/fs,2*fc2/fs]);%����FIR�˲�����������Ϊ60
SF=filter(b,1,uu);%ʹ�ø��˲��������˲�
SF=SF';
%�õ��˲����źŵĵ���
t=1:1:tr;
a=diff(SF)./diff(t);%�󵼣�R��б�ʴ�ͻ��R��

c=abs(a);%�����ֵ

for hh=1:tr-20*4
    as(hh)=mean(c(hh:hh+(20*4)-1));%��80ms��ƽ��ֵ���ƶ�����
end
% as=as(101:end);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

%% Ѱ��Ԥ���������ݵ�R����ֵ��
o_as=as/max(as);%��Ԥ�������ĵ����ݽ��й�һ��
[heartRate,peak,threshold]  = detectionRR2(o_as,fs);%��  ��һ��  ��ECG��R����ֵ��
pk=find(peak~=0);%�ҳ�R����ֵ������λ�ú͸���
    %% �����δ�ֶ�ǰ�����ݽ���R����ֵ���֮��R����ֵ���������25������Ϊû�г����쳣��������ý��зֶδ���
    %����ֱ�ӶԼ�⵽��R����ֵ����д�����ȥ��ʱ��Ӧ��Ԥ����֮���ECG��
    pk=pk-60;
    for i=1:1:length(pk)
        if pk(i)<=0
            pk(i)=0;
        end
    end
    p_ll=find(pk~=0);
    pk=pk(p_ll(1):end);
    
 %%%%%ȥ��ECG�źŴ���ķ�ֵ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cache=[];
    min_interval=(60/250)*fs;
    num=0;
    for i=1:length(pk)-1
        if pk(i+1)-pk(i)<min_interval
            num=num+1;
            cache(num,1)=pk(i);
            cache(num,2)=i;
        end
    end
    if size(cache,1)>1
        num=0;
        for i=1:size(cache,1)-1
            if cache(i+1,2)-cache(i,2)==1
                num=num+1;
               if o_as(cache(i+1,1)) > o_as(cache(i,1))
                   zhiling(num)=i+1;
               else
                   zhiling(num)=i;
               end
            end
        end
        cache(zhiling,1)=0;
    end
    if size(cache,1)>1
        cache((cache(:,1)==0),:)=[];
        for i=1:size(cache,1)
            pk(pk==cache(i,1))=0;
        end
        p_ll=find(pk~=0);
        pk=pk(p_ll);
     end
    
    %%%%%%%%%%%%%%%%%%%%%%%%   
    st_ll=pk;


%% Ѱ��ԭʼECG�źŵķ�ֵ��λ��
%Ԥ������ECG�ҵ���R����ֵ��Ա�ԭʼECG���ݵ�R����ֵ�㣬һ���ӳ���30��������֮��
%����������Ԥ������ECG�ҵ���R����ֵ��λ�õĻ����ϣ���ԭʼECG������ǰ��30��������ֵ
%�����ֵ��Ϊ��Ӧ��ԭʼECG��R����ֵ��λ��
 %p=p(101:end);%��ΪԤ������ECGǰ�����Ǵ���һ���ϴ��ֵ�㵼�º����޷���⣬ɾ����ǰ��100���㣬����ԭʼECGҲɾ��ǰ��100����
l_ll=length(st_ll);%��ȡR����ֵ��ĸ���
for i=1:1:l_ll
    if st_ll(i)-50>0
       % pp(:,i)=p(ll(i)-20:ll(i));
        pp=p(st_ll(i)-50:st_ll(i));%��ȡ��ǰR����ֵ��λ�õ�ǰ��30������
        m=st_ll(i)-50;
    else
        pp=p(1:st_ll(i));
        m=1;
    end
    RRpeak=max(pp);%��ȡ���������ֵ
    for n=m:1:st_ll(i)
        if pp(n-m+1)==RRpeak%Ѱ����30�������е������ֵ�ĵ㣬��ΪR����ֵ��
            d(i)=n;%��ȡ��ǰR����ֵ��λ��
        end
    end
end


end