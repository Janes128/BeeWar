INCLUDE Irvine32.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�D���ŧi;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	nowEnemynumber:DWORD
EnemyMove PROTO
EnemyAttacks PROTO,
	nowEnemynumber:DWORD

;������EnemyAttackStruct
EnemyAttackStruct STRUCT
	x BYTE ?
	y BYTE 0
	long BYTE 1
EnemyAttackStruct ENDS

EnemyBody STRUCT
	x BYTE 20
	y BYTE 0
	countnaturex BYTE 0
	bulletlocation	EnemyAttackStruct <>	;������	(�ľ���X�����ɪ���m�BEnemyAttacks PROC����(EnemyBody PTR Enemy[edi]).y
											;							   �վ㦨(EnemyBody PTR Enemy[edi]).bulletlocation.y �]��EnemyBody.y����n�����ĤH������)
	blood BYTE 5
	picture BYTE "V",0
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�ľ��ŧiEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main  EQU start@0 ;
.data
Nature NatureBody <>
Natureattack NatureAttackStruct <>					;������ (�D����X������t��)
Enemy EnemyBody 10 DUP(<20>,<35>,<28>,<17>,<11>) 	;��Enemy����m���X�l��
currentEnemyhavetoprint BYTE 5						;�ù��W�L�X���ľ� (�]�t���`��)
EnemyBodyhaveSTRUCTnumber DWORD 9

.code
main PROC

mov eax,0
mov ebx,0
mov ecx,0
mov edx,0
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
	;cmp  eax, 4800h			; �W
	;jz   UP
	;cmp  eax, 5000h			; �U
	;jz   DOWN
	cmp  eax, 0020h				; �ť���
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
		mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
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
	PrintEnemy:					;****�j�� �L�X�h�ӼĤH****
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
	loop PrintEnemy				;****�j�� �L�X�h�ӼĤH****
	ret
Enemymain ENDP
;----------------------------EnemyPrint
EnemyPrint PROC,
	nowEnemynumber:DWORD

	mov edi,nowEnemynumber	;���o�˰�������EnemyBody PTR Enemy[nowEnemynumber]�|�z��
	mov dl, (EnemyBody PTR Enemy[edi]).x
	mov dh, 0
	call Gotoxy
	mov  eax, 10 + ( black*16 )			;�]�w�e�����H���A�I�����¦�
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