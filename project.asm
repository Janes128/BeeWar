INCLUDE Irvine32.inc

; �a�ϵ��c
Map STRUCT
	top		BYTE	0
	left	BYTE 	0
	right 	BYTE 	60
	buttom 	BYTE 	20
Map ENDS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO,
	nowBlood: DWORD
NatureHitted PROTO

NatureBody STRUCT 							; �D�Ծ������c
	naturelong BYTE 6
	x BYTE 20
	y BYTE 20
	countnaturex BYTE 0
	blood DWORD 5
	picture BYTE "(^Y^)",0 				; �p�G��chcp 65001���ܡA���ӥi�H�γo��(^�D^)
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
	blood BYTE 5
	picture BYTE "{\V/}",0 						; �ľ��ϧ�
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�ľ��ŧiEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
Emy_num 	= 5
.data

Nature 		NatureBody 			<>
na_bullet 	NatureAttackStruct 	<>										;�l�u�]�w
Enemy 		EnemyBody 			Emy_num DUP(<20>,<35>,<28>,<15>,<8>) 	;��Enemy����m���X�l��
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<>,<>,<>,<>,<>) 	; �]�w�ľ��l�u(���C�@�x�ľ��@�T�l�u)
EmyNum 		BYTE	Emy_num												;�ù��W�L�X���ľ� (�]�t���`��)
GameOver 	BYTE	"Game Over!", 0

.code
main PROC

xor eax, eax 				; set register 0
xor ebx, ebx
xor ecx, ecx
xor edx, edx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:

	INVOKE EnemyMain;
	INVOKE NatureMain;
				
	push eax				;�ɶ��Ȱ��N
	mov eax,100
	call Delay
	pop eax

	call clrscr				;�M�ſù�

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
	INVOKE NatureBloodLine, Nature.blood

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx
	mov dl, Nature.x
	add dl, -2 							;���s�]�w�D����m�A������m�b'Y'������
	mov dh, Nature.y
	mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
	call SetTextColor
	;
	call Gotoxy
	mov edx, OFFSET Nature.picture
	call WriteString

	ret
NaturePrint ENDP
;----------------------------NatureMove

NatureMove PROC USES eax ebx
	
	call ReadKey				; �����O�_����L��J���
	cmp  eax, 4B00h				; ��
	jz   LEFT
	cmp  eax, 4D00h				; �k
	jz   RIGHT
	cmp  eax, 0020h				; �ť���
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
	;cmp ecx, 0
	;jz gameoverL
	mov dl, 50		; col
	mov dh, 0 		; row
	call Gotoxy
	;jmp bloodLoop
	;gameoverL: 								; �Y����S���F�A�N�L�XGameOver�a
	;	mov  eax, 10 + ( black*16 )			;�]�w�e�����H���A�I�����¦�
	;	call SetTextColor
	;	movzx edx, GameOver
	;	call WriteString
	;	jmp endOfBlood
	bloodLoop:
		mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
		call SetTextColor
		mov al, 'a' 							; �L�X�R�ߧΪ�
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
	xor esi, esi 							; esi�����O�ľ����s���A�q0�}�l�s��
	xor edi, edi 							; edi�����O�ľ��l�u���s���A�q�s�}�l
	PrintEnemy:								;****�j�� �L�X�h�ӼĤH****
		INVOKE EnemyPrint , esi
		INVOKE EnemyMove

		INVOKE EnemyAttacks , edi 			; print�ľ����l�u
		
		add esi, TYPE Enemy
		add edi, TYPE Enemy
	loop PrintEnemy							;****�j�� �L�X�h�ӼĤH****
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC USES edi edx eax,
	nowEnemy:DWORD

	mov edi, nowEnemy						;���o�˰�������EnemyBody PTR Enemy[nowEnemynumber]�|�z��
	mov dl,((EnemyBody PTR Enemy[edi]).x) 	; �ľ�����m(�s��edi���ľ�)
	add dl, -2								; -2 ���F�վ�Ϥ���Ϥ�������
	mov dh, 0 								; row 
	call Gotoxy
	mov  eax, 10 + ( black*16 )				;�]�w�e�����H���A�I�����¦�
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

	mov al, (EnemyAttackStruct PTR Emy_bullet[edi]).x       ; �]�w�l�ux�b����m�A�i�H�P�ľ�X�b���P�B���ʧ@(����)
	.IF (al == 0)
        mov al, (EnemyBody PTR Enemy[edi]).x
    .ENDIF
	mov dl, al

	;mov dh, (EnemyAttackStruct PTR Emy_bullet[edi]).y 		; �]�w�l�uy�b��m�A�i�H�P�ľ�y�b���P�B(����)
	mov ah, (EnemyAttackStruct PTR Emy_bullet[edi]).y
	.IF(ah == 0)
        mov ah, (EnemyBody PTR Enemy[edi]).y
    .ENDIF
    mov dh, ah
	inc dh
	mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh

	; �o�̰��D�Ծ��Q���쪺�P�w
	.IF (dl == Nature.x) && (dh == Nature.y)
		mov ecx, Nature.blood
		dec ecx
		INVOKE NatureBloodLine, ecx
	.ENDIF
	; �l�u�쩳���P�w�A�N�n�A���s���@��
	cmp dh, 20
	jz resetXY
	call Gotoxy
	jmp finalPrint
	resetXY:
        mov dl, 0                                                  ;�l�ux�y���k�s
        mov (EnemyAttackStruct PTR Emy_bullet[edi]).x, dl
        mov al, 0
		mov dh, 0                                                  ;�l�uy�y���k�s
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