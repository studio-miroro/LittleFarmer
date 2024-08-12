extends Button

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var time:Control = get_node("/root/World/User Interface/Hud/Time")
@onready var blackout:Control = get_node("/root/World/User Interface/Blackout")
@onready var player:CharacterBody2D = get_node("/root/World/Camera")

func _on_pressed() -> void:
	if pause.paused:
		#time.timerstop(true)
		blackout.blackout(true)
		json.gamesave()
		await get_tree().create_timer(1.25).timeout
		get_tree().quit()
