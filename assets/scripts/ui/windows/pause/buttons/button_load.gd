extends Button

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var player:CharacterBody2D = get_node("/root/World/Camera")
@onready var json = get_node("/root/World")

func _on_pressed() -> void:
	if pause.paused:
		json.gameload()
		pause.pausemenu()
