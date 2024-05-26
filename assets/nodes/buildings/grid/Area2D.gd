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

func BuildingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	var collision = get_overlapping_areas()
	for area in collision:
		if area.name == "Area2D":
			return true
		else:
			return false
			
func FarmingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if farm.check_custom_data(tile_mouse_pos, can_place_dirt_custom_data, ground_layer) and !farm.cell_check(tile_mouse_pos, farming_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
		
func WateringCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if farm.check_custom_data(tile_mouse_pos, can_place_seed_custom_data, farming_layer)\
	and !farm.cell_check(tile_mouse_pos, watering_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false

func PlantingCollisionCheck():
	var mouse_pos: Vector2 = get_global_mouse_position()
	var tile_mouse_pos = tilemap.local_to_map(mouse_pos)
	if farm.cell_check(tile_mouse_pos, farming_layer):
		grid.change_texture(false)
		return true
	else:
		grid.change_texture(true)
		return false
