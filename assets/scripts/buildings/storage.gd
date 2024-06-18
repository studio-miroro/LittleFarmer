extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var player = get_node("/root/World/Player")
@onready var shadow = get_node("/root/World/Shadow/StorageShadow")
@onready var sprite = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object: Dictionary = {
	1: {
		"name" = "Старый склад",
		"description" = "Для хранение чего-либо.",
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-1/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-1/shadow.png"),
	},
	2: {
		"name" = "Склад",
		"description" = "Для хранение чего-либо.",
		"default" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_0.png"),
		"hover" = preload("res://Assets/Resources/Buildings/Storage/Level-2/object_1.png"),
		"shadow" = preload("res://Assets/Resources/Buildings/Storage/Level-2/shadow.png"),
	},
}

func _ready():
	if object.has(level):
		if object[level].has("default")\
		and object[level].has("shadow"):
			sprite.texture = object[level]["default"]
			shadow.texture = object[level]["shadow"]
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused:
		if grid.mode == grid.gridmode.NOTHING\
		and distance < max_distance:
			if object.has(level):
				if object[level].has("hover"):
					sprite.texture = object[level]["hover"]
					ui.tooltip(get_global_mouse_position(), object[level]["name"], object[level]["description"], level, 0, true)
				else:
					push_error("There is no key at index " + str(level) + ".")
			else:
				push_error("Index " + str(level) + " is not in the dictionary.")

func _on_area_2d_mouse_exited():
	if !pause.paused:
		if object.has(level):
			if object[level].has("default"):
				sprite.texture = object[level]["default"]
				ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
			else:
				push_error("There is no object at index " + str(level) + ".")
		else:
			push_error("Index " + str(level) + " is not in the dictionary.")
