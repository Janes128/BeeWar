TITLE assembly language final project NatureWar
;----------------------------------------------------------
;assembly language, the 22nd
;title: NatureWar
;author: 蔡政育、高康捷、沈詮鈞、葉韋成
;update: 2017/06/01
;----------------------------------------------------------

INCLUDE Irvine32.inc
INCLUDE MainDec.inc
INCLUDE NatureDec.inc 		; the declaration of Nature
INCLUDE EnemyDec.inc 		; the declaration of Enemy
INCLUDE MenuDec.inc

main  EQU start@0 ;
Emy_num 	= 5
;++++++++++++++++++ data segment ++++++++++++++++++
.data

; Menu setting
Menucontrol Menustr <>
start byte "開始遊戲",0
button byte "操控說明",0
story byte "遊戲故事",0
set byte "遊戲設定",0
exitt byte "離開遊戲",0
arrowhead byte "->",0
clearup byte "   ",0


Nature 		NatureBody 			<>
na_bullet 	NatureAttackStruct 	<>										;子彈設定
Enemy 		EnemyBody 			Emy_num DUP(<20>,<34>,<60>,<114>,<50>) 	;對Enemy的位置做出始化，注意：一定要是二的倍數
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<>,<>,<>,<>,<>) 			; 設定敵機子彈(先每一台敵機一枚子彈)
EmyNum 		BYTE	Emy_num												; 敵機數量												;螢幕上印出的敵機 (包含死亡的)
randVal     DWORD   ?
mapSize 	COORD 				<120, 30> 								; 視窗畫面設定尺寸
outputHandle DWORD				0										; 設定輸出型態
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

;++++++++++++++++++ code segment ++++++++++++++++++
.code
main PROC

xor eax, eax 				; set register 0
xor ebx, ebx
xor ecx, ecx
xor edx, edx

push eax
INVOKE GetStdHandle, STD_OUTPUT_HANDLE      ;Get the console output handle
mov outputHandle, eax                       ;save console handle
pop eax

INVOKE SetConsoleScreenBufferSize, 			; 設定視窗邊界
	outputHandle,
	mapSize 								; 視窗邊界跟這個變數有關

cmp Menucontrol.start, 1 					; 若選單選擇"遊戲開始"，進入遊戲
jz RUNGAME

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;標題畫面;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Titleset:
    mov dl, Menucontrol.x
    mov dh, Menucontrol.y
    mov  eax, 12 + ( black*16 )
	call SetTextColor
	call Gotoxy
	mov edx, offset arrowhead
	call WriteString

	mov dh, 2
	mov dl, 10
	call Gotoxy
	mov  eax, 15 + ( black*16 )
	call SetTextColor
	mov edx, offset start
	call WriteString

	mov dh, 4
	mov dl, 10
	call Gotoxy
    mov edx, offset button
	call WriteString

	mov dh, 6
	mov dl, 10
	call Gotoxy
    mov edx, offset story
	call WriteString

	mov dh, 8
	mov dl, 10
	call Gotoxy
    mov edx, offset set
	call WriteString

	mov dh, 10
	mov dl, 10
	call Gotoxy
    mov edx, offset exitt
	call WriteString
	call Crlf
    mov Menucontrol.back, 0

GameTitle:

    invoke Menu
    cmp Menucontrol.back, 1
    jz Titleset
	jmp GameTitle

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;選單;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Menu proc

    invoke Menumove
    invoke Menuprint

    ret
Menu endp
Menuprint proc uses eax ebx ecx edx

    mov dl, 7
    mov dh, Menucontrol.y
    mov  eax, 12 + ( black*16 )
	call SetTextColor
	call Gotoxy
	mov edx, offset arrowhead
	call WriteString

    cmp Menucontrol.save, 0
    jz L1
    mov dl, 7
    mov dh, Menucontrol.save
    add dh, Menucontrol.y
    mov  eax, 12 + ( black*16 )
	call SetTextColor
	call Gotoxy
	mov edx, offset clearup
	mov Menucontrol.save, 0
	call WriteString
L1:
    ret
Menuprint endp

Menumove proc uses eax ebx ecx edx

    call readchar

	cmp  eax, 4800h				;上
	jz   UP
	cmp  eax, 5000h				;下
	jz   DOWN
	cmp  eax, 0E08h				;退格鍵
	jz	 SPACE
	jmp MenumoveEND

	SPACE:
        mov bl, Menucontrol.y

        cmp bl, 2
        jz startL
        cmp bl, 4
        jz buttonL
        cmp bl, 6
        jz storyL
        cmp bl, 8
        jz setLL
        invoke ExitProcess,0
    startL:
        invoke startproc
        mov Menucontrol.back, 1
        jmp ED
    buttonL:
        invoke buttonproc
        mov Menucontrol.back, 1
        jmp ED
    storyL:
        invoke storyproc
        mov Menucontrol.back, 1
        jmp ED
    setLL:
        invoke setproc
        mov Menucontrol.back, 1
        jmp ED

	UP:
        mov bl, Menucontrol.y
        cmp Menucontrol.y, 2
        jz MenumoveEND
        mov Menucontrol.ct, -2
        mov Menucontrol.save, 2
		jmp MenumoveEND

	DOWN:

        mov bl, Menucontrol.y
        cmp Menucontrol.y, 10
        jz MenumoveEND
        mov Menucontrol.ct, 2
        mov Menucontrol.save, -2
		jmp MenumoveEND


	MenumoveEND:
		add bl, Menucontrol.ct
		mov Menucontrol.y, bl
		mov Menucontrol.ct, 0
    ED:
	ret
Menumove ENDP
startproc proc uses eax ebx ecx edx
    call Clrscr

    call WaitMsg
    call Clrscr
    mov Menucontrol.start, 1
    invoke main
    ret
startproc endp

buttonproc proc uses eax ebx ecx edx
    call Clrscr

    call WaitMsg
    call Clrscr
    ret
buttonproc endp

storyproc proc uses eax ebx ecx edx
    call Clrscr

    call WaitMsg
    call Clrscr
    ret
storyproc endp

setproc proc uses eax ebx ecx edx
    call Clrscr

    call WaitMsg
    call Clrscr
    ret
setproc endp
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
	cmp  eax, 2C7Ah             ; 攻擊鍵Z
	jz   ATTACK

	jmp DontMove

	ATTACK:
        mov al, 1
        mov na_bullet.exist, al
        mov al, 0
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

NatureAttacks PROC USES esi edi eax ebx ecx edx
    mov edi, 0
    mov al, na_bullet.x
    .IF(al == 0)
        mov al, Nature.x
    .ENDIF
    mov dl, al

    mov ah, na_bullet.y
    .IF(ah == 25)
        mov ah, Nature.y
    .ENDIF
    mov dh, ah

    mov na_bullet.x, al
    dec dh
    mov na_bullet.y, dh

    cmp dh, MapTop
    jz ResetBullet
    call GotoXY
    jmp PrintBullet
    ResetBullet:
        mov dl, 0
        mov na_bullet.x, dl
        mov al, 0
        mov dh, 25
        mov na_bullet.y, dh
        mov ah, 0
        mov na_bullet.exist, ah
    PrintBullet:
        mov al, '^'
        call WriteChar

    NatureAttacksEND:
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
		push ecx
		push esi
		push edi
		push edx
		push ebx
		push eax
		INVOKE EnemyMove, esi
		pop eax
		pop ebx
		pop edx
		pop edi
		pop esi
		pop ecx

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
EnemyMove PROC USES edi eax ebx ecx edx esi,
	nowEnemy:DWORD

	mov edi,nowEnemy
	movzx ecx, EmyNum

	mov eax,4				;;隨機-1~1數字 (讓敵機移動)
	call RandomRange
	mov randVal,eax

	.IF (eax == 2)
	 mov randVal,-1
	.ENDIF
	.IF (eax == 3)
	 mov randVal,0
	.ENDIF

	movzx eax,((EnemyBody PTR Enemy[edi]).x)	;;讓敵機位置加上x
	add eax,randVal
	mov esi,0


	testrange:				;;測試如果加了變數的x是否會和其他敵機重疊
	push eax
	movzx ebx,((EnemyBody PTR Enemy[esi]).x)
	.IF (edi == esi)
	 jmp goahead
	.ENDIF
	;互減來判斷距離
	neg ebx
	add eax,ebx
	mov edx,5

	cmp eax,edx				;;比較距離是否在-5~5之間 如果是則不能移動 跳到cantmove
	JG  goahead
	neg edx
	cmp eax,edx
	JG  cantmove

	goahead:
	pop eax
	add esi, TYPE Enemy
	loop testrange			;;結束testrange測試



	.IF (eax <= 1)			;;先判斷是否有超出界線 如果沒有則可以設定敵機新位置
	 jmp cantmove
	.ENDIF
	.IF (eax >= 40)
	 jmp cantmove
	.ENDIF
	mov ((EnemyBody PTR Enemy[edi]).x),al

	cantmove:

	mov eax,10				;;設定敵機的y是否要往下移動  給定隨機變數0~9 如果等於2則敵機會往下移動
	call RandomRange
	mov randVal,eax
	mov randVal,0

	.IF (eax == 2)
	 mov randVal,1
	.ENDIF
	;;
	mov eax,0
	mov al,((EnemyBody PTR Enemy[edi]).y)
	add eax,randVal
	mov ((EnemyBody PTR Enemy[edi]).y),al

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