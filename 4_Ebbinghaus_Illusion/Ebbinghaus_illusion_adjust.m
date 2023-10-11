close all; clear all;

% SubjNum_str=input('실험 참가자 번호(엔터):        ','s');
SubjNum_str='0';
SubjNum=str2num(SubjNum_str); % Subject Number Define

% display parameters
ScreenNum=Screen('Screens'); % how many screens
scn=floor(median(ScreenNum));
scn=1;
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
% Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
[win, rect]=Screen('OpenWindow', scn, [0 0 0]);

% prepare for anti-alias
AssertOpenGL;
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

% Experiment Trials & Resposes
SerialNum=0; BlockNum=0; RepNum=10;
Iv1Num={'left'}; Iv2Num={'on' 'off'}; % left or right
incirL=nan; outcirL=nan; incirR=nan; outcirR=nan; Res=nan;
nIv1Num=4; nIv2Num=5; nincirL=6; noutcirL=7; nincirR=8; noutcirR=9; nRes=10;
nTrial=(length(Iv1Num)*length(Iv2Num)*RepNum);

ExpTrial=[];
for thisRep=1:RepNum
    ExpBlock=[];
    for thisIv1=1:length(Iv1Num)
        for thisIv2=1:length(Iv2Num)
            SerialNum=SerialNum+1;
            temBlock={SubjNum thisRep SerialNum Iv1Num{thisIv1} Iv2Num{thisIv2} incirL outcirL incirR incirR Res};
            ExpBlock=vertcat(ExpBlock,temBlock);
        end
    end
    ExpBlock=Shuffle(ExpBlock, 2);
    ExpTrial=vertcat(ExpTrial, ExpBlock);
end
ExpTrial(:, 3)=mat2cell((1:nTrial)', ones(nTrial, 1), [1]);

% keyboard input setting
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
enter= KbName('return');
space = KbName('space');
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
LS=KbName('LeftShift');
RS=KbName('RightShift');
C=KbName('c');
S=KbName('s');
one=KbName('1');

% % Loading Scene
% Screen('TextSize', win, 50)
% Screen('TextStyle', win, 1)
% Screen('TextFont', win, 'Ming LiU');
% DrawFormattedText(win1, '실험을 준비 중입니다.\n\n\n잠시만 기다려주세요.', 'center', 'center', white)
% Screen('Flip',win)
% Experiment starts -------------------------------------------------------
ExpStartT=GetSecs;
num=0; ResTimePool=[]; TimeInfo=clock;
DataTitle={'Subj' 'Rep' 'Serial' 'Iv1' 'Iv2' 'incirL' 'outcirL' 'incirR' 'ourcirR' 'Res'};
DataFileName=strcat('Data\','Ebb_Data',num2str(SubjNum),mat2str(TimeInfo),'.txt');
fid=fopen(DataFileName,'w');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', DataTitle{:});
fclose(fid);

outcircol=[255 255 255];
incircol=[255 255 255];
outcircol_R=[255 255 255];
incircol_R=[255 255 255];

for iTrial=1:nTrial
    
    if strcmp(ExpTrial{iTrial, nIv1Num}, 'left')==1
        dpt=[0 5];
    elseif strcmp(ExpTrial{iTrial, nIv1Num}, 'right')==1
        dpt=[-5 0];
    elseif strcmp(ExpTrial{iTrial, nIv2Num}, 'on')==1
        dpt=dpt*1;
    elseif strcmp(ExpTrial{iTrial, nIv2Num}, 'off')==1
        dpt=dpt*0;
    end
    Xcen=display.width/2; Ycen=display.height/2;
    ebb.incircd=[Xcen-(Xcen/2)+dpt(1) Ycen];
    ebb.incirradii=ang2pix(1.5, 1);
    ebb.incirradii_org=ebb.incirradii;
    ebb.outcirradii=ang2pix(2.5, 1);
    ebb.outcirradii_org=ebb.outcirradii;
    ebb.outcirbetw=ang2pix(0.5, 1);
    ebb.outcirnum=7;
    
    ebb.incircd_R=[Xcen+(Xcen/2)+dpt(2) Ycen];
    ebb.incirradii_R=ang2pix(1.5, 1);
    ebb.outcirradii_R=ang2pix(0.5, 1);
    ebb.outcirbetw_R=ang2pix(0.5, 1);
    ebb.outcirnum_R=7;
    
    tmpline=0;
    while 1
        [keyIsDown,secs, keyCode] = KbCheck;
        
        if keyCode(escapeKey)
            break
            return
        elseif keyCode(enter)
            ExpTrial{iTrial, nincirL}=ebb.incirradii;
            ExpTrial{iTrial, noutcirL}=ebb.outcirradii;
            ExpTrial{iTrial, nincirR}=ebb.incirradii_R;
            ExpTrial{iTrial, noutcirR}=ebb.outcirradii_R;
            ExpTrial{iTrial, nRes}=ebb.incirradii_org-ebb.incirradii;

            fid=fopen(DataFileName,'a');
            fprintf(fid, '%d\t%d\t%d\t%s\t%s\t%f\t%f\t%f\t%f\t%f\r\n', ExpTrial{iTrial,:});
            fclose(fid);
            KbReleaseWait;
            break
        elseif keyCode(upKey) && keyCode(LS)
            ebb.incirradii=ebb.incirradii+ang2pix(0.01,1);
        elseif keyCode(downKey) && keyCode(LS) && ebb.incirradii>10
            ebb.incirradii=ebb.incirradii-ang2pix(0.01,1);
        elseif keyCode(rightKey) && keyCode(LS)
            ebb.outcirradii=ebb.outcirradii+ang2pix(0.01,1);
        elseif keyCode(leftKey) && keyCode(LS) && ebb.outcirradii>10
            ebb.outcirradii=ebb.outcirradii-ang2pix(0.01,1);
        elseif keyCode(KbName('q')) && keyCode(LS)
            ebb.outcirnum=ebb.outcirnum+1;
            KbReleaseWait;
        elseif keyCode(KbName('w')) && keyCode(LS)
            ebb.outcirnum=ebb.outcirnum-1;
            min(ebb.outcirnum, 1)
            KbReleaseWait;
        elseif keyCode(KbName('a')) && keyCode(LS)
            ebb.outcirbetw=ebb.outcirbetw+ang2pix(0.01,1);
        elseif keyCode(KbName('s')) && keyCode(LS)
            ebb.outcirbetw=ebb.outcirbetw-ang2pix(0.01,1);
            
         elseif keyCode(upKey) && keyCode(RS)
            ebb.incirradii_R=ebb.incirradii_R+ang2pix(0.01,1);
        elseif keyCode(downKey) && keyCode(RS) && ebb.incirradii_R>10
            ebb.incirradii_R=ebb.incirradii_R-ang2pix(0.01,1);
        elseif keyCode(rightKey) && keyCode(RS)
            ebb.outcirradii_R=ebb.outcirradii_R+ang2pix(0.01,1);
        elseif keyCode(leftKey) && keyCode(RS) && ebb.outcirradii_R>10
            ebb.outcirradii_R=ebb.outcirradii_R-ang2pix(0.01,1);
        elseif keyCode(KbName('q')) && keyCode(RS)
            ebb.outcirnum_R=ebb.outcirnum_R+1;
            KbReleaseWait;
        elseif keyCode(KbName('w')) && keyCode(RS)
            ebb.outcirnum_R=ebb.outcirnum_R-1;
            KbReleaseWait;
        elseif keyCode(KbName('a')) && keyCode(RS)
            ebb.outcirbetw_R=ebb.outcirbetw_R+ang2pix(0.01,1);
        elseif keyCode(KbName('s')) && keyCode(RS)
            ebb.outcirbetw_R=ebb.outcirbetw_R-ang2pix(0.01,1);
        end
        
        if keyCode(space) && keyCode(RS)
            tmpline=1;
        elseif keyCode(space) && keyCode(LS)
            tmpline=0;
        end
        
        if tmpline==1
            Screen('DrawLines', win, [Xcen-(Xcen/2) Xcen-(Xcen/2) Xcen+(Xcen/2) Xcen+(Xcen/2); 0 rect(4) 0 rect(4)], 3, [255 0 0])
        end
        
        % left stimuli
        trackradii=((ebb.outcirradii*2)/sin(deg2rad((180/ebb.outcirnum)*(ebb.outcirradii/(ebb.outcirbetw+ebb.outcirradii)))))/2;
        
        outcircencd=[];
        for angnum=0:ebb.outcirnum-1
            tmpcd=[trackradii*sin(deg2rad((360/ebb.outcirnum)*angnum)), trackradii*cos(deg2rad((360/ebb.outcirnum)*angnum))];
            outcircencd=vertcat(outcircencd, tmpcd);
        end
        outcircencd(:, 1)=outcircencd(:, 1)+ebb.incircd(1);
        outcircencd(:, 2)=outcircencd(:, 2)+ebb.incircd(2);
        
        outcircd=horzcat(outcircencd-ebb.outcirradii, outcircencd+ebb.outcirradii);
        
        for ioval=1:ebb.outcirnum
            Screen('FillOval', win, outcircol, outcircd(ioval, :))
        end
        incircd=horzcat(ebb.incircd-ebb.incirradii, ebb.incircd+ebb.incirradii);
        Screen('FillOval', win, incircol, incircd)
        
        % Right stimuli
        trackradii_R=((ebb.outcirradii_R*2)/sin(deg2rad((180/ebb.outcirnum_R)*(ebb.outcirradii_R/(ebb.outcirbetw_R+ebb.outcirradii_R)))))/2;
        
        outcircencd_R=[];
        for angnum=0:ebb.outcirnum_R-1
            tmpcd=[trackradii_R*sin(deg2rad((360/ebb.outcirnum_R)*angnum)), trackradii_R*cos(deg2rad((360/ebb.outcirnum_R)*angnum))];
            outcircencd_R=vertcat(outcircencd_R, tmpcd);
        end
        outcircencd_R(:, 1)=outcircencd_R(:, 1)+ebb.incircd_R(1);
        outcircencd_R(:, 2)=outcircencd_R(:, 2)+ebb.incircd_R(2);
        
        outcircd_R=horzcat(outcircencd_R-ebb.outcirradii_R, outcircencd_R+ebb.outcirradii_R);
        
        for ioval=1:ebb.outcirnum_R
            Screen('FillOval', win, outcircol_R, outcircd_R(ioval, :))
        end
        incircd_R=horzcat(ebb.incircd_R-ebb.incirradii_R, ebb.incircd_R+ebb.incirradii_R);
        Screen('FillOval', win, incircol_R, incircd_R)
        
        Screen('Flip', win)
    end
end
Screen('Close', win)