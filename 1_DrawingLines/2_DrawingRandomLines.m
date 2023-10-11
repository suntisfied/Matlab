[wptr, rect] = Screen('OpenWindow', 0, [0 0 0], [100 100 1124 868]);
clr=floor(rand(7, 500)*10000);
clr(1:3, :)=mod(clr(1:3, :),256);
clr(4:2:6, :)=mod(clr(4:2:6, :),1024);
clr(5:2:7, :)=mod(clr(5:2:7, :),768);

H=round(rand(100,2))+1;

for i=1:50
    Screen('DrawLine', wptr, [clr(1, i) clr(2, i) clr(3, i)], clr(4, i), clr(6, i), clr(5, i), clr(7, i));
end     
Screen('Flip', wptr);  

GetChar;  
Screen('CloseAll'); 
clear all; 
 