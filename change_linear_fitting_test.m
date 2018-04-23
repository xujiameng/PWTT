function [mean_inc_changemap,mean_red_changemap]=change_linear_fitting_test(x,y)

l=length(y);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gap=3;
gap=gap/100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ����ѡ��������ֵ
for i=1:l
   increase_threshold_value(i,1)=y(i)*(1.1-gap);
   increase_threshold_value(i,2)=y(i)*(1.1+gap);
   
   increase_threshold_value(i,3)=y(i)*(1.2-gap);
   increase_threshold_value(i,4)=y(i)*(1.2+gap);
   
   increase_threshold_value(i,5)=y(i)*(1.3-gap);
   increase_threshold_value(i,6)=y(i)*(1.3+gap);
   
   increase_threshold_value(i,7)=y(i)*(1.4-gap);
   increase_threshold_value(i,8)=y(i)*(1.4+gap);
end
   
%% ����ѡ��������ֵ
for i=1:l
   reduce_threshold_value(i,1)=y(i)*(0.9-gap);
   reduce_threshold_value(i,2)=y(i)*(0.9+gap);
   
   reduce_threshold_value(i,3)=y(i)*(0.8-gap);
   reduce_threshold_value(i,4)=y(i)*(0.8+gap);
   
   reduce_threshold_value(i,5)=y(i)*(0.7-gap);
   reduce_threshold_value(i,6)=y(i)*(0.7+gap);
   
   reduce_threshold_value(i,7)=y(i)*(0.6-gap);
   reduce_threshold_value(i,8)=y(i)*(0.6+gap);
end


%% Ϊÿһ����j��¼��������i����һ�����λ��len

for j=1:l
    for i=1:4
    
        
        temporary=find(   y>=increase_threshold_value(j,2*i-1) & y<=increase_threshold_value(j,2*i)  );
        if sum(temporary)~=0
            for len=1:length(temporary)
                increase_change(j,i,len)=temporary(len);
            end
        end 
        temporary=find(   y>=reduce_threshold_value(j,2*i-1) & y<=reduce_threshold_value(j,2*i)  );
        if sum(temporary)~=0
            for len=1:length(temporary)
                reduce_change(j,i,len)=temporary(len);
            end
        end

        
    end
end

%% ��� y�仯��iʱ x�仯��

for i=1:length(   increase_change   )
    tem_ori_x=x(i);
    for time=1:4
        for j=1:length(   increase_change(i,time,:)    )
            if increase_change(i,time,j)~=0
                tem_det_x= x(increase_change(i,time,j));
            else
                tem_det_x=0;
            end
            inc_changemap(time,i,j)=(tem_det_x-tem_ori_x)/tem_ori_x;   
        end     
    end
end
    
  
    
for i=1:length(   reduce_change   )
    tem_ori_x=x(i);
    for time=1:4
        for j=1:length(   reduce_change(i,time,:)    )
            if  reduce_change(i,time,j)~=0
                tem_det_x= x( reduce_change(i,time,j));
            else
                tem_det_x=0;
            end
            red_changemap(time,i,j)=(tem_det_x-tem_ori_x)/tem_ori_x;
        end
    end
end

        
   

%%%��ÿһ����̶��ı仯��ȡƽ�� ������ÿһ��ӳ��ı仯��ȥ���쳣��(��ʱδʵ��)
for i=1:length(   inc_changemap   )
    for j=1:4
        mean_inc_changemap(i,j)=sum( red_changemap(find(inc_changemap(j,i,:)~=-1)) )/length( find(inc_changemap(j,i,:)~=-1) );
    end
end


       
for i=1:length(  red_changemap   )
    for j=1:4
         mean_red_changemap(i,j)=sum( red_changemap(find(red_changemap(j,i,:)~=-1)) )/length( find(red_changemap(j,i,:)~=-1) );
    end
end


end

   
   