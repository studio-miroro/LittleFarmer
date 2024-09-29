extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var manager = get_node("/root/" + main_scene)
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/GUI/Blur")
@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var blackout:Control = get_node("/root/" + main_scene + "/UI/GUI/Blackout")

@onready var path:String = "res://levels/main.tscn"

func _on_pressed() -> void:
	if blur.state:
		if pause.paused:
			blackout.blackout(true)
			if main_scene == "Farm":
				manager.gamesave()

			blackout.change_scene(path)
