extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)

@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")

func _on_button_pressed():
	if has_node("/root/" + main_scene + "/Buildings"):
		if has_node("/root/" + main_scene + "/Buildings/Grid"):
			if !blur.state:
				grid.mode = grid.gridmode.FARMING
				grid.visible = true
