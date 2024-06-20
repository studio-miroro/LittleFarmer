extends Area2D

@onready var farm = get_node("/root/World")
@onready var tilemap = get_node("/root/World/Tilemap")
@onready var grid = get_node("/root/World/Buildings/Grid")
@export var error = preload("res://assets/resources/buildings/grid/error.png")
var need_check:bool

var can_place_seed_custom_data = "can_place_seeds"
var can_place_dirt_custom_data = "can_place_dirt"
var can_place_watering_custom_data = "can_watering_dirt"

var ground_layer = 3
var farming_layer = 4
var watering_layer = 5
var seeds_layer = 6

var ground_terrain_set = 2
var watering_terrain_set = 1
var farming_terrain_set = 0

var ground_terrain = 0
var watering_terrain = 0
var farming_terrain = 0

func destroy_collision_check():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_cell(tile_mouse_pos, ground_layer)\
	and !check_cell(tile_mouse_pos, farming_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return 0
	elif check_cell(tile_mouse_pos, farming_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return 1
	elif check_cell(tile_mouse_pos, farming_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return 2
	elif check_cell(tile_mouse_pos, farming_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return 3
	elif check_cell(tile_mouse_pos, farming_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return 4
	else:
		grid.change_texture(true)
		return -1
		
func farming_collision_check():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer) and !check_cell(tile_mouse_pos, farming_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
		
func watering_collision_check():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farming_layer)\
	and !check_cell(tile_mouse_pos, watering_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false

func planting_collision_check():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_cell(tile_mouse_pos, farming_layer)\
	and !check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return true
	elif check_cell(tile_mouse_pos, farming_layer)\
	and check_cell(tile_mouse_pos, watering_layer)\
	and !check_cell(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
	
func building_collision_check():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	grid.change_texture(false)
	return true
	
func check_custom_data(tile_mouse, custom_data_layer, layer):
	var tiledata: TileData = tilemap.get_cell_tile_data(layer,tile_mouse)
	if tiledata:
		return tiledata.get_custom_data(custom_data_layer)
	else:
		return false

func check_cell(mouse, current_tile):
	if tilemap.get_cell_source_id(current_tile, mouse) == -1:
		return false
	else:
		return true
