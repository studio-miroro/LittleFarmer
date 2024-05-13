extends Node2D

@export var default = preload("res://levels/world/tilesets/building/stock/object_0.png")
@export var hover = preload("res://levels/world/tilesets/building/stock/object_1.png")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250

var object = preload("res://levels/world/ui/object info/object_info.tscn")
var object_name:String = "Склад"
var description:String = "Используется для хранение чего-либо"
var level:int = 1
var total_slots:int = 25
var free_slots:int = 0

func _input(event):
	if get_node("/root/World/UI/Pause").paused or game_variables.mode != game_variables.gamemode.NOTHING:
		$Stock.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !get_node("/root/World/UI/Pause").paused\
	and game_variables.mode == game_variables.gamemode.NOTHING\
	and distance < max_distance:
		$Stock.texture = hover
		get_node("/root/World/UI/ObjectInfo").object(get_global_mouse_position(), object_name, description, level, total_slots, true)
		
func _on_area_2d_mouse_exited():
	if !get_node("/root/World/UI/Pause").paused:
		$Stock.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
	else:
		$Stock.texture = default
		get_node("/root/World/UI/ObjectInfo").object(Vector2(0,0), "", "", 0, -1, false)
