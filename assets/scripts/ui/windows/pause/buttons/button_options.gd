extends Button

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var options:Control = get_node("/root/World/User Interface/Windows/Options")
@onready var player:CharacterBody2D = get_node("/root/World/Camera")

func _on_pressed() -> void:
	if pause.paused:
		options.open()
		pause.visible = false
