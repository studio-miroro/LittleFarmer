extends Area2D

@onready var main_scene = str(get_tree().root.get_child(1).name)
@onready var tilemap:TileMap = get_node("/root/" + main_scene + "/Tilemap")
@onready var grid:Node2D = get_node("/root/" + main_scene + "/ConstructionManager/Grid")

const can_place_seed_custom_data:String = "can_place_seeds"
const can_place_dirt_custom_data:String = "can_place_dirt"
const can_place_watering_custom_data:String = "can_watering_dirt"

const ground_layer:int = 0
const road_layer:int = 1
const farmland_layer:int = 2
const watering_layer:int = 3
const seed_layer:int = 4
const shadow_layer:int = 5
const building_layer:int = 6

const farming_terrain_set:int = 0
const watering_terrain_set:int = 1
const ground_terrain_set:int = 2
const terrain:int = 0

func destroy_collision_check() -> int:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_cell(tile_mouse_pos, road_layer)\
	and !check_cell(tile_mouse_pos, farmland_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return 0
	elif check_cell(tile_mouse_pos, farmland_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return 1
	elif check_cell(tile_mouse_pos, farmland_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return 2
	elif check_cell(tile_mouse_pos, farmland_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return 3
	elif check_cell(tile_mouse_pos, farmland_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return 4
	else:
		grid.change_sprite(true)
		return -1
		
func farming_collision_check() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, road_layer)\
	and !check_cell(tile_mouse_pos, farmland_layer):
		grid.change_sprite(false)
		return true
	else:
		grid.change_sprite(true)
		return false
		
func watering_collision_check() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farmland_layer)\
	and !check_cell(tile_mouse_pos, watering_layer):
		grid.change_sprite(false)
		return true
	else:
		grid.change_sprite(true)
		return false

func planting_collision_check() -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_cell(tile_mouse_pos, farmland_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return true
	elif check_cell(tile_mouse_pos, farmland_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seed_layer):
		grid.change_sprite(false)
		return true
	else:
		grid.change_sprite(true)
		return false
	
func terrain_collision_check(terrain_layer) -> bool:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	
	#if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farmland_layer)\
	if !check_cell(tile_mouse_pos, terrain_layer):
		grid.change_sprite(false)
		return true
	else:
		grid.change_sprite(true)
		return false

func building_collision_check(node_layer) -> bool:
	var mouse_pos:Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)

	var is_collision = check_cell(tile_mouse_pos, node_layer)
	grid.change_sprite(is_collision)
	return is_collision

func check_custom_data(tile_mouse:Vector2, custom_data_layer:String, layer:int) -> bool:
	var tiledata = tilemap.get_cell_tile_data(layer, tile_mouse)
	if tiledata:
		return tiledata.get_custom_data(custom_data_layer)
	else:
		return false

func check_cell(mouse:Vector2, current_tile:int) -> bool:
	if tilemap.get_cell_source_id(current_tile, mouse) == -1:
		return false
	else:
		return true

func get_used_cells(layer:int) -> Array:
	return tilemap.get_used_cells(layer)