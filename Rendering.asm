.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
INCLUDE SpaceGame.inc
ExitProcess proto,dwExitCode:dword

.data
ScoreLabel BYTE "Score: ", 0
LivesLabel BYTE " Lives: ", 0
LevelLabel BYTE " Level: ", 0
prevScore DWORD 0 ; scrappy solution to HUD flickering. Saves and checks against previous value to avoid unnecessary update
prevLives DWORD 0
prevLevel DWORD 0
prevPlayerX DWORD 0

.code
DrawPlayer PROC USES eax edx
	; Draw the player at (playerX, playerY)
	mov eax,playerX
	cmp prevPlayerX,eax
	jne Continue
	ret ; return if player has not moved
	Continue:
	; Remove previous sprite
	mov eax,prevPlayerX
	mov dl,al ; X for Gotoxy
	mov eax,playerY ; Y for Gotoxy
	mov dh,al
	call Gotoxy ; goto previous player position
	; Replace previous player sprite with empty space
	mov al,' '
	call WriteChar
	mov eax,playerX ; move current X
	mov prevPlayerX,eax ; update prev X with current
	; Call a function to draw the player sprite at (eax, edx)
	mov eax, playerX
	mov dl, al  ; Move playerX into dl for Gotoxy
	mov eax, playerY
	mov dh, al   ; Clear dh for Gotoxy
	call Gotoxy
	; DrawSprite eax, edx, PlayerSprite
	mov al, '^'
	call WriteChar
	ret
DrawPlayer ENDP

DrawInvaders PROC USES eax ecx edx esi edi
	; Draw all invaders based on their positions and alive status
	mov esi, 0 ; index for invaders
	mov ecx, 15 ; number of invaders to draw
	L1:
		mov eax, invaderAlive[esi] ; check if invader is alive
		cmp eax, 0
		je L2 ; if not alive, skip drawing
		; Call a function to draw the invader sprite at (eax, ebx)
		mov eax, invaderX[esi] ; get invader X position
		mov dl, al  ; Move invaderX into dl for Gotoxy
		mov eax, invaderY[esi] ; get invader Y position
		mov dh, al   ; Move invaderY into dh for Gotoxy
		call Gotoxy
		; DrawSprite eax, ebx, InvaderSprite
		mov al, bl
		call WriteChar
		L2:
			add esi, 4
			loop L1
	ret
DrawInvaders ENDP

DrawBullets PROC USES eax ebx ecx edx esi edi
	; Draw all bullets based on their positions and active status
	mov esi, 0 ; index for bullets
	mov ecx, 5 ; number of bullets to draw
	PlayerBulletLoop:
		mov ebx, playerBulletActive[esi]
		cmp ebx, 0
		je SkipPlayerBullet
		mov eax, playerBulletX[esi]
		mov ebx, playerBulletY[esi]
		; If bullet has reached the top, deactivate it
		cmp ebx, screenTopBound
		jbe DeactivatePlayerBullet
		; Move bullet upward
		dec ebx
		mov playerBulletY[esi], ebx
		; Draw bullet
		mov dl, al
		mov dh, bl
		call Gotoxy
		mov al, '|'
		call WriteChar

		jmp SkipPlayerBullet
	DeactivatePlayerBullet:
		mov playerBulletActive[esi], 0
	SkipPlayerBullet:
		add esi, 4
		loop PlayerBulletLoop
	mov esi, 0 ; reset index for invader bullets
	mov ecx, 5 ; number of invader bullets to draw
	InvaderBulletLoop:
		; DrawSprite eax, ebx, InvaderBulletSprite
		mov eax, invaderBulletActive[esi] ; check if invader bullet is active
		cmp eax, 0
		je SkipInvaderBullet ; if not active, skip drawing
		mov eax, invaderBulletX[esi] ; get invader bullet X position
		mov ebx, invaderBulletY[esi] ; get invader bullet Y position	
		; Call a function to draw the invader bullet sprite at (eax, ebx)
		mov dl, al  ; Move invaderBulletX into dl for Gotoxy
		mov dh, bl   ; Move invaderBulletY into dh for Gotoxy
		call Gotoxy
		; DrawSprite eax, ebx, InvaderBulletSprite
		mov al, '!'
		call WriteChar
	SkipInvaderBullet:
			add esi, 4
			loop InvaderBulletLoop
	ret
DrawBullets ENDP

DrawHUD PROC USES eax ebx ecx edx
	; Draw the HUD elements (score, lives, etc.)
	; Display the current score, lives, and level
	mov eax,prevScore
	cmp score,eax ; check for updates
	jne Continue
	mov eax,prevLives
	cmp lives,eax
	jne Continue
	mov eax,prevLevel
	cmp level,eax
	jne Continue
	ret ; return if no updates

	Continue:
	mov eax, 0 ; X position for HUD
	mov ebx, 0 ; Y position for HUD
	mov dl, al  ; Move X into dl for Gotoxy
	mov dh, bl   ; Move Y into dh for Gotoxy
	call Gotoxy
	; Draw the score, lives, and level
	mov edx, OFFSET ScoreLabel
	call WriteString
	mov eax, score
	mov prevScore,eax
	call WriteDec
	mov edx, OFFSET LivesLabel		
	call WriteString
	mov eax, lives
	mov prevLives,eax
	call WriteDec
	mov edx, OFFSET LevelLabel
	call WriteString
	mov eax, level
	mov prevLevel,eax
	call WriteDec
	ret
DrawHUD ENDP

ClearInvaders PROC USES ebx
	mov bl,' '
	call DrawInvaders
	ret
ClearInvaders ENDP

ClearBullets PROC USES eax ebx ecx edx esi edi
	mov esi, 0 ; index for bullets
	mov ecx, 5 ; number of bullets to draw
	PlayerBulletLoop:
		mov ebx, playerBulletActive[esi]
		cmp ebx, 0
		je SkipPlayerBullet
		mov eax, playerBulletX[esi]
		mov ebx, playerBulletY[esi]
		; Draw bullet
		mov dl, al
		mov dh, bl
		call Gotoxy
		mov al, ' '
		call WriteChar

		jmp SkipPlayerBullet
	DeactivatePlayerBullet:
		mov playerBulletActive[esi], 0
	SkipPlayerBullet:
		add esi, 4
		loop PlayerBulletLoop
	mov esi, 0 ; reset index for invader bullets
	mov ecx, 5 ; number of invader bullets to draw
	InvaderBulletLoop:
		; DrawSprite eax, ebx, InvaderBulletSprite
		mov eax, invaderBulletActive[esi] ; check if invader bullet is active
		cmp eax, 0
		je SkipInvaderBullet ; if not active, skip drawing
		mov eax, invaderBulletX[esi] ; get invader bullet X position
		mov ebx, invaderBulletY[esi] ; get invader bullet Y position
		; Call a function to draw the invader bullet sprite at (eax, ebx)
		mov dl, al  ; Move invaderBulletX into dl for Gotoxy
		mov dh, bl   ; Move invaderBulletY into dh for Gotoxy
		call Gotoxy
		; DrawSprite eax, ebx, InvaderBulletSprite
		mov al, ' '
		call WriteChar
	SkipInvaderBullet:
			add esi, 4
			loop InvaderBulletLoop
	ret
ClearBullets ENDP

END
