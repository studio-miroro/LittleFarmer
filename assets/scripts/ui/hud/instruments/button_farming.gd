extends Control

@onready var blur:Control = get_node("/root/World/User Interface/Blur")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")

func _on_button_pressed():
	if !blur.bluring:
		grid.mode = grid.gridmode.FARMING
		grid.visible = true
