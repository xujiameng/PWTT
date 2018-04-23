%% select_R
close all;
clc;
clear;
choose=1;
findpeaks_gap=700;
load 'D:/test/实验数据与程序/data转mat数据处理/对失血3的再改进.mat';



[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data,1,findpeaks_gap);
x=pwt2;
y=bp;
x(x==0|y==0)=0;%将pwtt中bp和pwtt的所有干扰点位置置0
y(x==0|y==0)=0;%将bp中bp和pwtt的所有干扰点位置置0
x(x==0)=[];%将pwtt中干扰点删除
y(y==0)=[];%将bp中干扰点删除


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if choose==0
i=0;
for gap=1:1:300
    i=i+1;
    RR(i,1)=gap;
    [RR(i,2),XX,YY]=test_R(x,y,gap);
    if RR(i,2)==min(RR(:,2))
        clear X;clear Y;
        X=XX;
        Y=YY;
    end
end
best_linear_R = min(RR(:,2))
best_linear_gap =  RR(   find(  RR(:,2)==min(RR(:,2))  )  ,  1  )
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
if choose==1
x_gap=length(x);
gap=ceil(0.03031*x_gap+0.54)
[R,X,Y]=test_R(x,y,gap);
linear_R = R
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 



%% 求取百分比变化数据
for i=1:length(X)-1
    for j=i+1:length(X)
        change_X(i,j)=(X(i)-X(j))/X(i);
        change_Y(i,j)=(Y(i)-Y(j))/Y(i);
    end
end

reshape_X=[];
reshape_Y=[];
for i=1:length(X)-1
    reshape_X=[ reshape_X, change_X(i,i+1:length(X)) ];
    reshape_Y=[ reshape_Y, change_Y(i,i+1:length(Y)) ];
end


%% 数据采集
test1_X=reshape_X(  find(    abs(reshape_Y)<=0.1   )   );
test1_Y=reshape_Y(  find(    abs(reshape_Y)<=0.1   )   );
 
test2_X=reshape_X(  find(    abs(reshape_Y)<=0.2 & abs(reshape_Y)>0.1   )  );
test2_Y=reshape_Y(  find(    abs(reshape_Y)<=0.2 & abs(reshape_Y)>0.1   )  );

test3_X=reshape_X(  find(    abs(reshape_Y)<=0.3 & abs(reshape_Y)>0.2   )  );
test3_Y=reshape_Y(  find(    abs(reshape_Y)<=0.3 & abs(reshape_Y)>0.2   )  );

test4_X=reshape_X(  find(    abs(reshape_Y)<=0.4 & abs(reshape_Y)>0.3   )  );
test4_Y=reshape_Y(  find(    abs(reshape_Y)<=0.4 & abs(reshape_Y)>0.3   )  );

test5_X=reshape_X(  find(    abs(reshape_Y)<=0.5 & abs(reshape_Y)>0.4   )  );
test5_Y=reshape_Y(  find(    abs(reshape_Y)<=0.5 & abs(reshape_Y)>0.4   )  );

%% 根据拟合标准R，挑选出最优区间
    R1=corrcoef( test1_X,test1_Y );  R(1)=R1(1,2); 
    R2=corrcoef( test2_X,test2_Y );  R(2)=R2(1,2);
    R3=corrcoef( test3_X,test3_Y );  R(3)=R3(1,2);
    R4=corrcoef( test4_X,test4_Y );  R(4)=R4(1,2);
    R5=corrcoef( test5_X,test5_Y );  R(5)=R5(1,2);
   
    best_change_R = R(    find( R(:) == min( R ) )   )
    best_change_Part = find( R == min( R ) )
    min_best_change_pwtt = min(test2_X) 
    max_best_change_pwtt = max(test2_X) 
