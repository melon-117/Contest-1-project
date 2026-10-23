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
.code
main PROC
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
	call DrawHud
	call DrawPlayer
	call DrawInvaders
	call DrawBullets

	sub totalTick,MSPerTick ; Adjust total ticks when tick complete
	cmp totalTick,MSPerTick
	jae AdvTick

	SkipTickAdv:
	; Irvine32 Sleep proc from docs: https://csc.csudh.edu/mmccullough/asm/help/
	; Sleep proc used to reduce excessive CPU usage while looping
	invoke Sleep,MSPerTick
	jmp L1
	
main ENDP

ProcessUserInput PROC USES eax
	call ReadKey ; Jump on exit key press
	cmp al,ExitKey
	jne C1
	invoke ExitProcess,0
	jmp processed
	C1: cmp al,'d'
	jne C2
	mov eax,screenRightBound
	cmp PlayerX,eax
	je processed
	add playerX,1
	jmp processed
	C2: cmp al,'a'
	jne C3
	mov eax,screenLeftBound
	cmp playerX,eax
	je processed
	sub playerX,1
	jmp processed
	C3: cmp al,' '
	jne C4
	mov eax,playerX
	mov playerBulletX,eax
	mov eax,playerY
	dec eax
	mov playerBulletY,eax
	mov playerBulletActive,1
	jmp processed
	C4:

	processed:
	ret
ProcessUserInput ENDP

END main