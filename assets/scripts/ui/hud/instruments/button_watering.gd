extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var blur:Control = get_node("/root/" + main_scene + "/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/ConstructionManager/Grid")

func _on_button_pressed():
	if has_node("/root/" + main_scene + "/ConstructionManager"):
		if has_node("/root/" + main_scene + "/ConstructionManager/Grid"):
			if !blur.state:
				grid.mode = grid.modes.WATERING
				grid.visible = true
