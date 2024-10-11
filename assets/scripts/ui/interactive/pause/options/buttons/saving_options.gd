extends Control

@onready var main = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")

func _on_button_pressed():
	if main != "MainMenu":
		var options:Control = get_node("/root/"+main+"/UI/Interactive/Options")
		if options.menu:
			options.close()
			pause.visible = true
	else:
		var options:Control = get_node("/root/"+main+"/Canvas/Options/Options")
		var blur:Control = get_node("/root/"+main+"/Canvas/Options/Blur")
		var menu:Node2D = get_node("/root/"+main)

		options.close()
		blur.blur(false)
		menu.clicked = false
