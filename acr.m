function acrvalue =acr(y,N)
   for k=0:N-1
       r1 = 0;
       r2=0;
       for n=1:N-k
           r1=r1+y(n)*y(n+k);
       end
       for n=1:N
           r2=r2+y(n)*y(n);
       end
       acrvalue(k+1,1)=r1/r2;
   end
end