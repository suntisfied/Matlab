
% ============= Font effect experiment in WordSuperiorityEffect ================== 
% ================== short stimulus duration (47.1ms) ===========================
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
sd=47.1;
sti(100, 50)=0;
mask(100, 50)=0;
probe(100, 50)=0;
fixation(100, 50)=0;
rp(432, 10)=0;
fImg='0000.jpg';
pImg='0000.jpg';
cnd=randperm(432);
mask=imread(strcat('images\', 'mask.jpg'));


% --------------------------- to initialize condition ---------------------------------
for ii=0:2                              % word: 사용된 낱말
    for jj=0:5                          % position: 초중종, 초중종
        for kk=0:5                      % condition: word, non-word, letter
            rp(ii*36+jj*6+kk+1,   :)=[1 ii jj kk 0 0 0 0 sd 0];
            rp(ii*36+jj*6+kk+109, :)=[1 ii jj kk 0 1 0 0 sd 0];
            rp(ii*36+jj*6+kk+217, :)=[1 ii jj kk 1 0 0 0 sd 0];
            rp(ii*36+jj*6+kk+325, :)=[1 ii jj kk 1 1 0 0 sd 0];
        end
    end
end

fname_data=input('실험을 시작합니다. 이름의 영문 이니셜을 입력하세요.: ', 's'); 

% ========================== Experiment Trials =======================================
HideCursor;
[w, wRect]=Screen('OpenWindow', 0, [0 0 0], [0,0, MSx, MSy]);
fixation=imread(strcat('images\', 'fixation.jpg'));
Screen('Flip', w);

for ii=1:432
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
    WaitSecs(0.047);
    
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
    Screen('FillRect', w, 0, loc);
    while rp(cnd(ii), 8) ~= '/' && rp(cnd(ii), 8) ~= 'z' 
         Screen('DrawText', w, '잘못누르셨습니다. [z]나 [/]를 눌러주세요.                                         ', MSx/2-270, MSy/2, 127 );
         Screen('Flip', w);
         rp(cnd(ii), 8)=GetChar;
    end
   Screen('FillRect', w, 0, [MSx/2-312, MSy/2-134, MSx/2+188, MSy/2+216]);
    
    rp(cnd(ii), 7)=ii;                           % check whether response is right or not
    if rp(cnd(ii), 6)==0                        % test letter=probe letter
        if rp(cnd(ii), 8)=='/'                
            rp(cnd(ii), 10)=1;
        else
            rp(cnd(ii), 10)=0;
        end
    else                                           % test letter !=probe letter
        if rp(cnd(ii), 8)=='z'
            rp(cnd(ii), 10)=1;
        else
            rp(cnd(ii), 10)=0;
        end
    end
end 

Screen('DrawText', w, 'Please wait', MSx/2-50, MSy/2-84, 255);
Screen('Flip', w);
GetChar;

TimeInfo=num2str(fix(clock));
TimeInfo(TimeInfo==' ') = '';
fdat=strcat('data\Condi_47ms_set1_', fname_data, '_', TimeInfo);  % WordSuperiorityEffect f=font exp, s=short duration

instr={'img_num1', 'img_num2', 'img_num3', 'stimType', 'fontType_testStim', 'letterMatch', 'order_stim', 'response', 'duration_stim', 'CorrectOrNot'};
resultdata=mat2cell(rp, ones(1, 432), ones(1, 10));
output=vertcat(instr, resultdata);
xlswrite(fdat, output);  


Screen('DrawText', w, 'All Done\n\nThanks!\n\nPress esc key', MSx/2-50, MSy/2-84, 255);
Screen('Flip', w);

KbName('UnifyKeyNames');
while 1
    [keyIsDown, Secs, keyCode]=KbCheck;
    if keyIsDown
        if keyCode(KbName('ESCAPE'))
            break;
        end
    end
end
Screen('CloseAll');
clear all; 