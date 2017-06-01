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

INCLUDE MenuMain.inc 						; �I�sMenu��code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;����C��(�j��);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;�禡;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCLUDE MenuProc.inc 						; �I�s���禡
INCLUDE NatureProc.inc 						; �I�s�D���禡
INCLUDE EnemyProc.inc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main