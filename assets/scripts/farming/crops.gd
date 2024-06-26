extends Node2D

class_name Crops
var crops:Dictionary = {
	"atlas": load("res://assets/resources/farming/crops.png"),
	"width": 16,
	"height": 32,
	"checkWatering": 5,
	1: {
		"caption" = "Морковь",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 25,
		"growthLevel" = 5,
		"mortality" = 5, 
		"X" = 0, "Y" = 0,
	},
	2: {
		"caption" = "Картофель",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 50,
		"growthLevel" = 6, 
		"mortality" = 5, 
		"X" = 0, "Y" = 32,
	},
	3: {
		"caption" = "Редис",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 35,
		"growthLevel" = 4, 
		"mortality" = 5, 
		"X" = 0, "Y" = 64,
	},
	4: {
		"caption" = "Капуста",
		"type" = "vegetable", 
		"season" = "spring",
		"growthRate" = 75,
		"growthLevel" = 4, 
		"mortality" = 5, 
		"X" = 0, "Y" = 96,
	},
}
