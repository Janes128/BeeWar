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