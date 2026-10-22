;DO NOT COMPILE this file once GameLoop.asm is finished 
;This file is ment to be used for testing the Rendering.asm file primarily to test if the Player, invader(s), & bullets can draw to the terminal 
;Please DELETE file once GameLoop.asm is completed
.386
.model flat,stdcall
.stack 4096
INCLUDE Irvine32.inc
ExitProcess proto,dwExitCode:dword
EXTERN playerX:DWORD
EXTERN playerY:DWORD
EXTERN playerBulletX:DWORD
EXTERN playerBulletY:DWORD
EXTERN playerBulletActive:DWORD
EXTERN invaderBulletX:DWORD
EXTERN invaderBulletY:DWORD
EXTERN invaderBulletActive:DWORD
DrawPlayer PROTO STDCALL
DrawInvaders PROTO STDCALL
DrawBullets PROTO STDCALL
DrawHUD PROTO STDCALL
initializeInvaders PROTO STDCALL
.data
.code
main PROC
	call initializeInvaders ; Initialize the invaders
	mov playerX, 50 ; Set initial player X position
	mov playerY, 25 ; Set initial player Y position
	mov playerBulletX, 40 ; Set initial player bullet X position
	mov playerBulletY, 15 ; Set initial player bullet Y position
	mov playerBulletActive, 1 ; Set initial player bullet active status
	mov invaderBulletX, 60 ; Set initial invader bullet X position
	mov invaderBulletY, 10 ; Set initial invader bullet Y position
	mov invaderBulletActive, 1 ; Set initial invader bullet active status
	call DrawHUD ; Call the DrawHUD procedure to render the HUD
	call DrawPlayer ; Call the DrawPlayer procedure to render the player
	call DrawInvaders ; Call the DrawInvaders procedure to render the invaders
	call DrawBullets ; Call the DrawBullets procedure to render the bullets
	call Readchar ; Wait for a key press before exiting
	invoke ExitProcess,0
main ENDP
END main
