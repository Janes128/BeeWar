INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�L�X�D��;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CallNature PROTO

NatureSTRUCT STRUCT
	x BYTE 5
	y BYTE 5
	blood BYTE 5
	picture BYTE "1234(^..^)   ",0
NatureSTRUCT ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main  EQU start@0 ;
.data
mainy BYTE "             ",0,"             ",0,"             ",0,"             ",0,"             ",0,"             ",0
Nature NatureSTRUCT <>

.code
main PROC

mov eax,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:
	cmp eax,50
	jb eaxless50
	mov eax,0
	eaxless50:

	INVOKE CallNature;�I�s Str_remove


	add eax,14							
	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP

CallNature PROC

	mov edx,OFFSET mainy
	call WriteString
	call Crlf

	add edx,eax
	call WriteString
	call Crlf

	add edx,eax
	call WriteString
	call Crlf

	ret
CallNature ENDP
END main

;call clrscr								;�M�ſù�