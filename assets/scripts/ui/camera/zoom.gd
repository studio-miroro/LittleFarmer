extends Camera2D

@onready var pause = get_node("/root/World/User Interface/Windows/Pause")

const zoom_min:float = 2.5
const zoom_max:float = 6
	
var current:float = 3.5
var increment:float = 1 
var target:float = 3

var zooming:bool = true
const speed:int = 6

func _process(delta):
	if !zooming:
		if Input.is_action_just_released("zoom_in") && !zooming:
			if current <= zoom_max:
				target = current + increment

		if Input.is_action_just_released("zoom_out") && !zooming:
			if current >= zoom_min:
				target = current - increment
			
		current = lerp(current, target, speed * delta)
		set_zoom(Vector2(current, current))
