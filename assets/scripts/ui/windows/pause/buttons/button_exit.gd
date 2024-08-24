extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var gamedata = get_node("/root/" + main_scene)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blackout:Control = get_node("/root/" + main_scene + "/User Interface/Blackout")

@onready var path:String = "res://levels/main.tscn"

func _on_pressed() -> void:
	if pause.paused:
		blackout.blackout(true)
		await get_tree().create_timer(1.25).timeout
		get_tree().change_scene_to_file(path)
		if main_scene == "Farm":
			gamedata.gamesave()
		
