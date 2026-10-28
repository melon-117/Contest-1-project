.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
INCLUDE SpaceGame.inc
ExitProcess proto,dwExitCode:dword

.data
bulletCount dword 0
invaderCount dword 0
invaderFireCounter dword 0
bestShooterOffset dword 0
bestShooterY dword 0
currentFireColumn dword 0 
rowsToCheck dword 0
.code
playerBulletCollision PROC USES eax ebx ecx edx esi edi ebp
	; Check for collision between player bullets and invaders
	mov esi, 0 ; index for player bullets
	mov bulletCount, 5 ; number of player bullets to check
	PlayerBulletloops:
		cmp bulletCount, 0
		jle Done
		mov ecx, playerBulletActive[esi] ; check if player bullet is active
		cmp ecx, 0
		je SkipPlayerBullet ; if not active, skip collision check
		mov eax, playerBulletX[esi] ; get player bullet X position
		mov ebx, playerBulletY[esi] ; get player bullet Y position
		; Check collision with invaders
		mov edi, 0 ; index for invaders
		mov invaderCount, 15 ; number of invaders to check
		InvaderLoop:
			mov ecx, invaderAlive[edi] ; check if invader is alive
			cmp ecx, 0
			je SkipInvaderCollision ; if not alive, skip collision check
			mov ecx, invaderX[edi] ; get invader X position
			mov ebp, invaderY[edi] ; get invader Y position
			; Check if bullet and invader occupy the same position
			cmp eax, ecx ; compare bullet X with invader X
			jne SkipInvaderCollision
			cmp ebx, ebp ; compare bullet Y with invader Y
			jne SkipInvaderCollision
			; Collision detected: deactivate bullet and invader
			mov playerBulletActive[esi], 0 ; deactivate bullet
			mov invaderAlive[edi], 0 ; deactivate invader
			; Update score or other game states
			add score, 10 ; increase score by 10
			dec invaderCount ; decrease invader count
			dec remainingInvaders
			cmp remainingInvaders, 0
			jne nextPlayerBullet
			mov gameStatus, 2
			jmp nextPlayerBullet
			SkipInvaderCollision:
				add edi, 4
				sub invaderCount, 1  
				cmp invaderCount, 0
				jg InvaderLoop
		SkipPlayerBullet:
			jmp nextPlayerBullet
		nextPlayerBullet:
			add esi, 4
			sub bulletCount, 1
			cmp bulletCount, 0
			jg PlayerBulletloops
		Done:
			ret
		
playerBulletCollision ENDP
invaderBulletCollision PROC USES eax ebx ecx edx esi edi ebp
	; Check for collision between invader bullets and player
	mov esi, 0 ; index for invader bullets
	mov bulletCount, 5 ; number of invader bullets to check
	InvaderBulletloops:
		cmp bulletCount, 0
		jle DoneInvader
		mov ecx, invaderBulletActive[esi] ; check if invader bullet is active
		cmp ecx, 0
		je nextInvaderBullet ; if not active, skip collision check
		mov eax, invaderBulletX[esi] ; get invader bullet X position
		mov ebx, invaderBulletY[esi] ; get invader bullet Y position
		; Check collision with player
		mov ecx, playerX ; get player X position
		mov edx, playerY ; get player Y position
		cmp eax, ecx ; compare bullet X with player X
		jne nextInvaderBullet
		cmp ebx, edx ; compare bullet Y with player Y
		jne nextInvaderBullet
		; Collision detected: deactivate bullet and reduce player health or lives
		mov invaderBulletActive[esi], 0 ; deactivate bullet
		sub lives, 1 ; decrease player lives by 1
		cmp lives, 0
		jg nextInvaderBullet
		mov gameStatus , 0 ; set game status to game over
		jmp nextInvaderBullet
	nextInvaderBullet:
			add esi, 4
			sub bulletCount, 1
			cmp bulletCount, 0
			jg InvaderBulletloops
	DoneInvader:
			ret
invaderBulletCollision ENDP
fireInvaderBullet PROC USES eax ecx esi edi
	; Wait 60 ticks between firing attempts
	inc invaderFireCounter
	cmp invaderFireCounter, 60
	jl FireDone
	mov invaderFireCounter, 0
	; Find an inactive invader bullet slot
	mov esi, 0
	FindBulletSlot:
		cmp esi, 20
		jge FireDone
		cmp invaderBulletActive[esi], 0
		je FindLivingInvader
		add esi, 4
		jmp FindBulletSlot
	FindLivingInvader:
		; Save the available bullet slot
		mov edi, esi
		; Search for a living invader
		mov esi, currentFireColumn
		shl esi,2
		mov bestShooterOffset, 0
		mov bestShooterY, -1
		mov rowsToCheck, 3
	FindInvaderColumn:
		cmp rowsToCheck, 0
		jle CheckShooter 
		cmp invaderAlive[esi], 0
		je NextInvader
		mov eax, invaderY[esi]
		cmp bestShooterY, -1
		je SelectShooter
		cmp eax, bestShooterY
		jle NextInvader
	SelectShooter:
		mov bestShooterY, eax
		mov bestShooterOffset, esi
		jmp NextInvader
	NextInvader:
		add esi, 20 
		dec rowsToCheck
		jmp FindInvaderColumn
	CheckShooter:
	    cmp bestShooterY, -1
		je AdvanceColumn
		jmp LaunchBullet
	LaunchBullet:
		mov esi, bestShooterOffset
		; Place the bullet just below the invader
		mov eax, invaderX[esi]
		mov invaderBulletX[edi], eax
		mov eax, invaderY[esi]
		inc eax
		mov invaderBulletY[edi], eax
		; Activate the bullet
		mov invaderBulletActive[edi], 1
	AdvanceColumn: 
		inc currentFireColumn
		cmp currentFireColumn, 5
		jl FireDone
		mov currentFireColumn, 0
	FireDone:
		ret
fireInvaderBullet ENDP
updateInvaderBullets PROC USES eax esi edi
	; Start at the first invader bullet slot
	mov esi, 0
	mov edi, 5
	UpdateBulletLoop:
		; Stop after checking all five slots
		cmp edi, 0
		jle UpdateBulletsDone
		; Skip inactive bullets
		cmp invaderBulletActive[esi], 0
		je NextBullet
		; Check whether the bullet has reached the bottom
		mov eax, invaderBulletY[esi]
		cmp eax, screenBottomBound
		jge DeactivateBullet
		; Move the bullet down one row
		inc eax
		mov invaderBulletY[esi], eax
		jmp NextBullet
	DeactivateBullet:
		; Mark the bullet as inactive
		mov invaderBulletActive[esi], 0
	NextBullet:
		; Advance to the next DWORD array element
		add esi, 4
		dec edi
		jmp UpdateBulletLoop
	UpdateBulletsDone:
		ret
updateInvaderBullets ENDP
END 