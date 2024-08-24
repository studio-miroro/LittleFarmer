extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")

var path:String = "res://levels/village.tscn"
var teleporting:bool

func _input(event) -> void:
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed():
		teleport()

func teleport() -> void:
	blackout.blackout(true, 4, path)

func _on_area_2d_mouse_entered():
	teleporting = true

func _on_area_2d_mouse_exited():
	teleporting = false
