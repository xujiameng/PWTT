%% ���Զ�BP��ֵѡȡģ�ͽ��иĽ�
function [max_BP]=find_peaks(d,BF)

l=length(d);
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
    [pks,locs] = findpeaks(i_BP);
%     if length(locs)==1
%         peak(i,1)=locs;
    if length(locs)==0
        peak(i,1)=0;
        else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            num=0;
            linshi=[];
            for tt=1:length(locs)
                bizhi=abs(( (( pks(tt)-BF( BP_begin(i) ) )-( max(pks)-BF(BP_begin(i)) ) ) / ( max(pks)-BF(BP_begin(i)) ) ));

                if  ( bizhi>0.6)   %ԭ����0.6
                    num=num+1;
                    linshi(num)=tt;
                end
            end
            locs(linshi)=[];
            %%%�����쳣��ʱ�ã���Ϊ��������ʱ��Ӱ��
            for jc=1:length(locs)
            jiancha(i,jc)=locs(jc);
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                     
            for tt=1:length(locs)
                peak(i,tt)=locs(tt);
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
%%%%%%%
clear peak;peak=jiancha;
%%%%%%%


order=1;
for i=1:1:length(BP_begin)
    for j=1:length(peak(i,:))
        if peak(i,j)~=0
           max_BP(order)=peak(i,j)+BP_begin(i);
           order=order+1;
        end
    end
end



order=0;
z=[];
for i=10:10:length(d)-10
    height=[];
    for h=1:10
        temp_BP(h,1)=BP_begin(i+h-10);
        temp=max_BP( (max_BP>d(i-10+h)) & (max_BP<d(i-9+h))  );
        temp_BP(h,2:length(temp)+1)=temp;
        for len=1:length(temp_BP(h,:))
            if temp_BP(h,len)~=0
                height(h,len)= BF(temp_BP(h,len))- BF(temp_BP(h,1));
            end
        end
    end

    the_mean=sum(height(:))/length(find( height(:)~=0 ));
    aim=[];
    if sum(height(:)<the_mean*0.4) & sum((height(find( (height<the_mean*0.4) )))~=0)
        aim=find( height<the_mean*0.4  &   height~=0  );
        for tt=1:length(find(aim))
            order=order+1;
            z(order)=temp_BP(aim(tt));
        end
    end
end
z=duplicatedelete(z);


order=0;
delect=[];
for i=1:length(z)
    linshi=find(max_BP==z(i));
    if linshi
        for j=1:length(linshi)
        order=order+1;
        delect(order)=linshi(j);
        end
    end
end
delect=delect(delect<max(max_BP));
max_BP(delect)=[];
        


    
end