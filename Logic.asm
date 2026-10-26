.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
INCLUDE SpaceGame.inc
ExitProcess proto,dwExitCode:dword

.data
bulletCount dword 0
invaderCount dword 0
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
END 