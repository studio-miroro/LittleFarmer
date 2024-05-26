extends Node2D

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid") 

@export var default = preload("res://assets/resources/buildings/house/object_0.png")
@export var hover = preload("res://assets/resources/buildings/house/object_1.png")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250
var object_name:String = "Домик"
var object_description:String = "Очень уютный домик"
var object_level:int = 1

func _ready():
	$Sprite2D.texture = default

func _input(event):
	if pause.paused\
	and grid.mode != grid.gridmode.nothing:
		$Sprite2D.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, 0, false)

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused\
	and grid.mode == grid.gridmode.nothing\
	and distance < max_distance:
		$Sprite2D.texture = hover
		ui.tooltip(get_global_mouse_position(), object_name, object_description, object_level, 0, true)
		
func _on_area_2d_mouse_exited():
	if !pause.paused:
		$Sprite2D.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
	else:
		$Sprite2D.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
