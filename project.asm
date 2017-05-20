INCLUDE Irvine32.inc

; 地圖結構
Map STRUCT
	top		BYTE	0
	left	BYTE 	0
	right 	BYTE 	60
	buttom 	BYTE 	20
Map ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO,
	nowBlood: DWORD
NatureHitted PROTO

NatureBody STRUCT 							; 主戰機的結構
	naturelong BYTE 6
	x BYTE 20
	y BYTE 20
	countnaturex BYTE 0
	blood DWORD 5
	picture BYTE "(^Y^)",0 				; 如果用chcp 65001的話，應該可以用這個(^￥^)
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
	nowEnemy:DWORD
EnemyMove PROTO
EnemyAttacks PROTO,
	nowEnemy:DWORD

EnemyAttackStruct STRUCT
	x 		BYTE ?
	y 		BYTE 0
	long 	BYTE 1
	pic		BYTE "v", 0
EnemyAttackStruct ENDS

EnemyBody STRUCT
	x BYTE ?
	y BYTE 0
	countnaturex BYTE 0
	;bulletlocation	EnemyAttackStruct <>		;韋成改	(敵機放出攻擊時的位置、EnemyAttacks PROC中的(EnemyBody PTR Enemy[edi]).y
	;更動0518，將敵機的攻擊結構與主體結構分開	;調整成(EnemyBody PTR Enemy[edi]).bulletlocation.y 因為EnemyBody.y之後要做成敵人的移動)
	blood BYTE 5
	picture BYTE "{\V/}",0 						; 敵機圖形
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
Emy_num 	= 5
.data

Nature 		NatureBody 			<>
na_bullet 	NatureAttackStruct 	<>										;子彈設定
Enemy 		EnemyBody 			Emy_num DUP(<20>,<35>,<28>,<15>,<8>) 	;對Enemy的位置做出始化
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<20>,<35>,<28>,<15>,<8>) 	; 設定敵機子彈(先每一台敵機一枚子彈)
EmyNum 		BYTE	Emy_num												;螢幕上印出的敵機 (包含死亡的)

.code
main PROC

xor eax, eax 				; set register 0
xor ebx, ebx
xor ecx, ecx
xor edx, edx
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
	INVOKE NatureBloodLine, Nature.blood

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx
	mov dl, Nature.x
	add dl, -2 							;重新設定主機位置，中間位置在'Y'的部分
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
	cmp  eax, 0020h				; 空白鍵
	jz	 SPACE

	jmp DontMove

	SPACE:
		INVOKE NatureAttacks
		jmp NatureMoveEDN
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

NatureBloodLine PROC USES ecx eax edx,
	nowBlood: DWORD
	mov ecx, nowBlood
	mov Nature.blood, ecx
	mov dl, 50		; col
	mov dh, 0 		; row
	call Gotoxy
	bloodLoop:
		mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
		call SetTextColor
		mov al, 'a' 							; 印出愛心形狀
		call WriteChar
		inc dh
		loop bloodLoop
	ret
NatureBloodLine ENDP

;----------------------------NatureHitted

NatureHitted PROC 

NatureHitted ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;EnemyPROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Enemymain
Enemymain PROC USES ecx esi edi
	movzx ecx, EmyNum
	xor esi, esi 							; esi指的是敵機的編號，從0開始編號
	xor edi, edi 							; edi指的是敵機子彈的編號，從零開始
	PrintEnemy:								;****迴圈 印出多個敵人****
		INVOKE EnemyPrint , esi
		INVOKE EnemyMove

		INVOKE EnemyAttacks , edi 			; print敵機的子彈
		
		add esi, TYPE Enemy
		add edi, TYPE Emy_bullet
	loop PrintEnemy							;****迴圈 印出多個敵人****
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC USES edi edx eax,
	nowEnemy:DWORD

	mov edi, nowEnemy						;不這樣做直接放EnemyBody PTR Enemy[nowEnemynumber]會爆掉
	mov dl,((EnemyBody PTR Enemy[edi]).x) 	; 敵機的位置(編號edi的敵機)
	add dl, -2								; -2 為了調整圖片到圖片的中央
	mov dh, 0 								; row 
	call Gotoxy
	mov  eax, 10 + ( black*16 )				;設定前景為淡綠色，背景為黑色
	call SetTextColor
	mov edx, OFFSET Enemy.picture
	call WriteString

	ret
EnemyPrint ENDP

;----------------------------EnemyMove
EnemyMove PROC 

	ret
EnemyMove ENDP

;----------------------------EnemyAttack

EnemyAttacks PROC USES edi edx eax ecx,
	nowEnemy:DWORD

	mov edi, nowEnemy
	mov dl, (EnemyAttackStruct PTR Emy_bullet[edi]).x 		; 設定子彈x軸的位置，可以與敵機X軸做同步的動作(目前沒有)
	mov dh, (EnemyAttackStruct PTR Emy_bullet[edi]).y 		; original: (EnemyBody PTR Enemy[edi]).y
	inc dh
	mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh
	
	; 這裡做主戰機被打到的判定
	.IF (dl == Nature.x) && (dh == Nature.y)
		mov ecx, Nature.blood 
		dec ecx
		INVOKE NatureBloodLine, ecx
	.ENDIF
	; 子彈到底的判定，就要再重新打一次
	cmp dh, 20
	jz resetY
	call Gotoxy
	jmp finalPrint
	resetY:
		mov dh, 0
		mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh
		jmp EnemyAttacksEND
	finalPrint:
		mov al, 'v'
		call WriteChar

	EnemyAttacksEND:
	ret
EnemyAttacks ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main