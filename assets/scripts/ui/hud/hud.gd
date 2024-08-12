extends Control

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")
@onready var inventory:Control = get_node("/root/World/User Interface/Windows/Inventory")
@onready var crafting:Control = get_node("/root/World/User Interface/Windows/Crafting")
@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var anim:AnimationPlayer = $Animation

#@onready var destroy_button:Button
#@onready var farming_button:Button
#@onready var watering_button:Button
#@onready var building_button:Button
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
