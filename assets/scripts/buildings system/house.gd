extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var player = get_node("/root/World/Player")
@onready var fume = get_node("/root/World/Buildings/House/Fume")
@onready var sprite = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object: Dictionary = {
	1: {
		"name" = "Дом",
		"description" = "Простой домик.",
		"default" = preload("res://assets/resources/buildings/house/level_1/object_0.png"),
		"hover" = preload("res://assets/resources/buildings/house/level_1/object_1.png"),
		"fume" = false,
	},
	2: {
		"name" = "Дом",
		"description" = "Улучшенный деревянный домик.",
		"default" = preload("res://assets/resources/buildings/house/level_2/object_0.png"),
		"hover" = preload("res://assets/resources/buildings/house/level_2/object_1.png"),
		"fume" = true,
	}
}

func _ready():
	if !object[level].get("fume"):
		fume.emitting = false
		fume.visible = false
	else:
		fume.emitting = true
		fume.visible = true
		
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused:
		if grid.mode == grid.gridmode.nothing\
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
