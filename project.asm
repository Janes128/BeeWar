INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO

NatureBody STRUCT
	naturelong BYTE 6
	x BYTE 20
	y BYTE 20
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "(^..^)",0
NatureBody ENDS

;������NatureAttackStruct
NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
NatureAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧiEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�ľ��ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EnemyMain PROTO
EnemyPrint PROTO
EnemyMove PROTO
EnemyAttacks PROTO

EnemyBody STRUCT
	enemylong BYTE 2
	x BYTE 5
	y BYTE 0
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "V",0
EnemyBody ENDS

;������EnemyAttackStruct
EnemyAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
EnemyAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�ľ��ŧiEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
.data
Nature NatureBody <>
Natureattack NatureAttackStruct <>	;������ (�D����X������t��)
Enemy EnemyBody <>
Enemyattack EnemyAttackStruct <>;������	(�ľ���X������t��)

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE NatureMain;
	INVOKE EnemyMain;
				
	push eax	;�ɶ��Ȱ��N
	mov eax,1
	call Delay
	pop eax

	call clrscr		;�M�ſù�

	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�禡;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NaturePROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Naturemain

Naturemain PROC
	INVOKE NaturePrint
	INVOKE NatureMove
	INVOKE NatureBloodLine

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx


	mov dl,Nature.x
	mov dh,Nature.y
	mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
	call SetTextColor
	;
	call Gotoxy
	mov edx, OFFSET Nature.picture
	call WriteString

	ret
NaturePrint ENDP
;----------------------------NatureMove

NatureMove PROC USES eax ebx esi edi
	
	;call readchar
	cmp  eax, 4B00h				;��
	jz   LEFT
	cmp  eax, 4D00h				;�k
	jz   RIGHT
	cmp  eax, 4800h				;�W
	jz   UP
	cmp  eax, 5000h				;�U
	jz   DOWN
	cmp  eax, 0020h				;�ť���
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
;----------------------------NatureBloodLine

NatureBloodLine PROC USES ecx eax edx
	movzx ecx, Nature.blood
	mov dl, 0		; col
	mov dh, 0 		; row
	call Gotoxy
	bloodLoop:
		mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
		call SetTextColor
		mov al, 'a'
		call WriteChar
		inc dh
		loop bloodLoop
	ret
NatureBloodLine ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EnemyPROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Enemymain
Enemymain PROC
	INVOKE EnemyPrint
	INVOKE EnemyMove
	INVOKE EnemyAttacks
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC USES eax edx ebx
	mov dl, 10
	mov dh, 0
	call Gotoxy
	mov  eax, 10 + ( black*16 )			;�]�w�e�����H���A�I�����¦�
	call SetTextColor
	mov al, 'V'
	call WriteChar

	mov dh, Enemy.y
	inc dh
	mov Enemy.y, dh
	cmp dh, 20
	jz resetY
	call Gotoxy
	jmp finalPrint
	resetY:
		mov dh, 0
		mov Enemy.y, dh
	finalPrint:
		mov al, '|'
		call WriteChar

	ret
EnemyPrint ENDP

;----------------------------EnemyMove
EnemyMove PROC

	ret
EnemyMove ENDP

;----------------------------EnemyAttack

EnemyAttacks PROC USES eax ebx esi edi

	ret
EnemyAttacks ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
