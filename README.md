# BeeWar
it's a assembly language project for school final project. Write by asm x86.

主題：彈幕遊戲－宇宙蜜蜂大戰爭(temp.)
故事大綱：世界需要被拯救

遊戲主要架構與說明：
	說明：就殺光所有殘害蜜蜂的人類...
	1. 主戰蜂王
	2. 敵人*N (AI)
	3. 攻擊設定
	4. 超音波障礙
	5. 血條生命條、分數條
	6. bonus
基本功能：
	1. 主戰蜂王 (nature)
		-畫出主戰

		-左右移動
		    -左nature.x -1
		    -右nature.x +1
		    -space:呼叫攻擊設定
		-攻擊設定
			natureattackstruct struct{
				x
				y
				long
			}
			natureattacks natureattackstruct 100 DUP()
		    -射出物質的形狀、速度 (natureattacks.y +2、nature.x)
		    -攻擊強化
		       -隨機產生bonus增加射出物質的形狀、速度
		-"偵測"是否受到攻擊(還不知如何偵測 有點抽象)
		    -主戰閃爍
		    -扣血(當偵測到攻擊則  nature.blood -5  並呼叫顯示血條重新顯示)
		    -死亡
		-顯示血條 (nature.blood)
////////////////////////////////////////////////////////////////////////////////////////////
	2. 敵人
		-畫出敵人
			enemystruct struct{
				x
				blood
			}
			enemys enemystruct 4 DUP()
		-隨機移動
			[enemys].x+random
			[enemys+1].x+random
			...
		-攻擊設定
		    -射出物質的形狀、速度 
		-"偵測"是否受到攻擊(還不知如何偵測 有點抽象)
		    -閃爍
		    -死亡
		       -分數累加
		-顯示血條([enemys].blood)

		-更新敵人設定(以下設定最好他X的有空做出來)
			-更新敵人
			-BOSS出現 (進階)blood 扣血(當偵測到攻擊則  [enemys+?].blood -5  並呼叫顯示血條重新顯示)
////////////////////////////////////////////////////////////////////////////////////////////
	3. 開始(選單)與結束介面	(以下設定最好他X的有空做出來)
		-開始選單，人機互動介面
			-開始設定
			-說明設定
			-遊戲故事
			-離開介面
			-功能設定
				-難度設定
				-音樂設定
		-介紹說明

		-遊戲中選單(暫停)
////////////////////////////////////////////////////////////////////////////////////////////
	4. 遊戲整合師
		-統合

		-設計PPT
外掛功能：
	1. 音樂
	2. 難度調控
	3. 暫停畫面
