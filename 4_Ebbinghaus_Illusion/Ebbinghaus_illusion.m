close all; clear all;

% keyboard input setting
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
enterKey= KbName('return');
spaceKey = KbName('space');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
LshiftKey=KbName('LeftShift');
RshiftKey=KbName('RightShift');

% color
black=[0 0 0];
white=[255 255 255];
gray=[140 140 140];
red=[255 0 0];
green=[0 255 0];
blue=[0 0 255];

SubjNum_str=input('실험 참가자 번호(엔터):        ','s');
% SubjNum_str='0';
SubjNum=str2num(SubjNum_str); % Subject Number Define
betwIv1={'left' 'right'};

% display parameters
ScreenNum=Screen('Screens'); % how many screens
scn=floor(median(ScreenNum));
scn=2;
display=Screen('Resolution', scn); % always screen 1
params.res = [display.width, display.height];
params.sz = [35 20]; % cm
params.dist = 40; % cm

% define function
% calcuate pix of visual angle % 1=width, 2=heigth
ang2pix = @(visualAngle, XY) tan(deg2rad(visualAngle/2))*2*params.dist*params.res(XY)/params.sz(XY);
% pix to visual angle
pix2ang = @(pix, XY) rad2deg(atan((pix/2)/(params.dist*params.res(XY)/params.sz(XY))))*2;

Screen('Preference', 'SkipSyncTests', 2); % skip sync test
% Screen('Preference', 'VisualDebugLevel', 3)
% Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
[win, rect]=Screen('OpenWindow', scn, white);
HideCursor;
% prepare for anti-alias
AssertOpenGL;
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

% Experiment Trials & Resposes
SerialNum=0; BlockNum=0; RepNum=10;
Iv1Num={betwIv1{ceil(rem(SubjNum+1, 2))+1}}; Iv2Num={'on' 'off'}; % left or right
incirS=nan; outcirS=nan; incirL=nan; outcirL=nan; Res=nan;
nIv1Num=4; nIv2Num=5; nincirS=6; noutcirS=7; nincirL=8; noutcirL=9; nRes=10;
nTrial=(length(Iv1Num)*length(Iv2Num)*RepNum);

ExpTrial=[];
for thisRep=1:RepNum
    ExpBlock=[];
    for thisIv1=1:length(Iv1Num)
        for thisIv2=1:length(Iv2Num)
            SerialNum=SerialNum+1;
            temBlock={SubjNum thisRep SerialNum Iv1Num{thisIv1} Iv2Num{thisIv2} incirS outcirS incirL outcirL Res};
            ExpBlock=vertcat(ExpBlock,temBlock);
        end
    end
%     ExpBlock=Shuffle(ExpBlock, 2);
    re=randperm(size(ExpBlock, 1));
    ExpBlock=ExpBlock(re ,:);
    ExpTrial=vertcat(ExpTrial, ExpBlock);
end
ExpTrial(:, 3)=mat2cell((1:nTrial)', ones(nTrial, 1), [1]);

% Read Images
Nimage=4;
imName=[]; imData={};
imPath='Images\';
for i=1:Nimage
    imName=strcat(imPath, 'image', num2str(i));
    tem_imData=imread(imName, 'jpg');
    imData=vertcat(imData,tem_imData);
end

% Make Images
imIdx=[];
for i=1:Nimage
    tem_imIdx=Screen('MakeTexture', win, imData{i,1});
    imIdx=vertcat(imIdx,tem_imIdx);
end

% Experiment starts -------------------------------------------------------
ExpStartT=GetSecs;
num=0; ResTimePool=[]; TimeInfo=clock;
DataTitle={'Subj' 'Rep' 'Serial' 'Iv1' 'Iv2' 'incirS' 'outcirS' 'incirL' 'ourcirL' 'Res'};
DataFileName=strcat('Data\','Ebb_Data',num2str(SubjNum),mat2str(TimeInfo),'.txt');
fid=fopen(DataFileName,'w');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', DataTitle{:});
fclose(fid);

outcircol=black;
incircol=black;

Xcen=display.width/2; Ycen=display.height/2;

imgsz=ang2pix(5, 1);
tmpim=[Xcen+(Xcen/2) Ycen Xcen+(Xcen/2) Ycen; Xcen-(Xcen/2) Ycen Xcen-(Xcen/2) Ycen];
tmpim(:, 1)=tmpim(:, 1)-imgsz;
tmpim(:, 2)=tmpim(:, 2)-imgsz;
tmpim(:, 3)=tmpim(:, 3)+imgsz;
tmpim(:, 4)=tmpim(:, 4)+imgsz;



% Screen('TextSize', win, 30)
% Screen('TextStyle', win, 1)
% Screen('TextFont', win, 'Ming LiU');
% Screen('Preference', 'TextEncodingLocale', 'UTF-8')
Screen('Preference', 'DefaultTextYpositionIsBaseline', 0)

% msg='두 개의 상이 하나로 보이도록 거울을 조정하세요.\n\n\n점들 사이에 볼록한 사각형이 나타납니다.\n\n\n거울을 조정 후 눈과 머리를 최대한 고정하세요.\n\n\n다음으로 넘어가려면 엔터키를 누르세요.';
msg='Instruction 1';
% DrawFormattedText(win, msg, 'center', 'center', black)
Screen('DrawText', win, msg)
Screen('Flip',win)

KbStrokeWait;
Screen('Close', win)
while 1
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(enterKey)
        KbReleaseWait
        break
    end
end

Screen('FillRect', win, [255 255 255], rect)
for idr=1:2
    Screen('DrawTexture', win, imIdx(idr+2, 1), [], tmpim(idr ,:))
end
Screen('Flip', win)
while 1
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(enterKey)
        KbReleaseWait
        break
    end
end

% Loading Scene
Screen('TextSize', win, 20)
msg='두번의 연습이 있습니다\n\n\n위쪽 화살표 키를 누르면 원이 커지고\n\n\n아래쪽 화살표를 누르면 작아집니다.\n\n\n두 원의 크기가 같아보일 때까지\n\n\n화살표를 눌러 크기를 조절하세요.\n\n\n입체로 보이는 조건과\n\n\n평면으로 보이는 조건이 나타납니다.\n\n\n하단의 가운데 원의 크기는\n\n\n무선적으로 바뀝니다.\n\n\n연습을 시작하려면 엔터키를 누르세요.';
DrawFormattedText(win, msg, Xcen+(Xcen/7), 'center', black)
Screen('Flip',win)
Screen('TextSize', win, 30)
while 1
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(enterKey)
        KbReleaseWait
        break
    end
end

n=0;
% experiments trials start
for iTrial=[1 1 1:nTrial]
    
    % according to Ivs
    if strcmp(ExpTrial{iTrial, nIv1Num}, 'left')==1
        dpt=[0 ang2pix(0.3, 1)];
    elseif strcmp(ExpTrial{iTrial, nIv1Num}, 'right')==1
        dpt=[-ang2pix(0.3, 1) 0];
    end
    if strcmp(ExpTrial{iTrial, nIv2Num}, 'on')==1
        dpt=dpt*1;
    elseif strcmp(ExpTrial{iTrial, nIv2Num}, 'off')==1
        dpt=dpt*0;
    end
    
    n=n+1;
    
    [keyIsDown,secs, keyCode] = KbCheck;
    if n==1
        dpt=dpt*1;
    elseif n==2
        dpt=dpt*0;
    end
    if n==3
        msg='연습이 끝났습니다.\n\n\n본 실험을 시작하시려면 엔터키를 누르세요.';
        DrawFormattedText(win, msg, 'center', 'center', black)
        Screen('Flip',win)
        while 1
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(enterKey)
                KbReleaseWait
                break
            end
        end
    end
    
    % set default coordinates of stimulus
    d1=[Xcen-(Xcen/2) Ycen-(Ycen/3.5)];
    d3=[Xcen-(Xcen/2) Ycen+(Ycen/3.5)];
    d2=[Xcen+(Xcen/2) Ycen-(Ycen/3.5)];
    d4=[Xcen+(Xcen/2) Ycen+(Ycen/3.5)];
    
    ebb.incircd=vertcat(d1, d3, d2, d4);
    ebb.incirradii=ang2pix(1, 1);
    ebb.incirradii_org=ebb.incirradii;
    ebb.outcirradii=[ang2pix(0.6, 1); ang2pix(1.8, 1)];
    ebb.outcirbetw=ang2pix(0.3, 1);
    ebb.outcirnum=7;
    
    tmpline=0;
    dincirradii=ang2pix(randi([-7 10])/10, 1);
    dincirradii_org=dincirradii;
    
    % stimulus and response loop starts
    loop=0;
    while loop==0
        [keyIsDown,secs, keyCode] = KbCheck;
        
        % key response settings
        if keyCode(escapeKey)
            Screen('Close', win)
            break
        elseif keyCode(enterKey) && dincirradii~=dincirradii_org
            WaitSecs(0.01)
            if n>2
                ExpTrial{iTrial, nincirS}=ebb.incirradii+dincirradii;
                ExpTrial{iTrial, noutcirS}=ebb.outcirradii(1);
                ExpTrial{iTrial, nincirL}=ebb.incirradii+dincirradii;
                ExpTrial{iTrial, noutcirL}=ebb.outcirradii(2);
                ExpTrial{iTrial, nRes}=dincirradii-dincirradii_org;
                
                fid=fopen(DataFileName,'a');
                fprintf(fid, '%d\t%d\t%d\t%s\t%s\t%f\t%f\t%f\t%f\t%f\r\n', ExpTrial{iTrial,:});
                fclose(fid);
            end
            KbReleaseWait;
            loop=1;
        elseif keyCode(upKey)
            dincirradii=dincirradii+ang2pix(0.01,1);
        elseif keyCode(downKey) && ebb.incirradii>10
            dincirradii=dincirradii-ang2pix(0.01,1);
        end
        
        % set for check line
        if keyCode(spaceKey)
            tmpline=1;
        elseif keyCode(spaceKey)
            tmpline=0;
        end
        
        % draw check line
        if tmpline==1
            Screen('DrawLines', win, [Xcen-(Xcen/2) Xcen-(Xcen/2) Xcen+(Xcen/2) Xcen+(Xcen/2); 0 rect(4) 0 rect(4)], 5, [255 0 0])
        end
        
        % track stimuli radius
        trackradii=[];
        for itrack=1:length(ebb.outcirradii)
            tmptrackradii=((ebb.outcirradii(itrack)*2)/sin(deg2rad((180/ebb.outcirnum)*(ebb.outcirradii(itrack)/(ebb.outcirbetw+ebb.outcirradii(itrack))))))/2;
            trackradii=vertcat(trackradii, tmptrackradii);
        end
        
        % make coordinates of in and out circles of stimulus
        outcircencd={};
        for icenout=1:length(ebb.incircd)
            tmpoutcircencd=[];
            icen=round(rem(icenout+1, 2))+1;
            for angnum=0:ebb.outcirnum-1
                tmpcd=[trackradii(icen, 1)*sin(deg2rad((360/ebb.outcirnum)*angnum)), trackradii(icen, 1)*cos(deg2rad((360/ebb.outcirnum)*angnum))];
                tmpoutcircencd=vertcat(tmpoutcircencd, tmpcd);
            end
            outcircencd=vertcat(outcircencd, tmpoutcircencd);
        end
        outcircencd_org=outcircencd;
        outcircd={}; incircd=[];
        for iout=1:length(ebb.incircd)
            outcircencd=outcircencd_org;
            isi=round(rem(iout+1, 2))+1;
            outcircencd{isi, 1}(:, 1)=outcircencd{isi, 1}(:, 1)+ebb.incircd(iout, 1);
            outcircencd{isi, 1}(:, 2)=outcircencd{isi, 1}(:, 2)+ebb.incircd(iout, 2);
            tmpoutcircd=horzcat(outcircencd{isi, 1} - ebb.outcirradii(isi), outcircencd{isi, 1} + ebb.outcirradii(isi));
            outcircd=vertcat(outcircd, tmpoutcircd);
            tmpincircd=horzcat(ebb.incircd(iout,:) - ebb.incirradii - dincirradii*(isi-1), ebb.incircd(iout,:) + ebb.incirradii + dincirradii*(isi-1));
            incircd=vertcat(incircd, tmpincircd);
        end
        
%         % setting coordinate of outside again accoring to Ivs
%         outcircd{1:(length(ebb.incircd)/2), 1}([1 3], :)=outcircd{1:(length(ebb.incircd)/2), 1}([1 3], :)+dpt(1);
%         outcircd{((length(ebb.incircd)/2)+1):length(ebb.incircd), 1}([1 3], :)=outcircd{((length(ebb.incircd)/2)+1):length(ebb.incircd), 1}([1 3], :)+dpt(2);
        
        % setting coordinate of outside again accoring to Ivs
        ta=0;
        for oi=[1 1 2 2]
            ta=ta+1;
            outcircd{ta, 1}(:, [1 3])=outcircd{ta, 1}(:, [1 3])+dpt(oi);
        end
        
        if n<=2
            msg='연습입니다.';
            DrawFormattedText(win, msg, Xcen+(Xcen/3), Ycen-(Ycen/1.5), black)
        end
        
        % draw stimulus
        for iinoval=1:length(ebb.incircd)
            for ioutoval=1:ebb.outcirnum
                Screen('FillOval', win, outcircol, outcircd{iinoval,1}(ioutoval, :))
            end
            Screen('FillOval', win, incircol, incircd(iinoval, :))
        end
        Screen('Flip', win)
    end
end
msg='수고하셨습니다. 실험이 모두 완료되었습니다.\n\n\n실험자에게 알려주세요.';
DrawFormattedText(win, msg, 'center', 'center', black)
Screen('Flip',win)
while 1
    [keyIsDown,secs, keyCode] = KbCheck;
    if keyCode(escapeKey)
        KbReleaseWait
        break
    end
end
Screen('Close', win)