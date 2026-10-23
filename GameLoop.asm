.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
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
	cmp [totalTick],MSPerTick
	jb SkipTickAdv

	; Loop while ticks are queued
	AdvTick:
	; Update score, read input, update game state, then render

	mov edx,OFFSET placeHolderText
	call WriteString
	call Crlf
	call ReadKey ; Jump on exit key press
	cmp al,ExitKey
	je ExitGame
	sub [totalTick],MSPerTick ; Adjust total ticks when tick complete
	cmp [totalTick],MSPerTick
	jae AdvTick

	SkipTickAdv:
	; Irvine32 Sleep proc from docs: https://csc.csudh.edu/mmccullough/asm/help/
	; Sleep proc used to reduce excessive CPU usage while looping
	invoke Sleep,MSPerTick
	jmp L1
	ExitGame:
	invoke ExitProcess,0
main ENDP
END main