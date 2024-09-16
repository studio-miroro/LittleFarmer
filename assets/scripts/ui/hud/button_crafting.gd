extends Control

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var craft:Control = get_node("/root/" + main_scene + "/User Interface/Windows/Crafting")
@onready var blur:Control = get_node("/root/" + main_scene + "/User Interface/Blur")

func _on_button_pressed():
	if !blur.state:
		craft.open()
