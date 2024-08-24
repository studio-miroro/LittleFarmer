extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var options:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Options")

func _on_button_pressed():
	if options.menu:
		options.close()
		pause.update_string_version()
		pause.visible = true
