.386
.model flat,stdcall
.stack 4096

EXTERN screenLeftBound:DWORD
EXTERN screenRightBound:DWORD
EXTERN screenTopBound:DWORD
EXTERN playerX:DWORD
EXTERN playerY:DWORD
EXTERN score:DWORD
EXTERN lives:DWORD
EXTERN level:DWORD
EXTERN gameStatus:DWORD
EXTERN invaders:DWORD
EXTERN invaderX:DWORD
EXTERN invaderY:DWORD
EXTERN invaderAlive:DWORD
EXTERN invaderDirection:DWORD
EXTERN playerBulletX:DWORD
EXTERN playerBulletY:DWORD
EXTERN playerBulletActive:DWORD
EXTERN playerBulletSlot:DWORD
EXTERN invaderBulletX:DWORD
EXTERN invaderBulletY:DWORD
EXTERN invaderBulletActive:DWORD
EXTERN invaderBulletSlot:DWORD
EXTERN remainingInvaders:DWORD
EXTERN gameStatus:DWORD
EXTERN score:DWORD
EXTERN lives:DWORD
EXTERN level:DWORD
PUBLIC DrawPlayer
PUBLIC DrawInvaders
PUBLIC DrawBullets
PUBLIC DrawHUD
DrawPlayer PROTO STDCALL
DrawInvaders PROTO STDCALL
DrawBullets PROTO STDCALL
DrawHUD PROTO STDCALL
initializeInvaders PROTO STDCALL
playerBulletCollision PROTO STDCALL
