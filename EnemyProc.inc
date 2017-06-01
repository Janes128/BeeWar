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