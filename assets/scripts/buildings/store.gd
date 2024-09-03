extends Node

class_name StoreBuilding
var content: Dictionary = {
	1: {
		"caption" = "Деревянная дорожка",
		"description" = "Деревянные дорожки для сада добавляют уют и красоту вашему пространству.",
		"resource" = {
			"wood" = 1,
			},
		"time" = 1,
		# Config
		"icon" = null,#load("res://assets/resources/UI/building menu/sprite_0.png")
		"node" = null,#load(""),
	},
	2: {
		"caption" = "Компостер",
		"description" = "Простой и недорогой компостер для разложения органического материала.",
		"resource" = {
			"wood" = 25,
			},
		"time" = 15,
		"icon" = null,#load("res://assets/resources/UI/building menu/sprite_0.png"),
		"node" = null,#load(""),
	},
	3: {
		"caption" = "Бочка",
		"description" = "Ёмкость для сбора и хранения дождевой воды для полива растений, мытья автомобилей или других задач.",
		"resource" = {
			"wood" = 75,
			},
		"time" = 60,
		"icon" = null,#load("res://assets/resources/UI/building menu/sprite_0.png"),
		"node" = null,#load(""),
	},
	4: {
		"caption" = "Колодец",
		"description" = "Глубокая яма с каменной обшивкой, используемая для доступа к подземным источникам воды.",
		"resource" = {
			"wood" = 100,
			"stone" = 250,
			},
		"time" = 12,
		"icon" = null,#load("res://assets/resources/UI/building menu/sprite_0.png"),
		"node" = null,#load(""),
	},
}
