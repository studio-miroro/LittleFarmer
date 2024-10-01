extends Control

@onready var main_scene:String = str(get_tree().root.get_child(1).name)
@onready var hud:Control = get_node("/root/" + main_scene + "/UI/HUD/GameHud")
@onready var tooltip:Control = get_node("/root/" + main_scene + "/UI/Feedback/Tooltip")
@onready var camera:CharacterBody2D = get_node("/root/" + main_scene + "/Player")
@onready var zoom:Camera2D = get_node("/root/" + main_scene + "/Player/Camera2D")
@onready var background:ColorRect = $ColorRect

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

	if has_node("/root/" + main_scene + "/UI/HUD/GameHud"):
		hud.state(bluring)
	if has_node("/root/" + main_scene + "/UI/Feedback/Tooltip"):
		tooltip.tooltip()
	if has_node("/root/" + main_scene + "/Player"):
		camera.switch = bluring
	if has_node("/root/" + main_scene + "/Player/Camera2D"):
		zoom.change_zoom = !bluring
	if bluring:
		if has_node("/root/" + main_scene + "/Buildings/"):
			for nodes in get_node("/root/" + main_scene + "/Buildings/").get_children():
				if nodes.has_method("_change_sprite"):
					nodes._change_sprite(false)
