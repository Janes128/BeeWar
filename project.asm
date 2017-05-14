INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;韋成改NatureAttackStruct
NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
NatureAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	picture BYTE "**",0
EnemyBody ENDS

;韋成改EnemyAttackStruct
EnemyAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
EnemyAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
.data
Nature NatureBody <>
Natureattack NatureAttackStruct <>	;韋成改 (主機放出的物質速度)
Enemy EnemyBody <>
Enemyattack EnemyAttackStruct <>;韋成改	(敵機放出的物質速度)

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE NatureMain;
	INVOKE EnemyMain;
				
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;函式;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NaturePROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
	cmp  eax, 4800h				;上
	jz   UP
	cmp  eax, 5000h				;下
	jz   DOWN
	cmp  eax, 5000h				;空白鍵??????????????????????????????
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EnemyPROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Enemymain
Enemymain PROC
	INVOKE EnemyPrint
	INVOKE EnemyMove
	INVOKE EnemyAttack
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC

	ret
EnemyPrint ENDP

;----------------------------EnemyMove
EnemyMove PROC

	ret
EnemyMove ENDP

;----------------------------EnemyAttack

EnemyAttack PROC USES eax ebx esi edi

	ret
EnemyAttack ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main
