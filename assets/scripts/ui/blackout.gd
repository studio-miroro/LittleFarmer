extends Control

@onready var anim:AnimationPlayer = $Animation

func _ready():
	z_index = 999

func blackout(speed:int) -> void:
	anim.play("Blackout")
	anim.speed_scale = speed

func blackout_reset(speed:int) -> void:
	anim.play("Blackout_reset")
	anim.speed_scale = speed

func key_parameter(key):
	if key == "gameload":
		return null
	else:
		get_tree().quit()
