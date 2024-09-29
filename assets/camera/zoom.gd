extends Camera2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var pause = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")

const zoom_min:float = 2.5
const zoom_max:float = 6
const speed:int = 6

var current:float = 3.5
var increment:float = 1 
var target:float = 3

var zooming:bool = true
var change_zoom:bool = false

func _process(delta):
	if !zooming:
		if change_zoom:
			if Input.is_action_just_released("zoom_in") && !zooming:
				if current <= zoom_max:
					target = current + increment

			if Input.is_action_just_released("zoom_out") && !zooming:
				if current >= zoom_min:
					target = current - increment
				
		current = lerp(current, target, speed * delta)
		set_zoom(Vector2(current, current))
