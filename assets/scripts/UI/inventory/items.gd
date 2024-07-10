extends Node

class_name InventoryItems
var content:Dictionary = {
	"max_items": 999,
	1: {
		"caption": "Доски",
		"description": "Прочные деревянные плиты для строительства и ремонта. Подходят для стен, крыш и мебели.",
		"type": "Стройматериалы",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_1.png"),
	},
	2: {
		"caption": "Камень",
		"description": "Твердый материал для прочных сооружений. Используется для фундаментов, стен и мостов.",
		"type": "Стройматериалы",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_1.png"),
	},
	3: {
		"caption": "Семена моркови",
		"description": "Маленькие семена для выращивания моркови. Посадите их на плодородной земле, поливайте и ждите урожая.",
		"bonus": {
			"growth": "3 игровых дня",
			"productivity": "5-10 морковок",
			"conditions": "Регулярный полив и солнечный свет",
		},
		"type": "Семена",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_1.png"),
	},
	4: {
		"caption": "Семена картофеля",
		"description": "Эти семена помогут вырастить питательный картофель. Посадите их в землю, поливайте и наблюдайте за ростом.",
		"bonus": {
			"growth": "5 игровых дней",
			"productivity": "3-6 картофелин",
			"conditions": "Хороший дренаж и регулярный полив",
		},
		"type": "Семена",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_2.png"),
	},
	5: {
		"caption": "Семена редиса",
		"description": "Маленькие семена для быстрого выращивания хрустящего редиса. Посадите их, поливайте и ждите урожая.",
		"bonus": {
			"growth": "2 игровых дня",
			"productivity": "8-12 редисок",
			"conditions": "Регулярный полив и солнечный свет",
		},
		"type": "Семена",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_2.png"),
	},
	6: {
		"caption": "Семена капусты",
		"description": "Семена для выращивания плотной и сочной капусты. Посадите их в землю, поливайте и ждите зрелости.",
		"bonus": {
			"growth": "7 игровых дней",
			"productivity": "1-2 кочана",
			"conditions": "Регулярный полив и богатая почва",
		},
		"type": "Семена",
		"purchase": 1,
		"sale": 0,
		"icon": null#load("res://assets/resources/UI/inventory/items/seeds packets/packet_2.png"),
	},
}
