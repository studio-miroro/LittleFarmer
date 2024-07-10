extends Node2D

@onready var ui = get_node("/root/World/UI/HUD/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var player = get_node("/root/World/Player")
@onready var shadow = get_node("/root/World/Shadow/StorageShadow")
@onready var sprite = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object: Dictionary = {
	1: {
		"caption" = "Старый склад",
		"description" = "Для хранение чего-либо.",
		"slots" = 10,
		# Sprites
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-1/shadow.png"),
	},
	2: {
		"caption" = "Склад",
		"description" = "Для хранение чего-либо.",
		"slots" = 25,
		# Sprites
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-2/shadow.png"),
	},
}

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
			ui.tooltip(get_global_mouse_position(), object[level]["caption"], object[level]["description"], level, 0, true)
	else:
		check_sprite("default")
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
		
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
	else:
		match key:
			"level":
				return level
			_:
				return null
				push_error("The specified key (" + str(key) + ") does not exist.")

func _on_area_2d_mouse_entered():
	if !pause.paused:
		change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)
