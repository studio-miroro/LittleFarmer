extends Control

@onready var main:String = str(get_tree().root.get_child(1).name)
@onready var pause:Control = get_node("/root/"+main+"/UI/Interactive/Pause")
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid")

func _on_button_pressed() -> void:
	if !pause.lock:
		if has_node("/root/"+main+"/ConstructionManager")\
		&& has_node("/root/"+main+"/ConstructionManager/Grid"):
			if !blur.state:
				grid.mode = grid.modes.DESTROY
				grid.visible = true

