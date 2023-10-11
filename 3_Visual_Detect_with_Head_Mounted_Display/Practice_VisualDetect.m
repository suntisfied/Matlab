clear all
close all

% Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
Screen('Preference','SkipSyncTests',2)
% screens=Screen('Screens');
% screenNumber=max(screens);
[win1,rect1]=Screen('OpenWindow',1);
[win2,rect2]=Screen('OpenWindow',2);
Screen('BlendFunction', win1, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
true=1; false=0;
HideCursor

% Values Define

% Color
white=[255 255 255];
black=[0 0 0];
grey=[125 125 125];
blue=[0 0 255];

% Response keys settings
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
Z=KbName('z');
slash=KbName('/');

% Subject Number Define
SubjNum=0;

% Experiment Trials & Resposes
Nimage=5;
SerialNum=0; BlockNum=0; RepNum=7;
Iv1Num=[0 1]; Iv2Num=[4 8]; Iv3Num=[2 3 4];
SceneNum=nan; SceneDirec=0; Arrows=0; PreAbs=0; Res=nan; Correct=0; RT_Arrow=nan; RT_Scene=nan; Discomfort=nan; HowtoFeel=nan;
nIv1Num=5; nIv2Num=6; nIv3Num=7; nSceneNum=8; nSceneDirec=9; nArrows=10; nPreAbs=11; nRes=12; nCorrect=13; nRT_Arrow=14; nRT_Scene=15; nDiscomfort=16; nHowtoFeel=17;

ExpTrial=[]; Cond={};
for thisIv1=1:length(Iv1Num)
    for thisIv2=1:length(Iv2Num)
        for thisIv3=1:length(Iv3Num)
            BlockNum=BlockNum+1;
            temCond=[];
            for thisRep=1:RepNum
                SerialNum=SerialNum+1;
                SceneNum=randi(Nimage);
                SceneDirec=randi(5);
                ArrowsPool=randperm(5);
                ArrowsStim=ArrowsPool(1:Iv3Num(thisIv3));
                Arrows=0;
                for i=1:Iv3Num(thisIv3)
                    Arrows=Arrows+ArrowsStim(i)*10^(i-1);
                end
                temTrial=[SubjNum BlockNum thisRep SerialNum Iv1Num(thisIv1) Iv2Num(thisIv2) Iv3Num(thisIv3) SceneNum SceneDirec Arrows PreAbs Res Correct RT_Arrow RT_Scene Discomfort HowtoFeel];
                ExpTrial=vertcat(ExpTrial,temTrial);
                temCond=vertcat(temCond,temTrial(5:10));
            end
            Cond=vertcat(Cond,{temCond});
        end
    end
end
Cond=Shuffle(Cond);
Cond=cell2mat(Cond);
ExpTrial(:,5:10)=Cond;


% Loading Scene
Screen('FillRect', win1, grey, rect1)
Screen('TextSize', win1, 50)
Screen('TextStyle', win1, 1);
Screen('TextFont', win1, 'Ming LiU');
DrawFormattedText(win1, '������ �غ� ���Դϴ�.\n\n\n��ø� ��ٷ��ּ���.', 'center', 'center', white)
Screen('Flip',win1)

% Read Images
imName=[]; imData={};
imPath='Prac_Images\';
for i=1:Nimage
    imName=strcat(imPath, 'image', num2str(i));
    tem_imData=imread(imName, 'jpg');
    imData=vertcat(imData,tem_imData);
end

% Read Arrow Images
arrow_imName=[]; arrow_imData={};
arrow_imPath='Arrow_imgs\';
for i=1:5
    arrow_imName=strcat(arrow_imPath, 'arrow', num2str(i));
    tem_arrow_imData=imread(arrow_imName, 'jpg');
    arrow_imData=vertcat(arrow_imData,tem_arrow_imData);
end

% Read Feedback Images
feedback_imName=[]; feedback_imData={};
feedback_imPath='Arrow_imgs\';
for i=1:2
    feedback_imName=strcat(feedback_imPath, 'feedback', num2str(i));
    tem_feedback_imData=imread(feedback_imName, 'jpg');
    feedback_imData=vertcat(feedback_imData,tem_feedback_imData);
end

% Make Images
imIdx=[];
for i=1:Nimage
    tem_imIdx=Screen('MakeTexture', win1, imData{i,1});
    imIdx=vertcat(imIdx,tem_imIdx);
end

% Make Arrow Images
arrow_imIdx=[];
for i=1:5
    tem_arrow_imIdx=Screen('MakeTexture', win1, arrow_imData{i,1});
    arrow_imIdx=vertcat(arrow_imIdx, tem_arrow_imIdx);
end

% Make Feedback Images
feedback_imIdx=[];
for i=1:2
    tem_feedback_imIdx=Screen('MakeTexture', win1, feedback_imData{i,1});
    feedback_imIdx=vertcat(feedback_imIdx, tem_feedback_imIdx);
end

Screen('FillRect', win1, white, rect1)

% Directing Scene
Screen('FillRect', win1, grey, rect1)
Screen('TextFont', win1, 'Ming LiU');
DrawFormattedText(win1, '���� Ű�� ������ ������ ���۵˴ϴ�.', 'center', 'center', white)
Screen('Flip',win1)

while 1
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==enter
            break;
        end
    end
end
KbReleaseWait

DrawFormattedText(win1, '������ ���۵Ǹ� �� ���� ������ �־����ϴ�.\n\n\n1. ȭ���� �ٲ�� ������ �ִ��� ���� ���� ����Ű�� ��������.\n\n''����''!�̶�� ������ ��Ÿ���ϴ�.\n\n\n�������� �Ѿ���� ����Ű�� ��������.', 'center', 'center', white)
Screen('Flip',win1)

while 1
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==enter
            break;
        end
    end
end
KbReleaseWait

DrawFormattedText(win1, '2. ȭ���� ���鼭 ��� �������� Ÿ�� �ִٰ� ����غ�����.\n\n��Ⱑ ��� �������� �����̴��� �����غ�����.\n\n����̳� ������� ȭ�鿡 �� ������ �ִ��� �������� ã�ƺ���\n\n�ִٸ� ������ ����Ű�� ���ٸ� ���� ����Ű�� �ִ��� ���� �����ּ���.\n\n���������� ���俩�ΰ� ǥ�õ˴ϴ�.\n\n\n�������� �Ѿ���� ����Ű�� ��������.', 'center', 'center', white)
Screen('Flip',win1)

while 1
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==enter
            break;
        end
    end
end
KbReleaseWait

DrawFormattedText(win1, '3. �Ϸ��� ������ ������ ���� �߰� �߰���\n\n������ �ϸ鼭 �������� �ְ����� ������ ���� ������ �ֽ��ϴ�.\n\n1~100�� ���̷� �������ּ���.\n\n\n�������� �Ѿ���� ����Ű�� ��������.', 'center', 'center', white)
Screen('Flip',win1)

while 1
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==enter
            break;
        end
    end
end
KbReleaseWait
%%%%%%%%%%%%%%%%%%%%% This experiment starts %%%%%%%%%%%%%%%%%%%%%%%%%%%
num=0;
for thisIv1=1:length(Iv1Num)
    for thisIv2=1:length(Iv2Num)
        for thisIv3=1:length(Iv3Num)
            for thisRep=1:RepNum
                num=num+1;
                
                % Determine which display
                if ExpTrial(num,nIv1Num)==0 % only moniter
                    winNum=win1; rectNum=rect1;
                    Xcenter=rect1(3)/2; Ycenter=rect1(4)/2;
                    Screen('FillRect',win2,white,rect2)
                    Screen('Flip',win2)
                elseif ExpTrial(num,nIv1Num)==1 % moniter + HMD
                    winNum=win2; rectNum=rect2;
                    Xcenter=rect2(3)/2; Ycenter=rect2(4)/2;
                end
                
                % Arrows Coordinates
                arrowLength_h=rectNum(4)/22;
                arrowBetw=rectNum(3)/17+(arrowLength_h*2);
                FrameDist=30;
                arrowX=Xcenter;
                arrowY=arrowLength_h+FrameDist;
                
                a=[arrowX-arrowLength_h-(arrowBetw*2) arrowY-arrowLength_h arrowX+arrowLength_h-(arrowBetw*2) arrowY+arrowLength_h];
                b=[arrowX-arrowLength_h-arrowBetw arrowY-arrowLength_h arrowX+arrowLength_h-arrowBetw arrowY+arrowLength_h];
                c=[arrowX-arrowLength_h arrowY-arrowLength_h arrowX+arrowLength_h arrowY+arrowLength_h];
                d=[arrowX-arrowLength_h+arrowBetw arrowY-arrowLength_h arrowX+arrowLength_h+arrowBetw arrowY+arrowLength_h];
                e=[arrowX-arrowLength_h+(arrowBetw*2) arrowY-arrowLength_h arrowX+arrowLength_h+(arrowBetw*2) arrowY+arrowLength_h];
                arrow_rect={c;b;d;a;e};
                
                arrowFrameXY=[a(1)-FrameDist a(2)-FrameDist e(3)+FrameDist e(4)+FrameDist];
                arrowFillXY=[0 a(2)-FrameDist rect1(3) e(4)+FrameDist];
                FrameLenght=arrowFrameXY(4)-arrowFrameXY(2);
                
                FeedbackDist=arrowBetw/2; FeedbackLength=arrowLength_h*2;
                feedback_rect=[a(1)-FeedbackDist-FeedbackLength a(2) a(1)-FeedbackDist a(2)+FeedbackLength;e(3)+FeedbackDist e(4)-FeedbackLength e(3)+FeedbackDist+FeedbackLength e(4)];
                
                % Draw Arrow Images
                R_arrow_imIdx=[];
                ArrowNum=ExpTrial(num,nArrows);
                for i=ExpTrial(num,nIv3Num):-1:1
                    temR_arrow_imIdx=floor(ArrowNum/(10^(i-1)));
                    R_arrow_imIdx=horzcat(R_arrow_imIdx,temR_arrow_imIdx);
                    ArrowNum=ArrowNum-(temR_arrow_imIdx*(10^(i-1)));
                end
                for i=1:ExpTrial(num,nIv3Num)
                    Screen('DrawTexture', winNum, arrow_imIdx(R_arrow_imIdx(i),1), [], arrow_rect{i,1})
                end
                Screen('FrameRect', winNum, black, arrowFrameXY, 15)
                
                for Ri=1:length(R_arrow_imIdx)
                    if R_arrow_imIdx(Ri)==ExpTrial(num,nSceneDirec)
                        ExpTrial(num,nPreAbs)=1;                    
                    end
                end
                
                % Draw Images
                X1=0; Y1=0; X2=rect1(3); Y2=rect1(4);
                pos_Img=[X1 Y1+FrameLenght X2 Y2+FrameLenght];
                Screen('FillRect', win1, white, rect1)
                Screen('DrawTexture', win1, imIdx(ExpTrial(num,nSceneNum)), [], pos_Img)
                if winNum==win1
                    Screen('Flip',win1)
                elseif winNum==win2
                    Screen('Flip',win1)
                    Screen('Flip',win2)
                end
                
                % Expand Images
                SOA=ExpTrial(num,nIv2Num);
                itv= Screen('GetFlipInterval', win1);
                
                Max_expand=rectNum(4)/1.2;
                Max_move=rectNum(4)/1.2;
                
                spd_expand=Max_expand/(SOA/itv);
                spd_move=Max_move/(SOA/itv);
                
                whichD=ExpTrial(num,nSceneDirec);
                time=0; direction=whichD;
                DownArrow=0; DownScene=0;
                Priority(2)
                while time<=SOA
                    st=GetSecs;
                    pos_Img=[X1 Y1+FrameLenght X2 Y2+FrameLenght];
                    Screen('DrawTexture', win1, imIdx(ExpTrial(num,nSceneNum),1), [], pos_Img)
                    Screen('FillRect', win1, white, arrowFillXY)
                    for i=1:ExpTrial(num,nIv3Num)
                        Screen('DrawTexture', winNum, arrow_imIdx(R_arrow_imIdx(i),1), [], arrow_rect{i,1})
                    end
                    Screen('FrameRect', winNum, black, arrowFrameXY, 15)
                    if DownArrow==2
                        Screen('DrawTexture', winNum, feedback_imIdx(1,1), [], feedback_rect(1,:))
                    elseif DownArrow==3
                        Screen('DrawTexture', winNum, feedback_imIdx(2,1), [], feedback_rect(2,:))
                    end
                    if DownScene==1
                        Screen('TextSize', win1, 50)
                        Screen('TextFont', win1, 'Ming LiU');
                        DrawFormattedText(win1, '����!', 'center', 'center', white)                                                                       
                    end                    
                    if winNum==win1
                        Screen('Flip',win1)
                    elseif winNum==win2
                        Screen('Flip',win1)
                        Screen('Flip',win2)
                    end
                    if DownScene==1
                        WaitSecs(0.2)
                        DownScene=2;
                    end
                    
                    if direction==1
                        X1=X1-spd_expand-sqrt(((spd_move^2)/3)); Y1=Y1-spd_expand-sqrt(((spd_move^2)/3)); X2=X2+spd_expand+spd_move+sqrt(((spd_move^2)/3)); Y2=Y2+spd_expand+sqrt(((spd_move^2)/3));
                    elseif direction==2
                        X1=X1-spd_expand+sqrt(((spd_move^2)/3)); Y1=Y1-spd_expand+sqrt(((spd_move^2)/3)*2); X2=X2+spd_expand+sqrt(((spd_move^2)/3)); Y2=Y2+spd_expand+sqrt(((spd_move^2)/3)*2);
                    elseif direction==3
                        X1=X1-spd_expand; Y1=Y1-spd_expand+spd_move; X2=X2+spd_expand; Y2=Y2+spd_expand+spd_move;
                    elseif direction==4
                        X1=X1-spd_expand-sqrt(((spd_move^2)/2)); Y1=Y1-spd_expand+sqrt(((spd_move^2)/2)); X2=X2+spd_expand-sqrt(((spd_move^2)/2)); Y2=Y2+spd_expand+sqrt(((spd_move^2)/2));
                    elseif direction==5
                        X1=X1-spd_expand-spd_move; Y1=Y1-spd_expand; X2=X2+spd_expand-spd_move; Y2=Y2+spd_expand;
                    end
                    et=GetSecs;
                    t=et-st;
                    time=time+t;
                    
                    [Keyisdown, Secs, keyCode] = KbCheck;
                    
                    if keyCode(leftKey) && DownArrow==0 % cross
                        ExpTrial(num,nRT_Arrow)=time;
                        DownArrow=2;
                        Screen('DrawTexture', winNum, feedback_imIdx(1,1), [], feedback_rect(1,:))
                        ExpTrial(num,nRes)=0;
                        if ExpTrial(num,nPreAbs)==ExpTrial(num,nRes)
                            ExpTrial(num,nCorrect)=1;
                        else
                            ExpTrial(num,nCorrect)=0;
                        end                        
                    elseif keyCode(rightKey) && DownArrow==0 % circle
                        ExpTrial(num,nRT_Arrow)=time;
                        DownArrow=3;
                        Screen('DrawTexture', winNum, feedback_imIdx(2,1), [], feedback_rect(2,:))
                        ExpTrial(num,nRes)=1;                        
                        if ExpTrial(num,nPreAbs)==ExpTrial(num,nRes)
                            ExpTrial(num,nCorrect)=1;
                        else
                            ExpTrial(num,nCorrect)=0;
                        end
                        
                    elseif keyCode(esc)
                        Screen('Close',win1)
                        break
                    end
                    if keyCode(upKey) && DownScene==0;
                        ExpTrial(num,nRT_Scene)=time;
                        DownScene=1;
                    end
                    
                end
                Priority(0)
                if ExpTrial(num,nCorrect)==1
                    Screen('TextFont', win1, 'Ming LiU');                    
                    DrawFormattedText(win1, '�����Դϴ�.', 'center', 'center', black);
                    Screen('Flip',win1)
                    WaitSecs(1)
                else
                    DrawFormattedText(win1, '�����Դϴ�.', 'center', 'center', black);
                    Screen('Flip',win1)
                    WaitSecs(1)
                end
            end
            
            Screen('FillRect',win2,white,rect2)
            Screen('Flip',win2)        
            
            HowtoFeel=-1;               
            while HowtoFeel<1 || HowtoFeel>100
                Screen('TextSize', win1, 50);
                msgDis = '������ �ϸ鼭 ���� ������ 1~100�������� ������ �����ּ���.\n\n\n1=�ſ� �������̾���(�����ߴ�). 100=�ſ� �������̾���(���ߴ�).';
                msgFault = '���ڸ� �߸� �Է��ϼ̽��ϴ�. 1~100�� ������ ������ �����ּ���.';
                
                DrawFormattedText(win1, msgDis, 'center', rect1(4)/3.5, black);                
                HowtoFeel=GetEchoNumber(win1, '���� �� ���� ����:', rect1(3)/3, rect1(4)/1.5, blue, white, 0);
                empty=isscalar(HowtoFeel);
                if empty==0
                    HowtoFeel=0;
                    
                end
                if HowtoFeel<1 || HowtoFeel>100 || empty==0
                    Screen('FillRect',win1, white, rect1)
                    DrawFormattedText(win1, msgFault, 'center', rect1(4)/2.5, black);
                    Screen('FillRect',win2,white,rect2)
                    Screen('Flip',win2)
                    Screen('Flip',win1)
                    WaitSecs(1)
                end
            end            
            
            Screen('FillRect',win1,white,rect1)
            DiscomfortLevel=-1;
            while DiscomfortLevel<1 || DiscomfortLevel>100
                Screen('TextSize', win1, 50);
                msgDis = '������ ������ ���̵��� �ְ������� �Ǵ��Ͽ�\n\n1~100�������� ������ �����ּ���.\n\n\n1=�ſ� ������. 100=�ſ� �������.';
                msgFault = '���ڸ� �߸� �Է��ϼ̽��ϴ�. 1~100�� ������ ������ �����ּ���.';
                
                DrawFormattedText(win1, msgDis, 'center', rect1(4)/3.5, black);
                DiscomfortLevel=GetEchoNumber(win1, '���� ������ ���̵�:', rect1(3)/3, rect1(4)/1.5, blue, white, 0);
                empty=isscalar(DiscomfortLevel);
                if empty==0
                    DiscomfortLevel=0;
                end
                if DiscomfortLevel<1 || DiscomfortLevel>100 || DiscomfortLevel==0
                    Screen('FillRect',win1, white, rect1)
                    DrawFormattedText(win1, msgFault, 'center', rect1(4)/2.4, black);
                    Screen('FillRect',win2,white,rect2)
                    Screen('Flip',win2)
                    Screen('Flip',win1)
                    WaitSecs(1)
                end
            end   
            % Session ends & restarts
            Screen('FillRect',win1,white,rect1)
            Screen('FillRect',win2,white,rect2)      
            Screen('TextSize', win1, 50);
            msgRest = '5�ʰ� �޽��ϰڽ��ϴ�. �� ���迡�� 1�а� �޽��մϴ�.';
            DrawFormattedText(win1, msgRest, 'center', 'center', black);
            Screen('Flip',win1)            
            Screen('Flip',win2)
            WaitSecs(5)
        end
    end
end

Data_Excel=0;
while 1
    msgEnd = '���迡 �������ּż� �����մϴ�.\n\n\n�����ڿ��� ���� ������ �������ּ���.';    
    Screen('TextFont', win1, 'Ming LiU');
    Screen('Flip',win1)
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==esc
            break;
        end
    end
end
