extends Node2D

@onready var tip:Control = get_node("/root/World/UI/HUD/Tooltip")
@onready var pause:Control = get_node("/root/World/UI/Pause")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid") 
@onready var player:CharacterBody2D = get_node("/root/World/MainCamera")
@onready var sprite:Sprite2D = $Sprite2D

var max_distance:int = 250
var level:int = 1
var object:Dictionary = {
	1: {
		"caption" 		= "Силосная башня",
		"description" 	= "Хранилище для зерна.",
		"default" 		= load("res://assets/resources/buildings/silo/level-1/object_0.png"),
		"hover" 		= load("res://assets/resources/buildings/silo/level-1/object_1.png"),
		"fume" 			= false,
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
	else:
		check_sprite("default")
		tip.tooltip("")

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

func _on_collision_mouse_entered():
	if !pause.paused:
		change_sprite(true)

func _on_collision_mouse_exited():
	change_sprite(false)
