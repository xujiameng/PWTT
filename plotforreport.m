clear all;
clc;


load 'ʵ������/ʵ������3/mat/data2/data2_01';
[pwt2,BP,bp,p,uu,tt,tt_pwt2]=usedbyplot(data);


%% ��ͼ����

%% ��ҩǰ������1

begin=450*250;   END=length(data); 
figure('Name','���ߡ�����1','NumberTitle','off'); 




subplot(3,1,1)
plot(tt(begin:END),p(begin:END)); 
ylabel('PPG');   xlabel('ʱ��/s'); 
set(gca,'XTickLabel',[480,495,509,524,538,553,567,582,596,611,625])
set(gca,'FontSize',16)
ylim([-2,4])


subplot(3,1,2)
plot(tt(begin:END),uu(begin:END)); 
ylabel('�ĵ�/mV');   xlabel('ʱ��/s'); 
set(gca,'XTickLabel',[480,495,509,524,538,553,567,582,596,611,625])
set(gca,'FontSize',16)



subplot(3,1,3)
plot(tt(begin:END),BP(begin:END)); 
ylabel('Ѫѹ/mmHg');   xlabel('ʱ��/s');   
set(gca,'XTickLabel',[480,495,509,524,538,553,567,582,596,611,625])
set(gca,'FontSize',16)

%% ��ҩǰ������2
begin=floor((begin/length(data))*length(pwt2));  
figure('Name','���ߡ�����2','NumberTitle','off'); 
subplot(2,1,1)
plot(tt_pwt2(begin:end),pwt2(begin:end)); 
ylabel('PWTT');   xlabel('ʱ��/s');   
set(gca,'XTickLabel',[480,504,528,553,577,601,625])

subplot(2,1,2)
plot(tt_pwt2(begin:end),bp(begin:end)); 
ylabel('Ѫѹ��ֵ/mmHg');   xlabel('ʱ��/s');   
set(gca,'XTickLabel',[480,504,528,553,577,601,625])

 
