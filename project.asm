INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO

NatureSTRUCT STRUCT
	naturelong BYTE 6
	x BYTE 5
	y BYTE 5
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "(^..^)",0
NatureSTRUCT ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main  EQU start@0 ;
.data
mainy BYTE "1            ",0,"2            ",0,"3            ",0,"4            ",0,"5            ",0,"6            ","123",0
Nature NatureSTRUCT <>


.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE NatureMain;呼叫 Str_remove

				
	push eax	;時間暫停術
	mov eax,0
	call Delay
	pop eax

	call clrscr		;清空螢幕

	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Naturemain

Naturemain PROC
	INVOKE NaturePrint
	INVOKE NatureMove

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax ecx esi edi

	push edx
	push eax

	mov dl,Nature.x
	mov dh,Nature.y
	mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
	call SetTextColor
	;
	call Gotoxy
	mov  al , "("
	call Writechar
	;
	add dl,1
	call Gotoxy
	mov  al , "^"
	call Writechar
	;
	add dl,1
	call Gotoxy
	mov  al , "."
	call Writechar
	;
	add dl,1
	call Gotoxy
	mov  al , "."
	call Writechar
	;
	add dl,1
	call Gotoxy
	mov  al , "^"
	call Writechar
	;
	add dl,1
	call Gotoxy
	mov  al , ")"
	call Writechar
	;
	mov  eax, white + ( black*16 )			;設定前景為白色，背景為黑色
	call SetTextColor

	pop eax
	pop edx

	ret
NaturePrint ENDP

;----------------------------NatureMove

NatureMove PROC USES eax ebx esi edi
	
	call readchar
	cmp  eax, 4B00h				;左
	jz   LEFT
	cmp  eax, 4D00h				;右
	jz   RIGHT
	jmp NatureMoveEDN

	LEFT:
		
		mov bl,Nature.x
		mov Nature.countnaturex,-1
		jmp NatureMoveEDN
	RIGHT:

		mov bl,Nature.x
		mov Nature.countnaturex,1

	NatureMoveEDN:
		add bl,Nature.countnaturex
		mov Nature.x,bl
		mov Nature.countnaturex,0
	ret
NatureMove ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
