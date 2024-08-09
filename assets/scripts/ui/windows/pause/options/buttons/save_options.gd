extends Control

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")

func _on_button_pressed():
	if options.menu:
		options.close()
		pause.update_string_version()
		pause.visible = true
