extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/GUI/Blur")
@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")

func _on_pressed() -> void:
	if blur.state:
		if pause.paused:
			pause.pause()
			player.check_switch()
