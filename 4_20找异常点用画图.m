

figure(1)
plot(uu/3)
hold on 
plot(p)
plot(rise(398:400),p(rise(398:400)),'d','LineWidth',2)
hold on 
plot(d(398:400),uu(d(398:400))/3,'k+','LineWidth',2)
hold on 
plot(max_BP,p(max_BP),'p')

    

figure(2)
plot(uu/3)
hold on 
plot(d(398:400),uu(d(398:400))/3,'k+','LineWidth',2)
hold on 
plot(BF)
hold on 
plot(max_BP(390:410),BF(max_BP(390:410)),'p','LineWidth',2)


plot(p)
hold on 
plot(uu)
hold on 
plot(BF)



len=480;
sum=0;
for i=len:-1:2
    sum=sum+i;
end
j=1;SUM=0;
while SUM<sum/(30/29)
    SUM=SUM+(len-j)
    j=j+1;
end
j/len