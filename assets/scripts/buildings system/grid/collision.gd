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

var farming_terrain_set = 0
var watering_terrain_set = 1
var farming_terrain = 0
var watering_terrain = 0

func DestroyCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if cell_check(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
		
func FarmingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer) and !cell_check(tile_mouse_pos, farming_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
		
func WateringCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farming_layer)\
	and !cell_check(tile_mouse_pos, watering_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false

func PlantingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if cell_check(tile_mouse_pos, farming_layer)\
	and !cell_check(tile_mouse_pos, watering_layer)\
	and !cell_check(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return true
	elif cell_check(tile_mouse_pos, farming_layer)\
	and cell_check(tile_mouse_pos, watering_layer)\
	and !cell_check(tile_mouse_pos, seeds_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
	
func BuildingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	grid.change_texture(false)
	return true
	
func check_custom_data(tile_mouse,custom_data_layer,layer):
	var tiledata: TileData = tilemap.get_cell_tile_data(layer,tile_mouse)
	if tiledata:
		return tiledata.get_custom_data(custom_data_layer)
	else:
		return false

func cell_check(mouse, current_tile):
	if tilemap.get_cell_source_id(current_tile,mouse) == -1:
		return false
		grid.change_texture(true)
	else:
		return true
		grid.change_texture(false)
