clc;clear all;
[ip,Fs] = audioread('b1.wav');
ip1=ip(1:600000,1);
L=length(ip1);
sec=rem(L,32000);
last=(L-sec)/32000;
ip1=normalize(ip1);
L=length(ip1);
[applause,decay_val,first_zerocross,total_block]=blockprocessing(ip1);
subplot(2,1,1);
plot(smooth(decay_val,'rloess'));
subplot(2,1,2);
plot(smooth(first_zerocross,'rloess'));
blockcount=0;
for i=1:total_block
    count=0;
    for j=1:250
        if((decay_val((i-1)*250+j)>0.5)&&(decay_val((i-1)*250+j)<0.9))
            count=count+1;
        end
    end
    if(count>128)
        blockcount=blockcount+1;
        applause_block(blockcount)=i;
    end  
end
 interval=[];
    for i=1:blockcount
        interval(i,1)= (applause_block(i)-1)*2;
        interval(i,2)=(applause_block(i))*2;  
        
    end
    vidObj=VideoReader('b1.flv.mpg');
[audio,fs]=audioread('b1.wav');
audio=audio(:,1);
framesPerSecond = get(vidObj,'FrameRate');
framesPerSecond=int16(framesPerSecond);
numFrames = get(vidObj,'NumberOfFrames');

l=length(interval);
for i=1:l
audio1=audio(fs*interval(i,1)+1 : fs*interval(i,2));
 video = read(vidObj,[1+framesPerSecond*interval(i,1) framesPerSecond*interval(i,2)]);
 vidfinal(i,:,:,:,:)=video;
 audfinal(i,:)=audio1;
h = implay(video,30);

play(h.DataSource.Controls);

 sound(audio1,fs);
end
h = implay(vidfinal,30);

play(h.DataSource.Controls);

 sound(audfinal,fs);
 clear audio1;
 clear video;
clear i;
clear j;
clear sec;
clear Con;
clear count;
clear L;
clear Filter;
  

