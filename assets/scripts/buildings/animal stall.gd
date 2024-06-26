extends Node2D

@onready var ui = get_node("/root/World/UI/HUD/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 
@onready var player = get_node("/root/World/Player")
@onready var sprite = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" = "Хлев",
		"description" = "Помещение для скота.",
		"default" = preload("res://assets/resources/buildings/animal stall/object_0.png"),
		"hover" = preload("res://assets/resources/buildings/animal stall/object_1.png"),
	},
}

func _ready():
	if object.has(level):
		if object[level].has("default"):
			sprite.texture = object[level]["default"]
		else:
			push_error("There is no key at index " + str(level) + ".")
	else:
		push_error("Index " + str(level) + " is not in the dictionary.")

func change_sprite(type:bool) -> void:
	if type:
		var distance = round(global_position.distance_to(player.global_position))
		if grid.mode == grid.gridmode.NOTHING\
		and distance < max_distance:
			if object.has(level):
				if object[level].has("hover"):
					sprite.texture = object[level]["hover"]
					ui.tooltip(get_global_mouse_position(), object[level]["caption"], object[level]["description"], level, 0, true)
				else:
					push_error("There is no key at index " + str(level) + ".")
			else:
				push_error("Index " + str(level) + " is not in the dictionary.")
	else:
		if object.has(level):
			if object[level].has("default"):
				sprite.texture = object[level]["default"]
				ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
			else:
				push_error("There is no object at index " + str(level) + ".")
		else:
			push_error("Index " + str(level) + " is not in the dictionary.")

func _on_area_2d_mouse_entered():
	if !pause.paused:
		change_sprite(true)

func _on_area_2d_mouse_exited():
	change_sprite(false)

