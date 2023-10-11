Screen('Preference', 'SkipSyncTests', 1)
[a,b]=Screen('OpenWindow',0,[0 0 0],[50 50 800 800]);
Screen('DrawLine',a,[255 255 0], 380, 220, 200 ,400, 5);
Screen('DrawLine',a,[255 255 0], 300, 300, 400 ,400, 5);
Screen('DrawLine',a,[255 255 0], 350, 300, 450 ,300, 5);
Screen('DrawLine',a,[255 255 0], 450, 200, 450 ,420, 5);
Screen('DrawLine',a,[255 255 0], 300, 400, 300 ,470, 5);
Screen('DrawLine',a,[255 255 0], 300, 470, 450 ,470, 5);
Screen('Flip',a);
KbStrokeWait;
sca;