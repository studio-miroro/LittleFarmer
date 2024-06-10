extends Node2D

var crops:Dictionary = {
	"atlas": load("res://assets/resources/farming/crops.png"),
	"width": 16,
	"height": 32,
	"checkWatering": 5,
	1: {
		"caption" = "Морковь",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 1,
		"growthLevel" = 4,
		"mortality" = 5, 
		"X" = 0, "Y" = 0,
	},
	2: {
		"caption" = "Картофель",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 30,
		"growthLevel" = 4, 
		"mortality" = 5, 
		"X" = 0, "Y" = 32,
	},
}
