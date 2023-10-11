close all; clear all; KbName('UnifyKeyNames');
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

% display parameters
ScreenNum=Screen('Screens'); % how many screens
scn=ceil((length(ScreenNum)-1)/length(ScreenNum)); % always screen 1
display=Screen('Resolution', scn);
params.res = [display.width, display.height];
params.sz = [35 20]; % cm
params.dist = 40; % cm
disp_ratio=display.height/display.width; 

% define function
% calcuate pix of visual angle % 1=width, 2=heigth
ang2pix = @(visualAngle, XY) tan(deg2rad(visualAngle/2))*2*params.dist*params.res(XY)/params.sz(XY);
% pix to visual angle
pix2ang = @(pix, XY) rad2deg(atan((pix/2)/(params.dist*params.res(XY)/params.sz(XY))))*2;

% Experiment Trials & Resposes
% Independent variable
ori=[0 1]; % 0: horizontal, 1: vertical
targetCol=[0 1]; % 0: black or 1: white
ISI=[0.1 0.2 0.4]; % cue presentation time: 100 ms or 400 ms
cueLoc=[1 2 3 4]; % cue location
validORnot=[1 1 1 1 1 1 1 1 1 0.1 0.2 0.3]; % 1: valid, 0.1: invalid, within-object, 0.2: invalid, between-object, 0: notarget
% validORnot=[0.3]; % 1: valid, 0.1: invalid, within-object, 0.2: invalid, between-object, 0: notarget
% Dependent variable
acc=nan; resT=nan;
% Variable Location
locSub=1; locBlock=2; locTrial=3; locOri=4; locTargetCol=5; locISI=6; locCueLoc=7; locValidORnot=8; locAcc=9; locResT=10;
% Trial & repitition
nRep=1; nTrial=(length(ori)*length(targetCol)*length(ISI)*length(cueLoc)*length(validORnot));

ExpTrial=[];
for thisRep=1:nRep
    ExpBlock=[]; serialNum=0;
    for thisFac1=1:length(ori)
        for thisFac2=1:length(targetCol)
            for thisFac3=1:length(ISI)
                for thisFac4=1:length(cueLoc)
                    for thisFac5=1:length(validORnot)
                        temBlock=[SubjNum thisRep serialNum ori(thisFac1) targetCol(thisFac2) ISI(thisFac3) cueLoc(thisFac4) validORnot(thisFac5) acc resT];
                        ExpBlock=vertcat(ExpBlock,temBlock);
                    end
                end
            end
        end
    end
    %     ExpBlock=Shuffle(ExpBlock, 2);
    re=randperm(size(ExpBlock, 1));
    ExpBlock=ExpBlock(re ,:);
    ExpBlock(:, locTrial)=transpose(1:nTrial);
    ExpTrial=vertcat(ExpTrial, ExpBlock);
end

bgCol=[127 127 127];
Screen('Preference', 'SkipSyncTests', 2); % skip sync test
% Screen('Preference', 'VisualDebugLevel', 3)
% Screen('Preference','SyncTestSettings' , 0.001, 50, 0.1, 5);
[win, rect]=Screen('OpenWindow', scn, bgCol);
% HideCursor;
% prepare for anti-alias
AssertOpenGL;
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
% [minSmoothLineWidth, maxSmoothLineWidth, minAliasedLineWidth, maxAliasedLineWidth] = Screen('DrawLines', win);

% Experiment starts -------------------------------------------------------
ExpStartT=GetSecs;
ResTimePool=[];
TimeInfo=num2str(fix(clock));
TimeInfo(TimeInfo==' ') = '';
DataTitle={'Subj' 'Rep' 'Trial' 'Ori' 'targetCol' 'ISIT' 'cueLoc' 'validORnot' 'Acc' 'resT'};
DataFileName=strcat('data\','sameobjadv_data_', num2str(SubjNum), '_', TimeInfo,'.txt');
fid=fopen(DataFileName,'w');
fprintf(fid,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\r\n', DataTitle{:});
fclose(fid);

Xcen=rect(3)/2; Ycen=rect(4)/2;
% parameters for fixation cross
fixationCol=[0 0 0];
fixationWidth=ang2pix(0.1, 1);
fixationHeight=ang2pix(0.3, 2);
fixationPos=[Xcen-fixationWidth Ycen-fixationHeight Xcen+fixationWidth Ycen+fixationHeight;
    Xcen-fixationHeight Ycen-fixationWidth Xcen+fixationHeight Ycen+fixationWidth];
% parameters for rectangulars
% lenRect=[ang2pix(1.7, 1) ang2pix(11.4, 2)]; % width, height
lenRect=[ang2pix(1.7, 1) ang2pix(10.2, 2)]; % width, height
% distFromCen=ang2pix(4.8, 1); %  original
distFromCen=ang2pix(4, 1); % modified
rectWidth=5;
% rectWidth=maxAliasedLineWidth;
rectCol=[50 50 50];

rectPos=[Xcen-distFromCen-lenRect(1) Ycen-(lenRect(2)/2) Xcen-distFromCen Ycen+(lenRect(2)/2);
    Xcen+distFromCen Ycen-(lenRect(2)/2) Xcen+distFromCen+lenRect(1) Ycen+(lenRect(2)/2);
    Xcen-(lenRect(2)/2) Ycen-distFromCen-lenRect(1) Xcen+(lenRect(2)/2) Ycen-distFromCen;
    Xcen-(lenRect(2)/2) Ycen+distFromCen Xcen+(lenRect(2)/2) Ycen+distFromCen+lenRect(1)];
% parameters for cues
cueCol=[0 0 0];
cueHeight=ang2pix(1.9, 2);
cueThickness=ang2pix(0.3, 1);
cuePos=[rectPos(1,:) + [0 0 0 -(lenRect(2) - cueHeight)];
    rectPos(2,:) + [0 0 0 -(lenRect(2) - cueHeight)];
    rectPos(1,:) + [0 +(lenRect(2) - cueHeight) 0 0];
    rectPos(2,:) + [0 +(lenRect(2) - cueHeight) 0 0];
    
    rectPos(3,:) + [0 0 -(lenRect(2) - cueHeight) 0];
    rectPos(4,:) + [0 0 -(lenRect(2) - cueHeight) 0];
    rectPos(3,:) + [+(lenRect(2) - cueHeight) 0 0 0];
    rectPos(4,:) + [+(lenRect(2) - cueHeight) 0 0 0]];
cuePos([1 2], [1 2])=cuePos([1 2], [1 2])-(cueThickness/2);
cuePos([1 2], [3])=cuePos([1 2], [3])+(cueThickness/2);
cuePos([3 4], [1])=cuePos([3 4], [1])-(cueThickness/2);
cuePos([3 4], [3 4])=cuePos([3 4], [3 4])+(cueThickness/2);

cuePos([5 6], [1 2])=cuePos([5 6], [1 2])-(cueThickness/2);
cuePos([5 6], [4])=cuePos([5 6], [4])+(cueThickness/2);
cuePos([7 8], [2])=cuePos([7 8], [2])-(cueThickness/2);
cuePos([7 8], [3 4])=cuePos([7 8], [3 4])+(cueThickness/2);

blockcueCol=bgCol;
blockcuePos=[rectPos(1,:) + [0 0 0 -(lenRect(2) - cueHeight)];
    rectPos(2,:) + [0 0 0 -(lenRect(2) - cueHeight)];
    rectPos(1,:) + [0 +(lenRect(2) - cueHeight) 0 0];
    rectPos(2,:) + [0 +(lenRect(2) - cueHeight) 0 0];
    
    rectPos(3,:) + [0 0 -(lenRect(2) - cueHeight) 0];
    rectPos(4,:) + [0 0 -(lenRect(2) - cueHeight) 0];
    rectPos(3,:) + [+(lenRect(2) - cueHeight) 0 0 0];
    rectPos(4,:) + [+(lenRect(2) - cueHeight) 0 0 0]];
blockcuePos([1 2], [1 2])=blockcuePos([1 2], [1 2])+(cueThickness/2);
blockcuePos([1 2], [3])=blockcuePos([1 2], [3])-(cueThickness/2);
blockcuePos([3 4], [1])=blockcuePos([3 4], [1])+(cueThickness/2);
blockcuePos([3 4], [3 4])=blockcuePos([3 4], [3 4])-(cueThickness/2);

blockcuePos([5 6], [1 2])=blockcuePos([5 6], [1 2])+(cueThickness/2);
blockcuePos([5 6], [4])=blockcuePos([5 6], [4])-(cueThickness/2);
blockcuePos([7 8], [2])=blockcuePos([7 8], [2])+(cueThickness/2);
blockcuePos([7 8], [3 4])=blockcuePos([7 8], [3 4])-(cueThickness/2);
% parameters for targets
% targetCol=[0 0 0];
targetColPool=[0 0 0; 255 255 255];

targetHeight=ang2pix(1.9, 2);
targetPos=[rectPos(1,:) + [0 0 0 -(lenRect(2) - targetHeight)];
    rectPos(2,:) + [0 0 0 -(lenRect(2) - targetHeight)];
    rectPos(1,:) + [0 +(lenRect(2) - targetHeight) 0 0];
    rectPos(2,:) + [0 +(lenRect(2) - targetHeight) 0 0];
    
    rectPos(3,:) + [0 0 -(lenRect(2) - targetHeight) 0];
    rectPos(4,:) + [0 0 -(lenRect(2) - targetHeight) 0];
    rectPos(3,:) + [+(lenRect(2) - targetHeight) 0 0 0];
    rectPos(4,:) + [+(lenRect(2) - targetHeight) 0 0 0]];
% targetPos=[rectPos(1,:) + [0 0 0 -(lenRect(2) - targetHeight)];
%     rectPos(2,:) + [0 0 0 -(lenRect(2) - targetHeight)];
%     rectPos(1,:) + [0 +(lenRect(2) - targetHeight) 0 0];
%     rectPos(2,:) + [0 +(lenRect(2) - targetHeight) 0 0];
%
%     rectPos(3,:) + [0 0 -(lenRect(2) - targetHeight) 0];
%     rectPos(3,:) + [0 0 -(lenRect(2) - targetHeight) 0];
%     rectPos(4,:) + [+(lenRect(2) - targetHeight) 0 0 0];
%     rectPos(4,:) + [+(lenRect(2) - targetHeight) 0 0 0]];

% instruction
distFromWidth = ang2pix(2, 1);
distFromHeight = distFromWidth * disp_ratio;

HideCursor;
PsychDefaultSetup(2); 
Screen('Preference', 'VisualDebugLevel', 3)
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
% [inst, ~, alpha]=imread('cat_PNG100.png');
inst=imread('instruction_text_image\instruction.jpg');
% [inst, b, alpha]=imread('instruction_text_image\instruction.png','V79Compatible',true);
% inst(:, :, 4) = alpha;
inst=Screen('MakeTexture', win, inst);
feedback_correct=Screen('MakeTexture', win, (imread('instruction_text_image\feedback_correct', 'jpg')));
feedback_incorrect=Screen('MakeTexture', win, (imread('instruction_text_image\feedback_incorrect', 'jpg')));
inst_end=Screen('MakeTexture', win, (imread('instruction_text_image\instruction_end.jpg')));
Screen('DrawTexture', win, inst, [], [distFromWidth, distFromHeight, rect(3) - distFromWidth, rect(4) - distFromHeight])
% Screen('PutImage', win, (imread('instruction_text_image\instruction', 'png')), [ang2pix(2, 1), ang2pix(2, 2), rect(3) - ang2pix(2, 1), rect(4) - ang2pix(2, 1)])
Screen('Flip', win)
while 1
    [keyisDown, secs, keyCode] = KbCheck;
    if keyCode(KbName('space'))
        break
    elseif keyCode(KbName('ESCAPE'))
        Screen('Close', win)
        ShowCursor;
        break
    end
end
nSerial=0;
for expRep=1:nRep
    for expOri=1:length(ori)
        for expTargetCol=1:length(targetCol)
            for expISI=1:length(ISI)
                for expCueLoc=1:length(cueLoc)
                    for expValidORnot=1:length(validORnot)
                        [keyisDownGlobal, secsGlobal, keyCodeGlobal] = KbCheck;
                        nSerial=nSerial+1;
                        targetColRGB=targetColPool(ExpTrial(nSerial, locTargetCol)+1,:);
                        % fixation cross draw
                        Screen('FillRect', win, fixationCol, fixationPos(1, :))
                        Screen('FillRect', win, fixationCol, fixationPos(2, :))
                        Screen('Flip', win, [], 1)
                        
                        if ExpTrial(nSerial, locOri)==1
                            parmRect=1;
                        elseif ExpTrial(nSerial, locOri)==0
                            parmRect=3;
                        end
                        % rectangulars draw
                        Screen('FrameRect', win, rectCol, rectPos(parmRect, :), rectWidth)
                        Screen('FrameRect', win, rectCol, rectPos(parmRect+1, :), rectWidth)
                        Screen('Flip', win, [], 1)
                        iniOnset=GetSecs;
                        while GetSecs-iniOnset<1
                            [keyisDown, secs, keyCode] = KbCheck;
                            if keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            end
                        end
                        % cue draw
                        parmCueLoc=ExpTrial(nSerial, locCueLoc);
                        if ExpTrial(nSerial, locOri)==0
                            parmCueLoc=parmCueLoc+4;
                        end
                        Screen('FrameRect', win, rectCol, rectPos(parmRect, :), rectWidth)
                        Screen('FrameRect', win, rectCol, rectPos(parmRect+1, :), rectWidth)
                        Screen('FillRect', win, cueCol, cuePos(parmCueLoc, :))
                        Screen('FillRect', win, blockcueCol, blockcuePos(parmCueLoc, :))
                        Screen('Flip', win)
                        iniOnset=GetSecs;
                        while GetSecs-iniOnset<0.1
                            [keyisDown, secs, keyCode] = KbCheck;
                            if keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            end
                        end
                        % rectangulars draw
                        Screen('FillRect', win, fixationCol, fixationPos(1, :))
                        Screen('FillRect', win, fixationCol, fixationPos(2, :))
                        Screen('FrameRect', win, rectCol, rectPos(parmRect, :), rectWidth)
                        Screen('FrameRect', win, rectCol, rectPos(parmRect+1, :), rectWidth)
                        Screen('Flip', win, [], 1)
                        iniOnset=GetSecs;
                        while GetSecs-iniOnset<ExpTrial(nSerial, locISI)
                            [keyisDown, secs, keyCode] = KbCheck;
                            if keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            end
                        end
                        if ExpTrial(nSerial, locOri)==0
                            parmCueLoc=parmCueLoc-4;
                        end
                        indexOri=4;
                        % targets draw
                        if ExpTrial(nSerial, locValidORnot)==1
                            parmTargetLoc=parmCueLoc;
                        elseif ExpTrial(nSerial, locValidORnot)==0.1 % within object
                            parmCueLoc=parmCueLoc+2;
                            parmTargetLoc=parmCueLoc-((ceil(parmCueLoc/(indexOri))-1)*(indexOri));
                        elseif ExpTrial(nSerial, locValidORnot)==0.2 % between object
                            if parmCueLoc<=2
                                parmCueLoc=abs(3-parmCueLoc);
                            elseif parmCueLoc>2
                                parmCueLoc=abs(7-parmCueLoc);
                            end
                            parmTargetLoc=parmCueLoc-((ceil(parmCueLoc/(indexOri)-1)*(indexOri)));
                        elseif ExpTrial(nSerial, locValidORnot)==0.3 % opposite location
                            parmCueLoc=abs(5-parmCueLoc);
                            parmTargetLoc=parmCueLoc-((ceil(parmCueLoc/(indexOri)-1)*(indexOri)));
                        end
                        if ExpTrial(nSerial, locOri)==0
                            parmTargetLoc=parmTargetLoc+4;
                        end
                        if ExpTrial(nSerial, locValidORnot)~=0
                            Screen('FillRect', win, fixationCol, fixationPos(1, :))
                            Screen('FillRect', win, fixationCol, fixationPos(2, :))
                            Screen('FrameRect', win, rectCol, rectPos(parmRect, :), rectWidth)
                            Screen('FrameRect', win, rectCol, rectPos(parmRect+1, :), rectWidth)
                            Screen('FillRect', win, targetColRGB, targetPos(parmTargetLoc, :))
                            Screen('Flip', win)
                        end
                        keyPress=nan;
                        TargetOnsetT=GetSecs;
                        while GetSecs-TargetOnsetT<2
                            [keyisDown, secs, keyCode] = KbCheck;
                            if keyCode(KbName('z'))
                                TargetOffsetT=GetSecs;
                                KbWait(-1, 1) % wait until all key released
                                keyPress=0;
                                break
                            elseif keyCode(KbName('/?'))
                                TargetOffsetT=GetSecs;
                                KbWait(-1, 1) % wait until all key released
                                keyPress=1;
                                break
                            elseif keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            else
                                TargetOffsetT=GetSecs;
                            end
                        end
                        Screen('FillRect', win, bgCol, rect)
                        Screen('Flip', win)
                        
                        drawn=false;
                        iniOnset=GetSecs;
                        while GetSecs-iniOnset<0.5
                            [keyisDown, secs, keyCode] = KbCheck;
                            if drawn==false
                                if (ExpTrial(nSerial,locTargetCol)==0 && keyPress==0) || (ExpTrial(nSerial,locTargetCol)==1 && keyPress==1)
                                    ExpTrial(nSerial,locAcc)=1;
                                else
                                    ExpTrial(nSerial,locAcc)=0;
                                end
                                ExpTrial(nSerial,locResT)=TargetOffsetT-TargetOnsetT;
                                
                                fid=fopen(DataFileName,'a');
                                fprintf(fid,'%d\t%d\t%d\t%d\t%d\t%f\t%d\t%f\t%d\t%f\r\n', ExpTrial(nSerial,:));
                                fclose(fid);
                                drawn=true;
                            elseif keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            end
                        end
%                         % feedback draw
%                         distFromWidth = ang2pix(15, 1);
%                         distFromHeight = distFromWidth * disp_ratio;
%                         if ExpTrial(nSerial,locAcc)==1
%                             Screen('DrawTexture', win, feedback_correct, [], [distFromWidth, distFromHeight, rect(3) - distFromWidth, rect(4) - distFromHeight],[],0)
%                         elseif ExpTrial(nSerial,locAcc)==0
%                             Screen('DrawTexture', win, feedback_incorrect, [], [distFromWidth, distFromHeight, rect(3) - distFromWidth, rect(4) - distFromHeight],[],0)
%                         end
%                         Screen('Flip', win)
                        
                        iniOnset=GetSecs;
                        while GetSecs-iniOnset<0.5
                            [keyisDown, secs, keyCode] = KbCheck;
                            if keyCode(KbName('ESCAPE'))
                                Screen('Close', win)
                                ShowCursor;
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end
ShowCursor;
distFromWidth = ang2pix(10, 1);
distFromHeight = distFromWidth * disp_ratio;
Screen('DrawTexture', win, inst_end, [], [distFromWidth, distFromHeight, rect(3) - distFromWidth, rect(4) - distFromHeight],[],0)
Screen('Flip', win)
while 1
    [keyisDown, secs, keyCode] = KbCheck;
    if keyCode(KbName('ESCAPE'))
        break
    end
end
Screen('Close', win)