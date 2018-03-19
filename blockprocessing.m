function [applause,decay_val,first_zerocross,k]=blockprocessing(Con)
   L=length(Con);
count=0;
     c=0;
     decay_val=[];
     decay_val=0;
    big_block= blocking(Con,L,32000);
    l=size(big_block);
    k=l(1,1);
    e=0;
    en=0.3;
    ham=hamming(256);
    Ham=ham';
    for i=1:k
        e=0;
        for j=1:l(1,2)
            e= e+big_block(i,j)*big_block(i,j);
        end
             if(e<0.3)
                continue;
            end
        shift_block=big_block(i,:);
        next_block=buffer(shift_block,256,128);
        small_block=next_block';
        g=size(small_block);
        en=.01;
        for x=1:250
            for r=1:256
                final_block(r)= small_block(x,r)*Ham(r);
            end
            e=0;
            decay_val((i-1)*250+ x)=1;
            for j=1:256
                e= e+final_block(j)*final_block(j);
                
            end
            if(e<en)
                decay_val((i-1)*250 + x)=0;
                continue;
            end
            
            acrvalue(i,x,:)=acr(final_block,256);
            zcr1=zcr(acrvalue(i,x,:));
            first_zerocross((i-1)*250 + x,1)=zcr1(1);
            decay_val((i-1)*250 + x)=decay_factor(acrvalue(i,x,:));
            decay_value=decay_val((i-1)*250 + x);
            if((decay_value>0.6)&&(decay_value<0.8))
                count=count+1;
                applause(count,1)=i;
                applause(count,2)=x;
                applause(count,3)=decay_value;
                applause(count,4)= (i-1)*32000 + x;
            end
        end        
    end
end
