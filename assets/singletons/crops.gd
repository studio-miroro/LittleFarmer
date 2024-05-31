extends Node2D

var crops:Dictionary = {
	"atlas": load("res://assets/resources/farming/stardew_valley.png"),
	"width": 16,
	"height": 32,
	1: {
		"caption" = "Морковь",
		"type" = "vegetable", 
		"season" = "spring",
		"growth_rate" = 20,
		"growth_level" = 4, 
		"rect_x" = 0,
		"rect_y" = 0,
	},
	2: {
		"caption" = "Картофель",
		"type" = "vegetable", 
		"season" = "spring",
		"growth_rate" = 20,
		"growth_level" = 4, 
		"rect_x" = 0,
		"rect_y" = 32,
	},
	#3: {
		#caption = "Редис",
		#"Type": "Vegetable",
		#"Season": "Summer",
		#"GrowthRate": 40,
		#"GrowthLevel": 4,
	#},
	#4: {
		#caption = "Капуста",
		#"Type": "Vegetable",
		#"Season": "Summer",
		#"GrowthRate": 50,
		#"GrowthLevel": 4,
	#},
	#5: {
		#caption = "Чеснок",
		#"Type": "Vegetable",
		#"Season": "Fall",
		#"GrowthRate": 60,
		#"GrowthLevel": 4,
	#},
	#6: {
		#caption = "Тюльпан",
		#"Type": "Flower",
		#"Season": "Fall",
		#"GrowthRate": 70,
		#"GrowthLevel": 4,
	#},
}
