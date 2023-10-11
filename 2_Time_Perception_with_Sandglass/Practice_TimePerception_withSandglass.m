clear all
close all

Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
[w,rect]=Screen('OpenWindow',2);

%number of each conditions
cond_a=2; cond_b=2; cond_c=2; cond_d=6;
cond=cell(cond_a*cond_b*cond_c*cond_d,1);

%matrix of conditions
con_t=0;
for ia=1:cond_a
    for ib=1:cond_b
        for ic=1:cond_c
            for id=1:cond_d
                con_t=con_t+1;
                cond{con_t,1}=[ia; ib; ic; id];
            end
        end
    end
end

%random order of conditions
randO=randperm(cond_a*cond_b*cond_c*cond_d);
Rcond=cell(cond_a*cond_b*cond_c*cond_d,1);

for Ri=1:cond_a*cond_b*cond_c*cond_d
    Rcond{Ri,1}=cond{randO(Ri),1};
end

KbName('UnifyKeyNames');
esc = KbName('ESCAPE');
enter = KbName('return');
space = KbName('Space');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
LS=KbName('LeftShift');
RS=KbName('RightShift');
C=KbName('c');
S=KbName('s');

cenP=[rect(3)/2 rect(4)/2];
glass_W=rect(3)/2.6;
glass_H=rect(4)/1.6;
glass_PW=18;
upL=[cenP(1)-(glass_W/2) cenP(2)-(glass_H/2)];
upR=[cenP(1)+(glass_W/2) cenP(2)-(glass_H/2)];
downL=[cenP(1)-(glass_W/2) cenP(2)+(glass_H/2)];
downR=[cenP(1)+(glass_W/2) cenP(2)+(glass_H/2)];

cenLP=[rect(3)/2-(glass_PW/5) rect(4)/2];
cenRP=[rect(3)/2+(glass_PW/5) rect(4)/2];
upLL=[cenP(1)-(glass_W/2)-(glass_PW/5) cenP(2)-(glass_H/2)];
upRR=[cenP(1)+(glass_W/2)+(glass_PW/5) cenP(2)-(glass_H/2)];
downLL=[cenP(1)-(glass_W/2)-(glass_PW/5) cenP(2)+(glass_H/2)];
downRR=[cenP(1)+(glass_W/2)+(glass_PW/5) cenP(2)+(glass_H/2)];

rect_color=[166 166 166];
frame_color=[0 0 0];
back_color=[255 255 255];
obs_color=[255 255 255];

bar_time1=5;
bar_time2=10;
bar_time3=15;
bar_time4=20;
bar_time5=25;
bar_time6=7;

grey=[166 166 166];
red=[255 0 0];
% orange=[255 187 0];
yellow=[255 228 0];
green=[29 219 22];
blue=[0 84 255];
% purple=[128 65 217];

first=1;
second=1;
third=1;
fourth=1;
fifth=1;
sixth=1;


ans_total=nan(24,13);
time=nan(24,1);

tbar_time=(bar_time6+bar_time1)/2;
ts_time= Screen('GetFlipInterval', w);
tv=(downL(2)-cenP(2))/(tbar_time/ts_time);
tx=upL(2):tv:cenP(2);
tx(length(tx))=cenP(2);
WaitSecs(0.01)

% wait=0.01;
tettime=nan(length(tx),1);

HideCursor

crectW=50;
crectH=50;
crectB=100;
mA_x1=(rect(3)/2)-(((crectW*4)+(crectB*3))/2);
%     mA_x1=(rect(3)/2)-(((crectW*6)+(crectB*5))/2);
mA_y1=((rect(4)/2)+(crectH/2))-(rect(4)/3);
mA_y2=mA_y1+crectH;
TS=30; % textsize
BTR=30; % between text and rect
Screen('TextFont', w, '맑은고딕');
Screen('TextSize', w, TS);
Screen('TextStyle', w, 1);

mA_x=nan(4,1);%(6,1);
for i=2:4%6
    mA_x(i,1)=mA_x1+(crectW*(i-1))+(crectB*(i-1));
end
mA_x(1,1)=mA_x1;

rc=cell(4,1);%(6,1); %rectcolor
%     rc{1,1}=red; rc{2,1}=orange; rc{3,1}=yellow; rc{4,1}=green; rc{5,1}=blue; rc{6,1}=purple;
rc{1,1}=red; rc{2,1}=yellow; rc{3,1}=green; rc{4,1}=blue;

btr=23; % between number text and rect

mA_xx=cell(4,1);%(6,1);
for i=1:4%6
    mA_xx{i,1}=[mA_x(i,1), mA_y1, mA_x(i,1)+crectW, mA_y2];
end


ptext1=0;
while ptext1~=1
    [Keyisdown, Secs, keyCode] = KbCheck;
    WaitSecs(0.001) % delay to prevent CPU hogging
    if keyCode(enter)
        ptext1=1;
    elseif ptext1==0     
        for i=1:4%6
            Screen('FillRect', w, rc{i,1}, mA_xx{i,1})
        end
        DrawFormattedText(w, '위의 네 가지 색을 구분하실 수 있는 분은 엔터를 누르세요.\n\n\n구분이 어려우신 분은 실험자께 말씀해주세요.', 'center', 'center', [0 0 0]);
        Screen('Flip',w)
    end
end

WaitSecs(1)

ptext=0;
while ptext~=1
    [Keyisdown, Secs, keyCode] = KbCheck;
    if keyCode(enter)
        ptext=1;
    elseif ptext==0
    WaitSecs(0.001) % delay to prevent CPU hogging
    DrawFormattedText(w, '다음의 글을 다 읽으신 후 엔터키를 누르면 빈 화면이 나타납니다.\n\n\n실험에 필요한 기본 설정 중이오니 완료 문구가 나올 때까지 기다려주세요.\n\n\n시간이 오래 걸릴 수 있습니다.\n\n\n빈 화면이 보이는 중에 키보드와 마우스는 만지지 말아주세요.', 'center', 'center', [0 0 0]);
    Screen('Flip',w)
    end
end
WaitSecs(0.1);
tetime1=GetSecs;
Priority(2)
WaitSecs(ts_time)
for i=1:length(tx)
    te_time11=GetSecs;
    Screen('FillRect', w, [255 255 255], [upL(1) tx(i) downR(1) tx(i)+(downL(2)-cenP(2))])
    Screen('FramePoly', w, [255 255 255], [upL; upR; cenP], glass_PW);
    Screen('FramePoly', w, [255 255 255], [downL; downR; cenP], glass_PW);
    Screen('FillPoly', w, [255 255 255], [upLL; cenLP; downLL]);
    Screen('FillPoly', w, [255 255 255], [upRR; cenRP; downRR]);
    Screen('FillRect', w, [255 255 255], [upL(1)-20 cenP(2) downR(1)-20 downL(2)-20])
    Screen('Flip',w)
    te_time111=GetSecs;
    te_time10=te_time111-te_time11;
    te_wait=ts_time-te_time10-0.0002;
    WaitSecs(te_wait)
    te_time1111=GetSecs;
    tettime(i,1)=te_time1111-te_time11;
end
Priority(0)
tetime2=GetSecs;
tetime=tetime2-tetime1;
s_time=(tetime)/length(tx);%0.0334;%s_time2-s_time1;
%     s_time=(tetime-(wait*length(tx)))/length(tx);

tev=0;
while tev~=1 
    
    [Keyisdown, Secs, keyCode] = KbCheck;
    WaitSecs(0.001) % delay to prevent CPU hogging
        
    if sum(tettime)<((ts_time+0.005)*length(tx))
        DrawFormattedText(w, '완료되었습니다. 엔터를 누르면 다음 단계로 넘어갑니다.', 'center', 'center', [0 0 0]);
        Screen('Flip',w)
        
    elseif sum(tettime)>((ts_time+0.005)*length(tx))
        DrawFormattedText(w, '재설정이 필요합니다. wait값을 조정하세요.', 'center', 'center', [0 0 0]);
        Screen('Flip',w)
    end
        
    if keyCode(enter)
        tev=1;
    end
end

WR=0;
while WR<=(cond_a*cond_b*cond_c*cond_d)-1
    WR=WR+1;
    Pcond=Rcond{WR,1};
    
    HideCursor
    
    WaitSecs(0.1)   
    
    if Pcond(4,1)==1 % time1
        bar_time=bar_time1;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(4,1)==2 % time2
        bar_time=bar_time2;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(4,1)==3 % time3
        bar_time=bar_time3;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(4,1)==4 % time4
        bar_time=bar_time4;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(4,1)==5 % time5
        bar_time=bar_time5;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(4,1)==6 % time6
        bar_time=bar_time6;
        v=(downL(2)-cenP(2))/(bar_time/s_time);
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(1,1)==1 % downward
        x=upL(2):v:cenP(2);
        x(length(x))=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(1,1)==2 % upward
        x=cenP(2):-v:upL(2);
        x(length(x))=upL(2);
        WaitSecs(0.01)
    end
    if Pcond(2,1)==1 && Pcond(1,1)==1 % decrease, downward
        obs_y2=cenP(2); obs_y4=downL(2)+20;
        WaitSecs(0.01)
    end
    if Pcond(2,1)==1 && Pcond(1,1)==2 % decrease, upward
        obs_y2=upL(2)-20; obs_y4=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(2,1)==2 && Pcond(1,1)==1 % increase, downward
        obs_y2=upL(2)-20; obs_y4=cenP(2);
        WaitSecs(0.01)
    end
    if Pcond(2,1)==2 && Pcond(1,1)==2 % increase, downward
        obs_y2=cenP(2); obs_y4=downL(2)+20;
        WaitSecs(0.01)
    end
    
    messageA = '다음 중 제시되지 않은 한 가지 색을 골라주세요.';
    messageB = '수행하신 색 변별과제의 난이도를 표현해주세요.';
    messageC1 = '수행하신 과제의 모레시계 속 모래는 몇 초분량만큼 남았는지를 어리짐작하여 표현해주세요.';
    messageC2 = '수행하신 과제의 모레시계 속 모래는 몇 초분량동안 지나갔는지를 어리짐작하여 표현해주세요.';    
    
    if Pcond(3,1)==1
        messageC=messageC1;
        
    end
    if Pcond(3,1)==2
        messageC=messageC2;
    end
    
    tcolor=first+second+third;%+fourth+fifth;%+sixth;
    
    ofirst=floor((first/tcolor)*length(x));
    osecond=floor((second/tcolor)*length(x));
    othird=floor((third/tcolor)*length(x));
%     ofourth=floor((fourth/tcolor)*length(x));
%     ofifth=floor((fifth/tcolor)*length(x));
    %osixth=floor((sixth/tcolor)*length(down_x1));
    
    color=cell(length(x),1);
    
    o1=ofirst;
    o2=ofirst+osecond;
    o3=ofirst+osecond+othird;
%     o4=ofirst+osecond+othird+ofourth;
%     o5=ofirst+osecond+othird+ofourth+ofifth;
    %o6=ofirst+osecond+othird+ofourth+ofifth+osixth;
    
%     colorS={red orange yellow green blue purple};
%     colorS1=randperm(6);
%     colorSS={colorS{colorS1(1)} colorS{colorS1(2)} colorS{colorS1(3)} colorS{colorS1(4)} colorS{colorS1(5)} colorS{colorS1(6)}};
    colorS={red yellow green blue};
    colorS1=randperm(4);
    colorSS={colorS{colorS1(1)} colorS{colorS1(2)} colorS{colorS1(3)} colorS{colorS1(4)}};
    
    for oo1=1:o1
        color{oo1,1}=colorSS{1};
    end
    for oo2=o1+1:o2
        color{oo2,1}=colorSS{2};
    end
    for oo3=o2+1:length(x)
        color{oo3,1}=colorSS{3};
    end
%     for oo4=o3+1:o4
%         color{oo4,1}=colorSS{4};
%     end
%     for oo5=o4+1:length(x)
%         color{oo5,1}=colorSS{5};
%     end
    color{1,1}=grey;
    color{length(x),1}=grey;
    
    WaitSecs(0.01)
    
    ttime=nan(length(x),1);
    
    ptext2=0;
    while ptext2~=1
        [Keyisdown, Secs, keyCode] = KbCheck;
        if keyCode(enter)
            ptext2=1;
        elseif ptext2==0
            WaitSecs(0.001) % delay to prevent CPU hogging
            DrawFormattedText(w, '다음의 과제에서는 모래시계의 늘어나거나 줄어드는 모래가 나옵니다.\n\n\n모래시계의 위 혹은 아래 중 한 군데만이 제시됩니다.\n\n\n모래의 색은 처음 확인한 네 가지 색 중 한 가지를 제외한 세 가지 색으로 변화합니다.\n\n\n빠진 한 가지 색이 무엇인지 찾으세요.\n\n\n이 설명문은 연습에서만 제시됩니다.\n\n\n엔터키를 누르면 다음으로 넘어갑니다.', 'center', 'center', [0 0 0]);
            Screen('Flip',w)
        end
    end
    
    WaitSecs(1)
        
    s1=0;
    while s1~=1
        
        [Keyisdown, Secs, keyCode] = KbCheck;
        WaitSecs(0.001) % delay to prevent CPU hogging       
       
        
        WaitSecs(0.1)
        
        DrawFormattedText(w, '스페이스바를 누르면 시작합니다.', 'center', 100, [0 0 0]);
        Screen('FramePoly', w, frame_color, [upL; upR; cenP], glass_PW);
        Screen('FramePoly', w, frame_color, [downL; downR; cenP], glass_PW);
        Screen('FillPoly', w, back_color, [upLL; cenLP; downLL]);
        Screen('FillPoly', w, back_color, [upRR; cenRP; downRR]);
        Screen('Flip',w)        
        
        if keyCode(space)
            time1=GetSecs;
            Priority(2)
            WaitSecs(ts_time)
            for i=1:length(x)
                time11=GetSecs;
                Screen('FillRect', w, color{i,1}, [upL(1) x(i) downR(1) x(i)+(downL(2)-cenP(2))])
                Screen('FillRect', w, obs_color, [upL(1)-10 obs_y2 downR(1)+10 obs_y4])
                Screen('FramePoly', w, frame_color, [upL; upR; cenP], glass_PW);
                Screen('FramePoly', w, frame_color, [downL; downR; cenP], glass_PW);                  
                Screen('FillPoly', w, back_color, [upLL; cenLP; downLL]);
                Screen('FillPoly', w, back_color, [upRR; cenRP; downRR]);                              
                Screen('Flip',w)
                
                time111=GetSecs;
                time10=time111-time11;
                wait=ts_time-time10-0.0002;
                WaitSecs(wait)
                time1111=GetSecs;
                ttime(i,1)=time1111-time11;
            end
            Priority(0)
            time2=GetSecs;
            time(WR)=time2-time1;
            atime=time/length(x);
            s1=1;
        elseif keyCode(esc)
            Screen('Close',w)            
        elseif keyCode(LS) && keyCode(enter)
            s1=1;
        end
    end
    
    WaitSecs(0.5)
    
            ptext3=0;
        while ptext3~=1
            [Keyisdown, Secs, keyCode] = KbCheck;
            if keyCode(enter)
                ptext3=1;
            elseif ptext3==0
                WaitSecs(0.001) % delay to prevent CPU hogging
                DrawFormattedText(w, '엔터키를 누르면 검사장면이 나타납니다. 세 가지를 물어봅니다.\n\n\n1. 네 가지 색 중 제시되지 않은 한 가지 색을 골라주세요(연습에선 정답여부를 가르쳐줍니다).\n\n\n2. 모래시계가 줄어들거나 늘어난 시간을 추측해주세요.\n\n\n3. 이 과제가 얼마나 어려웠는지 선택해주세요.\n\n\n1번 2번과 3번은 모두 마우스로 클릭하여 조정할 수 있습니다.\n\n\n이 설명은 연습에만 제시됩니다.\n\n\n엔터를 누르면 다음으로 넘어갑니다.', 'center', 'center', [0 0 0]);
                Screen('Flip',w)
            end
        end
        
        WaitSecs(0.1)
        
    ShowCursor('Arrow')
    SetMouse(rect(3)/2, rect(4)/2, w);
    
    
    crectW=50;
    crectH=50;
    crectB=100;
    mA_x1=(rect(3)/2)-(((crectW*4)+(crectB*3))/2);
%     mA_x1=(rect(3)/2)-(((crectW*6)+(crectB*5))/2);
    mA_y1=((rect(4)/2)-((rect(4)/7)*2));%+(crectH/2))-(rect(4)/3);
    mA_y2=mA_y1+crectH;
    TS=22; % textsize
    BTR=30; % between text and rect
    Screen('TextFont', w, '맑은고딕');
    Screen('TextSize', w, TS);
    Screen('TextStyle', w, 1);
    
    mA_x=nan(4,1);%(6,1);
    for i=2:4%6
        mA_x(i,1)=mA_x1+(crectW*(i-1))+(crectB*(i-1));
    end
    mA_x(1,1)=mA_x1;
    
    rc=cell(4,1);%(6,1); %rectcolor
%     rc{1,1}=red; rc{2,1}=orange; rc{3,1}=yellow; rc{4,1}=green; rc{5,1}=blue; rc{6,1}=purple;
    rc{1,1}=red; rc{2,1}=yellow; rc{3,1}=green; rc{4,1}=blue;
    
    btr=23; % between number text and rect
    
    mA_xx=cell(4,1);%(6,1);
    for i=1:4%6
        mA_xx{i,1}=[mA_x(i,1), mA_y1, mA_x(i,1)+crectW, mA_y2];
    end
    
    
    reac_color=[0 0 0];
    reacW=rect(3)/2;
    reacH=rect(4)/8;
    reacPW=15;
    
    d=260;
    dd=(rect(4)/7)*2+40;
    
    frx1=((rect(3)/2)-(reacW/2));
    fry1=((rect(4)/2)-(reacH/2))+dd;
    frx2=((rect(3)/2)+(reacW/2));
    fry2=((rect(4)/2)+(reacH/2))+dd;
    
    ffrx1=((rect(3)/2)-(reacW/2));
    ffrx2=((rect(3)/2)+(reacW/2));
    ffry1=((rect(4)/2)-(reacH/2));
    ffry2=((rect(4)/2)+(reacH/2));
    
    fr_rect=[frx1 fry1 frx2 fry2];
    ffr_rect=[ffrx1 ffry1 ffrx2 ffry2];
    
    reacWW=20;
    reacHHa=25;
    reacHH=reacH+reacHHa;
    
    mx1=((rect(3)/2)-(reacWW/2));
    my1=((rect(4)/2)-(reacHH/2))+dd;
    mx2=mx1+reacWW;
    my2=my1+reacHH;
    
    mmx1=((rect(3)/2)-(reacWW/2));
    mmx2=mx1+reacWW;
    mmy1=((rect(4)/2)-(reacHH/2));
    mmy2=mmy1+reacHH;
    
    dif_rect=[mx1 my1 mx2 my2];
    ddif_rect=[mmx1 mmy1 mmx2 mmy2];    
    
    inside=zeros(4,1);%(6,1);
    [mox1, moy1, buttons1] = GetMouse(w);
    b=0;
    while b<1 || sum(buttons1)<1
        
        [mox1, moy1, buttons1] = GetMouse(w);
        
        for i=1:4%6
            inside(i,1) = IsInRect(mox1, moy1, mA_xx{i});
            if inside(i,1) == 1 && sum(buttons1) > 0
                rc{i,1}=[166 166 166];
            end
%             DrawFormattedText(w, '1.', mA_x(1,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '2.', mA_x(2,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '3.', mA_x(3,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '4.', mA_x(4,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '5.', mA_x(5,1)-btr, mA_y1, [0 0 0]);
%             DrawFormattedText(w, '6.', mA_x(6,1)-btr, mA_y1, [0 0 0]);
            DrawFormattedText(w, messageA, 'center', mA_y1-TS-BTR, [0 0 0]);
            Screen('FillRect', w, rc{i,1}, mA_xx{i,1})
            if keyCode(esc)
                Screen('Close',w)
            end
        end
        b=sum(inside);
        ans_color=find(inside(:,1)==1);
        
        answer=2;
        
        if colorS1(4)==ans_color%colorS1(6)==ans_color
            answer=1;
        elseif colorS1(4)~=ans_color%colorS1(6)~=ans_color
            answer=0;
        end        
        
        DrawFormattedText(w, messageB, 'center', fry1-5-60, [0 0 0]);
        DrawFormattedText(w, '굉장히 쉬움', frx1-70, fry1+reacH+15, [0 0 0]);
        DrawFormattedText(w, '굉장히 어려움', frx2-70, fry2+15, [0 0 0]);
        
        Screen('FrameRect', w, reac_color, fr_rect, reacPW)
        %Screen('FillRect', w, reac_color, dif_rect)
        
        DrawFormattedText(w, messageC, 'center', ffry1-60, [0 0 0]);
        DrawFormattedText(w, '1', frx1-5, ffry1+reacH+15, [0 0 0]);
        DrawFormattedText(w, '60', frx2-10, ffry2+15, [0 0 0]);
        
        Screen('FrameRect', w, reac_color, ffr_rect, reacPW)
        %Screen('FillRect', w, reac_color, ddif_rect)
        
        Screen('Flip', w);
        
        if keyCode(esc)
            Screen('Close',w)
        end
    end

    
    
    [xCenter, yCenter] = RectCenter(rect);
    
    sx = xCenter;
    sy = yCenter;
    
    ssx = xCenter;
    ssy = yCenter;
    
    baseRect=[0 0 reacWW reacHH];
    offsetSet = 0;
    
    reac_color22=back_color;
    reac_color33=back_color;
    reac_two=0;
    while reac_two~=1
        
        [Keyisdown, Secs, keyCode] = KbCheck;
        WaitSecs(0.001)
        
        [mox2, moy2, buttons2] = GetMouse(w);
        
        [cx, cy] = RectCenter(dif_rect);
        
        inside2 = IsInRect(mox2, moy2, dif_rect);
        inside3 = IsInRect(mox2, moy2, ddif_rect);
        
        if inside2 == 1 && sum(buttons2) > 0 && offsetSet == 0
            dx = mox2 - cx;
            offsetSet = 1;
        end
        
        if inside2 == 1 && sum(buttons2) > 0
            sx = mox2 - dx;
        end
        
        
        [ccx, ccy] = RectCenter(ddif_rect);
        
        if inside3 == 1 && sum(buttons2) > 0 && offsetSet == 0
            ddx = mox2 - ccx;
            offsetSet = 1;
        end
        
        if inside3 == 1 && sum(buttons2) > 0
            ssx = mox2 - ddx;
        end
        
        
        if sx<frx1+(reacWW/2)
            sx=frx1+(reacWW/2);
        end
        
        if sx>frx2-(reacWW/2)
            sx=frx2-(reacWW/2);
        end
        
        
        if ssx<frx1+(reacWW/2)
            ssx=frx1+(reacWW/2);
        end
        
        if ssx>frx2-(reacWW/2)
            ssx=frx2-(reacWW/2);
        end
        
        inside22 = IsInRect(mox2, moy2, fr_rect);
        inside33 = IsInRect(mox2, moy2, ffr_rect);
        
        if inside22==1 && sum(buttons2)>0
            sx=mox2;
        end
        
        if inside33==1 && sum(buttons2)>0
            ssx=mox2;
        end
        
        if answer==1
            DrawFormattedText(w, '정답', 'center', mA_y1-TS-BTR-35, [0 0 0]);
        elseif answer==0
            DrawFormattedText(w, '오답', 'center', mA_y1-TS-BTR-35, [0 0 0]);
        end

        
        if inside22==1 && sum(buttons2)>0
            reac_color22=reac_color;
                        
        elseif inside33==1 && sum(buttons2)>0
            reac_color33=reac_color;           
            
        end
               
        dif_rect = CenterRectOnPointd(baseRect, sx, sy+dd);
        ddif_rect = CenterRectOnPointd(baseRect, ssx, sy);
        
        DrawFormattedText(w, messageB, 'center', fry1-60, [0 0 0]);
        DrawFormattedText(w, '굉장히 쉬움', frx1-70, fry1+reacH+15, [0 0 0]);
        DrawFormattedText(w, '굉장히 어려움', frx2-70, fry2+15, [0 0 0]);
 
        Screen('FillRect', w, reac_color22, dif_rect)
        Screen('FrameRect', w, reac_color, fr_rect, reacPW)
                
        DrawFormattedText(w, messageC, 'center', ffry1-60, [0 0 0]);
        DrawFormattedText(w, '1', frx1-5, ffry1+reacH+15, [0 0 0]);
        DrawFormattedText(w, '60', frx2-10, ffry2+15, [0 0 0]);
        
        Screen('FillRect', w, reac_color33, ddif_rect)
        Screen('FrameRect', w, reac_color, ffr_rect, reacPW)
        
        
        for i=1:4%6
%             DrawFormattedText(w, '1.', mA_x(1,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '2.', mA_x(2,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '3.', mA_x(3,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '4.', mA_x(4,1)-btr, mA_y1+((crectH-TS)/2), [0 0 0]);
%             DrawFormattedText(w, '5.', mA_x(5,1)-btr, mA_y1, [0 0 0]);
%             DrawFormattedText(w, '6.', mA_x(6,1)-btr, mA_y1, [0 0 0]);
            DrawFormattedText(w, messageA, 'center', mA_y1-TS-BTR, [0 0 0]);
            Screen('FillRect', w, rc{i,1}, mA_xx{i,1})
        end
        
        Screen('Flip',w)
        
        if sum(buttons2) <= 0
            offsetSet = 0;
        end
        
        if keyCode(enter)
            reac_two=1;
            ans_diff=sx-frx1;
            ans_time=ssx-ffrx1;
            if colorS1(4)==ans_color%colorS1(6)==ans_color
                answer=1;
            elseif colorS1(4)~=ans_color%colorS1(6)~=ans_color
                answer=0;
            end        
        end
        if keyCode(esc)
            Screen('Close',w)
        elseif keyCode(RS)
            WR=24; 
        end
    end
end
        
TS=30; % textsize
BTR=30; % between text and rect
Screen('TextFont', w, '맑은고딕');
Screen('TextSize', w, TS);
Screen('TextStyle', w, 1);
DrawFormattedText(w, message, 'center', 'center', [0 0 0]);
Screen('Flip', w);
