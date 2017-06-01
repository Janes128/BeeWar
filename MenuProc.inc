;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;選單;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Menu Proc;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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