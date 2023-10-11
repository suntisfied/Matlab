clear all;
clc;
  

Screen('Preference', 'SkipSyncTests', 1)
KbName('UnifyKeyNames');

display=Screen('Resolution', 0); % always screen 1
params.res = [display.width, display.height];

% 모니터 사이즈 (학교: 1680 X 1050)
MSx = display.width;
MSy = display.height;


loc=[MSx/2-100 MSy/2-50 MSx/2+100 MSy/2+50];
sti(100, 50)=0;
mask(100, 50)=0;
probe(100, 50)=0;
fixation(100, 50)=0;
rp(432, 9)=0;
fImg='0000.jpg';
pImg='0000.jpg';
cnd=randperm(432);
mask=imread(strcat('images\', 'mask.jpg')); 

% --------------------------- to initialize condition ---------------------------------
for ii=0:2                              % word
    for jj=0:5                          % position
        for kk=0:5                      % condition: word, non-word, letter
            rp(ii*36+jj*6+kk+1,   :)=[1 ii+3 jj kk 0 0 0 0 0];
            rp(ii*36+jj*6+kk+109, :)=[1 ii+3 jj kk 0 1 0 0 0];
            rp(ii*36+jj*6+kk+217, :)=[1 ii+3 jj kk 1 0 0 0 0];
            rp(ii*36+jj*6+kk+325, :)=[1 ii+3 jj kk 1 1 0 0 0];
        end
    end
end

% fname_data=input('실험을 시작합니다. 이름의 영문 이니셜을 입력하세요.: ', 's'); 
%strcat(fname_data, '.txt');

% ========================== Experiment Trials =======================================
HideCursor;
[w, wRect]=Screen('OpenWindow', 0, [0 0 0], [0,0, MSx, MSy]);
fixation=imread(strcat('images\', 'fixation.jpg'));
Screen('Flip', w);

for ii=1:20
    Screen('DrawText', w, 'Ready? Press space key', MSx/2-150, MSy/2-79, 255);
    Screen('PutImage', w, fixation, loc);
    Screen('Flip', w);
    ready=GetChar;
    
    Screen('DrawText', w, '검사낱자가 그 위치에 제시되었던 낱자와                                          ', MSx/2-265, MSy/2-280, 127);
    Screen('DrawText', w, '다르면 [z] 키, 같으면 [/] 키를 누르세요!!                                           ', MSx/2-275, MSy/2-250, 127);
    Screen('Flip', w);
    
    fImg(1:4)=rp(cnd(ii), 1:4)+48;
    pImg=fImg;
%  pImg(2)=2+48;
    sti=imread(strcat('images\', fImg));
    pImg(1)=1-rp(cnd(ii), 5)+48;      % 0=same font, 1=different font
    if rp(cnd(ii), 6)==0            % sti char = probe char(4->4, 5->5)
        pImg(4)=4+48+mod(fImg(4),2);
    else                            % sti char != probe char(4->5, 5->4)
        pImg(4)=5+48-mod(fImg(4),2);         
    end
    probe=imread(strcat('images\', pImg));

    Screen('DrawText', w, '검사낱자가 그 위치에 제시되었던 낱자와                                          ', MSx/2-265, MSy/2-280, 127);
    Screen('DrawText', w, '다르면 [z] 키, 같으면 [/] 키를 누르세요!!                                           ', MSx/2-275, MSy/2-250, 127);
    Screen('PutImage', w, sti, loc);
    Screen('Flip', w);
    WaitSecs(0.084);
    
    Screen('DrawText', w, '검사낱자가 그 위치에 제시되었던 낱자와                                          ', MSx/2-265, MSy/2-280, 127);
    Screen('DrawText', w, '다르면 [z] 키, 같으면 [/] 키를 누르세요!!                                           ', MSx/2-275, MSy/2-250, 127);
    Screen('PutImage', w, mask, loc);
    Screen('Flip', w);
    WaitSecs(0.1);

    Screen('DrawText', w, '검사낱자가 그 위치에 제시되었던 낱자와                                          ', MSx/2-265, MSy/2-280, 127);
    Screen('DrawText', w, '다르면 [z] 키, 같으면 [/] 키를 누르세요!!                                           ', MSx/2-275, MSy/2-250, 127);
    Screen('PutImage', w, probe, loc);
    Screen('Flip', w);

    rp(cnd(ii), 8)=GetChar;
    Screen(w, 'FillRect', 0, loc);
    while rp(cnd(ii), 8) ~= '/' && rp(cnd(ii), 8) ~= 'z' 
         Screen(w, 'DrawText', '잘못누르셨습니다. [z]나 [/]를 눌러주세요.                                         ', MSx/2-270, MSy/2, 127);
         Screen('Flip', w);
         rp(cnd(ii), 8)=GetChar;
    end
   
    rp(cnd(ii), 7)=ii;                           % check whether response is right or not
    if rp(cnd(ii), 6)==0                        % test letter=probe letter
        if rp(cnd(ii), 8)=='/'                
            Screen('DrawText', w, 'Correct!',  MSx/2-50, MSy/2-84, 255);
            Screen('Flip', w);
            GetChar;
            rp(cnd(ii), 9)=1;
        else
            Screen('DrawText', w, 'Wrong!',  MSx/2-50, MSy/2-84, 255);
            Screen('Flip', w);
            GetChar;
            rp(cnd(ii), 9)=0;
        end
    else                                           % test letter !=probe letter
        if rp(cnd(ii), 8)=='z'
            Screen('DrawText', w, 'Correct!',  MSx/2-50, MSy/2-84, 255);
            Screen('Flip', w);
            GetChar;
            rp(cnd(ii), 9)=1;
        else
            Screen('DrawText', w, 'Wrong!',  MSx/2-50, MSy/2-84, 255);
            Screen('Flip', w);
            GetChar;
            rp(cnd(ii), 9)=0;
        end
    end
end 


Screen('DrawText', w, 'Thanks!', MSx/2-50, MSy/2-84, 255);
Screen('Flip', w);
GetChar;

Screen('CloseAll');
clear all;

