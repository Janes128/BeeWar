INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Naturemain PROTO
Natureprint PROTO

NatureSTRUCT STRUCT
	naturelong BYTE 6
	x BYTE 5
	y BYTE 5
	blood BYTE 5
	picture BYTE "(^..^)",0
NatureSTRUCT ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main  EQU start@0 ;
.data
mainy BYTE "1            ",0,"2            ",0,"3            ",0,"4            ",0,"5            ",0,"6            ","123",0
Nature NatureSTRUCT <>
countnaturex BYTE 1

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:
	cmp eax,84
	jb eaxless84
	call clrscr		;�M�ſù�
	mov eax,0
	mov countnaturex,-1
	eaxless84:

	INVOKE Naturemain;�I�s Str_remove


	add eax,14							
	push eax	;�ɶ��Ȱ��N
	mov eax,200
	call Delay
	pop eax

	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;----------------------------Naturemain
Naturemain PROC
	INVOKE Natureprint

	mov bl,Nature.x
	add bl,countnaturex
	mov Nature.x,bl

	ret
Naturemain ENDP
;----------------------------Natureprint
Natureprint PROC

	push edx
	push eax

	mov dl,Nature.x
	mov dh,Nature.y
	mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
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

	pop eax
	pop edx

	ret
Natureprint ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
