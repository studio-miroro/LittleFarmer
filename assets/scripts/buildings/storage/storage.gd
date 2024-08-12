extends Node2D

class_name Storage
@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var tip:Control = get_node("/root/World/User Interface/System/Tooltip")
@onready var inventory:Control = get_node("/root/World/User Interface/Windows/Inventory")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid") 
@onready var player:CharacterBody2D = get_node("/root/World/Camera")
@onready var shadow:Sprite2D = get_node("/root/World/Shadow/StorageShadow")
@onready var sprite:Sprite2D = $Sprite2D

var menu:bool = false
var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" = "Старый склад",
		"description" = "Для хранения чего-либо.",
		"slots" = 12,
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-1/shadow.png"),
	},
	2: {
		"caption" = "Склад",
		"description" = "Для хранения чего-либо.",
		"slots" = 24,
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-2/shadow.png"),
	},
}

func _input(event):
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and menu:
		inventory.open()
		menu = false

func _ready():
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
			if object[level].has("shadow"):
				shadow.texture = object[level]["shadow"]
			else:
				push_error("The object shadow sprite is missing.")
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func change_sprite(type:bool):
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.gridmode.NOTHING and distance < max_distance:
			check_sprite("hover")
			tip.tooltip(
				str(object[level]["caption"]) + "\n" +
				str(object[level]["description"]) + "\n" +
				"Уровень: " + str(level)
				)
			menu = true
	else:
		check_sprite("default")
		tip.tooltip("")
		menu = false

func check_sprite(key:String):
	if object.has(level):
		if object[level].has(key):
			if typeof(object[level][key]) == TYPE_OBJECT and sprite.texture is CompressedTexture2D:
				sprite.texture = object[level][key]
			else:
				push_error("The specified sprite cannot be installed.")
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func get_data(key:String, inDictionary:bool):
	if inDictionary:
		if object.has(level):
			if object[level].has(key):
				return object[level].get(key)
			else:
				push_error("The " + str(key) + " key stores a type that is not an object.")
				return null
		else:
			push_error("Index " + str(level) + " is not in the dictionary.")
			return null

func _on_area_2d_mouse_entered():
	if !blur.bluring:
		change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)
