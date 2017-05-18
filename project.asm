INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO
NatureHitted PROTO

NatureBody STRUCT 							; �D�Ծ������c
	naturelong BYTE 6
	x BYTE 20
	y BYTE 20
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "(^..^)",0 				; �p�G��chcp 65001���ܡA���ӥi�H�γo��(^�D^)
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
	;bulletlocation	EnemyAttackStruct <>		;������	(�ľ���X�����ɪ���m�BEnemyAttacks PROC����(EnemyBody PTR Enemy[edi]).y
	;���0518�A�N�ľ����������c�P�D�鵲�c���}	;�վ㦨(EnemyBody PTR Enemy[edi]).bulletlocation.y �]��EnemyBody.y����n�����ĤH������)
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
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<20>,<35>,<28>,<15>,<8>) 	; �]�w�ľ��l�u(���C�@�x�ľ��@�T�l�u)
EmyNum 		BYTE	Emy_num												;�ù��W�L�X���ľ� (�]�t���`��)

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
	INVOKE NatureBloodLine

	ret
Naturemain ENDP
;----------------------------NaturePrint

NaturePrint PROC USES eax edx


	mov dl, Nature.x
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

NatureBloodLine PROC USES ecx eax edx
	movzx ecx, Nature.blood
	mov dl, 50		; col
	mov dh, 0 		; row
	call Gotoxy
	bloodLoop:
		mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
		call SetTextColor
		mov al, 'a' 							; �L�X�R�ߧΪ�
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
	xor esi, esi 							; esi�����O�ľ����s���A�q0�}�l�s��
	xor edi, edi 							; edi�����O�ľ��l�u���s���A�q�s�}�l
	PrintEnemy:								;****�j�� �L�X�h�ӼĤH****
		INVOKE EnemyPrint , esi
		INVOKE EnemyMove

		INVOKE EnemyAttacks , edi 			; print�ľ����l�u
		
		add esi, TYPE Enemy
		add edi, TYPE Emy_bullet
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

EnemyAttacks PROC USES edi edx eax,
	nowEnemy:DWORD

	mov edi, nowEnemy
	mov dl, (EnemyAttackStruct PTR Emy_bullet[edi]).x 		; �]�w�l�ux�b����m�A�i�H�P�ľ�X�b���P�B���ʧ@(�ثe�S��)
	mov dh, (EnemyAttackStruct PTR Emy_bullet[edi]).y 		; original: (EnemyBody PTR Enemy[edi]).y
	inc dh
	mov (EnemyAttackStruct PTR Emy_bullet[edi]).y, dh
	
	; �o�̰��D�Ծ��Q���쪺�P�w
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