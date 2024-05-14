extends Node2D

@export var default = preload("res://levels/world/tilesets/building/house/object_0.png")
@export var hover = preload("res://levels/world/tilesets/building/house/object_1.png")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250

var object = preload("res://levels/world/ui//object_info.tscn")
var object_name:String = "Домик"
var object_description:String = "Очень уютный домик"
var object_level:int = 1

func _ready():
	$Sprite2D.texture = default

func _input(event):
	if get_node("/root/World/UI/Pause").paused or game_variables.mode != game_variables.gamemode.NOTHING:
		$Sprite2D.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, 0, false)

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !get_node("/root/World/UI/Pause").paused\
	and game_variables.mode == game_variables.gamemode.NOTHING\
	and distance < max_distance:
		$Sprite2D.texture = hover
		get_node("/root/World/UI/ObjectInfo").object(get_global_mouse_position(), object_name, object_description, object_level, 0, true)
func _on_area_2d_mouse_exited():
	if !get_node("/root/World/UI/Pause").paused:
		$Sprite2D.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
	else:
		$Sprite2D.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
