INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO

NatureBody STRUCT
	naturelong BYTE 6
	x BYTE 5
	y BYTE 5
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "(^..^)",0
NatureBody ENDS

NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
NatureAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main  EQU start@0 ;
.data
;mainy BYTE "1            ",0,"2            ",0,"3            ",0,"4            ",0,"5            ",0,"6            ","123",0

Nature NatureBody <>
Natureattack NatureAttackStruct <>

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE NatureMain;�I�s Str_remove

				
	push eax	;�ɶ��Ȱ��N
	mov eax,0
	call Delay
	pop eax

	call clrscr		;�M�ſù�

	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	mov  eax, white + ( black*16 )			;�]�w�e�����զ�A�I�����¦�
	call SetTextColor

	pop eax
	pop edx

	ret
NaturePrint ENDP
;----------------------------NatureMove

NatureMove PROC USES eax ebx esi edi
	
	call readchar
	cmp  eax, 4B00h				;��
	jz   LEFT
	cmp  eax, 4D00h				;�k
	jz   RIGHT
	cmp  eax, 4800h				;�W
	jz   UP
	cmp  eax, 5000h				;�U
	jz   DOWN
	cmp  eax, 5000h				;�ť���??????????????????????????????
	jz	 SPACE
	jmp NatureMoveEDN

	SPACE:
		INVOKE NatureAttacks
		jmp NatureMoveEDN
	UP:
		jmp NatureMoveEDN
	DOWN:
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
;----------------------------NatureAttack

NatureAttacks PROC USES eax ebx esi edi

	ret
NatureAttacks ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
