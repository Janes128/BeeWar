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

INCLUDE MenuMain.inc 						; 呼叫Menu的code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;執行遊戲(迴圈);;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	call WaitMsg
	exit
main ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;函式;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCLUDE MenuProc.inc 						; 呼叫選單函式
INCLUDE NatureProc.inc 						; 呼叫主機函式
INCLUDE EnemyProc.inc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PROCEND;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END main