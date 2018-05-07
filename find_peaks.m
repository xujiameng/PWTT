%% ���Զ�BP��ֵѡȡģ�ͽ��иĽ�
function [max_BP]=find_peaks(d,BF)

%Description��
% �ó�����Ϊ����ȡ���ݷ�ֵ��λ����Ϣ
% ����ԭ�����̣�
%     Step1: ����R����Ϣ�������ݣ�BP�źŻ�PPG�źţ��еķ�ֵ����Ϣ
%     Step2: ������������п��ܵ��쳣�㲢�޳�

%Inputs��
%     d��ECG��ֵ��λ��
%     BF���˲����BP�źŻ�PPG�ź�����

%Outputs��
%	  max_BP��BP��PPG��ֵ��λ��

%Calls��
%	�����������õĺ����嵥
%     findpeaks����ȡ���ܴ��ڵķ�ֵ��λ��

%Called By��
%	���ñ��������嵥
%      usdbyplot����ԭʼ�ź����ݻ�ȡ��ǳ��쳣��λ�õ�PWTT��BP,���˲�������ECG�źţ�PPG�źţ�BP�ź�

%V1.0��2018/5/7



%% ����R����Ϣ����BF��Ϣ�еķ�ֵ����Ϣ
l=length(d);   %��ȡR���������
for i=1:1:l-1
%     bg=1000*(50/1000);%����ÿ��������R��֮��ʹ�õ�BP���ݶε���㣨��R����ʼ���50ms��
bg=0;
    ed=(d(i+1)-d(i))*1;%������������R��֮��ʹ�õ�BP���ݶε��յ㣨��Ϊ���ݲ�һ����Ҫ�Ŀ�ȿ��ܲ�һ�����ʴ˴�û���������ݳ��ȣ�
    if ed<=bg
        bg=ed/10;
    end
    BP_begin(i)=d(i)+round(bg);%��ȡ��ǰBP���ݶε����
    BP_end(i)=d(i)+round(ed);%��ȡ��ǰBP���ݶε��յ�
end
for i=1:1:length(BP_begin)
    i_BP=[];
    i_BP=BF(BP_begin(i):BP_end(i));%��ȡ��ǰ��Ҫ�����BP���ݶ�
    [pks,locs] = findpeaks(i_BP);  %Ѱ�ҵ�ǰ�����ݶο��ܴ��ڵķ�ֵ��λ��
%     if length(locs)==1
%         peak(i,1)=locs;
    if length(locs)==0      %�Ե�ǰ���ݶο��ܴ��ڵķ�ֵ����������ж�
        peak(i,1)=0;
        else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            num=0;
            linshi=[];
            for tt=1:length(locs)
                bizhi=abs(( (( pks(tt)-BF( BP_begin(i) ) )-( max(pks)-BF(BP_begin(i)) ) ) / ( max(pks)-BF(BP_begin(i)) ) ));     %�����i�����ܵķ�ֵ������ߵĵ�Ĳ�ı���

                if  ( bizhi>0.6)   %�����ı�������0.6 ������Ϊ�õ㲢�Ƿ�ֵ��
                    num=num+1;
                    linshi(num)=tt;
                end
            end
            locs(linshi)=[];     %���ϲ��жϵķǷ�ֵ����Ϣ����ɾ����������ֵ����Ϣ
%             %%%�����쳣��ʱ�ã���Ϊ��������ʱ��Ӱ��
%             for jc=1:length(locs)
%             jiancha(i,jc)=locs(jc);
%             end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
            for tt=1:length(locs)
                peak(i,tt)=locs(tt);  %����ֵ����Ϣ���浽peak������
%                 bizhi=abs(( (( pks(1)-BF( BP_begin(i) ) )-( pks(tt)-BF(BP_begin(i)) ) ) / ( pks(1)-BF(BP_begin(i)) ) ));
%                 if  ( bizhi< 0.4 )   
%                     peak(i,1)=locs(1);
%                     peak(i,tt)=locs(tt);
%                 else
%                     peak(i,1)=locs( find(max(pks)==pks) );
%                 end
% %                 if  ( bizhi> 2 )  
% % %                     peak(i,1)=locs(tt);
% % %                 else
% %                     peak(i,1)=locs( find(max(pks)==pks) );
% %                 end
%                 if ( pks(1)*pks(tt) <0)
%                     peak(i,1)=locs( find(max(pks)==pks) );
%                     peak(i,2:end)=0;
%                 end
            end
%         end
    end
end
% %%%%%%%
% clear peak;peak=jiancha;
% %%%%%%%

%%  �����ֵ��λ����Ϣ��һά���� max_BP ��
order=1;
for i=1:1:length(BP_begin)
    for j=1:length(peak(i,:))
        if peak(i,j)~=0            % �����i��R������i+1��R����ĵ�j����ֵ����Ϣ��Ϊ������У�����Ϊ�õ�Ϊһ����Ч�ķ�ֵ�㣬����������Ĳ���
           max_BP(order)=peak(i,j)+BP_begin(i);  %�����ֵ����������Ϣ�е�λ�ã����洢��һά����max_BP��
           order=order+1;
        end
    end
end


%% Ѱ��������һ���쳣�㣬���õ��ֵ�ĸ߶�С�ڽ�10��������ֵ�߶�ƽ��ֵ��40%
order=0;
z=[];
for i=10:10:length(d)-10
    height=[];  %���ڴ洢��ֵ���Ӧ�ķ�ֵ�ĸ߶�
    for h=1:10
        temp_BP(h,1)=BP_begin(i+h-10);                           %��10���ź���ʼ��λ�ô��浽 temp_BP��:,1����
        temp=max_BP( (max_BP>d(i-10+h)) & (max_BP<d(i-9+h))  );  %������R�������еķ�ֵ������浽temp_BP��:,2,end����
        temp_BP(h,2:length(temp)+1)=temp;                        %������R�������еķ�ֵ������浽temp_BP��:,2,end����
        for len=1:length(temp_BP(h,:))
            if temp_BP(h,len)~=0        %�����h����ĵ�len����ֵλ����Ϣ��Ϊ�㣬���������Ĳ���
                height(h,len)= BF(temp_BP(h,len))- BF(temp_BP(h,1)); %����ÿ����ֵ�ĸ߶�
            end
        end
    end

    the_mean=sum(height(:))/length(find( height(:)~=0 ));
    aim=[];  %���ڴ洢����ʮ��R�����쳣��λ����Ϣ
    if sum(height(:)<the_mean*0.4) & sum((height(find( (height<the_mean*0.4) )))~=0) %���ĳ��߶�С��ƽ���߶ȵ�40%�Ҹ߶Ȳ�Ϊ�㣬����Ϊ�õ�Ϊ�쳣��
        aim=find( height<the_mean*0.4  &   height~=0  );
        for tt=1:length(find(aim))
            order=order+1;
            z(order)=temp_BP(aim(tt));  %�����������쳣��λ����Ϣ���浽����Z��
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             order=order+1;
%             z(order)=temp_BP(aim(tt)-1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
    end
end
z=unique(z);   %ȷ������z��û���ظ�����ֵ

%% ��Ѱ�ҵ����쳣�����ɾ��
order=0;
delect=[];   %���ڴ洢�쳣��λ����Ϣ
for i=1:length(z)
    linshi=find(max_BP==z(i));     % Ѱ�Ҳ���¼�쳣���ڴ����ֵλ����Ϣ�������е�λ����Ϣ
    if linshi                      %����쳣��������Ϊ�����������Ĳ���
        for j=1:length(linshi)
        order=order+1;
        delect(order)=linshi(j);   %���쳣����Ϣ��¼��delect������
        end
    end
end
delect=delect(delect<max(max_BP)); %ȷ���ܹ�����ɾ����Ӧ����
max_BP(delect)=[];     %���쳣��ӷ�ֵ����Ϣ�н���ɾ��
        


    
end