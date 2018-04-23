function [new_a]=duplicatedelete(a)
b = unique(a);
c=[];
k=1;
len = length(b);
for i =1:len
    p =find(a==b(i));
    c(k)=p(1);
    k=k+1;
end
label = sort(c);
new_a = a(label);
end