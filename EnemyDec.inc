;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
EnemyMain PROTO
EnemyPrint PROTO,
	nowEnemy:DWORD
EnemyMove PROTO,
	nowEnemy:DWORD
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
	y BYTE 3 									; the same with MapTop
	countnaturex BYTE 0
	blood BYTE 5
	picture BYTE "{\V/}",0 						; 敵機圖形
EnemyBody ENDS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;敵機宣告END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;