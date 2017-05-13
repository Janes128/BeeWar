INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;印出主機;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:
	cmp eax,50
	jb eaxless50
	mov eax,0
	eaxless50:

	INVOKE CallNature;呼叫 Str_remove


	add eax,14							
	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;call clrscr								;清空螢幕