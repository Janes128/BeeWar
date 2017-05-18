INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO
EnemyPrint PROTO

NatureBody STRUCT
	naturelong BYTE 6
	x BYTE 20
	y BYTE 20
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "(^..^)",0
NatureBody ENDS

NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
NatureAttackStruct ENDS

EnemyAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE ?
EnemyAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

main  EQU start@0 ;
.data

Nature NatureBody <>
Natureattack NatureAttackStruct <>
Enemy EnemyAttackStruct <10>

.code
main PROC

xor eax, eax
xor ebx, ebx
xor ecx, ecx
xor edx, edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE NatureMain;呼叫 Str_remove

				
	push eax	;時間暫停術
	mov eax,1
	call Delay
	pop eax

	call clrscr		;清空螢幕

	jmp RUNGAME
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;++++++++++++++++++++++++++++Nature
;----------------------------Naturemain

Naturemain PROC
	INVOKE NaturePrint
	INVOKE EnemyPrint
	INVOKE NatureBloodLine
	INVOKE NatureMove
	
	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx

	;push edx
	;push eax

	mov dl,Nature.x
	mov dh,Nature.y
	mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
	call SetTextColor
	;
	call Gotoxy
	mov edx, OFFSET Nature.picture
	call WriteString
	;
	
	;mov  eax, white + ( black*16 )			;設定前景為白色，背景為黑色
	;call SetTextColor

	;pop eax
	;pop edx

	ret
NaturePrint ENDP
;----------------------------NatureMove

NatureMove PROC USES eax ebx
	
	call readchar
	cmp  eax, 4B00h				;左
	jz   LEFT
	cmp  eax, 4D00h				;右
	jz   RIGHT
	cmp  eax, 4800h				;上
	jz   UP
	cmp  eax, 5000h				;下
	jz   DOWN
	cmp  eax, 0020h				;空白鍵
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
		mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
		call SetTextColor
		mov al, 'a'
		call WriteChar
		inc dh
		loop bloodLoop
	ret
NatureBloodLine ENDP
;++++++++++++++++++++++++++++Nature

;++++++++++++++++++++++++++++Enemy
;----------------------------EnemyPrint
EnemyPrint PROC USES eax edx ebx
	mov dl, 10
	mov dh, 0
	call Gotoxy
	mov  eax, 10 + ( black*16 )			;設定前景為淡綠色，背景為黑色
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
;----------------------------EnemyPrint
;++++++++++++++++++++++++++++Enemy
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
