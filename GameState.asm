.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
ExitProcess proto,dwExitCode:dword
PUBLIC initializeInvaders
;file accesss to varibles 
PUBLIC playerX, playerY, score, lives, level, gameStatus
PUBLIC invaders, invaderX, invaderY, invaderAlive, invaderDirection, remainingInvaders, selectedInvader
PUBLIC playerBulletSlot, playerBulletX, playerBulletY, playerBulletActive
PUBLIC invaderBulletSlot, invaderBulletX, invaderBulletY, invaderBulletActive
PUBLIC screenWidth, screenHeight, screenLeftBound, screenRightBound, screenTopBound, screenBottomBound
.data
	; Define game state variables
	playerX DWORD 0
	playerY DWORD 0
	score DWORD 0
	lives DWORD 3
	level DWORD 1
	;invaders
	invaders DWORD 15
	invaderX DWORD 15 DUP(?)
	invaderY DWORD 15 DUP(?)
	invaderAlive DWORD 15 DUP(1)
	invaderDirection DWORD 1 ; 1 for right, -1 for left
	invaderMoveDown DWORD 0 ; > 0 for remaining invaders to move down, 0 for stationary
	selectedInvader DWORD 0
	;player bullet
	playerBulletSlot DWORD 5 DUP(?) ;might be redundant depending on how we implement the bullet system
	playerBulletX DWORD 5 DUP(?)
	playerBulletY DWORD 5 DUP(?)
	playerBulletActive DWORD 5 DUP(0)
	;invader bullet
	invaderBulletSlot DWORD 5 DUP(?) ;might be redundant depending on how we implement the bullet system
	invaderBulletX DWORD 5 DUP(?)
	invaderBulletY DWORD 5 DUP(?)
	invaderBulletActive DWORD 5 DUP(0)
	;screen dimensioons and boundries
	screenWidth DWORD 100
	screenHeight DWORD 30
	screenLeftBound DWORD 0
	screenRightBound DWORD 99
	screenTopBound DWORD 0
	screenBottomBound DWORD 29
	;remaining invaders and game status
	remainingInvaders DWORD 15
	gameStatus DWORD 1 ; 1 for playing, 0 for game over
	;rows and columns for invaders
	row DWORD 0
	col DWORD 0
.code 
initializeInvaders PROC USES ebx esi edi
	mov esi , 0 ; index for invaders
	mov ecx, 15 ; number of invaders to initialize
	L1:

		mov edi, esi
		shr edi, 2 ; divide index by 4 to get row and column

		; Calculate row and column based on index
		mov edx, 0 ; clear edx before division
		mov eax, edi
		mov ebx, 5 ; number of columns
		div ebx ; divide index by number of columns (5) to get row
		mov row, eax ; store row value
		mov col, edx ; store column value
		
		mov eax, col ; load column value
		imul eax, eax, 10 ; multiply column by number of rows
		add eax, 30 ; add starting position for invaders
		mov invaderX[esi], eax ; store x position

		mov eax, row ; load row value
		imul eax, eax, 3 ; multiply row by spacing
		add eax, 3 ; add starting position for invaders
		mov invaderY[esi], eax ; store y position
		
		mov invaderAlive[esi], 1 ; mark invader as alive

		add esi, 4
	loop L1
	ret
initializeInvaders ENDP

moveInvaders PROC USES eax ebx edx esi 
	cmp remainingInvaders,0 ; return if no invaders left
	je Return
	L1:
	; get current valid invader
	mov edx, 0 ; setup for div
	mov eax, selectedInvader
	mov ebx, 15
	div ebx ; get modulus of selected invader
	mov esi, edx
	imul esi,esi,4
	mov selectedInvader, edx

	inc selectedInvader ; advance selected for next call
	cmp invaderAlive[esi],0 ; if invader is dead, go to next invader
	je L1
	
	cmp invaderMoveDown,0
	jne MoveDown ; move down if queued

	mov eax,invaderDirection
	add invaderX[esi],eax ; move in x direction

	; check bounds
	mov eax,screenRightBound
	cmp invaderX[esi],eax
	je StartMoveDown ; set move down queue if at right bound
	mov eax,screenLeftBound
	cmp invaderX[esi],eax
	je StartMoveDown ; set move down queue if at left bound
	jmp Return

	MoveDown:
	inc invaderY[esi] ; change invader Y coordinate
	mov eax,playerY
	cmp invaderY[esi],eax
	jge GameOver
	dec invaderMoveDown ; advance invader move down queue
	jmp Return

	GameOver:
	mov gameStatus,0
	ret

	StartMoveDown:
	neg invaderDirection ; change direction
	mov eax,remainingInvaders
	mov invaderMoveDown,eax ; set move down queue
	mov eax,invaderDirection ; go back in bounds
	add invaderX[esi],eax
	jmp Return

	Return:
	ret
moveInvaders ENDP

END