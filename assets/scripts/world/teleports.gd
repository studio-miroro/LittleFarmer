extends Node2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager = get_node("/root/" + main_scene)
@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")

var teleporting:bool

func _input(event) -> void:
	if event is InputEventMouseButton\
	&& event.button_index == MOUSE_BUTTON_LEFT\
	&& event.is_pressed()\
	&& teleporting\
	&& grid.mode == grid.modes.NOTHING:
		teleport()

func teleport() -> void:
	blackout.blackout(true)
	match main_scene:
		"Farm":
			var path:String = "res://levels/village.tscn"
			manager.gamesave()
			GameLoader.loading(false)
			blackout.change_scene(path)

		"Village":
			var path:String = "res://levels/farm.tscn"
			GameLoader.loading(true)
			manager.file_save(manager.paths.world, "nature")
			manager.file_save(manager.paths.player, "player")
			blackout.change_scene(path)

		_:
			manager.debug("Pizda")

func _on_area_2d_mouse_entered():
	teleporting = true

func _on_area_2d_mouse_exited():
	teleporting = false
