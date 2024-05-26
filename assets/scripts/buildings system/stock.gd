extends Node2D

@export var default = preload("res://assets/resources/buildings/stock/object_0.png")
@export var hover = preload("res://assets/resources/buildings/stock/object_1.png")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250

@onready var ui = get_node("/root/World/UI/Tooltip")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid")

var object_name:String = "Склад"
var description:String = "Используется для хранение чего-либо"
var level:int = 1
var total_slots:int = 25
var free_slots:int = 0

func _input(event):
	if pause.paused or grid.mode != grid.gridmode.nothing:
		$Stock.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)

func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused\
	and grid.mode == grid.gridmode.nothing\
	and distance < max_distance:
		$Stock.texture = hover
		ui.tooltip(get_global_mouse_position(), object_name, description, level, total_slots, true)
		
func _on_area_2d_mouse_exited():
	if !pause.paused:
		$Stock.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
	else:
		$Stock.texture = default
		ui.tooltip(Vector2(0,0), "", "", 0, -1, false)
