%% ���ԸĽ�7-step���� 
function [add_delect_ppg]=improvements_to_7step(ppg,d)


[max_ppg]=find_peaks(d,ppg); %����R����Ϣ����ȡPPG�ź��з�ֵ��λ����Ϣ
for i=1:1:length(d)-1%�Դ洢������R����ֵ��λ����Ϣ���������ѭ��������ÿ��������R��֮���ppg��ֵ��
    m=1;
    s=1;
    num_max=[];%���ڴ洢����R����ֵ��֮���ppg��ֵ��λ����Ϣ
    %% ѭ�����ҵ�ǰ����R����ֵ��֮���PPG��ֵ��
    for j=1:1:length(max_ppg)%�Դ洢������B��ֵ��λ����Ϣ���������ѭ��
        if max_ppg(j)>d(i) && max_ppg(j)<d(i+1)%�жϸ�PPG��ֵ���Ƿ��ڵ�ǰ����R����ֵ��֮��
            num_max(m)=max_ppg(j);%�����ppg��ֵ������ڵ�ǰ����R����ֵ��֮�䣬��洢��num_max��
            m=m+1;
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    l_m=length(num_max);%��ȡ��ǰ����R����ֵ��֮���ppg��ֵ�����
    if l_m==1%�жϵ�ǰ����R����ֵ��֮���Ƿ����ҽ���һ��ppg��ֵ��P
        max_r(i)=num_max(1);%����ppg��ֵ��λ����Ϣ��������max_r��
    else%�����������Ϊ�쳣�����
        max_r(i)=0;%����ǰλ�ô���0
    end
end

add_delect_ppg=find(max_r==0);  %��PPG�쳣��λ����Ϣ�洢������add_delect_ppg


end
