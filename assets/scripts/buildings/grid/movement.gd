extends TileMap

@onready var pause:Control = get_node("/root/World/User Interface/Windows/Pause")
@onready var hud:Control = get_node("/root/World/User Interface/Hud")
@onready var grid:Node2D = get_node("/root/World/Buildings/Grid")

func _process(_delta):
	if grid.mode != grid.gridmode.NOTHING:
		movement()

func movement():
	var current:Vector2 = local_to_map(get_global_mouse_position())
	grid.set_position(map_to_local(current))
