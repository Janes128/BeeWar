;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NatureMain PROTO
NaturePrint PROTO,
	color: DWORD
NatureMove PROTO
NatureAttacks PROTO
NatureBloodLine PROTO,
	nowBlood: DWORD
NatureHitted PROTO

NatureBody STRUCT 						; 主戰機的結構
	naturelong 		BYTE 	6
	x 				BYTE 	50
	y 				BYTE 	25 			; the same with MapButtom
	countnaturex 	BYTE 	0
	blood 			DWORD 	5
	picture 		BYTE 	"(^Y^)",0 	; 如果用chcp 65001的話，應該可以用這個(^¥^)
	color			DWORD 	12
NatureBody ENDS

;NatureAttackStruct
NatureAttackStruct STRUCT
	x BYTE ?
	y BYTE ?
	long BYTE 1
	exist BYTE 0
NatureAttackStruct ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;主機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;