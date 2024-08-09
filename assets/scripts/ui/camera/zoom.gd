extends Camera2D

@onready var pause = get_node("/root/World/User Interface/Windows/Pause")

var zoom_min:float = 2.5
var zoom_max:float = 6
	
var current:float = 15
var increment:float = 1 
var target:float = 3
var speed:int = 6

var switch:bool

func _process(delta):
	if !pause.paused:
		if Input.is_action_just_released("zoom_in") && !switch:
			if current <= zoom_max:
				target = current + increment

		if Input.is_action_just_released("zoom_out") && !switch:
			if current >= zoom_min:
				target = current - increment
			
		current = lerp(current, target, speed * delta)
		set_zoom(Vector2(current, current))
