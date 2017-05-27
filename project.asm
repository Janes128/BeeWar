INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MapMain PROTO

NatureMain PROTO
NaturePrint PROTO,
	color: DWORD
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO,
	nowBlood: DWORD
NatureHitted PROTO

NatureBody STRUCT 						; 主戰機的結構
	naturelong 		BYTE 	6
	x 				BYTE 	50
	y 				BYTE 	25 			; the same with MapButtom
	countnaturex 	BYTE 	0
	blood 			DWORD 	5
	picture 		BYTE 	"(^Y^)",0 	; 如果用chcp 65001的話，應該可以用這個(^￥^)
	color			DWORD 	12
NatureBody ENDS

;NatureAttackStruct
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
	y BYTE 3 									; the same with MapTop
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "{\V/}",0 						; 敵機圖形
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
Emy_num 	= 5
.data

Nature 		NatureBody 			<>
na_bullet 	NatureAttackStruct 	<>										;子彈設定
Enemy 		EnemyBody 			Emy_num DUP(<20>,<34>,<60>,<114>,<50>) 	;對Enemy的位置做出始化，注意：一定要是二的倍數
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<>,<>,<>,<>,<>) 			; 設定敵機子彈(先每一台敵機一枚子彈)
EmyNum 		BYTE	Emy_num												;螢幕上印出的敵機 (包含死亡的)
;print data
GameOver 	BYTE	"Game Over!", 0
NatureLife	BYTE 	"Nature Life: ", 0
;

;地圖界線設定-------
MapTop		BYTE	2
MapRight	BYTE 	114
MapLeft		BYTE 	2
MapButtom	BYTE	25
;Max right : 114
;Max left : 2
;Max top : 2
;Max buttom : 25
;-------------------


.code
main PROC

xor eax, eax 				; set register 0
xor ebx, ebx
xor ecx, ecx
xor edx, edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:
	
	INVOKE MapMain
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Set Map;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MapMain PROC USES ecx edx eax
	mov eax, 9 + ( black*16 )		;設定前景為淡紅色，背景為黑色
	call SetTextColor
	mov eax, '='
	mov ecx, 118
	mov dl, 0
	mov dh, MapTop
	call Gotoxy

printTopMap:
	call WriteChar
	inc dl
	call Gotoxy
	loop printTopMap
	ret
MapMain ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;NaturePROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;----------------------------Naturemain

Naturemain PROC
	INVOKE NaturePrint, Nature.color
	INVOKE NatureMove
	INVOKE NatureBloodLine, Nature.blood

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx,
	color: DWORD
	mov dl, Nature.x
	add dl, -2 							;重新設定主機位置，中間位置在'Y'的部分
	mov dh, Nature.y
	mov eax, color + ( black*16 )		;設定前景為淡紅色，背景為黑色
	call SetTextColor
	;
	call Gotoxy
	mov edx, OFFSET Nature.picture
	call WriteString
	mov edx, 12
	mov Nature.color, edx

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
	mov dl, 100		; col
	mov dh, 0 		; row
	call Gotoxy
	cmp ecx, 0 								; 如果寫血條沒有了，就跳過去gameoverL印出
	jle gameoverL

	mov  eax, 12 + ( black*16 )			;設定前景為淡紅色，背景為黑色
	call SetTextColor
	mov edx, OFFSET NatureLife
	call WriteString
	jmp bloodLoop
	gameoverL: 								; 若血條沒有了，就印出GameOver吧
		mov  eax, 13 + ( black*16 )			;設定前景為淡洋紅色，背景為黑色
		call SetTextColor
		mov edx, OFFSET GameOver
		call WriteString
		jmp endOfBlood
	bloodLoop:
		mov al, 'a' 						; 印出愛心形狀
		call WriteChar
		inc dh
		loop bloodLoop
	endOfBlood:
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
		add edi, TYPE Enemy
	loop PrintEnemy							;****迴圈 印出多個敵人****
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC USES edi edx eax,
	nowEnemy:DWORD

	mov edi, nowEnemy						;不這樣做直接放EnemyBody PTR Enemy[nowEnemynumber]會爆掉
	mov dl,((EnemyBody PTR Enemy[edi]).x) 	; 敵機的位置(編號edi的敵機)
	add dl, -2								; -2 為了調整圖片到圖片的中央
	mov dh,((EnemyBody PTR Enemy[edi]).y) 	; row 
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

EnemyAttacks PROC USES edi eax ebx ecx edx,
	nowEnemy:DWORD

	mov edi, nowEnemy

	mov al, (EnemyAttackStruct PTR Emy_bullet[edi]).x       ; 設定子彈x軸的位置，可以與敵機X軸做同步的動作(完成)
	.IF (al == 0)
        mov al, (EnemyBody PTR Enemy[edi]).x
    .ENDIF
	mov dl, al

	;mov dh, (EnemyAttackStruct PTR Emy_bullet[edi]).y 		; 設定子彈y軸位置，可以與敵機y軸做同步(完成)
	mov ah, (EnemyAttackStruct PTR Emy_bullet[edi]).y
	.IF(ah == 0)
        mov ah, (EnemyBody PTR Enemy[edi]).y
    .ENDIF
    mov dh, ah
	inc dh
	mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh

	; 這裡做主戰機被打到的判定
	.IF (dl == Nature.x) && (dh == Nature.y)
		mov ecx, Nature.blood
		dec ecx
		INVOKE NatureBloodLine, ecx
		mov ecx, 14
		mov Nature.color, ecx
	.ENDIF

	; 子彈到底的判定，就要再重新打一次
	cmp dh, MapButtom
	jz resetXY
	call Gotoxy
	jmp finalPrint
	resetXY:
        mov dl, 0                                                  ;子彈x座標歸零
        mov (EnemyAttackStruct PTR Emy_bullet[edi]).x, dl
        mov al, 0
		mov dh, 0                                                  ;子彈y座標歸零
		mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh
		mov ah, 0
		jmp EnemyAttacksEND
	finalPrint:
		mov al, 'v'
		call WriteChar

	EnemyAttacksEND:
	ret
EnemyAttacks ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main