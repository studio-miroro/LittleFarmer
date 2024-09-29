extends Button

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/UI/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/GUI/Blur")
@onready var options:Control = get_node("/root/" + main_scene + "/UI/Windows/Options")
@onready var player:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")

func _on_pressed() -> void:
	if blur.state:
		if pause.paused:
			options.open()
			pause.visible = false
