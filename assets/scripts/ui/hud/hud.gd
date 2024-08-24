extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var pause:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Pause")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")
@onready var inventory:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Inventory")
@onready var crafting:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var anim:AnimationPlayer = $Animation

var hud:bool

func _hide():
	anim.play("hide")
	hud = false
	
func _show():
	anim.play("show")
	hud = true

func _visible(state:bool):
	match state:
		true:
			_hide()
		false:
			_show()

func window():
	visible = hud
