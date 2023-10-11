clear all
close all

SubjNum_str=input('실험 참가자 번호(엔터):        ','s');

Screen('Preference','SkipSyncTests',1);
Screen('Preference','TextRenderer', 0);
% Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
% Screen('Preference','SkipSyncTests',2)
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
SubjNum=str2num(SubjNum_str);

% Experiment Trials & Resposes
Nimage=5;%40
RestTime=60;%60
SerialNum=0; BlockNum=0; RepNum=35;%35 
Iv1Num=[1 1]; Iv2Num=[4 8]; Iv3Num=[2 3 4];
SceneNum=nan; SceneDirec=0; Arrows=0; PreAbs=0; Res=nan; Correct=0; RT_Arrow=nan; RT_Scene=nan; Discomfort=nan; HowtoFeel=nan;
nIv1Num=5; nIv2Num=6; nIv3Num=7; nSceneNum=8; nSceneDirec=9; nArrows=10; nPreAbs=11; nRes=12; nCorrect=13; nRT_Arrow=14; nRT_Scene=15; nDiscomfort=16; nHowtoFeel=17;

ExpTrial=[]; Cond={}; ExpOrder={};
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
            ExpOrder=vertcat(ExpOrder,{(thisIv1*100)+(thisIv2*10)+thisIv3});
        end
    end
end
Cond=horzcat(Cond,ExpOrder);
rCond=Shuffle(Cond,2);
Cond=cell2mat(rCond(:,1));
ExpOrder=cell2mat(rCond(:,2));
ExpTrial(:,5:10)=Cond;
ExpOrder=horzcat(transpose(1:12),ExpOrder,nan(12,1));


% Loading Scene
Screen('FillRect', win1, grey, rect1)
Screen('TextSize', win1, 50)
Screen('TextStyle', win1, 1)
Screen('TextFont', win1, 'Ming LiU');
DrawFormattedText(win1, '실험을 준비 중입니다.\n\n\n잠시만 기다려주세요.', 'center', 'center', white)
Screen('Flip',win1)

% Read Images
imName=[]; imData={};
imPath='Images\';
LoadP=0;
for i=1:Nimage
    imName=strcat(imPath, 'image', num2str(i));
    tem_imData=imread(imName, 'jpg');
    imData=vertcat(imData,tem_imData);
    LoadP=LoadP+1;
    LoadPer=round((LoadP/Nimage)*100);
    LoadPer_str=strcat(num2str(LoadPer),'%');
    DrawFormattedText(win1, '실험을 준비 중입니다.\n\n\n잠시만 기다려주세요.', 'center', 'center', white)
    DrawFormattedText(win1, LoadPer_str, 'center', rect1(4)/1.5, white)
    Screen('Flip',win1)
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

%%%%%%%%%%%%%%%%%%%%% This experiment starts %%%%%%%%%%%%%%%%%%%%%%%%%%%
ExpStartT=GetSecs;
num=0; ResTimePool=[]; TimeInfo=clock;
DataTitle={'Subj' 'Block' 'Rep' 'Serial' 'Iv1' 'Iv2' 'Iv3' 'SceneNum' 'SceneDirec' 'Arrows' 'PreAbs' 'Res' 'Correct' 'RT_Arrow' 'RT_Scene' 'HowtoFeel' 'Discomfort'};
DataFileName=strcat('Data\','HMD_Data',num2str(SubjNum),mat2str(TimeInfo),'.txt');
fid=fopen(DataFileName,'w');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', DataTitle{:});
fclose(fid);

ExpOrder_DataTitle={'Num' 'IVs' 'startT' 'EndT'};
ExpOrder_DataFileName=strcat('Data\','HMD_ExpOrder_Data',num2str(SubjNum),mat2str(TimeInfo),'.txt');
ExpOrder_fid=fopen(ExpOrder_DataFileName,'w');
fprintf(ExpOrder_fid,'%s\t%s\t%s\t%s\r\n',ExpOrder_DataTitle{:});
fclose(ExpOrder_fid);

SessionNum=0;
for thisIv1=1:length(Iv1Num)
    for thisIv2=1:length(Iv2Num)
        for thisIv3=1:length(Iv3Num)
            SessionNum=SessionNum+1;
            % Directing Scene
            Screen('FillRect', win1, grey, rect1)            
            Screen('TextFont', win1, 'Ming LiU');
            DrawFormattedText(win1, '엔터 키를 누르면 실험이 시작됩니다.', 'center', 'center', white)
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
            
            if SessionNum==1
                SessionStartTime=GetSecs;
                ExpOrder(1,3)=0;
            else 
                SessionTime=GetSecs;
                ExpOrder(SessionNum,3)=SessionTime;
                ExpOrder(SessionNum,3)=ExpOrder(SessionNum,3)-SessionStartTime;
            end                                               
                        
            ExpOrder_fid=fopen(ExpOrder_DataFileName,'a');
            fprintf(ExpOrder_fid,'%d\t%d\t%f', ExpOrder(SessionNum,:));
            fclose(ExpOrder_fid);         
            
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
                        Screen('TextFont', win1, 'Ming LiU');
                        DrawFormattedText(win1, '시작!', 'center', 'center', white)                                                                       
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
                        for Ri=1:length(R_arrow_imIdx)
                            if R_arrow_imIdx(Ri)==ExpTrial(num,nSceneDirec)
                                ExpTrial(num,nCorrect)=1;
                            end
                        end
                    elseif keyCode(rightKey) && DownArrow==0 % circle
                        ExpTrial(num,nRT_Arrow)=time;
                        DownArrow=3;
                        Screen('DrawTexture', winNum, feedback_imIdx(2,1), [], feedback_rect(2,:))
                        ExpTrial(num,nRes)=1;                        
                        for Ri=1:length(R_arrow_imIdx)
                            if R_arrow_imIdx(Ri)==ExpTrial(num,nSceneDirec)
                                ExpTrial(num,nCorrect)=1;
                            end
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
                Priority(1)
                
                fid=fopen(DataFileName,'a');
                if thisRep<RepNum
                    myformat='%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%f\t%f\t%d\t%d\r\n';
                    fprintf(fid, myformat, ExpTrial(num,:));
                elseif thisRep==RepNum
                    myformat='%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%f\t%f\t';
                    fprintf(fid, myformat, ExpTrial(num,1:nRT_Scene));
                end                
                fclose(fid);
            end
            SessionEndTime=GetSecs;
            ExpOrder_fid=fopen(ExpOrder_DataFileName,'a');
            fprintf(ExpOrder_fid,'\t%f\r\n', (SessionEndTime-SessionStartTime));
            fclose(ExpOrder_fid);   
            
            Screen('FillRect',win2,white,rect2)
            Screen('Flip',win2)          
            
            HowtoFeel=-1;
            while HowtoFeel<1 || HowtoFeel>100
                Screen('TextSize', win1, 50);
                msgDis = '실험을 하면서 받은 느낌을 1~100점까지의 점수로 적어주세요.\n\n\n1=매우 부정적이었다(불편했다). 100=매우 긍정적이었다(편했다).';
                msgFault = '숫자를 잘못 입력하셨습니다. 1~100점 사이의 점수를 적어주세요.';
                
                DrawFormattedText(win1, msgDis, 'center', rect1(4)/3.5, black);                
                HowtoFeel=GetEchoNumber(win1, '실험 중 받은 느낌:', rect1(3)/3, rect1(4)/1.5, blue, white, 0);
                empty=isscalar(HowtoFeel);
                if empty==0
                    HowtoFeel=0;
                end                
                if HowtoFeel<1 || HowtoFeel>100 || empty==0
                    Screen('FillRect',win1, white, rect1)
                    DrawFormattedText(win1, msgFault, 'center', rect1(4)/2.4, black);
                    Screen('FillRect',win2,white,rect2)
                    Screen('Flip',win2)
                    Screen('Flip',win1)
                    WaitSecs(1)
                end
            end
            ExpTrial(num,nHowtoFeel)=HowtoFeel;
            fid=fopen(DataFileName,'a');
            myformat='%d\t';
            fprintf(fid, myformat, HowtoFeel);
            fclose(fid);
            
            Screen('FillRect',win1,white,rect1)
            DiscomfortLevel=-1;
            while DiscomfortLevel<1 || DiscomfortLevel>100                
                msgDis = '수행한 과제의 난이도를 주관적으로 판단하여\n\n1~100점까지의 점수로 적어주세요.\n\n\n1=매우 쉬웠다. 100=매우 어려웠다.';
                msgFault = '숫자를 잘못 입력하셨습니다. 1~100점 사이의 점수를 적어주세요.';
                
                DrawFormattedText(win1, msgDis, 'center', rect1(4)/3.5, black);
                DiscomfortLevel=GetEchoNumber(win1, '내게 느껴진 난이도:', rect1(3)/3, rect1(4)/1.5, blue, white, 0);
                empty=isscalar(DiscomfortLevel);
                if empty==0
                    DiscomfortLevel=0;
                end                
                if DiscomfortLevel<1 || DiscomfortLevel>100 || empty==0
                    Screen('FillRect',win1, white, rect1)
                    DrawFormattedText(win1, msgFault, 'center', rect1(4)/2.4, black);
                    Screen('FillRect',win2,white,rect2)
                    Screen('Flip',win2)
                    Screen('Flip',win1)
                    WaitSecs(1)
                end
            end
            ExpTrial(num,nDiscomfort)=DiscomfortLevel;
            fid=fopen(DataFileName,'a');
            myformat='%d\r\n';
            fprintf(fid, myformat, DiscomfortLevel);
            fclose(fid);
            
            % Session ends & restarts
            Screen('FillRect',win1,white,rect1)
            Screen('FillRect',win2,white,rect2)
            Screen('TextSize', win1, 50);
            msgRest = '1분간 휴식하겠습니다.';
            DrawFormattedText(win1, msgRest, 'center', 'center', black);
            Screen('Flip',win1)
            Screen('Flip',win2)
            WaitSecs(RestTime)            
        end
    end
end
ExpEndT=GetSecs;
ExpTime=ExpEndT-ExpStartT;
fid=fopen(ExpOrder_DataFileName,'a');
myformat='%f\n';
fprintf(fid, myformat, ExpTime);
fclose(fid);

Screen('FillRect', win1, white, rect1)
Screen('TextSize', win1, 50)
msgEnd = '실험에 참여해주셔서 감사합니다.\n\n\n마지막으로 간단한 설문 문항에 응답해주세요.\n\n\n다음으로 넘어가려면 엔터키를 누르세요.';
DrawFormattedText(win1, msgEnd, 'center', rect1(4)/2.4, black);
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

msgEndsur1 = '실험을 수행하면서 헬멧의 화면에\n\n화살표가 표시되는 것이 얼마나 과제 수행에 도움이 되었나요?\n\n\n1=전혀 도움이 되지 않았다. 100=매우 도움이 되었다.';
msgFail = '숫자를 잘못 입력하셨습니다. 1~100점 사이의 점수를 적어주세요.';
msgEndsur1_Level=-1;
while 1    
    DrawFormattedText(win1, msgEndsur1, 'center', rect1(4)/3.5, black);
    msgEndsur1_Level=GetEchoNumber(win1, '내게 느껴진 유용감:', rect1(3)/3, rect1(4)/1.5, blue, white, 0);
    empty=isscalar(msgEndsur1_Level);
    if empty==0
        msgEndsur1_Level=0;
    end        
    if msgEndsur1_Level<1 || msgEndsur1_Level>100 || empty==0
        Screen('FillRect',win1, white, rect1)
        DrawFormattedText(win1, msgFail, 'center', rect1(4)/2.4, black);
        Screen('FillRect',win2,white,rect2)
        Screen('Flip',win2)
        Screen('Flip',win1)
        WaitSecs(1)
    else
        break
    end
end
Screen('FillRect',win1, white, rect1)
msgEnd = '잠시만 기다려주세요.';
DrawFormattedText(win1, msgEnd, 'center', rect1(4)/2.4, black);
Screen('Flip',win1)

Size_Exp=size(ExpTrial);
EndSurVal=zeros(Size_Exp(1),1);
EndSurVal=EndSurVal+msgEndsur1_Level;
ExpTrial=horzcat(ExpTrial,EndSurVal);

fDataName=strcat('Data\Data_HMD_exp1_', num2str(SubjNum), '_', num2str(ExpTime),'.xlsx');
xlswrite(fDataName, ExpTrial, 1);

Screen('FillRect',win1, white, rect1)
msgEnd = '실험의 모든 과정이 완료되었습니다. 수고하셨습니다.\n\n\n실험자에게 말씀해주세요.\n\n\n임의로 종료하지 마세요.';
DrawFormattedText(win1, msgEnd, 'center', rect1(4)/2.4, black);
Screen('Flip',win1)
Data_Excel=1;
while 1
    [keyIsDown, Secs, keyCode]=KbCheck(-1);
    if keyIsDown
        if find(keyCode)==esc
            break;
        end
    end
end
KbReleaseWait
Screen('Close',win1)
Screen('Close',win2)
