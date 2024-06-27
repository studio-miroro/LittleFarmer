extends Control

@onready var node		= $ColorRect
var max_blur:float 		= 1.5
var min_blur:float 		= 0.0
var speed:float			= 0.1
var value:float 		= 0
var bluring:bool		= false

func _process(delta):
	if bluring:
		if value < max_blur:
			value = value + speed
	else:
		if value > min_blur:
			value = value - speed
	
	node.material.set_shader_parameter("lod", value)

func blur(_bluring:bool, switch:bool):
	self.bluring = _bluring
