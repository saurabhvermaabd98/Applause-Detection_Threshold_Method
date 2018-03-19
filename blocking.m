function xnew= blocking(y,L,Bs)
r=mod(L,Bs);
if  r== 0
    n=L/Bs;
else
    n=(L-r)/Bs+1;
    y((n-1)*Bs+r+1:(n)*Bs,1)=0;
end
for i=1:n
    xnew(i,:)=y((i-1)*Bs+1:i*Bs);
end
end