.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
INCLUDE SpaceGame.inc
ExitProcess proto,dwExitCode:dword
TicksPerSec = 60
MSPerTick = 1000 / TicksPerSec ; 1000 ms / 60 ticks per second
ExitKey = 'q'

.data
	currTime DWORD ?
	newTime DWORD ?
	totalTick DWORD 0
	placeHolderText BYTE "Press q to Exit", 0
	consoleHandle DWORD ?
	cursorInfo DWORD 25, 0
    gameOverText BYTE "Game Over!", 0
    finalScoreText BYTE "Your final score: ", 0
    exitPromptText BYTE "Press any key to exit...", 0
    gameWonText BYTE "YOU WIN! All Invaders have been defeated!",0
.code
main PROC
    invoke GetStdHandle, -11
    mov consoleHandle, eax
    invoke SetConsoleCursorInfo, consoleHandle, ADDR cursorInfo
	call initializeInvaders
	mov playerX,50
	mov playerY,25
	call GetTickCount
	mov currTime,eax
	; while game not over
	L1:
	call GetTickCount
	mov newTime,eax ; save new time
	sub eax,currTime ; calc frame time
	add eax,totalTick ; add total tick time to frame time
	mov totalTick,eax ; save new tick time
	mov eax,newTime ; save new time as current time
	mov currTime,eax
	; Skip tick advance loop if total current ticks are less than ms per tick
	cmp totalTick,MSPerTick
	jb SkipTickAdv

	; Loop while ticks are queued
	AdvTick:
	; Update score, read input, update game state, then render

	call ProcessUserInput
	call Clrscr
    call DrawBullets
    call playerBulletCollision
    call invaderBulletCollision
    cmp gameStatus, 0
    je GameOver
    cmp gameStatus, 2
    je GameWon
    call fireInvaderBullet
    call updateInvaderBullets
	call DrawHud
	call DrawPlayer
	call DrawInvaders
	


	sub totalTick,MSPerTick ; Adjust total ticks when tick complete
	cmp totalTick,MSPerTick
	jae AdvTick

	SkipTickAdv:
	; Irvine32 Sleep proc from docs: https://csc.csudh.edu/mmccullough/asm/help/
	; Sleep proc used to reduce excessive CPU usage while looping
	invoke Sleep,MSPerTick
	jmp L1

    GameOver:
        call clrscr
        mov edx, offset gameOverText
        call WriteString
        jmp ShowFinalScore
    GameWon:
        call clrscr
        mov edx, offset gameWonText
        call WriteString
        jmp ShowFinalScore
    ShowFinalScore:
        call Crlf
        mov edx, OFFSET finalScoreText
        call WriteString
        mov eax, score
        call WriteDec
        call Crlf
        mov edx, OFFSET exitPromptText
        call WriteString
     waitForKeyPress:
        call ReadKey
        jz waitForKeyPress
        jmp exitCurrentGame
     exitCurrentGame:
        invoke ExitProcess, 0
main ENDP

ProcessUserInput PROC USES eax esi ebx ecx edx
    call ReadKey
    jz processed

    ; Exit only when q is pressed
    cmp al, ExitKey
    je exitGame

    ; Check arrow keys
    cmp ah, 4Dh
    je moveRight

    cmp ah, 4Bh
    je moveLeft

    ; Check A and D keys
    cmp al, 'd'
    je moveRight

    cmp al, 'a'
    je moveLeft

    ; Check spacebar to fire
    cmp al, ' '
    je fireBulletCheck

    jmp processed

exitGame:
    invoke ExitProcess, 0

moveRight:
    mov eax, screenRightBound
    cmp playerX, eax
    jae processed
    add playerX, 1
    jmp processed

moveLeft:
    mov eax, screenLeftBound
    cmp playerX, eax
    jbe processed
    sub playerX, 1
    jmp processed

fireBulletCheck:
    mov esi, 0
    mov ecx, 5

checkSlot:
    mov ebx, playerBulletActive[esi]
    cmp ebx, 0
    je fireBullet
    add esi, 4
    loop checkSlot
    jmp processed

fireBullet:
    mov eax, playerX
    mov ebx, playerY
    dec ebx
    mov playerBulletActive[esi], 1
    mov playerBulletX[esi], eax
    mov playerBulletY[esi], ebx
    jmp processed

processed:
    ret
ProcessUserInput ENDP

END main