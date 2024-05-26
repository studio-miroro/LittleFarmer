extends Node2D
#Культуры
var crops:Dictionary = {
	"Carrot": {
		object_name = "Морковь",
		object_type = "Vegetable",
		Season = "Spring",
		GrowthRate = 25,
		GrowthLevel = 4,
		ID = 1
	},
	2: {
		"Name": "Картофель",
		"Type": "Vegetable",
		"Season": "Spring",
		"GrowthRate": 30,
		"GrowthLevel": 4,
	},
	3: {
		"Name": "Редис",
		"Type": "Vegetable",
		"Season": "Summer",
		"GrowthRate": 40,
		"GrowthLevel": 4,
	},
	4: {
		"Name": "Капуста",
		"Type": "Vegetable",
		"Season": "Summer",
		"GrowthRate": 50,
		"GrowthLevel": 4,
	},
	5: {
		"Name": "Чеснок",
		"Type": "Vegetable",
		"Season": "Fall",
		"GrowthRate": 60,
		"GrowthLevel": 4,
	},
	6: {
		"Name": "Тюльпан",
		"Type": "Flower",
		"Season": "Fall",
		"GrowthRate": 70,
		"GrowthLevel": 4,
	},
}
