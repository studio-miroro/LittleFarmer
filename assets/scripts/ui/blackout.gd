extends Control

@onready var anim:AnimationPlayer = $Animation

func _ready():
	z_index = 999

func blackout(state:bool, speed:int = 4):
	match state:
		true:
			anim.play("Blackout")
			anim.speed_scale = speed
		false:
			anim.play("Blackout_reset")
			anim.speed_scale = speed
