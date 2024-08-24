extends TileMap

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var grid:Node2D = get_node("/root/" + main_scene + "/Buildings/Grid")

func _process(_delta):
	if has_node("/root/" + main_scene + "/Buildings"):
		if has_node("/root/" + main_scene + "/Buildings/Grid"):
			if grid.mode != grid.gridmode.NOTHING:
				movement()

func movement() -> void:
	var current:Vector2 = local_to_map(get_global_mouse_position())
	grid.set_position(map_to_local(current))
