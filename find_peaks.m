%% 尝试对BP峰值选取模型进行改进
function [max_BP]=find_peaks(d,BF)

l=length(d);
for i=1:1:l-1
%     bg=1000*(50/1000);%定义每相邻两个R波之间使用的BP数据段的起点（即R波开始后的50ms）
bg=0;
    ed=(d(i+1)-d(i))*1;%定义相邻两个R波之间使用的BP数据段的终点（因为数据不一样需要的宽度可能不一样，故此处没有限制数据长度）
    if ed<=bg
        bg=ed/10;
    end
    BP_begin(i)=d(i)+round(bg);%获取当前BP数据段的起点
    BP_end(i)=d(i)+round(ed);%获取当前BP数据段的终点
end
for i=1:1:length(BP_begin)
    i_BP=[];
    i_BP=BF(BP_begin(i):BP_end(i));%获取当前需要处理的BP数据段
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

                if  ( bizhi>0.6)   %原来是0.6
                    num=num+1;
                    linshi(num)=tt;
                end
            end
            locs(linshi)=[];
            %%%检验异常点时用，作为函数运行时不影响
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