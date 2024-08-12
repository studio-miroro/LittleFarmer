extends Control

@onready var node:ColorRect = $ColorRect

var max_blur:float = 1.5
var min_blur:float = 0.0
var speed:float = 0.1
var value:float = 0
var bluring:bool = false

func _process(delta):
	if bluring:
		if value < max_blur:
			value = value + speed
	else:
		if value > min_blur:
			value = value - speed
	node.material.set_shader_parameter("lod", value)

func blur(_bluring:bool):
	self.bluring = _bluring
	get_node("/root/World/User Interface/System/Tooltip").tooltip("")
	#get_node("/root/World/Camera/Camera2D").switch = _bluring
	get_node("/root/World/Camera").switch = _bluring
	if bluring:
		get_node("/root/World/Buildings/House").change_sprite(false)
		get_node("/root/World/Buildings/Mailbox").change_sprite(false)
		get_node("/root/World/Buildings/Storage").change_sprite(false)
		get_node("/root/World/Buildings/Animal Stall").change_sprite(false)
		get_node("/root/World/Buildings/Silo").change_sprite(false)
