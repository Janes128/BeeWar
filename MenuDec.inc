;;;;;;;;;;;;;;;;;;;;;;; Menu Declaration ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;選單畫面
Menu proto
Menumove proto
Menuprint proto
startproc proto
buttonproc proto
storyproc proto
setproc proto

Menustr STRUCT
	x BYTE 7
	y BYTE 2
	ct byte 0
	save byte 0
	back byte 0
	start byte 0
Menustr ENDS