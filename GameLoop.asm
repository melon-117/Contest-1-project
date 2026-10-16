.386
.model flat,stdcall
.stack 4096

INCLUDE Irvine32.inc
ExitProcess proto,dwExitCode:dword

.data

.code
main PROC

	invoke ExitProcess,0
main ENDP
END main