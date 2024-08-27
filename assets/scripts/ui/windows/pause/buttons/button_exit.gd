extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var gamedata = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")

@onready var path:String = "res://levels/main.tscn"

func _on_pressed() -> void:
	if pause.paused:
		blackout.blackout(true)
		if main_scene == "Farm":
			gamedata.gamesave()

		blackout.change_scene(path)
