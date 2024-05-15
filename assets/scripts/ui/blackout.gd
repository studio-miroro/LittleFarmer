extends Control

func _ready():
	$".".z_index = 999

func blackout(speed:int):
	$Animation.play("Blackout")
	$Animation.speed_scale = speed

func blackout_reset(speed:int):
	$Animation.play("Blackout_reset")
	$Animation.speed_scale = speed

func key_parameter(key):
	if key == "gameload":
		return null
	else:
		get_tree().quit()
