function op=decay_factor(ip1)
sum=0;
sm=0;
L=length(ip1);
for i=1:L
    sum=sum+ip1(i)*ip1(i);
end
for i=1:20
    sm=sm+ip1(i)*ip1(i);
end
op=sm/sum;