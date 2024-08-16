extends Button

@onready var gamedata = get_node("/root/World")
@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var blackout:Control = get_node("/root/World/User Interface/Blackout")

@onready var path:String = "res://levels/main.tscn"

func _on_pressed() -> void:
	if pause.paused:
		blackout.blackout(true)
		await get_tree().create_timer(1.25).timeout
		gamedata.gamesave()
		get_tree().change_scene_to_file(path)
		
