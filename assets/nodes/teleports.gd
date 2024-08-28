extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var manager = get_node("/root/" + main_scene)
@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")

var teleporting:bool

func _input(event) -> void:
	if event is InputEventMouseButton\
	and event.button_index == MOUSE_BUTTON_LEFT\
	and event.is_pressed()\
	and teleporting:
		teleport()

func teleport() -> void:
	blackout.blackout(true)
	
	if main_scene == "Farm":
		var path:String = "res://levels/village.tscn"
		manager.gamesave()
		GameLoader.loading(false)
		blackout.change_scene(path)

	if main_scene == "Village":
		var path:String = "res://levels/farm.tscn"
		GameLoader.loading(true)
		blackout.change_scene(path)

func _on_area_2d_mouse_entered():
	teleporting = true

func _on_area_2d_mouse_exited():
	teleporting = false
