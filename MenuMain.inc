;;;;;;;;;;;;;;;;;;;;; Menu in main ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 把Menu 在Main中的函式，放到這裡來

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