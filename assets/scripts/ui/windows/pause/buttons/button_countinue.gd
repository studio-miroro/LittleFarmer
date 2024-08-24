extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")

func _on_pressed() -> void:
	if pause.paused:
		pause.pause()
		player.check_switch()
