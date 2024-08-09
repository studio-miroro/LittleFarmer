extends Button

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var player:CharacterBody2D = get_node("/root/World/Camera")

func _on_pressed() -> void:
	if pause.paused:
		pause.pause()
		player.check_switch()
