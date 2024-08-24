extends Control

@onready var node:ColorRect = $ColorRect

var max_blur:float = 1.5
var min_blur:float = 0.0
var speed:float = 0.1
var value:float = 0
var state:bool = false

func _process(_delta):
	if state:
		if value < max_blur:
			value = value + speed
	else:
		if value > min_blur:
			value = value - speed

	node.material.set_shader_parameter("lod", value)

func blur(bluring:bool) -> void:
	var main_scene = str(get_tree().root.get_child(1).name)

	self.state = bluring
	get_node("/root/" + main_scene + "/User Interface/Hud")._visible(bluring)
	get_node("/root/" + main_scene + "/User Interface/System/Tooltip").tooltip()
	get_node("/root/" + main_scene + "/Camera").switch = bluring
	if bluring:
		var parent = "/root/" + main_scene + "/Buildings/" 
		if has_node(parent):
			for i in get_node(parent).get_children():
				i.change_sprite(false)
