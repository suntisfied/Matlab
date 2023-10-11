 close all;
clear all;
sca
Screen('Preference', 'SkipSyncTests', 1)
[a,b]=Screen('OpenWindow',0,[0 0 0]);

thick=4;
d2=400;
length=300;
m=[350 850 50 70];

H=round(rand(20,4))+1;
for ii=1:20;
H(ii,2)=mod(H(ii,1),2)+1;
H(ii,3)=H(ii,3)+2;
H(ii,4)=mod(H(ii,3),2)+1+2;
end

aa=randperm(20); 

for i=1:5
Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),1)) , d2, (m(1,H(aa(1,i),1)) +length), d2, thick);
Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),1)) , d2, (m(1,H(aa(1,i),1)) +m(1,H(aa(1,i),3)) ), (d2-m(1,H(aa(1,i),4)) ), thick);
Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),1)) , d2, (m(1,H(aa(1,i),1)) +m(1,H(aa(1,i),3)) ), (d2-m(1,H(aa(1,i),4)) )+2*(d2-(d2-m(1,H(aa(1,i),4)) )), thick);
Screen('DrawLine',a,[255 255 255], (m(1,H(aa(1,i),1)) +length), d2, (m(1,H(aa(1,i),1)) +length)-((m(1,H(aa(1,i),1)) +m(1,H(aa(1,i),3)) )-m(1,H(aa(1,i),1)) ), (d2-m(1,H(aa(1,i),4)) ), thick);
Screen('DrawLine',a,[255 255 255], (m(1,H(aa(1,i),1)) +length), d2, (m(1,H(aa(1,i),1)) +length)-((m(1,H(aa(1,i),1)) +m(1,H(aa(1,i),3)) )-m(1,H(aa(1,i),1)) ), (d2-m(1,H(aa(1,i),4)) )+2*(d2-(d2-m(1,H(aa(1,i),4)) )), thick);

Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),2)) , d2, (m(1,H(aa(1,i),2)) +length), d2, thick);
Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),2)) , d2, (m(1,H(aa(1,i),2)) -m(1,H(aa(1,i),3)) ), (d2-m(1,H(aa(1,i),4)) ), thick);
Screen('DrawLine',a,[255 255 255], m(1,H(aa(1,i),2)) , d2, (m(1,H(aa(1,i),2)) -m(1,H(aa(1,i),3)) ), (d2-m(1,H(aa(1,i),4)) )+2*(d2-(d2-m(1,H(aa(1,i),4)) )), thick);
Screen('DrawLine',a,[255 255 255], (m(1,H(aa(1,i),2)) +length), d2, (m(1,H(aa(1,i),2)) +length)-((m(1,H(aa(1,i),2)) -m(1,H(aa(1,i),3)) )-m(1,H(aa(1,i),2)) ), (d2-m(1,H(aa(1,i),4)) ), thick);
Screen('DrawLine',a,[255 255 255], (m(1,H(aa(1,i),2)) +length), d2, (m(1,H(aa(1,i),2)) +length)-((m(1,H(aa(1,i),2)) -m(1,H(aa(1,i),3)) )-m(1,H(aa(1,i),2)) ), (d2-m(1,H(aa(1,i),4)) )+2*(d2-(d2-m(1,H(aa(1,i),4)) )), thick);
Screen('Flip',a); 
KbStrokeWait;
end
KbStrokeWait;
close all;
clear all;
sca