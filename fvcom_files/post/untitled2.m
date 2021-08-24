a=[];
for i=1:30000
    if mod(i,3)==0 | contains(num2str(i),'3')
        a(i)=i;
    end
end


sum(a);


x=0;
y=0;
z=0;
for x=0:30
    for y=0:40
        for z=0:20
            
        end
    end
end

sss = a*a+b*b+c*c;

a=[];
l=1;
for i = 1:128
    for j=1:128
        k = sqrt(i*i+j*j);
        pp = rem(k,1);
        
        if pp==0 && j>=i
            a(l,1)=i;
            a(l,2)=j;
            a(l,3)=k;
            l=l+1;
        end
    end
end

500 Internal Server Error