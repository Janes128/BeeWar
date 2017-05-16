INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;韋成改NatureAttackStruct
NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
NatureAttackStruct ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EnemyMain PROTO
EnemyPrint PROTO,
	nowEnemynumber:DWORD
EnemyMove PROTO
EnemyAttacks PROTO,
	nowEnemynumber:DWORD

;韋成改EnemyAttackStruct
EnemyAttackStruct STRUCT
	x BYTE ?
	y BYTE 0
	long BYTE 1
EnemyAttackStruct ENDS

EnemyBody STRUCT
	x BYTE 20
	y BYTE 0
	countnaturex BYTE 0
	bulletlocation	EnemyAttackStruct <>	;韋成改	(敵機放出攻擊時的位置、EnemyAttacks PROC中的(EnemyBody PTR Enemy[edi]).y
											;							   調整成(EnemyBody PTR Enemy[edi]).bulletlocation.y 因為EnemyBody.y之後要做成敵人的移動)
	blood BYTE 5
	picture BYTE "V",0
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
.data
Nature NatureBody <>
Natureattack NatureAttackStruct <>					;韋成改 (主機放出的物質速度)
Enemy EnemyBody 10 DUP(<20>,<35>,<28>,<17>,<11>) 	;對Enemy的位置做出始化
currentEnemyhavetoprint BYTE 5						;螢幕上印出的敵機 (包含死亡的)
EnemyBodyhaveSTRUCTnumber DWORD 9

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE EnemyMain;
	INVOKE NatureMain;
				
	push eax				;時間暫停術
	mov eax,100
	call Delay
	pop eax

	call clrscr				;清空螢幕

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
	INVOKE NatureBloodLine

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx


	mov dl, Nature.x
	mov dh, Nature.y
	mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
	call SetTextColor
	;
	call Gotoxy
	mov edx, OFFSET Nature.picture
	call WriteString

	ret
NaturePrint ENDP
;----------------------------NatureMove

NatureMove PROC USES eax ebx
	
	call ReadKey				; 偵測是否有鍵盤輸入資料
	cmp  eax, 4B00h				; 左
	jz   LEFT
	cmp  eax, 4D00h				; 右
	jz   RIGHT
	;cmp  eax, 4800h			; 上
	;jz   UP
	;cmp  eax, 5000h			; 下
	;jz   DOWN
	cmp  eax, 0020h				; 空白鍵
	jz	 SPACE

	jmp DontMove

	SPACE:
		INVOKE NatureAttacks
		jmp NatureMoveEDN
	;UP:
	;	jmp NatureMoveEDN
	;DOWN:
	;	jmp NatureMoveEDN
	LEFT:
		mov bl,Nature.x
		mov Nature.countnaturex,-2
		jmp NatureMoveEDN
	RIGHT:
		mov bl,Nature.x
		mov Nature.countnaturex,2

	NatureMoveEDN:
		add bl,Nature.countnaturex
		mov Nature.x,bl
		mov Nature.countnaturex,0
	DontMove:

	ret
NatureMove ENDP
;----------------------------NatureAttack

NatureAttacks PROC USES eax ebx

	ret
NatureAttacks ENDP
;----------------------------NatureBloodLine

NatureBloodLine PROC USES ecx eax edx
	movzx ecx, Nature.blood
	mov dl, 50		; col
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EnemyPROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Enemymain
Enemymain PROC
	movzx ecx,currentEnemyhavetoprint
	mov eax,0
	PrintEnemy:					;****迴圈 印出多個敵人****
		mov esi,OFFSET Enemy
		add esi,eax

		push eax
		INVOKE EnemyPrint , eax
		INVOKE EnemyMove
		pop eax
		push eax
		INVOKE EnemyAttacks , eax
		pop eax
		
		add eax,EnemyBodyhaveSTRUCTnumber					;EnemyBodyhaveSTRUCTnumber
	loop PrintEnemy				;****迴圈 印出多個敵人****
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC,
	nowEnemynumber:DWORD

	mov edi,nowEnemynumber	;不這樣做直接放EnemyBody PTR Enemy[nowEnemynumber]會爆掉
	mov dl, (EnemyBody PTR Enemy[edi]).x
	mov dh, 0
	call Gotoxy
	mov  eax, 10 + ( black*16 )			;設定前景為淡綠色，背景為黑色
	call SetTextColor
	mov al, 'V'
	call WriteChar


	ret
EnemyPrint ENDP

;----------------------------EnemyMove
EnemyMove PROC 

	ret
EnemyMove ENDP

;----------------------------EnemyAttack

EnemyAttacks PROC,
	nowEnemynumber:DWORD

	mov edi,nowEnemynumber
	mov dh, (EnemyBody PTR Enemy[edi]).y
	inc dh
	mov (EnemyBody PTR Enemy[edi]).y, dh
	cmp dh, 20
	jz resetY
	call Gotoxy
	jmp finalPrint
	resetY:
		mov dh, 0
		mov (EnemyBody PTR Enemy[edi]).y, dh
		jmp EnemyAttacksEND
	finalPrint:
		mov al, '.'
		call WriteChar

	EnemyAttacksEND:
	ret
EnemyAttacks ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main