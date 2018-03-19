function ip1=normalize(ip1)
    mean1= mean(ip1);
    ip1=ip1-mean1;        
    M=max(ip1);
    ip1=ip1/M;
end