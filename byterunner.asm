INCLUDE Irvine32.inc
Include macros.inc
includelib Winmm.lib
.386
.model flat,stdcall
.stack 4096
PlaySound PROTO,
    pszSound:ptr BYTE,
    hmod:DWORD,
    fdwSound:DWORD
.data

startsound     BYTE "8d82b5_Pacman_Opening_Song_Sound_Effect.wav",0
pausesound     BYTE "pause_KzBkT4p.wav",0
unpausesound   BYTE "08-voice-lg-resume-shortly.wav",0
levelupsound   BYTE "world-of-warcraft-lvl-up.wav",0
endsound       BYTE "oh-you-were-finished.wav",0
arcadesound    BYTE "pac-man-waka-waka.wav",0
deadsound      BYTE "8d82b5_pacman_dies_sound_effect.wav",0
namesound      BYTE "pacman_AwvgsBv.wav",0
lifesound      BYTE "level-up-47165.wav",0


buffer_size = 1000
filename  BYTE "score.txt",0
filenames  BYTE "score.txt", 0
fileHandle   HANDLE ?
sizeofarr dd ?
stringLength DWORD ?
arr byte 500 dup (0)
arr1 byte 500 dup (0)
newHighMsg BYTE "NEW HIGH SCORE!", 0dh, 0ah, 0
currentScore DWORD ?
error BYTE "Cannot create file",0dh,0ah,0
output BYTE "Bytes written to file [output.txt]:",0

level2check byte 0
level3check byte 0
mazing byte 0
enterName byte "Enter Your Name: ",0
highscore byte "Press H to Show Highscore",0ah,0
Inst byte "Press I to Show Instructuctions",0ah,0
highdisp byte "HIGHSCORE",0ah,0
Instdisp byte "INSTRUCTIONS",0ah,0
moveinst byte "Use A, S, D, W For THE MOVEMENT of Runner",0ah,0
Oinst byte "O will give ability to player so that Ghost can't Eat",0ah,0
Tinst byte "T will Teleport Ghost to any Random Position",0ah,0
Finst byte "F will Freeze the Ghost ",0ah,0
dotinst byte ". will increase score",0ah,0
Linst byte "L gives player a extra life",0ah,0
goback byte "Press Any Key to Go Back",0ah,0
Pressing byte "Press Any Key to Continue",0ah,0
tostart byte "Press S to Start the Game",0ah,0
toexit byte "Press Q to Exit the Game",0ah,0
input byte ?,0
user byte 20 dup (" "),0
dash byte "+",0
dash1 byte "+",0

space byte " ",0
ground BYTE "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++",0
ground1 BYTE "+",0ah,0
ground2 BYTE "+",0

FLOOP BYTE 0
delaylevel2 byte 0

delaylevel3 byte 0

Ghostdelay byte 70

temp byte ?

Ending byte "THE END!!",0
life byte "LIVES: ",0
strScore BYTE "Your score is: ",0
score BYTE 0,0
lives BYTE 3
Names byte "Name: ",0
Leveldisp byte "LEVEL: ",0
level byte 1,0

pausse byte "`"

xPos BYTE 20
yPos BYTE 20

oyes byte 0

Fyes byte 0

Lyes byte 0

Tyes byte 0

xGHOSTPos BYTE 25
yGHOSTPos BYTE 25

xGHOST1Pos BYTE 1
yGHOST1Pos BYTE 5

xGHOST2Pos BYTE 102
yGHOST2Pos BYTE 10

Ghostmov byte 'i'

Ghost1mov byte 'j'

Ghost2mov byte 'k'

Ghostloop byte 0

Oloop byte 0

xCoinPos BYTE ?
yCoinPos BYTE ?

xCoin1Pos BYTE ?
yCoin1Pos BYTE ?

xCoin2Pos BYTE ?
yCoin2Pos BYTE ?

xCoin3Pos BYTE ?
yCoin3Pos BYTE ?

xCoin4Pos BYTE ?
yCoin4Pos BYTE ?

xOPos BYTE ?
yOPos BYTE ?

xFruitPos BYTE ?
yFruitPos BYTE ?

xLPos BYTE ?
yLPos BYTE ?

xTPos BYTE ?
yTPos BYTE ?

xFPos BYTE ?
yFPos BYTE ?

inputChar BYTE ?

.code

filehandlingfunc PROC

 mov edx, OFFSET filenames
    call OpenInputFile
    mov fileHandle, eax

    cmp eax, INVALID_HANDLE_VALUE; error opening file ?
    jne file_ok1

        mWrite <"Cannot open file", 0dh, 0ah>
        jmp quit1
    file_ok1:
    mov edx, OFFSET arr
    mov ecx, BUFFER_SIZE
    call ReadFromFile
    jnc check_buffer_size
        mWrite "Error reading file. "
        call WriteWindowsMsg
        jmp close_file1
    check_buffer_size:
    mov sizeofarr, eax
    cmp eax, BUFFER_SIZE
    jb buf_size_ok1
    mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
    jmp quit1
    buf_size_ok1:
    mov arr[eax], 0
   
    call WriteDec
    call Crlf
    mov dl, 45
    mov dh, 17
    call GOTOXY
    mov edx, OFFSET arr
   ; call WriteString
    call Crlf
    close_file1:
    mov eax, fileHandle
    call CloseFile

    quit1:


   mov edx, OFFSET filename
call CreateOutputFile
mov fileHandle, eax

cmp eax, INVALID_HANDLE_VALUE; error found ?
jne file_ok
    mov edx, OFFSET error
    call WriteString
    jmp quit

file_ok:

mov eax, OFFSET arr

mov eax,fileHandle
mov edx, offset arr
mov ecx, sizeofarr
call WriteToFile

mov ecx, eax
mov sizeofarr, ecx
mov stringLength, ecx
mov edi, offset arr


mov eax,0
mov al,score
add eax, 0
 aas
or eax,303030h
mov[edi], ah
inc edi
mov[edi], al
inc edi
mov esi, offset space
mov dl, [esi]
mov[edi], dl
inc edi

mov eax,0
mov al,level
add eax, 0
aas
or eax, 303030h

mov[edi], al
inc edi
mov esi, offset space
mov dl, [esi]
mov[edi], dl
inc edi

mov esi,offset user
mov ecx,lengthof user
l1:
mov dl,[esi]
mov[edi], dl
inc edi
inc esi
loop l1
mov al,0ah
mov [edi],al
inc edi


mov eax, fileHandle
add sizeofarr, 27

mov edx, OFFSET arr
;mov stringLength, sizeofarr
mov ecx, sizeofarr

call WriteToFile

mov edx, offset filename
mov eax, filehandle
call CloseFile

mov edx, OFFSET output

call WriteString


call WriteDec

call Crlf

quit:
ret

filehandlingfunc ENDP
main PROC
; High score comparison will be done after calculating final score

   ; strat menu
    call startByteRunner
    
    call start
    
    call clrscr

    ; draw ground at (0,29):
    mov eax,cyan + (cyan * 16)
    call SetTextColor
     
    
    
    ; creating maze
         call maze1
    call gravity
    call DrawRunner

    call CreateRandomCoin4
    call DrawCoin4

    call CreateRandomCoin3
    call DrawCoin3

     call CreateRandomCoin2
    call DrawCoin2

     call CreateRandomCoin1
    call DrawCoin1

     call CreateRandomCoin
    call DrawCoin

    call Randomize
        

  INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h

      moveUp1:
         cmp yPos,2
          je notup1
          cmp ypos,23
          jne upmov1
          cmp xpos,10
          je notup1
          upmov1:
          cmp ypos,23
          jne upmov2
          cmp xpos,108
          je notup1
          upmov2:
          cmp ypos,5
          jne upmov3
          mov al,35
          mov ecx,50
          loopu1:
          cmp xpos,al
          je notup1
          inc al
          loop loopu1
          upmov3:
            call UpdateRunner
            dec yPos
            call DrawRunner
            notup1:
        jmp afterplayerset 

        moveDown1:
         cmp yPos,28
          je notdown1
          cmp ypos,7
          jne downmov1
          cmp xpos,10
          je notdown1
          downmov1:
          cmp ypos,7
          jne downmov2
          cmp xpos,108
          je notdown1
          downmov2:
          cmp ypos,3
          jne downmov3
          mov al,35
          mov ecx,50
          loopd1:
          cmp xpos,al
          je notdown1
          inc al
          loop loopd1
          downmov3:
        call UpdateRunner
        inc yPos
        call DrawRunner
        notdown1:
       jmp afterplayerset 

        moveLeft1:
         cmp XPos,1
          je notleft1
          cmp xpos,11
          jne leftmov1
          mov al,8
          mov ecx,15
          loopl1:
          cmp ypos,al
          je notleft1
          inc al
          loop loopl1
          leftmov1:
           cmp xpos,109
          jne leftmov2
          mov al,8
          mov ecx,15
          loopl2:
          cmp ypos,al
          je notleft1
          inc al
          loop loopl2
          leftmov2:
          cmp xpos,85
          jne leftmov3
          cmp ypos,4
          je notleft1
          leftmov3:
        call UpdateRunner
        dec xPos
        call DrawRunner
        notleft1:
        jmp afterplayerset 

        moveRight1:
         cmp XPos,118
          je notright1
         cmp XPos,1
          je notright1
          cmp xpos,9
          jne rightmov1
          mov al,8
          mov ecx,15
          loopr1:
          cmp ypos,al
          je notright1
          inc al
          loop loopr1
          rightmov1:
          cmp xpos,107
          jne rightmov2
          mov al,8
          mov ecx,15
          loopr2:
          cmp ypos,al
          je notright1
          inc al
          loop loopr2
          rightmov2:
          cmp xpos,34
          jne rightmov3
          cmp ypos,4
          je notright1
          rightmov3:
        call UpdateRunner
        inc xPos
        call DrawRunner
        notright1:
       jmp afterplayerset 

       
        ;Player Movment
             moveUp:
                ; allow player to jump:
                cmp yPos,2
                jna notup
                 cmp yPos, 16
                jne up0
                mov ecx, 48
                mov al, 35
                u1:
                    cmp xPos,al
                    je notdown
                    inc al
                loop u1
                up0:
                 cmp yPos, 24
                jne up1
                cmp xPos, 34
                je notup
                up1:
                cmp yPos, 24
                jne up2
                cmp xPos, 83
                je notup
                up2:
                cmp xPos, 40
                jne up3
                cmp yPos, 23
                je notup
                up3:
                cmp xPos, 78
                jne up4
                cmp yPos, 23
                je notup
                up4:
                cmp yPos, 11
                jne up5
                mov al,24
                mov ecx,8
                u2:
                cmp xPos, al
                je notup
                inc al
                loop u2
                up5:
                 cmp yPos, 11
                jne up6
                mov al,85
                mov ecx,8
                u3:
                cmp xPos, al
                je notup
                inc al
                loop u3
                up6:
                cmp xPos, 58
                jne up7
                cmp ypos, 13
                je notup
                up7:
                 cmp yPos, 19
                jne up8
                mov al,45
                mov ecx, 30
                u4:
                cmp xPos, al
                je notup
                inc al
                loop u4
                up8:
                cmp yPos, 24
                jne up9
                mov al,45
                mov ecx, 30
                u5:
                cmp xPos, al
                je notup
                inc al
                loop u5
                up9:
                cmp xPos, 10
                jne up10
                cmp yPos, 23
                je notup
                up10:
                cmp xPos, 108
                jne up11
                cmp yPos, 23
                je notup
                up11:
                cmp yPos, 5
                jne up12
                mov al, 35
                mov ecx, 50
                u6:
                cmp xPos, al
                je notup
                inc al
                loop u6
                up12:
                call UpdateRunner
                dec yPos
                call DrawRunner
                notup:
                jmp afterPlayerset

            moveDown:
                cmp yPos,27
                ja notdown
                cmp yPos, 15
                jne down0
                cmp xPos, 83
                je notdown
                down0:
                cmp yPos, 15
                jne down1
                cmp xPos, 34
                je notdown
                down1:
                cmp yPos, 14
                jne down2
                mov ecx, 48
                mov al, 35
                d1:
                cmp xPos,al
                je notdown
                inc al
                loop d1
                down2:
                cmp xPos, 40
                jne down3
                cmp yPos, 19
                je notdown
                down3:
                cmp xPos, 78
                jne down4
                cmp yPos, 19
                je notdown
                down4:
                cmp level,2
                jb down12
                cmp yPos, 9
                jne down5
                mov al,24
                mov ecx,8
                d2:
                cmp xPos, al
                je notdown
                inc al
                loop d2
                down5:
                 cmp yPos, 9
                jne down6
                mov al,85
                mov ecx,8
                d3:
                cmp xPos, al
                je notdown
                inc al
                loop d3
                down6:
                cmp xPos, 58
                jne down7
                cmp ypos, 8
                je notdown
                down7:
                 cmp yPos, 17
                jne down8
                mov al,45
                mov ecx, 30
                d4:
                cmp xPos, al
                je notdown
                inc al
                loop d4
                down8:
                cmp yPos, 22
                jne down9
                mov al,45
                mov ecx, 30
                d5:
                cmp xPos, al
                je notdown
                inc al
                loop d5
                down9:
                cmp xPos, 10
                jne down10
                cmp yPos, 7
                je notup
                down10:
                cmp xPos, 108
                jne down11
                cmp yPos, 7
                je notup
                down11:
                cmp yPos, 3
                jne down12
                mov al, 35
                mov ecx, 50
                d6:
                   cmp xPos, al
                   je notdown
                   inc al
                   loop d6
                down12:
                call UpdateRunner
                inc yPos
                call DrawRunner
                notdown:
                jmp afterPlayerset

            moveLeft:
                cmp xPos,1
                jna notleft
                cmp yPos, 15
                jne left0
                cmp xPos, 83
                je notleft
                left0:
                cmp xPos, 84
                jne left1
                mov al,16
                mov ecx, 8
                le1:
                cmp yPos, al
                je notleft
                inc al
                loop le1
                left1:
                cmp xPos, 41
                jne left2
                mov ecx,3
                mov al,20
                le2:
                cmp yPos, al
                je notleft
                inc al
                loop le2
                left2:
                 cmp xPos, 79
                jne left3
                mov ecx,3
                mov al,20
                le3:
                cmp yPos, al
                je notleft
                inc al
                loop le3
                left3:
                 cmp xPos, 32
                jne left4
                cmp yPos, 10
                je notleft
                left4:
                cmp xPos, 93
                jne left5
                cmp yPos, 10
                je notleft
                left5:
                cmp xPos, 35
                jne left6
                mov al,16
                mov ecx, 8
                le4:
                cmp yPos, al
                je notleft
                inc al
                loop le4
                left6:
                cmp xPos, 59
                jne left7
                mov al, 9
                mov ecx, 4
                le5:
                cmp yPos, al
                je notleft
                inc al
                loop le5
                left7:
                cmp xPos, 75
                jne left8
                cmp yPos, 18
                je notleft
                left8:
                cmp xPos, 75
                jne left9
                cmp yPos, 23
                je notleft
                left9:
                cmp xPos, 85
                jne left10
                cmp yPos, 4
                je notleft
                left10:
                cmp xPos,109
                jne left11
                mov al, 8
                mov ecx, 15
                le6:
                cmp yPos, al
                je notleft 
                inc al
                loop le6
                left11:
                cmp xPos,11
                jne left12
                mov al, 8
                mov ecx, 15
                le7:
                cmp yPos, al
                je notleft 
                inc al
                loop le7
                left12:
                call UpdateRunner
                dec xPos
                call DrawRunner
                notleft:
                jmp afterPlayerset

            moveRight:
                cmp xPos, 117
                ja notright
                cmp yPos, 15
                jne right0
                cmp xPos, 34
                je notright
                right0:
                cmp xPos, 33
                jne right1
                mov al,16
                mov ecx, 8
                r1:
                cmp yPos, al
                je notright
                inc al
                loop r1
                right1:
                 cmp xPos, 39
                jne right2
                mov ecx,3
                mov al,20
                r2:
                cmp yPos, al
                je notright
                inc al
                loop r2
                right2:
                 cmp xPos, 77
                jne right3
                mov ecx,3
                mov al,20
                r3:
                cmp yPos, al
                je notright
                inc al
                loop r3
                right3:
                cmp xPos, 23
                jne right4
                cmp yPos, 10
                je notright
                right4:
                cmp xPos, 84
                jne right5
                cmp yPos, 10
                je notright
                right5:
                cmp xPos, 82
                jne right6
                mov al,16
                mov ecx, 8
                r4:
                cmp yPos, al
                je notright
                inc al
                loop r4
                right6:
                cmp xPos, 57
                jne right7
                mov al, 9
                mov ecx, 4
                r5:
                cmp yPos, al
                je notleft
                inc al
                loop r5
                right7:
                cmp xPos, 44
                jne right8
                cmp yPos, 18
                je notright
                right8:
                cmp xPos, 44
                jne right9
                cmp yPos, 23
                je notright
                right9:
                cmp xPos, 34
                jne right10
                cmp yPos, 4
                je notright
                right10:
                cmp xPos,107
                jne right11
                mov al, 8
                mov ecx, 15
                r6:
                cmp yPos, al
                je notright 
                inc al
                loop r6
                right11:
                cmp xPos,9
                jne right12
                mov al, 8
                mov ecx, 15
                r7:
                cmp yPos, al
                je notright
                inc al
                loop r7
                right12:
                call UpdateRunner
                inc xPos
                call DrawRunner
                notright:
                jmp afterPlayerset

           Level3:
           INVOKE PlaySound, OFFSET levelupsound, NULL, 20001h
           mov level3check,1
           mov ghostdelay,20
                jmp ll3
           Level2:
           mov level2check,1
           INVOKE PlaySound, OFFSET levelupsound, NULL, 20001h
           
                mov ghostdelay,40
                cmp fyes,1
                je dot
                mov fyes, 1
                call CreateRandomF
                call DrawF
                call CreateRandomFruit
                call DrawFruit
                dot:
                jmp ll2


    gameLoop:
        
        ;increase level

        cmp score, 5
        jb noneed
        mov level,2

        cmp score, 10
        jb noneed
        mov level,3

        noneed:
     
        ;check for coin collision

            mov al, xCoinpos
            cmp xCoin1pos,al
            jne c1ok
            mov al,yCoinpos
            cmp yCoin1pos,al
            jne c1ok
            call CreateRandomCoin
            call drawCoin
            c1ok:

            mov al, xCoin2pos
            cmp xCoin1pos,al
            jne c2ok
            mov al,yCoin2pos
            cmp yCoin1pos,al
            jne c2ok
            call CreateRandomCoin2
            call drawCoin2
            c2ok:

            mov al, xCoin2pos
            cmp xCoinpos,al
            jne c3ok
            mov al,yCoin2pos
            cmp yCoinpos,al
            jne c3ok
            call CreateRandomCoin2
            call drawCoin2
            c3ok:

            mov al, xCoin2pos
            cmp xCoin3pos,al
            jne c4ok
            mov al,yCoin2pos
            cmp yCoin3pos,al
            jne c4ok
            call CreateRandomCoin3
            call drawCoin3
            c4ok:

            mov al, xCoin1pos
            cmp xCoin3pos,al
            jne c5ok
            mov al,yCoin1pos
            cmp yCoin3pos,al
            jne c5ok
            call CreateRandomCoin3
            call drawCoin3
            c5ok:

            mov al, xCoinpos
            cmp xCoin3pos,al
            jne c6ok
            mov al,yCoinpos
            cmp yCoin3pos,al
            jne c6ok
            call CreateRandomCoin3
            call drawCoin3
            c6ok:

            mov al, xCoin4pos
            cmp xCoin3pos,al
            jne c7ok
            mov al,yCoin4pos
            cmp yCoin3pos,al
            jne c7ok
            call CreateRandomCoin3
            call drawCoin3
            c7ok:

            mov al, xCoin2pos
            cmp xCoin4pos,al
            jne c8ok
            mov al,yCoin2pos
            cmp yCoin4pos,al
            jne c8ok
            call CreateRandomCoin4
            call drawCoin4
            c8ok:

            mov al, xCoin1pos
            cmp xCoin4pos,al
            jne c9ok
            mov al,yCoin1pos
            cmp yCoin4pos,al
            jne c9ok
            call CreateRandomCoin4
            call drawCoin4
            c9ok:

            mov al, xCoinpos
            cmp xCoin4pos,al
            jne c10ok
            mov al,yCoinpos
            cmp yCoin4pos,al
            jne c10ok
            call CreateRandomCoin4
            call drawCoin4
            c10ok:

            cmp level, 2
            jl noth
             mov al, xOpos
            cmp xfruitpos,al
            jne c11ok
            mov al,yOpos
            cmp yfruitpos,al
            jne c11ok
            call CreateRandomfruit
            call drawfruit
            c11ok:

              mov al, xFpos
            cmp xfruitpos,al
            jne c12ok
            mov al,yFpos
            cmp yfruitpos,al
            jne c12ok
            call CreateRandomF
            call drawF
            c12ok:



            noth:

        ; getting points:
            mov bl,xPos
            cmp bl,xCoinPos
            jne notCollecting
            mov bl,yPos
            cmp bl,yCoinPos
            jne notCollecting
            ; player is intersecting coin:
            inc score
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomCoin
            call DrawCoin
            notCollecting:

            mov bl,xPos
            cmp bl,xCoin1Pos
            jne notCollecting1
            mov bl,yPos
            cmp bl,yCoin1Pos
            jne notCollecting1
            ; player is intersecting coin:
            inc score
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomCoin1
            call DrawCoin1
            notCollecting1:

            mov bl,xPos
            cmp bl,xCoin2Pos
            jne notCollecting2
            mov bl,yPos
            cmp bl,yCoin2Pos
            jne notCollecting2
            ; player is intersecting coin:
            inc score
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomCoin2
            call DrawCoin2
            notCollecting2:

            mov bl,xPos
            cmp bl,xCoin3Pos
            jne notCollecting23
            mov bl,yPos
            cmp bl,yCoin3Pos
            jne notCollecting23
            ; player is intersecting coin:
            inc score
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomCoin3
            call DrawCoin3
            notCollecting23:

            mov bl,xPos
            cmp bl,xCoin4Pos
            jne notCollecting22
            mov bl,yPos
            cmp bl,yCoin4Pos
            jne notCollecting22
            ; player is intersecting coin:
            inc score
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomCoin4
            call DrawCoin4
            notCollecting22:
        ; power up for level 2
            cmp level,2
            jb notCollecting0
             cmp delaylevel2,0
            jne ll2
            cmp level2check,0
            je level2
            
            ll2:
            cmp Oyes,0
            je ocreate
            mov bl,xPos
            cmp bl,xOPos
            jne notCollecting0
            mov bl,yPos
            cmp bl,yOPos
            jne notCollecting0
            ; player is intersecting O:
            ADD score, 5
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            mov Oloop, 50
            ocreate:
            mov Oyes, 1
            call CreateRandomO
            call DrawO
            notCollecting0:
             mov bl,xPos
            cmp bl,xFPos
            jne notCollecting00
            mov bl,yPos
            cmp bl,yFPos
            jne notCollecting00
            mov floop, 50
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomF
            call DrawF
            notCollecting00:

            cmp level,2
            jl skipper
            mov bl,xPos
            cmp bl,xfruitPos
            jne notCollecting000
            mov bl,yPos
            cmp bl,yfruitPos
            jne notCollecting000
            add score, 5
            INVOKE PlaySound, OFFSET arcadesound, NULL, 20001h
            call CreateRandomfruit
            call Drawfruit
            notCollecting000:
            skipper:
        ; power up for level 3
            cmp level,3
            jb notCollecting02
             cmp delaylevel3,0
            jne ll3
            cmp level3check,0
            je level3
            ll3:
            cmp lyes,0
            jbe Lcreate
            mov bl,xPos
            cmp bl,xLPos
            jne notCollecting01
            mov bl,yPos
            cmp bl,yLPos
            jne notCollecting01
            ; player is intersecting L:
            inc lives
            INVOKE PlaySound, OFFSET lifesound, NULL, 20001h
            Lcreate:
            mov Lyes, 1
            call CreateRandomL
            call DrawL
            notCollecting01:

            cmp Tyes,0
            jne notCollecting02
            cmp Tyes, 2
            je notCollecting02
            mov Tyes, 2
            call CreateRandomT
            call DrawT
            notCollecting02:

            cmp Oloop,0
            jg dontcol
            mov bl,xPos
            cmp bl,xGhostPos
            jne notdec
            mov bl,yPos
            cmp bl,yGhostPos
            jne notdec
            ; player is intersecting ghost:
            dec lives
            INVOKE PlaySound, OFFSET deadsound, NULL, 20001h
            call gravity
            notdec:

            mov bl,xPos
            cmp bl,xGhost1Pos
            jne notdec1
            mov bl,yPos
            cmp bl,yGhost1Pos
            jne notdec1
            ; player is intersecting ghost1:
            dec lives
            INVOKE PlaySound, OFFSET deadsound, NULL, 20001h
            call gravity
            notdec1:

            mov bl,xPos
            cmp bl,xGhost2Pos
            jne notdec2
            mov bl,yPos
            cmp bl,yGhost2Pos
            jne notdec2
            ; player is intersecting ghost2:
            dec lives
            INVOKE PlaySound, OFFSET deadsound, NULL, 20001h
            call gravity
            notdec2:

            dontcol:
            cmp Oloop,0
            jle sky
            dec Oloop
            sky:

            mov bl,xGhostPos
            cmp bl,xTPos
            jne notCollecting03
            mov bl,yGhostPos
            cmp bl,yTPos
            jne notCollecting03
            ; Ghost is intersecting T:
            call teleport
            call CreateRandomT
            call DrawT
           notCollecting03:

           mov bl,xGhost1Pos
            cmp bl,xTPos
            jne notCollecting031
            mov bl,yGhost1Pos
            cmp bl,yTPos
            jne notCollecting031
            ; Ghost1 is intersecting T:
            call teleport1
            call CreateRandomT
            call DrawT
           notCollecting031:

           mov bl,xGhost2Pos
            cmp bl,xTPos
            jne notCollecting032
            mov bl,yGhost2Pos
            cmp bl,yTPos
            jne notCollecting032
            ; Ghost2 is intersecting T:
            call teleport2
            call CreateRandomT
            call DrawT
           notCollecting032:

        mov eax,lightgray (black * 16)
        call SetTextColor

        ; draw score:
            mov dl,0
            mov dh,0
            call Gotoxy
            mov edx,OFFSET strScore
            call WriteString
            mov al,score
            call WriteInt

       ; draw lives:
            mov dl,100
            mov dh,0
            call Gotoxy
            mov edx,OFFSET Life
            call WriteString
            mov al,lives
            call WriteInt

       ; draw User:
            mov dl,38
            mov dh,0
            call Gotoxy
            mov edx,OFFSET Names
            call WriteString
            mov dl,44
            mov dh,0
            call Gotoxy
            mov edx,OFFSET User
            call WriteString

      ; draw Level:
            mov dl,70
            mov dh,0
            call Gotoxy
            mov edx,OFFSET Leveldisp
            call WriteString
            mov al, level
            call Writeint
            
    ; End the game is life gets zero
       cmp lives,0
       jle ENDGame

        onGround:

            ; get user key input:
            call Readkey
            mov inputChar,al

            call drawGhost
            cmp level,2
            jb skip
            call drawGhost1
            call drawGhost2
             cmp mazing,1
             je skip
             call maze
             mov mazing,1
            Skip:

            mov eax,0
            mov al,Ghostdelay
                call Delay

             call DrawRunner

         
         ; Pause game if user types 'p':
            cmp inputChar,"p"
            je Pausestart

            Pauseend:
               

        ; exit game if user types 'q':
            cmp inputChar,"q"
            je ENDGame

        cmp level,1
        jne skipping
        cmp inputChar,"w"
        je moveUp1

        cmp inputChar,"s"
        je moveDown1

        cmp inputChar,"a"
        je moveLeft1

        cmp inputChar,"d"
        je moveRight1

        jmp afterPlayerset
        
        skipping:
        cmp inputChar,"w"
        je moveUp

        cmp inputChar,"s"
        je moveDown

        cmp inputChar,"a"
        je moveLeft

        cmp inputChar,"d"
        je moveRight

        afterPlayerset:

        cmp Floop,0
        jg notGhost2

        ;Ghost Movement
            
            cmp [Ghostloop], 0
            ja ok
            mov eax,3
            call RandomRange
           
                mov [Ghostloop], 40
                cmp eax,0
                jne g1
                mov [Ghostmov], 'l' 
                mov [Ghost1mov], 'j' 
                mov [Ghost2mov], 'k' 
                jmp ok
                g1:
                cmp eax,1
                jne g2
                mov [Ghostmov], 'k' 
                mov [Ghost1mov], 'i' 
                mov [Ghost2mov], 'l' 
                jmp ok
                g2:
                cmp eax,2
                jne g3
                mov [Ghostmov], 'j'
                mov [Ghost1mov], 'k'
                mov [Ghost2mov], 'i' 
                jmp ok
                g3:
                mov [Ghostmov], 'i' 
                mov [Ghost1mov], 'l'
                mov [Ghost2mov], 'j' 

                
            ok:
                dec [GhostLoop]
                cmp Ghostmov,'i'
                jne moveGhostDown
            moveGhostUp:
                cmp yGhostPos,2
                jna notGhostup

                 cmp yGhostPos, 16
                jne Ghostup0
                mov ecx, 48
                mov al, 35
                Ghostu1:
                    cmp xGhostPos,al
                    je notGhostdown
                    inc al
                loop Ghostu1
                Ghostup0:
                 cmp yGhostPos, 24
                jne Ghostup1
                cmp xGhostPos, 34
                je notGhostup
                Ghostup1:
                cmp yGhostPos, 24
                jne Ghostup2
                cmp xGhostPos, 83
                je notGhostup
                Ghostup2:
                cmp xGhostPos, 40
                jne Ghostup3
                cmp yGhostPos, 23
                je notGhostup
                Ghostup3:
                cmp xGhostPos, 78
                jne Ghostup4
                cmp yGhostPos, 23
                je notGhostup
                Ghostup4:
                cmp yGhostPos, 11
                jne Ghostup5
                mov al,24
                mov ecx,8
                Ghostu2:
                cmp xGhostPos, al
                je notGhostup
                inc al
                loop Ghostu2
                Ghostup5:
                 cmp yGhostPos, 11
                jne Ghostup6
                mov al,85
                mov ecx,8
                Ghostu3:
                cmp xGhostPos, al
                je notGhostup
                inc al
                loop Ghostu3
                Ghostup6:
                cmp xGhostPos, 58
                jne Ghostup7
                cmp yGhostpos, 13
                je notGhostup
                Ghostup7:
                 cmp yGhostPos, 19
                jne Ghostup8
                mov al,45
                mov ecx, 30
                Ghostu4:
                cmp xGhostPos, al
                je notGhostup
                inc al
                loop Ghostu4
                Ghostup8:
                cmp yGhostPos, 24
                jne Ghostup9
                mov al,45
                mov ecx, 30
                Ghostu5:
                cmp xGhostPos, al
                je notGhostup
                inc al
                loop Ghostu5
                Ghostup9:
                cmp xGhostPos, 10
                jne Ghostup10
                cmp yGhostPos, 23
                je notGhostup
                Ghostup10:
                cmp xGhostPos, 108
                jne Ghostup11
                cmp yGhostPos, 23
                je notGhostup
                Ghostup11:
                cmp yGhostPos, 5
                jne Ghostup12
                mov al, 35
                mov ecx, 50
                Ghostu6:
                cmp xGhostPos, al
                je notGhostup
                inc al
                loop Ghostu6
                Ghostup12:

                call UpdateGhost
                dec yGhostPos
                call DrawGhost
               jmp notGhost
                notGhostup:
                  mov Ghostmov, 'l'

            moveGhostDown:
            cmp Ghostmov,'k'
            jne moveGhostLeft
                cmp yGhostPos,27
                ja notGhostdown

                 cmp yGhostPos, 15
                jne Ghostdown0
                cmp xGhostPos, 83
                je notGhostdown
                Ghostdown0:
                cmp yGhostPos, 15
                jne Ghostdown1
                cmp xGhostPos, 34
                je notGhostdown
                Ghostdown1:
                cmp yGhostPos, 14
                jne Ghostdown2
                mov ecx, 48
                mov al, 35
                Ghostd1:
                cmp xGhostPos,al
                je notGhostdown
                inc al
                loop Ghostd1
                Ghostdown2:
                cmp xGhostPos, 40
                jne Ghostdown3
                cmp yGhostPos, 19
                je notGhostdown
                Ghostdown3:
                cmp xGhostPos, 78
                jne Ghostdown4
                cmp yGhostPos, 19
                je notGhostdown
                Ghostdown4:
                cmp yGhostPos, 9
                jne Ghostdown5
                mov al,24
                mov ecx,8
                Ghostd2:
                cmp xGhostPos, al
                je notGhostdown
                inc al
                loop Ghostd2
                Ghostdown5:
                 cmp yGhostPos, 9
                jne Ghostdown6
                mov al,85
                mov ecx,8
                Ghostd3:
                cmp xGhostPos, al
                je notGhostdown
                inc al
                loop Ghostd3
                Ghostdown6:
                cmp xGhostPos, 58
                jne Ghostdown7
                cmp yGhostpos, 8
                je notGhostdown
                Ghostdown7:
                 cmp yGhostPos, 17
                jne Ghostdown8
                mov al,45
                mov ecx, 30
                Ghostd4:
                cmp xGhostPos, al
                je notGhostdown
                inc al
                loop Ghostd4
                Ghostdown8:
                cmp yGhostPos, 22
                jne Ghostdown9
                mov al,45
                mov ecx, 30
                Ghostd5:
                cmp xGhostPos, al
                je notGhostdown
                inc al
                loop Ghostd5
                Ghostdown9:
                cmp xGhostPos, 10
                jne Ghostdown10
                cmp yGhostPos, 7
                je notGhostup
                Ghostdown10:
                cmp xGhostPos, 108
                jne Ghostdown11
                cmp yGhostPos, 7
                je notGhostup
                Ghostdown11:
                cmp yGhostPos, 3
                jne Ghostdown12
                mov al, 35
                mov ecx, 50
                Ghostd6:
                   cmp xGhostPos, al
                   je notGhostdown
                   inc al
                   loop Ghostd6
                Ghostdown12:

                call UpdateGhost
                inc yGhostPos
                call DrawGhost
               jmp notGhost
                notGhostdown:
                  mov Ghostmov, 'j'
                 

            moveGhostLeft:
            cmp Ghostmov,'j'
            jne moveGhostRight
                cmp xGhostPos,1
                jna notGhostleft

                cmp yGhostPos, 15
                jne Ghostleft0
                cmp xGhostPos, 83
                je notGhostleft
                Ghostleft0:
                cmp xGhostPos, 84
                jne Ghostleft1
                mov al,16
                mov ecx, 8
                Ghostle1:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostle1
                Ghostleft1:
                cmp xGhostPos, 41
                jne Ghostleft2
                mov ecx,3
                mov al,20
                Ghostle2:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostle2
                Ghostleft2:
                 cmp xGhostPos, 79
                jne Ghostleft3
                mov ecx,3
                mov al,20
                Ghostle3:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostle3
                Ghostleft3:
                 cmp xGhostPos, 32
                jne Ghostleft4
                cmp yGhostPos, 10
                je notGhostleft
                Ghostleft4:
                cmp xGhostPos, 93
                jne Ghostleft5
                cmp yGhostPos, 10
                je notGhostleft
                Ghostleft5:
                cmp xGhostPos, 35
                jne Ghostleft6
                mov al,16
                mov ecx, 8
                Ghostle4:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostle4
                Ghostleft6:
                cmp xGhostPos, 59
                jne Ghostleft7
                mov al, 9
                mov ecx, 4
                Ghostle5:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostle5
                Ghostleft7:
                cmp xGhostPos, 76
                jne Ghostleft8
                cmp yGhostPos, 18
                je notGhostleft
                Ghostleft8:
                cmp xGhostPos, 76
                jne Ghostleft9
                cmp yGhostPos, 23
                je notGhostleft
                Ghostleft9:
                cmp xGhostPos, 85
                jne Ghostleft10
                cmp yGhostPos, 4
                je notGhostleft
                Ghostleft10:
                cmp xGhostPos,109
                jne Ghostleft11
                mov al, 8
                mov ecx, 15
                Ghostle6:
                cmp yGhostPos, al
                je notGhostleft 
                inc al
                loop Ghostle6
                Ghostleft11:
                cmp xGhostPos,11
                jne Ghostleft12
                mov al, 8
                mov ecx, 15
                Ghostle7:
                cmp yGhostPos, al
                je notGhostleft 
                inc al
                loop Ghostle7
                Ghostleft12:

                call UpdateGhost
                dec xGhostPos
                call DrawGhost
               jmp notGhost
                notGhostleft:
                  mov Ghostmov, 'i'

            moveGhostRight:
            cmp Ghostmov,'l'
            jne notGhost
                cmp xGhostPos,117
                ja notGhostright

                cmp yGhostPos, 15
                jne Ghostright0
                cmp xGhostPos, 34
                je notGhostright
                Ghostright0:
                cmp xGhostPos, 33
                jne Ghostright1
                mov al,16
                mov ecx, 8
                Ghostr1:
                cmp yGhostPos, al
                je notGhostright
                inc al
                loop Ghostr1
                Ghostright1:
                 cmp xGhostPos, 39
                jne Ghostright2
                mov ecx,3
                mov al,20
                Ghostr2:
                cmp yGhostPos, al
                je notGhostright
                inc al
                loop Ghostr2
                Ghostright2:
                 cmp xGhostPos, 77
                jne Ghostright3
                mov ecx,3
                mov al,20
                Ghostr3:
                cmp yGhostPos, al
                je notGhostright
                inc al
                loop Ghostr3
                Ghostright3:
                cmp xGhostPos, 23
                jne Ghostright4
                cmp yGhostPos, 10
                je notGhostright
                Ghostright4:
                cmp xGhostPos, 84
                jne Ghostright5
                cmp yGhostPos, 10
                je notGhostright
                Ghostright5:
                cmp xGhostPos, 82
                jne Ghostright6
                mov al,16
                mov ecx, 8
                Ghostr4:
                cmp yGhostPos, al
                je notGhostright
                inc al
                loop Ghostr4
                Ghostright6:
                cmp xGhostPos, 57
                jne Ghostright7
                mov al, 9
                mov ecx, 4
                Ghostr5:
                cmp yGhostPos, al
                je notGhostleft
                inc al
                loop Ghostr5
                Ghostright7:
                cmp xGhostPos, 44
                jne Ghostright8
                cmp yGhostPos, 18
                je notGhostright
                Ghostright8:
                cmp xGhostPos, 44
                jne Ghostright9
                cmp yGhostPos, 23
                je notGhostright
                Ghostright9:
                cmp xGhostPos, 34
                jne Ghostright10
                cmp yGhostPos, 4
                je notGhostright
                Ghostright10:
                cmp xGhostPos,107
                jne Ghostright11
                mov al, 8
                mov ecx, 15
                Ghostr6:
                cmp yGhostPos, al
                je notGhostright 
                inc al
                loop Ghostr6
                Ghostright11:
                cmp xGhostPos,9
                jne Ghostright12
                mov al, 8
                mov ecx, 15
                Ghostr7:
                cmp yGhostPos, al
                je notGhostright
                inc al
                loop Ghostr7
                Ghostright12:

                call UpdateGhost
                inc xGhostPos
                call DrawGhost
               jmp notGhost
                notGhostright:
                  mov Ghostmov, 'k'
          NotGhost:
          cmp level,1
          je gameloop

          cmp level,2
          jb notghost2
                cmp Ghost1mov,'i'
                jne moveGhost1Down
            moveGhost1Up:
                cmp yGhost1Pos,2
                jna notGhost1up

                 cmp yGhost1Pos, 16
                jne Ghost1up0
                mov ecx, 48
                mov al, 35
                Ghost1u1:
                    cmp xGhost1Pos,al
                    je notGhost1down
                    inc al
                loop Ghost1u1
                Ghost1up0:
                 cmp yGhost1Pos, 24
                jne Ghost1up1
                cmp xGhost1Pos, 34
                je notGhost1up
                Ghost1up1:
                cmp yGhost1Pos, 24
                jne Ghost1up2
                cmp xGhost1Pos, 83
                je notGhost1up
                Ghost1up2:
                cmp xGhost1Pos, 40
                jne Ghost1up3
                cmp yGhost1Pos, 23
                je notGhost1up
                Ghost1up3:
                cmp xGhost1Pos, 78
                jne Ghost1up4
                cmp yGhost1Pos, 23
                je notGhost1up
                Ghost1up4:
                cmp yGhost1Pos, 11
                jne Ghost1up5
                mov al,24
                mov ecx,8
                Ghost1u2:
                cmp xGhost1Pos, al
                je notGhost1up
                inc al
                loop Ghost1u2
                Ghost1up5:
                 cmp yGhost1Pos, 11
                jne Ghost1up6
                mov al,85
                mov ecx,8
                Ghost1u3:
                cmp xGhost1Pos, al
                je notGhost1up
                inc al
                loop Ghost1u3
                Ghost1up6:
                cmp xGhost1Pos, 58
                jne Ghost1up7
                cmp yGhost1pos, 13
                je notGhost1up
                Ghost1up7:
                 cmp yGhost1Pos, 19
                jne Ghost1up8
                mov al,45
                mov ecx, 30
                Ghost1u4:
                cmp xGhost1Pos, al
                je notGhost1up
                inc al
                loop Ghost1u4
                Ghost1up8:
                cmp yGhost1Pos, 24
                jne Ghost1up9
                mov al,45
                mov ecx, 30
                Ghost1u5:
                cmp xGhost1Pos, al
                je notGhost1up
                inc al
                loop Ghost1u5
                Ghost1up9:
                cmp xGhost1Pos, 10
                jne Ghost1up10
                cmp yGhost1Pos, 23
                je notGhost1up
                Ghost1up10:
                cmp xGhost1Pos, 108
                jne Ghost1up11
                cmp yGhost1Pos, 23
                je notGhost1up
                Ghost1up11:
                cmp yGhost1Pos, 5
                jne Ghost1up12
                mov al, 35
                mov ecx, 50
                Ghost1u6:
                cmp xGhost1Pos, al
                je notGhost1up
                inc al
                loop Ghost1u6
                Ghost1up12:

                call UpdateGhost1
                dec yGhost1Pos
                call DrawGhost1
               jmp notGhost1
                notGhost1up:
                  mov Ghost1mov, 'l'

            moveGhost1Down:
            cmp Ghost1mov,'k'
            jne moveGhost1Left
                cmp yGhost1Pos,27
                ja notGhost1down

                 cmp yGhost1Pos, 15
                jne Ghost1down0
                cmp xGhost1Pos, 83
                je notGhost1down
                Ghost1down0:
                cmp yGhost1Pos, 15
                jne Ghost1down1
                cmp xGhost1Pos, 34
                je notGhost1down
                Ghost1down1:
                cmp yGhost1Pos, 14
                jne Ghost1down2
                mov ecx, 48
                mov al, 35
                Ghost1d1:
                cmp xGhost1Pos,al
                je notGhost1down
                inc al
                loop Ghost1d1
                Ghost1down2:
                cmp xGhost1Pos, 40
                jne Ghost1down3
                cmp yGhost1Pos, 19
                je notGhost1down
                Ghost1down3:
                cmp xGhost1Pos, 78
                jne Ghost1down4
                cmp yGhost1Pos, 19
                je notGhost1down
                Ghost1down4:
                cmp yGhost1Pos, 9
                jne Ghost1down5
                mov al,24
                mov ecx,8
                Ghost1d2:
                cmp xGhost1Pos, al
                je notGhost1down
                inc al
                loop Ghost1d2
                Ghost1down5:
                 cmp yGhost1Pos, 9
                jne Ghost1down6
                mov al,85
                mov ecx,8
                Ghost1d3:
                cmp xGhost1Pos, al
                je notGhost1down
                inc al
                loop Ghost1d3
                Ghost1down6:
                cmp xGhost1Pos, 58
                jne Ghost1down7
                cmp yGhost1pos, 8
                je notGhost1down
                Ghost1down7:
                 cmp yGhost1Pos, 17
                jne Ghost1down8
                mov al,45
                mov ecx, 30
                Ghost1d4:
                cmp xGhost1Pos, al
                je notGhost1down
                inc al
                loop Ghost1d4
                Ghost1down8:
                cmp yGhost1Pos, 22
                jne Ghost1down9
                mov al,45
                mov ecx, 30
                Ghost1d5:
                cmp xGhost1Pos, al
                je notGhost1down
                inc al
                loop Ghost1d5
                Ghost1down9:
                cmp xGhost1Pos, 10
                jne Ghost1down10
                cmp yGhost1Pos, 7
                je notGhost1up
                Ghost1down10:
                cmp xGhost1Pos, 108
                jne Ghost1down11
                cmp yGhost1Pos, 7
                je notGhost1up
                Ghost1down11:
                cmp yGhost1Pos, 3
                jne Ghost1down12
                mov al, 35
                mov ecx, 50
                Ghost1d6:
                   cmp xGhost1Pos, al
                   je notGhost1down
                   inc al
                   loop Ghost1d6
                Ghost1down12:

                call UpdateGhost1
                inc yGhost1Pos
                call DrawGhost1
               jmp notGhost1
                notGhost1down:
                  mov Ghost1mov, 'j'
                 

            moveGhost1Left:
            cmp Ghost1mov,'j'
            jne moveGhost1Right
                cmp xGhost1Pos,1
                jna notGhost1left

                cmp yGhost1Pos, 15
                jne Ghost1left0
                cmp xGhost1Pos, 83
                je notGhost1left
                Ghost1left0:
                cmp xGhost1Pos, 84
                jne Ghost1left1
                mov al,16
                mov ecx, 8
                Ghost1le1:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1le1
                Ghost1left1:
                cmp xGhost1Pos, 41
                jne Ghost1left2
                mov ecx,3
                mov al,20
                Ghost1le2:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1le2
                Ghost1left2:
                 cmp xGhost1Pos, 79
                jne Ghost1left3
                mov ecx,3
                mov al,20
                Ghost1le3:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1le3
                Ghost1left3:
                 cmp xGhost1Pos, 32
                jne Ghost1left4
                cmp yGhost1Pos, 10
                je notGhost1left
                Ghost1left4:
                cmp xGhost1Pos, 93
                jne Ghost1left5
                cmp yGhost1Pos, 10
                je notGhost1left
                Ghost1left5:
                cmp xGhost1Pos, 35
                jne Ghost1left6
                mov al,16
                mov ecx, 8
                Ghost1le4:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1le4
                Ghost1left6:
                cmp xGhost1Pos, 59
                jne Ghost1left7
                mov al, 9
                mov ecx, 4
                Ghost1le5:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1le5
                Ghost1left7:
                cmp xGhost1Pos, 76
                jne Ghost1left8
                cmp yGhost1Pos, 18
                je notGhost1left
                Ghost1left8:
                cmp xGhost1Pos, 76
                jne Ghost1left9
                cmp yGhost1Pos, 23
                je notGhost1left
                Ghost1left9:
                cmp xGhost1Pos, 85
                jne Ghost1left10
                cmp yGhost1Pos, 4
                je notGhost1left
                Ghost1left10:
                cmp xGhost1Pos,109
                jne Ghost1left11
                mov al, 8
                mov ecx, 15
                Ghost1le6:
                cmp yGhost1Pos, al
                je notGhost1left 
                inc al
                loop Ghost1le6
                Ghost1left11:
                cmp xGhost1Pos,11
                jne Ghost1left12
                mov al, 8
                mov ecx, 15
                Ghost1le7:
                cmp yGhost1Pos, al
                je notGhost1left 
                inc al
                loop Ghost1le7
                Ghost1left12:

                call UpdateGhost1
                dec xGhost1Pos
                call DrawGhost1
               jmp notGhost1
                notGhost1left:
                  mov Ghost1mov, 'i'

            moveGhost1Right:
            cmp Ghost1mov,'l'
            jne notGhost1
                cmp xGhost1Pos,117
                ja notGhost1right

                cmp yGhost1Pos, 15
                jne Ghost1right0
                cmp xGhost1Pos, 34
                je notGhost1right
                Ghost1right0:
                cmp xGhost1Pos, 33
                jne Ghost1right1
                mov al,16
                mov ecx, 8
                Ghost1r1:
                cmp yGhost1Pos, al
                je notGhost1right
                inc al
                loop Ghost1r1
                Ghost1right1:
                 cmp xGhost1Pos, 39
                jne Ghost1right2
                mov ecx,3
                mov al,20
                Ghost1r2:
                cmp yGhost1Pos, al
                je notGhost1right
                inc al
                loop Ghost1r2
                Ghost1right2:
                 cmp xGhost1Pos, 77
                jne Ghost1right3
                mov ecx,3
                mov al,20
                Ghost1r3:
                cmp yGhost1Pos, al
                je notGhost1right
                inc al
                loop Ghost1r3
                Ghost1right3:
                cmp xGhost1Pos, 23
                jne Ghost1right4
                cmp yGhost1Pos, 10
                je notGhost1right
                Ghost1right4:
                cmp xGhost1Pos, 84
                jne Ghost1right5
                cmp yGhost1Pos, 10
                je notGhost1right
                Ghost1right5:
                cmp xGhost1Pos, 82
                jne Ghost1right6
                mov al,16
                mov ecx, 8
                Ghost1r4:
                cmp yGhost1Pos, al
                je notGhost1right
                inc al
                loop Ghost1r4
                Ghost1right6:
                cmp xGhost1Pos, 57
                jne Ghost1right7
                mov al, 9
                mov ecx, 4
                Ghost1r5:
                cmp yGhost1Pos, al
                je notGhost1left
                inc al
                loop Ghost1r5
                Ghost1right7:
                cmp xGhost1Pos, 44
                jne Ghost1right8
                cmp yGhost1Pos, 18
                je notGhost1right
                Ghost1right8:
                cmp xGhost1Pos, 44
                jne Ghost1right9
                cmp yGhost1Pos, 23
                je notGhost1right
                Ghost1right9:
                cmp xGhost1Pos, 34
                jne Ghost1right10
                cmp yGhost1Pos, 4
                je notGhost1right
                Ghost1right10:
                cmp xGhost1Pos,107
                jne Ghost1right11
                mov al, 8
                mov ecx, 15
                Ghost1r6:
                cmp yGhost1Pos, al
                je notGhost1right 
                inc al
                loop Ghost1r6
                Ghost1right11:
                cmp xGhost1Pos,9
                jne Ghost1right12
                mov al, 8
                mov ecx, 15
                Ghost1r7:
                cmp yGhost1Pos, al
                je notGhost1right
                inc al
                loop Ghost1r7
                Ghost1right12:

                call UpdateGhost1
                inc xGhost1Pos
                call DrawGhost1
               jmp notGhost1
                notGhost1right:
                  mov Ghost1mov, 'k'
          NotGhost1:

           cmp Ghost2mov,'i'
                jne moveGhost2Down
            moveGhost2Up:
                cmp yGhost2Pos,2
                jna notGhost2up

                 cmp yGhost2Pos, 16
                jne Ghost2up0
                mov ecx, 48
                mov al, 35
                Ghost2u1:
                    cmp xGhost2Pos,al
                    je notGhost2down
                    inc al
                loop Ghost2u1
                Ghost2up0:
                 cmp yGhost2Pos, 24
                jne Ghost2up1
                cmp xGhost2Pos, 34
                je notGhost2up
                Ghost2up1:
                cmp yGhost2Pos, 24
                jne Ghost2up2
                cmp xGhost2Pos, 83
                je notGhost2up
                Ghost2up2:
                cmp xGhost2Pos, 40
                jne Ghost2up3
                cmp yGhost2Pos, 23
                je notGhost2up
                Ghost2up3:
                cmp xGhost2Pos, 78
                jne Ghost2up4
                cmp yGhost2Pos, 23
                je notGhost2up
                Ghost2up4:
                cmp yGhost2Pos, 11
                jne Ghost2up5
                mov al,24
                mov ecx,8
                Ghost2u2:
                cmp xGhost2Pos, al
                je notGhost2up
                inc al
                loop Ghost2u2
                Ghost2up5:
                 cmp yGhost2Pos, 11
                jne Ghost2up6
                mov al,85
                mov ecx,8
                Ghost2u3:
                cmp xGhost2Pos, al
                je notGhost2up
                inc al
                loop Ghost2u3
                Ghost2up6:
                cmp xGhost2Pos, 58
                jne Ghost2up7
                cmp yGhost2pos, 13
                je notGhost2up
                Ghost2up7:
                 cmp yGhost2Pos, 19
                jne Ghost2up8
                mov al,45
                mov ecx, 30
                Ghost2u4:
                cmp xGhost2Pos, al
                je notGhost2up
                inc al
                loop Ghost2u4
                Ghost2up8:
                cmp yGhost2Pos, 24
                jne Ghost2up9
                mov al,45
                mov ecx, 30
                Ghost2u5:
                cmp xGhost2Pos, al
                je notGhost2up
                inc al
                loop Ghost2u5
                Ghost2up9:
                cmp xGhost2Pos, 10
                jne Ghost2up10
                cmp yGhost2Pos, 23
                je notGhost2up
                Ghost2up10:
                cmp xGhost2Pos, 108
                jne Ghost2up11
                cmp yGhost2Pos, 23
                je notGhost2up
                Ghost2up11:
                cmp yGhost2Pos, 5
                jne Ghost2up12
                mov al, 35
                mov ecx, 50
                Ghost2u6:
                cmp xGhost2Pos, al
                je notGhost2up
                inc al
                loop Ghost2u6
                Ghost2up12:

                call UpdateGhost2
                dec yGhost2Pos
                call DrawGhost2
                jmp gameLoop
                notGhost2up:
                  mov Ghost2mov, 'l'

            moveGhost2Down:
            cmp Ghost2mov,'k'
            jne moveGhost2Left
                cmp yGhost2Pos,27
                ja notGhost2down

                 cmp yGhost2Pos, 15
                jne Ghost2down0
                cmp xGhost2Pos, 83
                je notGhost2down
                Ghost2down0:
                cmp yGhost2Pos, 15
                jne Ghost2down1
                cmp xGhost2Pos, 34
                je notGhost2down
                Ghost2down1:
                cmp yGhost2Pos, 14
                jne Ghost2down2
                mov ecx, 48
                mov al, 35
                Ghost2d1:
                cmp xGhost2Pos,al
                je notGhost2down
                inc al
                loop Ghost2d1
                Ghost2down2:
                cmp xGhost2Pos, 40
                jne Ghost2down3
                cmp yGhost2Pos, 19
                je notGhost2down
                Ghost2down3:
                cmp xGhost2Pos, 78
                jne Ghost2down4
                cmp yGhost2Pos, 19
                je notGhost2down
                Ghost2down4:
                cmp yGhost2Pos, 9
                jne Ghost2down5
                mov al,24
                mov ecx,8
                Ghost2d2:
                cmp xGhost2Pos, al
                je notGhost2down
                inc al
                loop Ghost2d2
                Ghost2down5:
                 cmp yGhost2Pos, 9
                jne Ghost2down6
                mov al,85
                mov ecx,8
                Ghost2d3:
                cmp xGhost2Pos, al
                je notGhost2down
                inc al
                loop Ghost2d3
                Ghost2down6:
                cmp xGhost2Pos, 58
                jne Ghost2down7
                cmp yGhost2pos, 8
                je notGhost2down
                Ghost2down7:
                 cmp yGhost2Pos, 17
                jne Ghost2down8
                mov al,45
                mov ecx, 30
                Ghost2d4:
                cmp xGhost2Pos, al
                je notGhost2down
                inc al
                loop Ghost2d4
                Ghost2down8:
                cmp yGhost2Pos, 22
                jne Ghost2down9
                mov al,45
                mov ecx, 30
                Ghost2d5:
                cmp xGhost2Pos, al
                je notGhost2down
                inc al
                loop Ghost2d5
                Ghost2down9:
                cmp xGhost2Pos, 10
                jne Ghost2down10
                cmp yGhost2Pos, 7
                je notGhost2up
                Ghost2down10:
                cmp xGhost2Pos, 108
                jne Ghost2down11
                cmp yGhost2Pos, 7
                je notGhost2up
                Ghost2down11:
                cmp yGhost2Pos, 3
                jne Ghost2down12
                mov al, 35
                mov ecx, 50
                Ghost2d6:
                   cmp xGhost2Pos, al
                   je notGhost2down
                   inc al
                   loop Ghost2d6
                Ghost2down12:

                call UpdateGhost2
                inc yGhost2Pos
                call DrawGhost2
                jmp gameLoop
                notGhost2down:
                  mov Ghost2mov, 'j'
                 

            moveGhost2Left:
            cmp Ghost2mov,'j'
            jne moveGhost2Right
                cmp xGhost2Pos,1
                jna notGhost2left

                cmp yGhost2Pos, 15
                jne Ghost2left0
                cmp xGhost2Pos, 83
                je notGhost2left
                Ghost2left0:
                cmp xGhost2Pos, 84
                jne Ghost2left1
                mov al,16
                mov ecx, 8
                Ghost2le1:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2le1
                Ghost2left1:
                cmp xGhost2Pos, 41
                jne Ghost2left2
                mov ecx,3
                mov al,20
                Ghost2le2:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2le2
                Ghost2left2:
                 cmp xGhost2Pos, 79
                jne Ghost2left3
                mov ecx,3
                mov al,20
                Ghost2le3:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2le3
                Ghost2left3:
                 cmp xGhost2Pos, 32
                jne Ghost2left4
                cmp yGhost2Pos, 10
                je notGhost2left
                Ghost2left4:
                cmp xGhost2Pos, 93
                jne Ghost2left5
                cmp yGhost2Pos, 10
                je notGhost2left
                Ghost2left5:
                cmp xGhost2Pos, 35
                jne Ghost2left6
                mov al,16
                mov ecx, 8
                Ghost2le4:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2le4
                Ghost2left6:
                cmp xGhost2Pos, 59
                jne Ghost2left7
                mov al, 9
                mov ecx, 4
                Ghost2le5:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2le5
                Ghost2left7:
                cmp xGhost2Pos, 76
                jne Ghost2left8
                cmp yGhost2Pos, 18
                je notGhost2left
                Ghost2left8:
                cmp xGhost2Pos, 76
                jne Ghost2left9
                cmp yGhost2Pos, 23
                je notGhost2left
                Ghost2left9:
                cmp xGhost2Pos, 85
                jne Ghost2left10
                cmp yGhost2Pos, 4
                je notGhost2left
                Ghost2left10:
                cmp xGhost2Pos,109
                jne Ghost2left11
                mov al, 8
                mov ecx, 15
                Ghost2le6:
                cmp yGhost2Pos, al
                je notGhost2left 
                inc al
                loop Ghost2le6
                Ghost2left11:
                cmp xGhost2Pos,11
                jne Ghost2left12
                mov al, 8
                mov ecx, 15
                Ghost2le7:
                cmp yGhost2Pos, al
                je notGhost2left 
                inc al
                loop Ghost2le7
                Ghost2left12:

                call UpdateGhost2
                dec xGhost2Pos
                call DrawGhost2
                jmp gameLoop
                notGhost2left:
                  mov Ghost2mov, 'i'

            moveGhost2Right:
            cmp Ghost2mov,'l'
            jne notGhost2
                cmp xGhost2Pos,117
                ja notGhost2right

                cmp yGhost2Pos, 15
                jne Ghost2right0
                cmp xGhost2Pos, 34
                je notGhost2right
                Ghost2right0:
                cmp xGhost2Pos, 33
                jne Ghost2right1
                mov al,16
                mov ecx, 8
                Ghost2r1:
                cmp yGhost2Pos, al
                je notGhost2right
                inc al
                loop Ghost2r1
                Ghost2right1:
                 cmp xGhost2Pos, 39
                jne Ghost2right2
                mov ecx,3
                mov al,20
                Ghost2r2:
                cmp yGhost2Pos, al
                je notGhost2right
                inc al
                loop Ghost2r2
                Ghost2right2:
                 cmp xGhost2Pos, 77
                jne Ghost2right3
                mov ecx,3
                mov al,20
                Ghost2r3:
                cmp yGhost2Pos, al
                je notGhost2right
                inc al
                loop Ghost2r3
                Ghost2right3:
                cmp xGhost2Pos, 23
                jne Ghost2right4
                cmp yGhost2Pos, 10
                je notGhost2right
                Ghost2right4:
                cmp xGhost2Pos, 84
                jne Ghost2right5
                cmp yGhost2Pos, 10
                je notGhost2right
                Ghost2right5:
                cmp xGhost2Pos, 82
                jne Ghost2right6
                mov al,16
                mov ecx, 8
                Ghost2r4:
                cmp yGhost2Pos, al
                je notGhost2right
                inc al
                loop Ghost2r4
                Ghost2right6:
                cmp xGhost2Pos, 57
                jne Ghost2right7
                mov al, 9
                mov ecx, 4
                Ghost2r5:
                cmp yGhost2Pos, al
                je notGhost2left
                inc al
                loop Ghost2r5
                Ghost2right7:
                cmp xGhost2Pos, 44
                jne Ghost2right8
                cmp yGhost2Pos, 18
                je notGhost2right
                Ghost2right8:
                cmp xGhost2Pos, 44
                jne Ghost2right9
                cmp yGhost2Pos, 23
                je notGhost2right
                Ghost2right9:
                cmp xGhost2Pos, 34
                jne Ghost2right10
                cmp yGhost2Pos, 4
                je notGhost2right
                Ghost2right10:
                cmp xGhost2Pos,107
                jne Ghost2right11
                mov al, 8
                mov ecx, 15
                Ghost2r6:
                cmp yGhost2Pos, al
                je notGhost2right 
                inc al
                loop Ghost2r6
                Ghost2right11:
                cmp xGhost2Pos,9
                jne Ghost2right12
                mov al, 8
                mov ecx, 15
                Ghost2r7:
                cmp yGhost2Pos, al
                je notGhost2right
                inc al
                loop Ghost2r7
                Ghost2right12:

                call UpdateGhost2
                inc xGhost2Pos
                call DrawGhost2
                jmp gameLoop
                notGhost2right:
                  mov Ghost2mov, 'k'
NotGhost2:

          dec Floop
    jmp gameLoop

    Pausestart:
    INVOKE PlaySound, OFFSET pausesound, NULL, 20001h
        mov eax,offset pausse
        call readchar 
        cmp al,'p'
        jne Pausestart
        INVOKE PlaySound, OFFSET unpausesound, NULL, 20000h
        call Pauseend
       
        
    ENDGame:
        INVOKE PlaySound, OFFSET endsound, NULL, 20001h
        call clrscr 
        call maze1
        mov eax, cyan
        call settextcolor
        mov dl, 55
        mov dh, 13
        call gotoxy
        mov edx, offset Ending
        call writestring
        mov dl, 55
        mov dh, 15
        call gotoxy
        mov edx, offset Names
        call writestring
        mov edx, offset user
        call writestring
        mov dl, 55
        mov dh, 17
        call gotoxy
        mov edx, offset strScore
        call writestring
        mov al, Score
        call writeint
        call readchar

        call filehandlingfunc
    call ExitGame
main ENDP

; gravity logic:
gravity PROC
    mov xPos, 57
    mov yPos, 21
    call UpdateRunner
    ret
gravity ENDP

startByteRunner PROC

    INVOKE PlaySound, OFFSET startsound, NULL, 20001h
    mov eax,Cyan
    call settextcolor
    mov al,10
    mov ah,1
    
    inc ah
    mov ecx,6
    s1:
    mov ebx,ecx
    mov ecx,10
    inn:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring 
        inc ah
    loop inn
    mov ecx,ebx
    add al,18
    mov ah,2
    loop s1
    
    mov ah,1
    mov al,10
    mov ecx,5
    s2:

        mov ebx,ecx 
        mov ecx,15

        inner:
            inc al
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
        loop inner
        
        mov ecx,ebx 
        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring

        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring

        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring
    loop s2

     mov ah,6
    mov al,10
    mov ecx,2
    AP:
         mov ebx,ecx
         mov ecx,15
         age:
            inc al
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
         loop age
         mov ecx,ebx
         mov ah,6
         mov al,28
    loop AP

    mov al,26
    mov ah,2
    mov ecx,5
    P:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop P

    mov al,44
    mov ah,2
    mov ecx,10
    A1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop A1

    mov al,47
    mov ah,11
    mov ecx,15
    C1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc al
    loop C1

     mov al,72
     mov ah,1
     mov dh,ah
     mov dl,al
     call gotoxy
     mov edx,offset space
    
    call writestring
    mov ah,2
    mov ecx,10
    M1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop M1

     mov al,80
    mov ah,2
    mov ecx,10
    M2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop M2

     mov ah,6
    mov al,82
    mov ecx,15
    A2h:
        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
    loop A2h

    inc al
    mov ah,2
    mov ecx,10
    A2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop A2

      inc al
      mov dh,ah
      mov dl,al
      call gotoxy
      mov edx,offset space
      call writestring
        
      inc al
      mov dh,ah
      mov dl,al
      call gotoxy
      mov edx,offset space
      call writestring

    add al,15
    mov ah,2
    mov ecx,10
    N2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop N2

    sub al,14
    mov ah,1
    mov dh,ah
    mov dl,al
    call gotoxy
    mov edx,offset dash
    call writestring
    inc al
    mov ecx,6
    N1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        call writestring
        call writestring
        add ah,2
        add al,2
    loop N1

    mov dh,20
    mov dl,45
     
    call gotoxy
    mov ax,lightgreen+(black*16)
    call settextcolor
    mov edx,offset Pressing
    call writestring
    mov edi,offset INPUT
    call readchar
    call clrscr
    
        ret
startByteRunner ENDP

Starting PROC

    mov eax,lightgreen
    call settextcolor
    mov al,10
    mov ah,1
    
    inc ah
    mov ecx,6
    s1:
    mov ebx,ecx
    mov ecx,10
    inn:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring 
        inc ah
    loop inn
    mov ecx,ebx
    add al,18
    mov ah,2
    loop s1
    
    mov ah,1
    mov al,10
    mov ecx,5
    s2:

        mov ebx,ecx 
        mov ecx,15

        inner:
            inc al
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
        loop inner
        
        mov ecx,ebx 
        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring

        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring

        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset space
        call writestring
    loop s2

     mov ah,6
    mov al,10
    mov ecx,2
    AP:
         mov ebx,ecx
         mov ecx,15
         age:
            inc al
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
         loop age
         mov ecx,ebx
         mov ah,6
         mov al,28
    loop AP

    mov al,26
    mov ah,2
    mov ecx,5
    P:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop P

    mov al,44
    mov ah,2
    mov ecx,10
    A1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop A1

    mov al,47
    mov ah,11
    mov ecx,15
    C1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc al
    loop C1

     mov al,72
     mov ah,1
     mov dh,ah
     mov dl,al
     call gotoxy
     mov edx,offset space
    
    call writestring
    mov ah,2
    mov ecx,10
    M1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop M1

     mov al,80
    mov ah,2
    mov ecx,10
    M2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop M2

     mov ah,6
    mov al,82
    mov ecx,15
    A2h:
        inc al
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
    loop A2h

    inc al
    mov ah,2
    mov ecx,10
    A2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop A2

      inc al
      mov dh,ah
      mov dl,al
      call gotoxy
      mov edx,offset space
      call writestring
        
      inc al
      mov dh,ah
      mov dl,al
      call gotoxy
      mov edx,offset space
      call writestring

    add al,15
    mov ah,2
    mov ecx,10
    N2:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc ah
    loop N2

    sub al,14
    mov ah,1
    mov dh,ah
    mov dl,al
    call gotoxy
    mov edx,offset dash
    call writestring
    inc al
    mov ecx,6
    N1:
        mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        call writestring
        call writestring
        add ah,2
        add al,2
    loop N1
        ret
Starting ENDP

START PROC
    call Starting
    INVOKE PlaySound, OFFSET startsound, NULL, 20001h
    mov eax,lightmagenta
    call settextcolor
    
    mov dl, 50
    mov dh, 15
    call gotoxy
    mov edx, offset tostart
    call writestring
    mov dl, 50
    mov dh, 17
    call gotoxy
    mov edx, offset highscore
    call writestring
    mov dl, 50
    mov dh, 19
    call gotoxy
    mov edx, offset Inst
    call writestring
    mov dl, 50
    mov dh, 21
    call gotoxy
    mov edx, offset toexit
    call writestring

    call ReadChar
    mov input, al

     cmp input,'s'
    je here
    cmp input,'h'
    je there
    cmp input,'i'
    je where
    call exitGame
    here:
        INVOKE PlaySound, OFFSET namesound, NULL, 20001h
        call UserEnter
        ret
    there:
        INVOKE PlaySound, OFFSET namesound, NULL, 20001h
        call highsc
        ret
    where:
        INVOKE PlaySound, OFFSET namesound, NULL, 20001h
        call Instruction
    ret
START ENDP

UserEnter PROC
    call clrscr
    call Starting
    mov eax, gray
    call settextcolor
    mov dl, 50
    mov dh, 15
    call gotoxy
    mov edx, offset enterName
    call writestring
   
    mov edx, offset user
    mov ecx, lengthof user
    call readstring
    mov user[eax], "."
    mov user[eax + 1], "."
    mov ecx, lengthof user
    mov user[ecx - 1], 0

    ret
UserEnter ENDP

highsc PROC
    call clrscr
    call Starting
     mov eax, lightgreen
    call settextcolor
    mov dl, 50
    mov dh, 15
    call gotoxy
    mov edx, offset highdisp
    call writestring
    mov dl, 45
    mov dh, 17
    call GOTOXY



    mov edx, OFFSET filenames
    call OpenInputFile
    mov fileHandle, eax

    cmp eax, INVALID_HANDLE_VALUE; error opening file ?
    jne file_ok

    mWrite <"Cannot open file", 0dh, 0ah>
    jmp quit
    file_ok :
    mov edx, OFFSET sizeofarr
    mov ecx, BUFFER_SIZE
    call ReadFromFile
    jnc check_buffer_size
    mWrite "Error reading file. "
    call WriteWindowsMsg
    jmp close_file
    check_buffer_size :
    cmp eax, BUFFER_SIZE
    jb buf_size_ok
    mWrite <"Error: Buffer too small for the file", 0dh, 0ah>
    jmp quit
    buf_size_ok :
    mov sizeofarr[eax], 0
   
    call WriteDec
    call Crlf
    mov dl, 45
    mov dh, 17
    call GOTOXY
    mov edx, OFFSET sizeofarr
    call WriteString
    call Crlf
    close_file :
    mov eax, fileHandle
    call CloseFile
    quit :



    mov dl, 45
    mov dh, 29
    call gotoxy
    mov edx, offset goback
    call writestring
    call readChar
    call clrscr
    call START
    ret
Highsc ENDP

Instruction PROC
    call clrscr
    call Starting
     mov eax, lightcyan
    call settextcolor
    mov dl, 50
    mov dh, 15
    call gotoxy
    mov edx, offset instdisp
    call writestring
    mov dl, 35
    mov dh, 17
    call gotoxy
    mov edx, offset moveinst
    call writestring
    mov dl, 35
    mov dh, 19
    call gotoxy
    mov edx, offset dotinst
    call writestring
    mov dl, 35
    mov dh, 21
    call gotoxy
    mov edx, offset linst
    call writestring
    mov dl, 35
    mov dh, 23
    call gotoxy
    mov edx, offset Oinst
    call writestring
    mov dl, 35
    mov dh, 25
    call gotoxy
    mov edx, offset Finst
    call writestring
    mov dl, 35
    mov dh, 27
    call gotoxy
    mov edx, offset Tinst
    call writestring
    mov dl, 45
    mov dh, 29
    call gotoxy
    mov edx, offset goback
    call writestring
    call readChar
    call clrscr
    call START
    ret
Instruction ENDP


exitGame Proc
     exit
exitGame ENDP

maze1 PROC
    mov eax, cyan;+(cyan*16)
    call settextcolor
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString
    mov dl,0
    mov dh,1
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov ecx,27
    mov dh,2
    l1:
    mov dl,0
    call Gotoxy
    mov edx,OFFSET ground1
    call WriteString
    ;inc dh
    loop l1

    mov ecx,27
    mov dh,2
    mov temp,dh
    l2:
    mov dh,temp
    mov dl,119
    call Gotoxy
    mov edx,OFFSET ground2
    call WriteString
    inc temp
    loop l2

    mov al, 10
    mov ah, 8
    mov ecx, 15
    maz:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc ah
    loop maz

     mov al, 108
    mov ah, 8
    mov ecx, 15
    maz1:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc ah
    loop maz1

     mov al, 35
    mov ah, 4
    mov ecx, 50
    maz2:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc al
    loop maz2
    ret
    maze1 ENDP

maze PROC
    mov eax, cyan;+(cyan*16)
    call settextcolor
    mov dl,0
    mov dh,29
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString
    mov dl,0
    mov dh,1
    call Gotoxy
    mov edx,OFFSET ground
    call WriteString

    mov ecx,27
    mov dh,2
    l1:
    mov dl,0
    call Gotoxy
    mov edx,OFFSET ground1
    call WriteString
    ;inc dh
    loop l1

    mov ecx,27
    mov dh,2
    mov temp,dh
    l2:
    mov dh,temp
    mov dl,119
    call Gotoxy
    mov edx,OFFSET ground2
    call WriteString
    inc temp
    loop l2

    mov al, 10
    mov ah, 8
    mov ecx, 15
    maz:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc ah
    loop maz

     mov al, 108
    mov ah, 8
    mov ecx, 15
    maz1:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc ah
    loop maz1

     mov al, 35
    mov ah, 4
    mov ecx, 50
    maz2:
       mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        inc al
    loop maz2


    mov al,35
    mov ah,15
    mov ecx,48
    maze0:
         mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash
        call writestring
        inc al
    loop maze0
    
    mov al,45
    mov ah,18
    mov ecx,2
    maze11:
        mov ebx,ecx
        mov ecx,30
        mazein:
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
            inc al
        loop mazein
        mov ecx,ebx
        mov al,45
        add ah,5
    loop maze11

     mov al,40
    mov ah,22
    mov ecx,2
    maze2:
        mov ebx,ecx
        mov ecx,3
        mazeinn:
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash1
            call writestring
            dec ah
        loop mazeinn
        mov ecx,ebx
        add al,38
        mov ah,22
    loop maze2

    mov al,34
    mov ah,23
    mov ecx,2
    maze3:
        mov ebx,ecx
        mov ecx,8
        min:
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash1
            call writestring
            dec ah
        loop min
        mov ecx,ebx
        add al,49
        mov ah,23
    loop maze3

    mov al,24
    mov ah,10
    mov ecx,2
    maze4:
        mov ebx,ecx
        mov ecx,8
        minn:
            mov dh,ah
            mov dl,al
            call gotoxy
            mov edx,offset dash
            call writestring
            inc al
        loop minn
        mov ecx,ebx
        add al,53
        mov ah,10
    loop maze4

     mov al,58
    mov ah,12
    mov ecx,4
    maze5:
         mov dh,ah
        mov dl,al
        call gotoxy
        mov edx,offset dash1
        call writestring
        dec ah
    loop maze5

    ret
maze ENDP

DrawRunner PROC
    ; draw player at (xPos,yPos):
    mov eax,magenta ;(lightred*16)
    call SetTextColor
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
    mov al,"P"
    call WriteChar
    ret
DrawRunner ENDP

UpdateRunner PROC
    mov dl,xPos
    mov dh,yPos
    call Gotoxy
   
    mov bl,xPos
    cmp bl,xTPos
    jne notCollecting
    mov bl,yPos
    cmp bl,yTPos
    jne notCollecting
    mov eax,Green
    call settextcolor
    mov al,"T"
    jmp HERE
    notCollecting:

    mov bl,xPos
    cmp bl,xGhostPos
    jne notCollecting1
    mov bl,yPos
    cmp bl,yGhostPos
    jne notCollecting1
    mov al," "
    call gravity
    dec lives
    jmp HERE
    notCollecting1:
    
    mov bl,xPos
    cmp bl,xGhost1Pos
    jne notCollecting2
    mov bl,yPos
    cmp bl,yGhost1Pos
    jne notCollecting2
    mov al," "
    call gravity
    dec lives
    jmp HERE
    notCollecting2:
    
    mov bl,xPos
    cmp bl,xGhost2Pos
    jne notCollecting3
    mov bl,yPos
    cmp bl,yGhost2Pos
    jne notCollecting3
    mov al," "
    call gravity
    dec lives
    jmp HERE
    notCollecting3:

    mov al," "
    HERE:
    call WriteChar
    ret
UpdateRunner ENDP

DrawGHOST PROC
    ; draw Ghost at (xPos,yPos):
    cmp Oloop,0
    jg here
    mov eax,magenta ;(lightred*16)
    jmp there
    here:
    mov eax, lightred
    there:
    call SetTextColor
    mov dl,xGHOSTPos
    mov dh,yGHOSTPos
    call Gotoxy
    mov al,"G"
    call WriteChar
    ret

DrawGHOST ENDP

UpdateGHOST PROC
    mov dl,XGHOSTPos
    mov dh,YGHOSTPos
    call Gotoxy
     mov bl,xGhostPos
                cmp bl,xCoinPos
                jne notCollectingGhost
                mov bl,yGhostPos
                cmp bl,yCoinPos
                jne notCollectingGhost
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost:
                
                 mov bl,xGhostPos
                cmp bl,xCoin1Pos
                jne notCollectingGhost1
                mov bl,yGhostPos
                cmp bl,yCoin1Pos
                jne notCollectingGhost1
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost1:

                mov bl,xGhostPos
                cmp bl,xCoin2Pos
                jne notCollectingGhost2
                mov bl,yGhostPos
                cmp bl,yCoin2Pos
                jne notCollectingGhost2
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost2:

                mov bl,xGhostPos
                cmp bl,xCoin3Pos
                jne notCollectingGhost23
                mov bl,yGhostPos
                cmp bl,yCoin3Pos
                jne notCollectingGhost23
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost23:

                mov bl,xGhostPos
                cmp bl,xCoin4Pos
                jne notCollectingGhost24
                mov bl,yGhostPos
                cmp bl,yCoin4Pos
                jne notCollectingGhost24
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost24:

                mov bl,xGhostPos
                cmp bl,xOPos
                jne notCollectingGhost3
                mov bl,yGhostPos
                cmp bl,yOPos
                jne notCollectingGhost3
                mov eax,lightgreen 
                call settextcolor
                mov al,"O"
                jmp here
                notCollectingGhost3:


                mov bl,xGhostPos
                cmp bl,xfruitPos
                jne notCollectingGhost31
                mov bl,yGhostPos
                cmp bl,yfruitPos
                jne notCollectingGhost31
                mov eax,0FFC0CBh 
                call settextcolor
                mov al,"#"
                jmp here
                notCollectingGhost31:

                mov bl,xGhostPos
                cmp bl,xLPos
                jne notCollectingGhost4
                mov bl,yGhostPos
                cmp bl,yLPos
                jne notCollectingGhost4
                mov eax,magenta
                call settextcolor
                mov al,"L"
                jmp here
                notCollectingGhost4:

                mov bl,xGhostPos
                cmp bl,xFPos
                jne notCollectingGhost5
                mov bl,yGhostPos
                cmp bl,yFPos
                jne notCollectingGhost5
                mov eax,BROWN
                call settextcolor
                mov al,"F"
                jmp here
                notCollectingGhost5:

                mov al," "
    here:
    call WriteChar
    ret
UpdateGHOST ENDP

DrawGhost1 PROC
    ; draw Ghost at (xPos,yPos):
    cmp Oloop,0
    jg here
    mov eax,magenta ;(lightred*16)
    jmp there
    here:
    mov eax, lightred
    there:
    call SetTextColor
    mov dl,xGhost1Pos
    mov dh,yGhost1Pos
    call Gotoxy
    mov al,"G"
    call WriteChar
    ret

DrawGhost1 ENDP

UpdateGhost1 PROC
    mov dl,XGhost1Pos
    mov dh,YGhost1Pos
    call Gotoxy
     mov bl,xGhost1Pos
                cmp bl,xCoinPos
                jne notCollectingGhost1
                mov bl,yGhost1Pos
                cmp bl,yCoinPos
                jne notCollectingGhost1
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost1:
                
                 mov bl,xGhost1Pos
                cmp bl,xCoin1Pos
                jne notCollectingGhost11
                mov bl,yGhost1Pos
                cmp bl,yCoin1Pos
                jne notCollectingGhost11
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost11:

                mov bl,xGhost1Pos
                cmp bl,xCoin2Pos
                jne notCollectingGhost12
                mov bl,yGhost1Pos
                cmp bl,yCoin2Pos
                jne notCollectingGhost12
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost12:

                mov bl,xGhost1Pos
                cmp bl,xCoin3Pos
                jne notCollectingGhost23
                mov bl,yGhost1Pos
                cmp bl,yCoin3Pos
                jne notCollectingGhost23
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost23:

                mov bl,xGhost1Pos
                cmp bl,xfruitPos
                jne notCollectingGhost31
                mov bl,yGhost1Pos
                cmp bl,yfruitPos
                jne notCollectingGhost31
                mov eax,0FFC0CBh 
                call settextcolor
                mov al,"#"
                jmp here
                notCollectingGhost31:

                mov bl,xGhost1Pos
                cmp bl,xCoin4Pos
                jne notCollectingGhost24
                mov bl,yGhost1Pos
                cmp bl,yCoin4Pos
                jne notCollectingGhost24
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost24:

                mov bl,xGhost1Pos
                cmp bl,xOPos
                jne notCollectingGhost13
                mov bl,yGhost1Pos
                cmp bl,yOPos
                jne notCollectingGhost13
                mov eax,lightgreen 
                call settextcolor
                mov al,"O"
                jmp here
                notCollectingGhost13:

                mov bl,xGhost1Pos
                cmp bl,xLPos
                jne notCollectingGhost14
                mov bl,yGhost1Pos
                cmp bl,yLPos
                jne notCollectingGhost14
                mov eax,magenta
                call settextcolor
                mov al,"L"
                jmp here
                notCollectingGhost14:

                mov bl,xGhost1Pos
                cmp bl,xFPos
                jne notCollectingGhost15
                mov bl,yGhost1Pos
                cmp bl,yFPos
                jne notCollectingGhost15
                mov eax,BROWN
                call settextcolor
                mov al,"F"
                jmp here
                notCollectingGhost15:

                mov al," "
    here:
    call WriteChar
    ret
UpdateGhost1 ENDP

DrawGhost2 PROC
    ; draw Ghost at (xPos,yPos):
    cmp Oloop,0
    jg here
    mov eax,magenta ;(lightred*16)
    jmp there
    here:
    mov eax, lightred
    there:
    call SetTextColor
    mov dl,xGhost2Pos
    mov dh,yGhost2Pos
    call Gotoxy
    mov al,"G"
    call WriteChar
    ret

DrawGhost2 ENDP

UpdateGhost2 PROC
    mov dl,XGhost2Pos
    mov dh,YGhost2Pos
    call Gotoxy
     mov bl,xGhost2Pos
                cmp bl,xCoinPos
                jne notCollectingGhost2
                mov bl,yGhost2Pos
                cmp bl,yCoinPos
                jne notCollectingGhost2
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost2:
                
                 mov bl,xGhost2Pos
                cmp bl,xCoin1Pos
                jne notCollectingGhost21
                mov bl,yGhost2Pos
                cmp bl,yCoin1Pos
                jne notCollectingGhost21
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost21:

                mov bl,xGhost2Pos
                cmp bl,xCoin2Pos
                jne notCollectingGhost22
                mov bl,yGhost2Pos
                cmp bl,yCoin2Pos
                jne notCollectingGhost22
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost22:

                mov bl,xGhost2Pos
                cmp bl,xCoin3Pos
                jne notCollectingGhost223
                mov bl,yGhost2Pos
                cmp bl,yCoin3Pos
                jne notCollectingGhost223
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost223:

                mov bl,xGhost2Pos
                cmp bl,xCoin4Pos
                jne notCollectingGhost224
                mov bl,yGhost2Pos
                cmp bl,yCoin4Pos
                jne notCollectingGhost224
                mov eax,lightgreen 
                call settextcolor
                mov al,"*"
                jmp here
                notCollectingGhost224:

                mov bl,xGhost2Pos
                cmp bl,xfruitPos
                jne notCollectingGhost31
                mov bl,yGhost2Pos
                cmp bl,yfruitPos
                jne notCollectingGhost31
                mov eax,0FFC0CBh 
                call settextcolor
                mov al,"#"
                jmp here
                notCollectingGhost31:

                mov bl,xGhost2Pos
                cmp bl,xOPos
                jne notCollectingGhost23
                mov bl,yGhost2Pos
                cmp bl,yOPos
                jne notCollectingGhost23
                mov eax,lightgreen 
                call settextcolor
                mov al,"O"
                jmp here
                notCollectingGhost23:

                mov bl,xGhost2Pos
                cmp bl,xLPos
                jne notCollectingGhost24
                mov bl,yGhost2Pos
                cmp bl,yLPos
                jne notCollectingGhost24
                mov eax,magenta
                call settextcolor
                mov al,"L"
                jmp here
                notCollectingGhost24:

                mov bl,xGhost2Pos
                cmp bl,xFPos
                jne notCollectingGhost25
                mov bl,yGhost2Pos
                cmp bl,yFPos
                jne notCollectingGhost25
                mov eax,BROWN
                call settextcolor
                mov al,"F"
                jmp here
                notCollectingGhost25:

                mov al," "
    here:
    call WriteChar
    ret
UpdateGhost2 ENDP

DrawCoin PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xCoinPos
    mov dh,yCoinPos
    call Gotoxy
    mov al,"*"
    call WriteChar
    ret
DrawCoin ENDP

CreateRandomCoin PROC
    
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xCoinpos, 2
    mov yCoinpos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xCoinpos, 116
    mov yCoinpos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xCoinpos, 2
    mov yCoinpos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xCoinpos, 116
    mov yCoinpos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xCoinpos, 55
    mov yCoinpos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xCoinpos, 55
    mov yCoinpos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xCoinpos, 50
    mov yCoinpos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xCoinpos, 60
    mov yCoinpos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xCoinpos, 50
    mov yCoinpos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xCoinpos, 60
    mov yCoinpos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xCoinpos, 30
    mov yCoinpos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xCoinpos, 105
    mov yCoinpos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xCoinpos, 30
    mov yCoinpos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xCoinpos, 105
    mov yCoinpos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xCoinpos, 2
    mov yCoinpos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xCoinpos, 116
    mov yCoinpos,13
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xCoinpos, 55
    mov yCoinpos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xCoinpos, 47
    mov yCoinpos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xCoinpos, 65
    mov yCoinpos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xCoinpos, 32
    mov yCoinpos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomCoin ENDP

DrawCoin1 PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xCoin1Pos
    mov dh,yCoin1Pos
    call Gotoxy
    mov al,"*"
    call WriteChar
    ret
DrawCoin1 ENDP

CreateRandomCoin1 PROC
    
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xCoin1pos, 2
    mov yCoin1pos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xCoin1pos, 116
    mov yCoin1pos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xCoin1pos, 2
    mov yCoin1pos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xCoin1pos, 116
    mov yCoin1pos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xCoin1pos, 55
    mov yCoin1pos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xCoin1pos, 55
    mov yCoin1pos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xCoin1pos, 50
    mov yCoin1pos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xCoin1pos, 60
    mov yCoin1pos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xCoin1pos, 50
    mov yCoin1pos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xCoin1pos, 60
    mov yCoin1pos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xCoin1pos, 30
    mov yCoin1pos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xCoin1pos, 105
    mov yCoin1pos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xCoin1pos, 30
    mov yCoin1pos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xCoin1pos, 105
    mov yCoin1pos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xCoin1pos, 2
    mov yCoin1pos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xCoin1pos, 116
    mov yCoin1pos,13
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xCoin1pos, 55
    mov yCoin1pos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xCoin1pos, 47
    mov yCoin1pos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xCoin1pos, 65
    mov yCoin1pos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xCoin1pos, 32
    mov yCoin1pos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomCoin1 ENDP

DrawCoin2 PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xCoin2Pos
    mov dh,yCoin2Pos
    call Gotoxy
    mov al,"*"
    call WriteChar
    ret
DrawCoin2 ENDP

CreateRandomCoin2 PROC
   
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xCoin2pos, 2
    mov yCoin2pos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xCoin2pos, 116
    mov yCoin2pos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xCoin2pos, 2
    mov yCoin2pos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xCoin2pos, 116
    mov yCoin2pos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xCoin2pos, 55
    mov yCoin2pos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xCoin2pos, 55
    mov yCoin2pos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xCoin2pos, 50
    mov yCoin2pos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xCoin2pos, 60
    mov yCoin2pos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xCoin2pos, 50
    mov yCoin2pos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xCoin2pos, 60
    mov yCoin2pos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xCoin2pos, 30
    mov yCoin2pos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xCoin2pos, 105
    mov yCoin2pos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xCoin2pos, 30
    mov yCoin2pos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xCoin2pos, 105
    mov yCoin2pos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xCoin2pos, 2
    mov yCoin2pos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xCoin2pos, 116
    mov yCoin2pos,13
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xCoin2pos, 55
    mov yCoin2pos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xCoin2pos, 47
    mov yCoin2pos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xCoin2pos, 65
    mov yCoin2pos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xCoin2pos, 32
    mov yCoin2pos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomCoin2 ENDP

DrawCoin3 PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xCoin3Pos
    mov dh,yCoin3Pos
    call Gotoxy
    mov al,"*"
    call WriteChar
    ret
DrawCoin3 ENDP

CreateRandomCoin3 PROC
   
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xCoin3pos, 2
    mov yCoin3pos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xCoin3pos, 116
    mov yCoin3pos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xCoin3pos, 2
    mov yCoin3pos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xCoin3pos, 116
    mov yCoin3pos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xCoin3pos, 55
    mov yCoin3pos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xCoin3pos, 55
    mov yCoin3pos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xCoin3pos, 50
    mov yCoin3pos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xCoin3pos, 60
    mov yCoin3pos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xCoin3pos, 50
    mov yCoin3pos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xCoin3pos, 60
    mov yCoin3pos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xCoin3pos, 30
    mov yCoin3pos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xCoin3pos, 105
    mov yCoin3pos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xCoin3pos, 30
    mov yCoin3pos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xCoin3pos, 105
    mov yCoin3pos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xCoin3pos, 2
    mov yCoin3pos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xCoin3pos, 116
    mov yCoin3pos,13
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xCoin3pos, 55
    mov yCoin3pos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xCoin3pos, 47
    mov yCoin3pos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xCoin3pos, 65
    mov yCoin3pos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xCoin3pos, 32
    mov yCoin3pos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomCoin3 ENDP

DrawCoin4 PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xCoin4Pos
    mov dh,yCoin4Pos
    call Gotoxy
    mov al,"*"
    call WriteChar
    ret
DrawCoin4 ENDP

CreateRandomCoin4 PROC
   
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xCoin4pos, 2
    mov yCoin4pos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xCoin4pos, 116
    mov yCoin4pos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xCoin4pos, 2
    mov yCoin4pos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xCoin4pos, 116
    mov yCoin4pos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xCoin4pos, 55
    mov yCoin4pos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xCoin4pos, 55
    mov yCoin4pos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xCoin4pos, 50
    mov yCoin4pos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xCoin4pos, 60
    mov yCoin4pos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xCoin4pos, 50
    mov yCoin4pos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xCoin4pos, 60
    mov yCoin4pos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xCoin4pos, 30
    mov yCoin4pos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xCoin4pos, 105
    mov yCoin4pos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xCoin4pos, 30
    mov yCoin4pos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xCoin4pos, 105
    mov yCoin4pos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xCoin4pos, 2
    mov yCoin4pos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xCoin4pos, 116
    mov yCoin4pos,13
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xCoin4pos, 55
    mov yCoin4pos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xCoin4pos, 47
    mov yCoin4pos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xCoin4pos, 65
    mov yCoin4pos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xCoin4pos, 32
    mov yCoin4pos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomCoin4 ENDP

DrawO PROC
    mov eax,lightgreen ;(magenta * 16)
    call SetTextColor
    mov dl,xOPos
    mov dh,yOPos
    call Gotoxy
    mov al,"O"
    call WriteChar
    ret
DrawO ENDP

CreateRandomO PROC
    
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xOpos, 4
    mov yOpos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xOpos, 114
    mov yOpos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xOpos, 4
    mov yOpos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xOpos, 114
    mov yOpos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xOpos, 56
    mov yOpos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xOpos, 56
    mov yOpos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xOpos, 51
    mov yOpos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xOpos, 61
    mov yOpos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xOpos, 51
    mov yOpos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xOpos, 61
    mov yOpos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xOpos, 31
    mov yOpos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xOpos, 107
    mov yOpos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xOpos, 31
    mov yOpos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xOpos, 104
    mov yOpos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xOpos, 4
    mov yOpos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xOpos, 116
    mov yOpos,15
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xOpos, 56
    mov yOpos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xOpos, 48
    mov yOpos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xOpos, 66
    mov yOpos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xOpos, 16
    mov yOpos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomO ENDP

Drawfruit PROC
    mov eax,0FFC0CBh  ;(magenta * 16)
    call SetTextColor
    mov dl,xfruitPos
    mov dh,yfruitPos
    call Gotoxy
    mov al,"#"
    call WriteChar
    ret
Drawfruit ENDP

CreateRandomfruit PROC
    
    mov eax,19
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xfruitPos, 4
    mov yfruitPos,2
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xfruitPos, 114
    mov yfruitPos,2
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xfruitPos, 4
    mov yfruitPos,27
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xfruitPos, 114
    mov yfruitPos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xfruitPos, 56
    mov yfruitPos,2
    jmp n25
    n5:
    cmp eax,6
    jne n6
    mov xfruitPos, 56
    mov yfruitPos,27
    jmp n25
    n6:
    cmp eax,7
    jne n7
    mov xfruitPos, 51
    mov yfruitPos,12
    jmp n25
    n7:
    cmp eax,8
    jne n8
    mov xfruitPos, 61
    mov yfruitPos,12
    jmp n25
    n8:
    cmp eax,9
    jne n9
    mov xfruitPos, 51
    mov yfruitPos,17
    jmp n25
    n9:
    cmp eax,10
    jne n10
    mov xfruitPos, 61
    mov yfruitPos,17
    jmp n25
    n10:
    cmp eax,11
    jne n11
    mov xfruitPos, 31
    mov yfruitPos,20
    jmp n25
    n11:
    cmp eax,12
    jne n12
    mov xfruitPos, 107
    mov yfruitPos,20
    jmp n25
    n12:
    cmp eax,13
    jne n13
    mov xfruitPos, 31
    mov yfruitPos,6
    jmp n25
    n13:
    cmp eax,14
    jne n14
    mov xfruitPos, 104
    mov yfruitPos,6
    jmp n25
    n14:
    cmp eax,15
    jne n15
    mov xfruitPos, 4
    mov yfruitPos,13
    jmp n25
    n15:
    cmp eax,16
    jne n16
    mov xfruitPos, 116
    mov yfruitPos,15
    jmp n25
    n16:
    cmp eax,17
    jne n17
    mov xfruitPos, 56
    mov yfruitPos,19
    jmp n25
    n17:
    cmp eax,18
    jne n18
    mov xfruitPos, 48
    mov yfruitPos,19
    jmp n25
    n18:
    cmp eax,19
    jne n19
    mov xfruitPos, 66
    mov yfruitPos,19
    jmp n25
    n19:
    cmp eax,20
    jne n20
    mov xfruitPos, 16
    mov yfruitPos,19
    jmp n25
    n20:

    n25:
    ret
CreateRandomfruit ENDP


Teleport PROC
    mov dl,xGhostpos
    mov dh,yGhostpos
    mov eax,4
    call randomrange 
    cmp al,0
    jne j1 
    mov xGhostpos,1
    mov yGhostpos,2
    jmp j4
    j1:
    cmp al,1
    jne j2 
    mov xGhostpos,116
    mov yGhostpos,2
    jmp j4
    j2:
    cmp al,2
    jne j3
    mov xGhostpos,1
    mov yGhostpos,28
    jmp j4
    j3:
    mov xGhostpos,116
    mov yGhostpos,28
    j4:
    call gotoxy
     mov al," "
     call writechar
    
    ret
Teleport ENDP

Teleport1 PROC
    mov dl,xGhost1pos
    mov dh,yGhost1pos
    mov eax,4
    call randomrange 
    cmp al,0
    jne j1 
    mov xGhost1pos,1
    mov yGhost1pos,2
    jmp j4
    j1:
    cmp al,1
    jne j2 
    mov xGhost1pos,116
    mov yGhost1pos,2
    jmp j4
    j2:
    cmp al,2
    jne j3
    mov xGhost1pos,1
    mov yGhost1pos,28
    jmp j4
    j3:
    mov xGhost1pos,116
    mov yGhost1pos,28
    j4:
    call gotoxy
     mov al," "
     call writechar
    
    ret
Teleport1 ENDP

Teleport2 PROC
    mov dl,xGhost2pos
    mov dh,yGhost2pos
    mov eax,4
    call randomrange 
    cmp al,0
    jne j1 
    mov xGhost2pos,1
    mov yGhost2pos,2
    jmp j4
    j1:
    cmp al,1
    jne j2 
    mov xGhost2pos,116
    mov yGhost2pos,2
    jmp j4
    j2:
    cmp al,2
    jne j3
    mov xGhost2pos,1
    mov yGhost2pos,28
    jmp j4
    j3:
    mov xGhost2pos,116
    mov yGhost2pos,28
    j4:
    call gotoxy
     mov al," "
     call writechar
    
    ret
Teleport2 ENDP

DrawT PROC
    mov eax,Green ;(magenta * 16)
    call SetTextColor
    mov dl,xTPos
    mov dh,yTPos
    call Gotoxy
    mov al,"T"
    call WriteChar
    ret
DrawT ENDP

CreateRandomT PROC
     mov eax,4
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xTpos, 1
    mov yTpos,5
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xTpos, 118
    mov yTpos,5
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xTpos, 1
    mov yTpos,24
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xTpos, 118
    mov yTpos,24
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xTpos, 59
    mov yTpos,5
    jmp n25
    n5:
    cmp eax,6
    jne n25
    mov xTpos, 59
    mov yTpos,28

    n25:
    ret

CreateRandomT ENDP


DrawL PROC
    mov eax,magenta ;(magenta * 16)
    call SetTextColor
    mov dl,xLPos
    mov dh,yLPos
    call Gotoxy
    mov al,"L"
    call WriteChar
    ret
DrawL ENDP

CreateRandomL PROC
   mov eax,5
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xLpos, 4
    mov yLpos,8
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xLpos, 114
    mov yLpos,8
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xLpos, 4
    mov yLpos,24
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xLpos, 114
    mov yLpos,25
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xLpos, 60
    mov yLpos,5
    jmp n25
    n5:
    cmp eax,6
    jne n25
    mov xLpos, 60
    mov yLpos,28

    n25:
    ret

CreateRandomL ENDP

DrawF PROC
    mov eax,Brown ;(magenta * 16)
    call SetTextColor
    mov dl,xFPos
    mov dh,yFPos
    call Gotoxy
    mov al,"F"
    call WriteChar
    ret
DrawF ENDP

CreateRandomF PROC
    mov eax,5
    inc eax
    call Randomrange
    cmp eax,1
    jne n1
    mov xFpos, 4
    mov yFpos,11
    jmp n25
    n1:
    cmp eax,2
    jne n2
    mov xFpos, 114
    mov yFpos,11
    jmp n25
    n2:
    cmp eax,3
    jne n3
    mov xFpos, 4
    mov yFpos,26
    jmp n25
    n3:
    cmp eax, 4
    jne n4
    mov xFpos, 114
    mov yFpos,27
    jmp n25
    n4:
    cmp eax,5
    jne n5
    mov xFpos, 60
    mov yFpos,7
    jmp n25
    n5:
    cmp eax,6
    jne n25
    mov xFpos, 60
    mov yFpos,24

    n25:
    ret

CreateRandomF ENDP

END main