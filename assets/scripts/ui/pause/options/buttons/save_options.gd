extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")

func _on_button_pressed():
	if main_scene != "MainMenu":
		var options:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Options")
		if options.menu:
			options.close()
			pause.visible = true
	else:
		var options:Control = get_node("/root/" + main_scene +"/Canvas/Options/Options")
		var blur:Control = get_node("/root/" + main_scene +"/Canvas/Options/Blur")
		var menu:Node2D = get_node("/root/" + main_scene)

		options.close()
		blur.blur(false)
		menu.clicked = false
