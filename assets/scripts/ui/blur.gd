extends Control

@onready var main_scene:String = str(get_tree().root.get_child(1).name)
@onready var hud:Control = get_node("/root/" + main_scene + "/User Interface/Hud")
@onready var tooltip:Control = get_node("/root/" + main_scene + "/User Interface/System/Tooltip")
@onready var camera:CharacterBody2D = get_node("/root/" + main_scene + "/Camera")
@onready var background:ColorRect = $ColorRect

var buildings:String = "/root/" + main_scene + "/Buildings/"

const max_blur:float = 1.5
const min_blur:float = 0.0
const speed:float = 0.1

var value:float = 0
var state:bool = false

func _process(_delta):
	if state:
		if value < max_blur:
			value = value + speed
	else:
		if value > min_blur:
			value = value - speed

	background.material.set_shader_parameter("lod", value)

func blur(bluring:bool) -> void:
	self.state = bluring
	
	hud._visible(bluring)
	tooltip.tooltip()
	camera.switch = bluring

	if bluring:
		if has_node(buildings):
			for nodes in get_node(buildings).get_children():
				nodes.change_sprite(false)
