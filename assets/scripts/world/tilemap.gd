extends TileMap

@onready var main = str(get_tree().root.get_child(1).name)
@onready var data = get_node("/root/"+main)
@onready var blur:Control = get_node("/root/"+main+"/UI/Decorative/Blur")
@onready var grid:Node2D = get_node("/root/"+main+"/ConstructionManager/Grid")

func _process(_delta):
	if !blur.state:
		if has_node("/root/"+main+"/ConstructionManager"):
			if has_node("/root/"+main+"/ConstructionManager/Grid"):
				if grid.mode != grid.modes.NOTHING:
					grid_movement()

func grid_movement() -> void:
	var movement:Vector2 = local_to_map(get_global_mouse_position())
	grid.set_position(map_to_local(movement))
