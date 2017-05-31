TITLE assembly language final project NatureWar
;----------------------------------------------------------
;assembly language, the 22nd
;title: NatureWar
;author: ���F�|�B���d���B�H��v�B������
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
start byte "�}�l�C��",0
button byte "�ޱ�����",0
story byte "�C���G��",0
set byte "�C���]�w",0
exitt byte "���}�C��",0
arrowhead byte "->",0
clearup byte "   ",0


Nature 		NatureBody 			<>
na_bullet 	NatureAttackStruct 	<>										;�l�u�]�w
Enemy 		EnemyBody 			Emy_num DUP(<20>,<34>,<60>,<114>,<50>) 	;��Enemy����m���X�l�ơA�`�N�G�@�w�n�O�G������
Emy_bullet	EnemyAttackStruct 	Emy_num DUP(<>,<>,<>,<>,<>) 			; �]�w�ľ��l�u(���C�@�x�ľ��@�T�l�u)
EmyNum 		BYTE	Emy_num												; �ľ��ƶq												;�ù��W�L�X���ľ� (�]�t���`��)
randVal     DWORD   ?
mapSize 	COORD 				<120, 30> 								; �����e���]�w�ؤo
outputHandle DWORD				0										; �]�w��X���A
;print data
GameOver 	BYTE	"Game Over!", 0
NatureLife	BYTE 	"Nature Life: ", 0
;

;�a�Ϭɽu�]�w-------
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

INVOKE SetConsoleScreenBufferSize, 			; �]�w�������
	outputHandle,
	mapSize 								; ������ɸ�o���ܼƦ���

cmp Menucontrol.start, 1 					; �Y�����"�C���}�l"�A�i�J�C��
jz RUNGAME

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;���D�e��;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RUNGAME:
	
	INVOKE MapMain
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;���;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

	cmp  eax, 4800h				;�W
	jz   UP
	cmp  eax, 5000h				;�U
	jz   DOWN
	cmp  eax, 0E08h				;�h����
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
	mov eax, 9 + ( black*16 )		;�]�w�e�����H����A�I�����¦�
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
	add dl, -2 							;���s�]�w�D����m�A������m�b'Y'������
	mov dh, Nature.y
	mov eax, color + ( black*16 )		;�]�w�e�����H����A�I�����¦�
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
	
	call ReadKey				; �����O�_����L��J���
	cmp  eax, 4B00h				; ��
	jz   LEFT
	cmp  eax, 4D00h				; �k
	jz   RIGHT
	cmp  eax, 0020h				; �ť���
	jz	 SPACE
	cmp  eax, 2C7Ah             ; ������Z
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
	cmp ecx, 0 								; �p�G�g����S���F�A�N���L�hgameoverL�L�X
	jle gameoverL

	mov  eax, 12 + ( black*16 )			;�]�w�e�����H����A�I�����¦�
	call SetTextColor
	mov edx, OFFSET NatureLife
	call WriteString
	jmp bloodLoop
	gameoverL: 								; �Y����S���F�A�N�L�XGameOver�a
		mov  eax, 13 + ( black*16 )			;�]�w�e�����H�v����A�I�����¦�
		call SetTextColor
		mov edx, OFFSET GameOver
		call WriteString
		jmp endOfBlood
	bloodLoop:
		mov al, 'a' 						; �L�X�R�ߧΪ�
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
	mov dh,((EnemyBody PTR Enemy[edi]).y) 	; row 
	call Gotoxy
	mov  eax, 10 + ( black*16 )				;�]�w�e�����H���A�I�����¦�
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

	mov eax,4				;;�H��-1~1�Ʀr (���ľ�����)
	call RandomRange
	mov randVal,eax

	.IF (eax == 2)
	 mov randVal,-1
	.ENDIF
	.IF (eax == 3)
	 mov randVal,0
	.ENDIF

	movzx eax,((EnemyBody PTR Enemy[edi]).x)	;;���ľ���m�[�Wx
	add eax,randVal
	mov esi,0


	testrange:				;;���զp�G�[�F�ܼƪ�x�O�_�|�M��L�ľ����|
	push eax
	movzx ebx,((EnemyBody PTR Enemy[esi]).x)
	.IF (edi == esi)
	 jmp goahead
	.ENDIF
	;����ӧP�_�Z��
	neg ebx
	add eax,ebx
	mov edx,5

	cmp eax,edx				;;����Z���O�_�b-5~5���� �p�G�O�h���ಾ�� ����cantmove
	JG  goahead
	neg edx
	cmp eax,edx
	JG  cantmove

	goahead:
	pop eax
	add esi, TYPE Enemy
	loop testrange			;;����testrange����



	.IF (eax <= 1)			;;���P�_�O�_���W�X�ɽu �p�G�S���h�i�H�]�w�ľ��s��m
	 jmp cantmove
	.ENDIF
	.IF (eax >= 40)
	 jmp cantmove
	.ENDIF
	mov ((EnemyBody PTR Enemy[edi]).x),al

	cantmove:

	mov eax,10				;;�]�w�ľ���y�O�_�n���U����  ���w�H���ܼ�0~9 �p�G����2�h�ľ��|���U����
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
		mov ecx, 14
		mov Nature.color, ecx
	.ENDIF

	; �l�u�쩳���P�w�A�N�n�A���s���@��
	cmp dh, MapButtom
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