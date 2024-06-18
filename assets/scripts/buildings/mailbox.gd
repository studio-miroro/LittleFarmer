extends Node2D

@onready var object_sprite:Sprite2D = $Sprite2D
@export var default = preload("res://assets/resources/buildings/mailbox/object_0.png")
@export var hover = preload("res://assets/resources/buildings/mailbox/object_1.png")
@onready var pause = get_node("/root/World/UI/Pause")
@onready var grid = get_node("/root/World/Buildings/Grid")
@onready var player = get_node("/root/World/Player")
var max_distance:int = 250

func _input(event):
	if pause.paused or grid.mode != grid.gridmode.NOTHING:
		object_sprite.texture = default
	
func _on_area_2d_mouse_entered():
	var distance = round(global_position.distance_to(player.global_position))
	if !pause.paused\
	and grid.mode == grid.gridmode.NOTHING\
	and distance < max_distance:
		object_sprite.texture = hover

func _on_area_2d_mouse_exited():
	if !pause.paused:
		object_sprite.texture = default
	else:
		object_sprite.texture = default
